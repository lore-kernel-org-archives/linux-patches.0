Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02EE3290A5;
	Fri, 24 Apr 2026 13:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038133; cv=none; b=hHdiObfwXLW6k1iobiHjBTmw4FJ+bO4gnfwuM4+QGdUN/UP63U8rcpANHfWtK5KRssybfblhatkTAtFOoS4/Pdd0gKTyQvQnJyDvshj+gyaZ598EPjx4s3bF2GIrEuV4cIQhZf7O0kig3tiG7cZZiqvFMrl4JwfESjgKNM3QAPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038133; c=relaxed/simple;
	bh=OcpSBZsZfzm02KaO+r6iPGmxfQFnoGHjcyDLz5cvj/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y22WsFP0y7AOhOjR9FbgSrAbcBYIV94CZJ7stKxzjtlMblZFpUqmG7l/TDRgfQ8mdKFHJANtu5zE9z8Tl155MOw7yGUuvybxzkIT6cPKeZriIflz3fHR1sxOQlFCQnPmoEJVPSEn7zfhrDvmrdkPe0CIimFvTHwc+AJtlf/Sn2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQo3Cgo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQo3Cgo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76906C19425;
	Fri, 24 Apr 2026 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038132;
	bh=OcpSBZsZfzm02KaO+r6iPGmxfQFnoGHjcyDLz5cvj/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQo3Cgo4umn12GFpUk80fjRYo/ccb08HSa1inlY/8ZmrhSGKQdyjMqcKSGQqoH4Pd
	 4Co1GcK0sBdRgqMiRFEGN0K2z7gZkJotFr3um+kecJRjuIIUYiHKoDob+M+R7Im1fh
	 tdHfs07dKPUkDunSCgGNnHLqL8QnXdg/FHclb22U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 37/55] smb: server: fix active_num_conn leak on transport allocation failure
Date: Fri, 24 Apr 2026 15:31:16 +0200
Message-ID: <20260424132437.703670287@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 6551300dc452ac16a855a83dbd1e74899542d3b3 upstream.

Commit 77ffbcac4e56 ("smb: server: fix leak of active_num_conn in
ksmbd_tcp_new_connection()") addressed the kthread_run() failure
path.  The earlier alloc_transport() == NULL path in the same
function has the same leak, is reachable pre-authentication via any
TCP connect to port 445, and was empirically reproduced on UML
(ARCH=um, v7.0-rc7): a small number of forced allocation failures
were sufficient to put ksmbd into a state where every subsequent
connection attempt was rejected for the remainder of the boot.

ksmbd_kthread_fn() increments active_num_conn before calling
ksmbd_tcp_new_connection() and discards the return value, so when
alloc_transport() returns NULL the socket is released and -ENOMEM
returned without decrementing the counter.  Each such failure
permanently consumes one slot from the max_connections pool; once
cumulative failures reach the cap, atomic_inc_return() hits the
threshold on every subsequent accept and every new connection is
rejected.  The counter is only reset by module reload.

An unauthenticated remote attacker can drive the server toward the
memory pressure that makes alloc_transport() fail by holding open
connections with large RFC1002 lengths up to MAX_STREAM_PROT_LEN
(0x00FFFFFF); natural transient allocation failures on a loaded
host produce the same drift more slowly.

Mirror the existing rollback pattern in ksmbd_kthread_fn(): on the
alloc_transport() failure path, decrement active_num_conn gated on
server_conf.max_connections.

Repro details: with the patch reverted, forced alloc_transport()
NULL returns leaked counter slots and subsequent connection
attempts -- including legitimate connects issued after the
forced-fail window had closed -- were all rejected with "Limit the
maximum number of connections".  With this patch applied, the same
connect sequence produces no rejections and the counter cycles
cleanly between zero and one on every accept.

Fixes: 0d0d4680db22 ("ksmbd: add max connections parameter")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -197,6 +197,8 @@ static int ksmbd_tcp_new_connection(stru
 	t = alloc_transport(client_sk);
 	if (!t) {
 		sock_release(client_sk);
+		if (server_conf.max_connections)
+			atomic_dec(&active_num_conn);
 		return -ENOMEM;
 	}
 


