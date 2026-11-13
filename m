Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585421;
	b=DXjBAzuntw45NBzTvIVrBdqtZ0Jl55XT5NFTylX1plUfVXQ66d2/OJA2k85yTq67DcRf
	 4DUmq2153pQsPK503MB44dpzv1LPp8lb3Bwn3yyb1QlEJZsHkRrDsoewOdAU+4S7i5jsP
	 0KJRAPVdzke7jIASO95dm3tfybMunttN7dCiMFHjeLqkfiYV87LKlSko6GSnboz2EfdWd
	 Un3yTLJnUM1G2sLeEZkjsRnH3XhGNTtx/64oGnAEdTGpaCs3e90Dpu9AFW6YdcuZwm6dr
	 inprkNMghePNF85IRtmZCBypzpUH62rJOjH7TjA5YV2pnzgzj0vZx15Ja4Lfjls9KEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fLtbqtMSKlOhXscyAjwAccYDD2ih73JeOrvXCql6NE0=;
	b=uheIinvS49vdyPkZGxVnEKRNB8ZHDhPqRcj5L8KVpO3QsMdUGhYKl3H/95nMOerUMcD5
	 dOgjKSHQhSfWN8hMu9eNd0ZTbXfkRkeX0Our6r2592tJZLbRs//zQwyQNGnmxhHvBSFq0
	 /O1lTIYHzJroakGLesmn0ggUAAhg3Y1BoYrFnwLlLYMpEelBLqCmxP/W8FYw91gmOCcJ9
	 D0d1Dj1zJHb+VzH1ETIZVtmX7E2ey8YaqWNYJGtVeXhwUj391V9w5oxq5tRp2cDvq2hHW
	 cCVAt6Ks3nKZIEr6sLuYt28t3C4Ar8BYUSnUPHXZ96Ut96u59bcKvH+V+oEZlqRoETA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCroEWYk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B2D60A380B;
	Fri, 13 Nov 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCroEWYk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D021F000C5;
	Fri, 13 Nov 2026 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585421;
	bh=fLtbqtMSKlOhXscyAjwAccYDD2ih73JeOrvXCql6NE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCroEWYkLTBswIYCr3nWSDzY4r6S2p2b21SCeaVCEMGf0t5wDnpFvRM+j3/1gWDG6
	 jVZHhcgJv5ulBl9H9sM2ftYo3CQJcJe8BkSvG7/Tx/+XZeAcdTLYU7LqI9pshL9mQL
	 oRKbrU56Oi2D4FaS7C1O414d8jQppaplLsr9z590=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 085/507] batman-adv: fix skb leak when hard_iface is being released
Date: Fri, 13 Nov 2026 10:46:29 -0500
Message-ID: <20261113153756.773112741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 522e4aece2e96cacbb8a6ae1eec0d4c0dd6f4fed ]

batadv_batman_skb_recv() owns the skb it is given. When the hard_iface
refcount already dropped to zero, the function jumped to err_out, which
only returned NET_RX_DROP and skipped the kfree_skb() under err_free.

To avoid a leak, free the skb before returning in this case.

Cc: stable@vger.kernel.org
Fixes: 4fe56e60ac1b ("batman-adv: Check hard_iface refcnt when receiving skb")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index d89d44706269b..eec28e7f82b51 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -483,8 +483,10 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	 * shut down otherwise the packet may trigger de-reference errors
 	 * further down in the receive path.
 	 */
-	if (!kref_get_unless_zero(&hard_iface->refcount))
-		goto err_out;
+	if (!kref_get_unless_zero(&hard_iface->refcount)) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
 
@@ -540,7 +542,6 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	kfree_skb(skb);
 err_put:
 	batadv_hardif_put(hard_iface);
-err_out:
 	return NET_RX_DROP;
 }
 
-- 
2.53.0



