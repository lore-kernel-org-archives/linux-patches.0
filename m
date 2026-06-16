Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC084472798;
	Tue, 16 Jun 2026 18:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634381; cv=none; b=TSLXWrlMRDcuul7PPJV6xJu6sIGBWhMGUjPV5eQ9V010AqXx+HHrS80V5ZynjSmq3LUh7WfBLZrDRCbC46M12wjxDQUeWMY2OsGkqx6tjETTl+SEtDPBdws7ST9z8tvUvJ1N95J1v5p1/B/EgRQqyoSBTejDJFroDH9eGxV4J38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634381; c=relaxed/simple;
	bh=VY7PbV4a9dXpBebZ49VbO4M3t852DX2ILTQIH0D6T4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvBpXlPl/Dhom3KHavgfZS4ZBR0InGR6ciEwwveHLlzxX67bho+V8tRB7GA0BJFYbWRAaoPNz6Emm0qArMIEyd+ufLQ3FGICLh9y4LtN5CFpj71Trumd0p4XbNBliv5+HjJPFSTBPQldVNiUAIKkeJ1e23p+l5BekssDGvCsgtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHdHT4wL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHdHT4wL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81D71F000E9;
	Tue, 16 Jun 2026 18:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634380;
	bh=9yc1i16/atASPB95xKgkP1w5OP5HgCfaXJ2ZlUAuQt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHdHT4wLnkrAItO1nEWdHu+x3VhgrQTHYOSBn4VNQHJhjGAbspzhJ6IDxNJPBUM0a
	 EcsTPYEzHD85WvQV7uMr4Z1t/rasO2NAaUJOA3pJ2LqIdD5/2Ac3JL4D0Atsx83iA8
	 hh9L6QVcC57XxLPbUEzLWxIB6yvcG9T3AkrZkM0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/411] smb: server: fix active_num_conn leak on transport allocation failure
Date: Tue, 16 Jun 2026 20:28:11 +0530
Message-ID: <20260616145114.446206836@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 6551300dc452ac16a855a83dbd1e74899542d3b3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -191,6 +191,8 @@ static int ksmbd_tcp_new_connection(stru
 	t = alloc_transport(client_sk);
 	if (!t) {
 		sock_release(client_sk);
+		if (server_conf.max_connections)
+			atomic_dec(&active_num_conn);
 		return -ENOMEM;
 	}
 


