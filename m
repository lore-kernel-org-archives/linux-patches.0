Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209657;
	b=BJsQ8RWQXK2Wis4Q4f7w1pJ0ssI/4BH49wCVByMPfahQ8cG2gmMMkETPztpfYgibeM1s
	 KByEN4XozgDJElzsBUvhPPnj4+2G+LhzN8c8F5fNoBcEJPwLb83y/9cupJtZ7hrvUaYUK
	 O+Zq6GSrsQL36KQlQ0GTgmg1NkXnwV7IItcIUfgeSEUdPEkRwik09V9FAqU38Jts3aZY3
	 t3CuuGdNCfd9Bag4dr0nsp3Vl3JBpUtk9g9ru6RtzqvG33+zZ1GsWsaCN2RMUXe7vOF/b
	 +tEwFmSvCetkKuVOl2hZdu3LCgRE8eaHEMxZar4RHB0G7hngnbBogcKympPHIF10hmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zzK6SQLXrBkQjcT6FWldb38jm3v2supWylM/S16F5Iw=;
	b=WaY69YtPHUa1H0s7QsdzvFNRPqlgBC2IARmI4GmRczho/wYQR4zZaMhsJTLBdu55cu3s
	 J3hxUQTePMadsiAIKM03zGPSp3N0Ltf+TeoDHZfYOdL9uG8MW9CDM6xD39MY7Aj635Cg7
	 cMMr0vA345Q59MKFJ+d3M2kFsmjNQMKPxqNabPiS+8nSNiPojGaVOf/33gXvTrQWNZLP6
	 L2XAQfTbh5WoiaQHD6R6c2g48NRJgcCbThx2Q4K+kp44XZTOQVBKNd2wGROxWVsN7KR3a
	 w6j/o3BI2GbhliNl+suaaJ6KkqnCIGLFgPdRJlOoNv060bRMfIZtB2zkuFeoTEwepgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PLOTz3/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532C3606A31C;
	Wed, 28 Oct 2026 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLOTz3/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775211F01825;
	Wed, 28 Oct 2026 17:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209657;
	bh=zzK6SQLXrBkQjcT6FWldb38jm3v2supWylM/S16F5Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLOTz3/cLGQ9JKJYXaAIjHqA1Qbs7Umhn7uRfDtUW4O0Qsnf2xbeqXb7JqqukYvAO
	 cxLxrzTQ3+FX/jQWvW62NjLf07i6QFYYczl5cIcrP7m/ePPqhifp4qHWVubqPrx6jQ
	 cB2x7Da9AphY+5xszwmqEHh+3JEmBdmeChIzEfXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/109] ax25: dont free an incoming SABM skb left on the listeners queue
Date: Wed, 28 Oct 2026 18:00:14 +0100
Message-ID: <20261028165943.071796272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When a SABM comes in for a listening socket, ax25_rcv() creates the new
socket, puts the skb on the listener's receive queue and only then
allocates the digipeater path. If that allocation fails, the skb is
freed with kfree_skb() while it is still linked on the queue, and the
accept backlog count taken by sk_acceptq_added() is never given back.
The next accept() or the close of the listener then walks a queue that
contains a freed skb.

Allocate the path before the skb is queued, so that the error path only
has to free an skb nobody else knows about and to destroy the new
socket. The later allocation remains for a connection that has no
listening socket.

Only reachable when the atomic allocation fails for a call that comes
through digipeaters. Regression tested in QEMU (6.12.94 with lockdep
and KASAN): 14 incoming connections to a listening socket, each
accepted, served and closed, before and after; no report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 2d67e8e9f3d627327114fb946c3a28ef72becb2d)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_in.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index c81bc8c4563b5..1bcb5e321467d 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -383,6 +383,24 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 		}
 
 		ax25 = sk_to_ax25(make);
+
+		/*
+		 * Get the digipeater path before the skb goes on the
+		 * listener's queue: once queued it belongs to that queue
+		 * and cannot simply be freed if the allocation fails.
+		 */
+		if (dp.ndigi && !ax25->digipeat) {
+			ax25->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC);
+			if (!ax25->digipeat) {
+				kfree_skb(skb);
+				ax25_destroy_socket(ax25);
+				bh_unlock_sock(sk);
+				sock_put(sk);
+
+				return 0;
+			}
+		}
+
 		skb_set_owner_r(skb, make);
 		skb_queue_head(&sk->sk_receive_queue, skb);
 
@@ -406,14 +424,13 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 	ax25->dest_addr   = src;
 
 	/*
-	 *	Sort out any digipeated paths.
+	 *	Sort out any digipeated paths. A socket made from a listener
+	 *	already has its path allocated, see above.
 	 */
 	if (dp.ndigi && !ax25->digipeat &&
 	    (ax25->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 		kfree_skb(skb);
 		ax25_destroy_socket(ax25);
-		if (sk)
-			sock_put(sk);
 		return 0;
 	}
 
-- 
2.53.0



