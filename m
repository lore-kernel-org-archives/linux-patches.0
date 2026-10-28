Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207477;
	b=RWqoEYgrPpWgIXsR7d3ujSM0T39NL1ybC2NRliYtYNSHAlAyKwH5lEUGDt6RhNBhwXOA
	 Q6XSDwKzEvE/Gj/Kge7R8JPxFKRpJU5a4e4NSHZJZuL+vJIykK3u4z2+Ix8mbqC/fyfsn
	 YIjyy2KTQD1HG1FQTL/83uzMjuJv6Y8Xa29xBzT8YgSV9lf5Lp45YalrdRuNcWqca1EKQ
	 jpZOgyyXKg5OgqPzFz6LJ1ocaoTaMlxdfm1r+Xg5LMPiG5kEFmYUjnKHgiI/nMzE6/vuy
	 NdPdxBECG3VQEOLtUyE/DYo0jwDnYmVqdZ2w9nzS0UZgDKHk3umHuYwRPXmpyHVMltA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m2PztWSrik9Gd4WP8bP5Q/DoyP4WwtN6IkeqobHOOqk=;
	b=dBD5RzlxQEnpQ/LpMKpM5Bw6YJfpTO8QL4fTR7D/H2rdtwoCk4eeQUjqxDiwQuDctfTl
	 NyjaePA07Z8Iv8HtmAAy0twJYcvGRalQdTHeXNbE9+Z0hdvuz8p755IaTAvp7HVUQMUp/
	 8zZYtNsBil5Or8wHxDTZHbioklQRJlbtQNuUNKRk2d/Wg0DsqQ/JIumL46Ct6o9nTiDwK
	 jFrVPizgICJZ3wAKOU36/Q+eQnHHeyMqHL+gSA9OGkRSAsJdLc+2q9+P7BtB9GbXlQU8T
	 tXGvN/UpmACnwrlLiHrMFjGGGFlw3za4Osp5XV0cyzOl+55G1WqyzZbjQmsVBVevdvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02W2AEVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59B7606A31C;
	Wed, 28 Oct 2026 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02W2AEVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA4B1F01825;
	Wed, 28 Oct 2026 17:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207476;
	bh=m2PztWSrik9Gd4WP8bP5Q/DoyP4WwtN6IkeqobHOOqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02W2AEVBljHdvNInLDAhtDFQa+a9YOFCuzf9MpBq2Kx5UQ3cwOD88CFCo1k0opkM6
	 LZBJ0D30gmx2UFTUIdAl4ugYekcXRgbh9EVCOcXCRyE8rl87Nnp5UXJjsD3wyH+2EH
	 iWzTXB6yoIRxDH7pge4+WRRJ7cXSUElV/ml/6FCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/247] rose: release netdev ref and destroy orphaned incoming sockets
Date: Wed, 28 Oct 2026 17:56:46 +0100
Message-ID: <20261028165947.437460186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

Two related cleanup gaps left the module unremovable after a loopback
session:

1. rose_destroy_socket() did not release the device reference.  When
   an unaccepted incoming socket (created by rose_rx_call_request()) is
   destroyed via rose_heartbeat_expiry(), it is removed from rose_list
   before rose_kill_by_device() can find it, so the netdev_hold() taken
   in rose_rx_call_request() was never matched by netdev_put().  Add the
   release at the top of rose_destroy_socket() guarded by a NULL check
   so that rose_release() and rose_kill_by_device(), which already call
   netdev_put() and set device = NULL, are not affected.

2. rose_heartbeat_expiry() STATE_0 cleanup required TCP_LISTEN in
   addition to SOCK_DEAD.  Unaccepted incoming sockets are
   TCP_ESTABLISHED, so the condition was never true and those sockets
   lingered forever, holding the module use count above zero and
   blocking rmmod.  Drop the TCP_LISTEN restriction: any STATE_0 +
   SOCK_DEAD socket is orphaned and should be destroyed.

Together with the earlier rose_make_new() double-hold fix these three
patches allow clean rmmod after loopback sessions.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>

(cherry picked from commit df12be096302d2c947388acc25764456c7f18cc1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c    | 9 +++++++++
 net/rose/rose_timer.c | 9 +++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 314f11fec831d..5aedbbf105c33 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -363,6 +363,7 @@ static void rose_destroy_timer(struct timer_list *t)
  */
 void rose_destroy_socket(struct sock *sk)
 {
+	struct rose_sock *rose = rose_sk(sk);
 	struct sk_buff *skb;
 
 	rose_remove_socket(sk);
@@ -370,6 +371,14 @@ void rose_destroy_socket(struct sock *sk)
 	rose_stop_idletimer(sk);
 	rose_stop_timer(sk);
 
+	/* Drop any device reference not already released by rose_kill_by_device()
+	 * or rose_release() -- e.g. incoming sockets that were never accepted.
+	 */
+	if (rose->device) {
+		netdev_put(rose->device, &rose->dev_tracker);
+		rose->device = NULL;
+	}
+
 	rose_clear_queues(sk);		/* Flush the queues */
 
 	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index 92c07ceaa3899..b2c5f4653b11d 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -128,10 +128,11 @@ static void rose_heartbeat_expiry(struct timer_list *t)
 	}
 	switch (rose->state) {
 	case ROSE_STATE_0:
-		/* Magic here: If we listen() and a new link dies before it
-		   is accepted() it isn't 'dead' so doesn't get removed. */
-		if (sock_flag(sk, SOCK_DESTROY) ||
-		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
+		/* Destroy any orphaned STATE_0 socket: either explicitly
+		 * flagged SOCK_DESTROY, or SOCK_DEAD (covers both unaccepted
+		 * incoming connections and listening sockets whose link died).
+		 */
+		if (sock_flag(sk, SOCK_DESTROY) || sock_flag(sk, SOCK_DEAD)) {
 			bh_unlock_sock(sk);
 			rose_destroy_socket(sk);
 			sock_put(sk);
-- 
2.53.0



