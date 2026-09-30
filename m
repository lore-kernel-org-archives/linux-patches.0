Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02465509F06;
	Wed, 30 Sep 2026 18:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792377; cv=none; b=vAuM28prEGBTKu5O40MIcwTcfrojDHUPBhVJs9o9p4RwIXW196lSHiE0Qd8LvJgTKEjHJDIAy9bV+iSQJiYc5Ye15sbYUyY+gn4LqlAno3f4qxa3K2ApeTzW2apjl2MrQyO3khDIna1wtkLD+Aw8DZ/sFBNduefU/tCtWEqW3IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792377; c=relaxed/simple;
	bh=LCIr8cERxQFuFgZprdLc7OfW4RWaQz13gnT1iN+jOmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVpcL+Q4J2f08cEo9qmu3kd5S4TZc+RN3FgjbWc1jBc97bUfR5tCzjiI0BCo85BsQX9ahyYenhbracLq7xMibS4vKoipQk7uxBRjXfJsPJ7um6eGNCNa1weFvUnQAxbUKo+uFj53G0ldH6K6yygtb2XtRoXPV5ZztYv1dSSWk0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWWL35a1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWWL35a1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3551E1F000FF;
	Wed, 30 Sep 2026 18:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792375;
	bh=+YorkqdlJbN/l2ythzEq5+zB2SBjHgLcLnu0TcsfRvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWWL35a1Rgfyf/rb7zraHkFH2PALwE0jgT0sZgiBC8jIGgeKVyV+O3j0yIhb8EGJU
	 dnv6xow8bm3nT0aSrkWHSMPHXNHQjdc4zj9nQQgipJzmLWN45ivJ93PCSdMGAr3bfn
	 5oopY4AYfRxK6y2BppzUiBB8KtIFToRfFLNAI91U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 633/752] Bluetooth: bnep: fix out-of-bounds reads on short RX/TX frames and control fallthrough
Date: Wed, 30 Sep 2026 17:28:23 +0200
Message-ID: <20260930152411.968623447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index ee1e22e4c315c..c00243fa79bf2 100644
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



