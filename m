Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8843D75C3;
	Fri, 24 Apr 2026 13:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038233; cv=none; b=Qxh1z6wD6TnX0wn8DLcbeAzRa/iAw6NQu1VJVpkLKAxhMQcCfTAXjKFT/akTwNCQ70/FoALSdPw8nCvbp3H7eInm+ouykdzuCyrmvSpiw6nouEhWeJBbBSPcTHFiSPWwfDAyJxzVjD45YOQ3k+KkqGyVvhn7TTJGz8kQ8xjxNH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038233; c=relaxed/simple;
	bh=zI8WWnMlT+hTqvtHb/1BwS+5vm/6uQ02ScS7KjUjGtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNNaLenQGB55ZhX9Lg5fGesxPWfor2githxjLQtspNHkrL81X4demh1yLVL5l5ziXBpoTQooH3DJgA46Do3pOeS2wmE7nN5FFet8nO70Nq902x8c9PyZP3G6CogYtaUUVC/KuaIGPj0Vk/LhfS+PWKtGlxKxKYRNJGK6cGc4AWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHLyOGLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHLyOGLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A3BC2BCB5;
	Fri, 24 Apr 2026 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038233;
	bh=zI8WWnMlT+hTqvtHb/1BwS+5vm/6uQ02ScS7KjUjGtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHLyOGLuvsa8KxFA4ko7wj1BX5bPtmlRV7ljXocpqPMgCil9YbBm3mdHlpe226Usv
	 MT3I+AohTLo1upWjgXcAS0lAXJEpXr8COiQMgHN0KspH44Xkhc5SzOVaH6zAguGrbL
	 FV5yiLvRyODN0X4cNGJO20jaBO4jUtc+gLwbBiLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 20/35] smb: server: fix active_num_conn leak on transport allocation failure
Date: Fri, 24 Apr 2026 15:31:27 +0200
Message-ID: <20260424132415.943689485@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -203,6 +203,8 @@ static int ksmbd_tcp_new_connection(stru
 	t = alloc_transport(client_sk);
 	if (!t) {
 		sock_release(client_sk);
+		if (server_conf.max_connections)
+			atomic_dec(&active_num_conn);
 		return -ENOMEM;
 	}
 


