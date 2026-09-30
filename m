Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAE950254F;
	Wed, 30 Sep 2026 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786411; cv=none; b=WYWg/BCHBt1xPwB5NJRQofSogaOcnEnTByn0vn40aoKq4m1JDdIB146a0smhaLDl9/fi4UBAxejjIi7nJBh67Q1FdWk/LuET2qzM8ziKzv2EfN7gViNJtybK32iVIelpl+zAyeM+Ot6SjWm+3tQvpDZc0blqvJyzfgdbRmALTUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786411; c=relaxed/simple;
	bh=lzSP0xDmVCXm56tTBm3slgcGXPlilzfYE6gRlg2V7XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYPROWfjHHdi9i2rEG5O7ux6zlPgBjthi51r/r+7B5pSlIww7TXsMYRpvk8qpao4+JtQ7YdtfvfkXBqgT4yyVKDScK94Hb7I2USbclBzmXeoKv3tJ+guOqiE0vgbsyNtzg8B7+YMVDs3bgShuRo9mDRxwSeFFhhGn6FYcOTG4DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktzDWC36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktzDWC36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7287D1F000FF;
	Wed, 30 Sep 2026 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786410;
	bh=RJfyvXquONT8Ze/xibAc+Y3XPZJs2fmEP/jeW/Rr4RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktzDWC36ODvXRszZGyKIJBQ65Knmi+5QOHgwZIEmJHq1fZU0xGl6C8P039sZOYI3I
	 v7wzfwSCT1Y6FFL0vZhT/VwgjKNmlApFOu2gFMClEr2NUdvcHqL2+jVC0FK0O0ZV/j
	 s+kefoglaQRn3GeZrHoEconBEwgu/Vj66YJ+0ihY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 852/982] Bluetooth: bnep: fix out-of-bounds reads on short RX/TX frames and control fallthrough
Date: Wed, 30 Sep 2026 17:26:28 +0200
Message-ID: <20260930152435.049492469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

[ Upstream commit f0ca020cbb9bb7f3f4ea8ba1dfcf30a282aec91e ]

Fix multiple out-of-bounds reads in Bluetooth BNEP frame processing:

1. In bnep_rx_frame() and bnep_ctrl_frame() (net/bluetooth/bnep/core.c),
   use pskb_may_pull() to verify the BNEP header, control type byte,
   filter count, and extension headers exist before reading them, and
   return 0 after handling BNEP_CONTROL instead of falling through to
   Ethernet frame submission when no extension headers follow.
2. In bnep_net_xmit() (net/bluetooth/bnep/netdev.c), verify skb->len >=
   ETH_HLEN with pskb_may_pull() before reading the 14-byte Ethernet
   header to prevent an out-of-bounds heap read and infoleak on short
   AF_PACKET TX frames.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/bnep/core.c   | 17 ++++++++++++++++-
 net/bluetooth/bnep/netdev.c |  8 +++++++-
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index a691d228f66c5..d6f69b6710623 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -273,9 +273,14 @@ static int bnep_rx_extension(struct bnep_session *s, struct sk_buff *skb)
 
 		BT_DBG("type 0x%x len %u", h->type, h->len);
 
+		if (skb->len < h->len) {
+			err = -EILSEQ;
+			break;
+		}
+
 		switch (h->type & BNEP_TYPE_MASK) {
 		case BNEP_EXT_CONTROL:
-			bnep_rx_control(s, skb->data, skb->len);
+			bnep_rx_control(s, skb->data, h->len);
 			break;
 
 		default:
@@ -376,6 +381,11 @@ static int bnep_rx_frame(struct bnep_session *s, struct sk_buff *skb)
 			goto badframe;
 	}
 
+	if ((type & BNEP_TYPE_MASK) == BNEP_CONTROL) {
+		kfree_skb(skb);
+		return 0;
+	}
+
 	/* Strip 802.1p header */
 	if (ntohs(s->eh.h_proto) == ETH_P_8021Q) {
 		if (!skb_pull(skb, 4))
@@ -454,6 +464,11 @@ static int bnep_tx_frame(struct bnep_session *s, struct sk_buff *skb)
 		goto send;
 	}
 
+	if (skb->len < ETH_HLEN) {
+		kfree_skb(skb);
+		return 0;
+	}
+
 	iv[il++] = (struct kvec) { &type, 1 };
 	len++;
 
diff --git a/net/bluetooth/bnep/netdev.c b/net/bluetooth/bnep/netdev.c
index cc1cff63194f0..5d9d851db926f 100644
--- a/net/bluetooth/bnep/netdev.c
+++ b/net/bluetooth/bnep/netdev.c
@@ -169,6 +169,12 @@ static netdev_tx_t bnep_net_xmit(struct sk_buff *skb,
 
 	BT_DBG("skb %p, dev %p", skb, dev);
 
+	if (!pskb_may_pull(skb, ETH_HLEN)) {
+		dev->stats.tx_dropped++;
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 #ifdef CONFIG_BT_BNEP_MC_FILTER
 	if (bnep_net_mc_filter(skb, s)) {
 		kfree_skb(skb);
@@ -221,7 +227,7 @@ void bnep_net_setup(struct net_device *dev)
 	dev->addr_len = ETH_ALEN;
 
 	ether_setup(dev);
-	dev->min_mtu = 0;
+	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = ETH_MAX_MTU;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 	dev->netdev_ops = &bnep_netdev_ops;
-- 
2.53.0



