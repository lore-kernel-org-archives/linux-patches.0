Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490673E024D;
	Wed, 30 Sep 2026 19:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796271; cv=none; b=lezgotiJd+FgX7PIkrhSki8Aw/MbgSJq2jbJsnRuHJ60wpgiNUVpkPs2HOD0PAVNMv7gvSMIsfHbSYOEXwthJD1Qbr0RiJq5tZOF3H/z+0ZeCS1Uj+DbDHkJczD88Y4ub3na1PBdd/CIeRzgH6Bdk9fSG/b6RX/QI+cu7dYdqPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796271; c=relaxed/simple;
	bh=RR62wTlS+eqeHabV0AsUWjPeKq/ytxnr5qapD9dNoPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ag8ll+jeS31dLS078jIN/k5mlOylHDctrfY1GkZf6yJHq5esgAqTI5xXmiYFlS0IY2Y2J+e19d3FRYl0WA6eXkL5uEt7ktvvO1eWevBIBZuSpkr3AtlUjWn4/viK2Xvpb1K9FfyiiLMtfu2wzMLmlp84RpX7k9oCJGQFYuShc6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w83YZ40O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w83YZ40O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C4D1F000FF;
	Wed, 30 Sep 2026 19:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796270;
	bh=5TFT8Zsdz2XHu+oxBOwy1km13eUKNidQmTCw5s6dE5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w83YZ40ONtOlvFA0PLZzZ0+Q3mUOxtegBHQL2HN4Xy0C2agidM9D3hmIZzmr9X4yH
	 26dUFCgS0mLnWsOHuzsYRdtVaveW0XPhzeAnBJH2+QMrSOkFkZbIAkPj3Na6hbQu6o
	 GjyW4R2alSe4yp6TPNzSuHc8e1SEx/6cMNSlk+XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0cece8fa7d83523f47a3@syzkaller.appspotmail.com,
	Juan Perdomo <jcperdomo100@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0809/1193] Bluetooth: RFCOMM: avoid socket lock inversion in listener cleanup
Date: Wed, 30 Sep 2026 17:24:53 +0200
Message-ID: <20260930152452.219831535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juan Perdomo <jcperdomo100@gmail.com>

[ Upstream commit 801fb950cae7048eb7d83b18857d1ca37b8cd5a4 ]

rfcomm_sock_cleanup_listen() closes unaccepted child sockets through
rfcomm_sock_close(), which takes the child socket lock before
rfcomm_dlc_close() acquires rfcomm_mutex. The RFCOMM worker takes these
locks in reverse order while handling connections and DLC state changes,
so lockdep reports a possible deadlock.

Close dequeued children without taking their socket lock. The accept queue
owns a reference to each child, and bt_accept_dequeue() locks the child
while unlinking it and clearing its parent pointer.

Dropping the child lock makes it important to prevent a concurrent
rfcomm_connect_ind() from enqueueing a new child after cleanup observes an
empty queue. Set a listening socket to BT_CLOSED while its lock is still
held, before dropping the lock and draining the queue. The state check in
rfcomm_connect_ind() then rejects new children once cleanup starts.

Reported-by: syzbot+0cece8fa7d83523f47a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0cece8fa7d83523f47a3
Fixes: b7ce436a5d79 ("Bluetooth: switch to lock_sock in RFCOMM")
Signed-off-by: Juan Perdomo <jcperdomo100@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/sock.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index d72cdcd2e2bb1..729c70c992cfa 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -243,9 +243,7 @@ static void __rfcomm_sock_close(struct sock *sk)
  */
 static void rfcomm_sock_close(struct sock *sk)
 {
-	lock_sock(sk);
 	__rfcomm_sock_close(sk);
-	release_sock(sk);
 }
 
 static void rfcomm_sock_init(struct sock *sk, struct sock *parent)
@@ -903,6 +901,7 @@ static int rfcomm_sock_compat_ioctl(struct socket *sock, unsigned int cmd, unsig
 static int rfcomm_sock_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
+	bool cleanup_listen = false;
 	int err = 0;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
@@ -913,9 +912,17 @@ static int rfcomm_sock_shutdown(struct socket *sock, int how)
 	lock_sock(sk);
 	if (!sk->sk_shutdown) {
 		sk->sk_shutdown = SHUTDOWN_MASK;
+		if (sk->sk_state == BT_LISTEN) {
+			/* Block new children before cleaning up without sk lock. */
+			sk->sk_state = BT_CLOSED;
+			cleanup_listen = true;
+		}
 
 		release_sock(sk);
-		__rfcomm_sock_close(sk);
+		if (cleanup_listen)
+			rfcomm_sock_cleanup_listen(sk);
+		else
+			__rfcomm_sock_close(sk);
 		lock_sock(sk);
 
 		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
-- 
2.53.0



