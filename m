Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208029;
	b=5FNMdxH6kA74YhytUFaEZiJBhc3RPgI5bYT0dai4JG5mWNCYlEwseS4E4FBM3GqRr/dx
	 BtHF61ns9AYv2jBL3C6U6D1eYsccZ6uJIiwElj9nqd9fMosTBDhlb0JRyp13ou8JLjlmI
	 jQAOMkh5a75neoH069Hsd8AAiy/2jqae4i0GWtq5ed6GIgdz5jUtmA16ISb+4E7yRAE8o
	 2Y6oUN2cKA3S4Xg3KO1svklySQo0oO4kMa+l3IlKQxwU32VZxW3SPGSp4vdbk39mS2SSr
	 YgiadYMHvUWHDgIa+kpEXifv3gH+kWbdLlVo4nUvdjbsWeHefoIyuuwGgFohJfK3Eqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FGXIpAAg0nTBrMwGSk98AzopYTUBpsK6QfINb7sx408=;
	b=itEeTVHpZvpuphExNRi0JdV9+pyA4Fv6jJBooOaHW4tCh8IaDXaL9mCsvNSeJIwpzTfO
	 8DlefQKZki75ez/BRGN60IFM7gQf8f9mg3MiSKU1nnzgV1un8LvZ1EaI/khZlL9yL+WLI
	 KlVvOr91IxaIb1J35NjJXtAFTBWCwcMKGt5B83DmXNXf++zRejTzRlVbxQfNDtUCZsHx/
	 WUojFRUzBxY1W3gLPO3Pn3xemlfAeMOw/OzJ0KmnO7UIEIy8yG3erZYY+3JmQkrcVzMuo
	 H2csj94ARdgzd8bIbMMpantUIz5S9YE7BAbCym8XeONIA8wMqYGCUrUsFXKahyIPgBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDVlOi4w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E3606A31A;
	Wed, 28 Oct 2026 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDVlOi4w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03921F01829;
	Wed, 28 Oct 2026 17:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208029;
	bh=FGXIpAAg0nTBrMwGSk98AzopYTUBpsK6QfINb7sx408=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDVlOi4wi06WpJasO2K2sBTuvlFWb2nfsK6xX48JP0i0lkGC3z21psRb3zMVWmadA
	 jL9hJ0xxy8i6pNb1iEO5A+UtOFeWRwjZuhEYUsgxWry40D1jCktsviPsctg9QKcQSH
	 exfB42+JRFRg9QsQ6bfXfizqmLMuF6FMFoVcgIL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/247] ax25: dont free an incoming SABM skb left on the listeners queue
Date: Wed, 28 Oct 2026 17:59:44 +0100
Message-ID: <20261028165951.705758852@linuxfoundation.org>
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



