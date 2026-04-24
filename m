Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86853AC00;
	Fri, 24 Apr 2026 13:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037552; cv=none; b=WbL/UG3J+RBuVa4HXhozJkGUH5okIEdfUBMFt9xx6h6Ja9NJQ8OKqgjnXl3muEHcDlErHUM4ps9jdsr1JxNRjIt9sRQeAclu2r2Q4oAuIW/ZHaJuw2K8exFCt4oFRhzGLaK1L8JLx6SfBU7EJV+y+CFVmIHfoRhb6mHqpPvjxqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037552; c=relaxed/simple;
	bh=+QaF78pvgeXyaXauiC3LsHRAe5b3VSC+R3+efsMK+0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9i3QYpVp3xMZz4qzHAtJLNiPG0O6LtsA5G4J1DMDOhGOAT0L5g8Q/WIiAo0t6sslPA1i/zw2YGdM2Lfiy73lrNe94PZqAVKrlYhxBRYMU83vwgepCzqltVOB3KOK8FHvsFLMwNtGwL4V6uKdWz19sE2fTVI7EymtsecwBDCAxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUJwIGuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUJwIGuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B093C2BCB2;
	Fri, 24 Apr 2026 13:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037551;
	bh=+QaF78pvgeXyaXauiC3LsHRAe5b3VSC+R3+efsMK+0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUJwIGuEyoyiqyhU6uMa9/ZZVVIAsWFaxyy3n7INSLD4U8vmmVDFsKLkjDTosoHbD
	 JVKk9dxvkrFWJXJx+rWl3CkCzvdk/uS1p23LkiTATAZ33mFX/pSPrqwjUsDBFYz+Mu
	 S021VsKR+6TAsvFeEDj45eMMAY9rvZ5d8TX9Xg+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 21/42] smb: server: fix active_num_conn leak on transport allocation failure
Date: Fri, 24 Apr 2026 15:30:46 +0200
Message-ID: <20260424132424.890208544@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -183,6 +183,8 @@ static int ksmbd_tcp_new_connection(stru
 	t = alloc_transport(client_sk);
 	if (!t) {
 		sock_release(client_sk);
+		if (server_conf.max_connections)
+			atomic_dec(&active_num_conn);
 		return -ENOMEM;
 	}
 


