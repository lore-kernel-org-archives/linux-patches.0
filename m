Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2748A3D7D74;
	Wed,  8 Apr 2026 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672543; cv=none; b=TfDrneIdpnGS7HPr9l4Pe1oHALV2MpGVjWYpnQwE41weZzvf9uCas2jUaAtRmp1aWAOfiWNESdr5uaQp7ZEaHm8+JuLXLEZ9EPMD7R25XVe5lcrWmGVCxhLLHekVbn5FCerVoD8Y+sLyfyBxyaa/3FUVzPGraTB6NUXg/WDz5SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672543; c=relaxed/simple;
	bh=KLJcjOVlI2Qef0AB0CHjZD78P/T7Ji+O/lAga2docN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ex5yHj6183KlvZlJdJCls8K85AAEXr2xOprJRyboZLG1NE+YviyCHnwK1TJsVb+BCOIF1RabRn0GpBeeIoBK1qJVaHq/RVHcs9ftGtsR8UODeZME8b394xmnQehx7VjqJ2Iyldlz2qEXe4dluSzoOT+SIXaQN3mZfLDIta1/T0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3J+em7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3J+em7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0F7C4AF09;
	Wed,  8 Apr 2026 18:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672543;
	bh=KLJcjOVlI2Qef0AB0CHjZD78P/T7Ji+O/lAga2docN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3J+em7slxwLihSkyQzDjVrCeN3SSuHssGBB2BEsJtu0GjkR3uGQWkAd62b2ItSxU
	 9JwWuo5lz0D3n1G2642wub0bjHGtU66nhnRWkWcbAEHWioj/qjIbUN3pjhICQ+80yv
	 ETpNbZtBCuMbr+ZVIRwxOq7+KqCBa1yImfW+Vp/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/160] Bluetooth: SCO: fix race conditions in sco_sock_connect()
Date: Wed,  8 Apr 2026 20:02:14 +0200
Message-ID: <20260408175914.965508757@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 8a5b0135d4a5d9683203a3d9a12a711ccec5936b ]

sco_sock_connect() checks sk_state and sk_type without holding
the socket lock. Two concurrent connect() syscalls on the same
socket can both pass the check and enter sco_connect(), leading
to use-after-free.

The buggy scenario involves three participants and was confirmed
with additional logging instrumentation:

  Thread A (connect):    HCI disconnect:      Thread B (connect):

  sco_sock_connect(sk)                        sco_sock_connect(sk)
  sk_state==BT_OPEN                           sk_state==BT_OPEN
  (pass, no lock)                             (pass, no lock)
  sco_connect(sk):                            sco_connect(sk):
    hci_dev_lock                                hci_dev_lock
    hci_connect_sco                               <- blocked
      -> hcon1
    sco_conn_add->conn1
    lock_sock(sk)
    sco_chan_add:
      conn1->sk = sk
      sk->conn = conn1
    sk_state=BT_CONNECT
    release_sock
    hci_dev_unlock
                           hci_dev_lock
                           sco_conn_del:
                             lock_sock(sk)
                             sco_chan_del:
                               sk->conn=NULL
                               conn1->sk=NULL
                               sk_state=
                                 BT_CLOSED
                               SOCK_ZAPPED
                             release_sock
                           hci_dev_unlock
                                                  (unblocked)
                                                  hci_connect_sco
                                                    -> hcon2
                                                  sco_conn_add
                                                    -> conn2
                                                  lock_sock(sk)
                                                  sco_chan_add:
                                                    sk->conn=conn2
                                                  sk_state=
                                                    BT_CONNECT
                                                  // zombie sk!
                                                  release_sock
                                                  hci_dev_unlock

Thread B revives a BT_CLOSED + SOCK_ZAPPED socket back to
BT_CONNECT. Subsequent cleanup triggers double sock_put() and
use-after-free. Meanwhile conn1 is leaked as it was orphaned
when sco_conn_del() cleared the association.

Fix this by:
- Moving lock_sock() before the sk_state/sk_type checks in
  sco_sock_connect() to serialize concurrent connect attempts
- Fixing the sk_type != SOCK_SEQPACKET check to actually
  return the error instead of just assigning it
- Adding a state re-check in sco_connect() after lock_sock()
  to catch state changes during the window between the locks
- Adding sco_pi(sk)->conn check in sco_chan_add() to prevent
  double-attach of a socket to multiple connections
- Adding hci_conn_drop() on sco_chan_add failure to prevent
  HCI connection leaks

Fixes: 9a8ec9e8ebb5 ("Bluetooth: SCO: Fix possible circular locking dependency on sco_connect_cfm")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 56a146515df9e..1c9c54f35988b 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -238,7 +238,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	int err = 0;
 
 	sco_conn_lock(conn);
-	if (conn->sk)
+	if (conn->sk || sco_pi(sk)->conn)
 		err = -EBUSY;
 	else
 		__sco_chan_add(conn, sk, parent);
@@ -292,9 +292,20 @@ static int sco_connect(struct sock *sk)
 
 	lock_sock(sk);
 
+	/* Recheck state after reacquiring the socket lock, as another
+	 * thread may have changed it (e.g., closed the socket).
+	 */
+	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
+		release_sock(sk);
+		hci_conn_drop(hcon);
+		err = -EBADFD;
+		goto unlock;
+	}
+
 	err = sco_chan_add(conn, sk, NULL);
 	if (err) {
 		release_sock(sk);
+		hci_conn_drop(hcon);
 		goto unlock;
 	}
 
@@ -601,13 +612,18 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
 
-	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND)
+	lock_sock(sk);
+
+	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
+		release_sock(sk);
 		return -EBADFD;
+	}
 
-	if (sk->sk_type != SOCK_SEQPACKET)
-		err = -EINVAL;
+	if (sk->sk_type != SOCK_SEQPACKET) {
+		release_sock(sk);
+		return -EINVAL;
+	}
 
-	lock_sock(sk);
 	/* Set destination address and psm */
 	bacpy(&sco_pi(sk)->dst, &sa->sco_bdaddr);
 	release_sock(sk);
-- 
2.53.0



