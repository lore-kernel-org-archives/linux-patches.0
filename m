Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019007;
	b=zUu/NHm0Xi5An5aTwXZsyt1B+M1TZx+souhveqoAQeLHwj+HSahaJzyos2WzaTFjCc73
	 joU4iAQorfDyIyVn+bA1Tkc47hgTBArldnREC84SwJa1WCiEzxkdRK4nrm6li+4epHpY8
	 JHAi5RFoPm8VQJKeVoO7ubHa3XXlbihqfKWwc4HHx4bYQGkudlyRq9AVqOho7CebTY3yX
	 mQpu8X9XgyN3EgqCnWb6fFhDVoQLoOMHk1tAfDEh67zVVCcPKKjjdz8JqixqQdnznsw/N
	 hG9OnPwImlnNvAAC8Hiy0Y0YuPs1nW6GJ4q1I47JpTMMY2Kh8tx2qH5S/ayR9vaIfhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+fZcC0WjjxHoL+JYPXplnwmcDloX0OK2iho+pSD8OGI=;
	b=zOcPLiYxI+obted6dDEGlHPcVf+WzT5cPR844V5/zRD7462lQIZdBhoZmz1A4aBsGnXp
	 S6r4U3FVWUVhaxpdHVjixP69bmF6V42SDArOp1By/c0P01P0bw/QH6BeCG+f42tvex1dk
	 oOT/EfAtNFQ1dXL8VAQ7P3S6PAiQ3rbP7u9bbLq74eeOTIdyUcemu7cl0rBIsayRL/usI
	 AgA1/pkZ6CDpMq/LxlazWHp06tTR+QO2sugXoGh1p/5KCE6S/s6gKZUFgCjcNF0AMVdSH
	 z3WcwNqjeODJPjntpwh8Hlvt6lswRIVj16TE857KHv0rV++RSdhHTupo3qCAWxYxoxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BT2DMXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C1E606A31C;
	Wed, 18 Nov 2026 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BT2DMXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3E61F000C4;
	Wed, 18 Nov 2026 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019006;
	bh=+fZcC0WjjxHoL+JYPXplnwmcDloX0OK2iho+pSD8OGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BT2DMXg+Ff++MbPL/7oV+tKuDOEc7QD2YpIA9y1nQegLBC8oZfarkwo4guQsX9+4
	 LPd8CPLN8meLwvLBWUcS73p3jeff8rFiPLmotFaHvpWmF6xQQ532v+SVa/xMO9aleu
	 86wSxBA38EcdOURfPz5NwGlZ/5OiGWvUASASptaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1401/2651] wifi: mm81x: move beacon work and init below the tx op
Date: Wed, 18 Nov 2026 15:44:01 +0100
Message-ID: <20261118150338.448657813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 483e1ebc813280dc566210ec5c48738060355f62 ]

Move mm81x_mac_beacon_work() and mm81x_mac_beacon_init() to below
mm81x_mac_ops_tx() to prepare for future multicast handling such that
we avoid a forward declaration. No functional change.

Link: https://patch.msgid.link/20260827054917.255584-2-lachlan.hodges@morsemicro.com
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Stable-dep-of: 54b961097682 ("wifi: mm81x: start beaconing on beacon enable not interface add")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 84 ++++++++++-----------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 0fa80b1488aac..2760e9389518b 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -445,39 +445,6 @@ static void mm81x_beacon_h_fill_tx_info(struct mm81x *mors,
 			cpu_to_le32(MM81X_TX_CONF_FLAGS_IMMEDIATE_REPORT);
 }
 
-static void mm81x_mac_beacon_work(struct work_struct *work)
-{
-	struct mm81x_vif *mors_vif =
-		from_work(mors_vif, work, u.ap.beacon_work);
-	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
-	struct mm81x_skbq *mq;
-	struct sk_buff *beacon;
-	struct ieee80211_vif *vif = mm81x_vif_to_ieee80211_vif(mors_vif);
-	struct mm81x_skb_tx_info tx_info = { 0 };
-	int num_bcn_vifs = atomic_read(&mors->num_bcn_vifs);
-
-	mq = mm81x_hif_get_tx_beacon_queue(mors);
-	if (!mq) {
-		dev_err(mors->dev, "no matching beacon Q found");
-		return;
-	}
-
-	if (mm81x_skbq_count(mq) >= num_bcn_vifs) {
-		dev_err(mors->dev,
-			"previous beacon not consumed, dropping req [id:%d]",
-			mors_vif->id);
-		return;
-	}
-
-	beacon = ieee80211_beacon_get(mors->hw, vif, false);
-	if (!beacon)
-		return;
-
-	mm81x_beacon_h_fill_tx_info(mors, &tx_info, mors_vif,
-				    cfg80211_chandef_s1g_pri_width(&mors->chandef));
-	mm81x_skbq_skb_tx(mq, &beacon, &tx_info, MM81X_SKB_CHAN_BEACON);
-}
-
 void mm81x_mac_beacon_irq_handle(struct mm81x *mors, u32 status)
 {
 	int vif_id;
@@ -497,15 +464,6 @@ void mm81x_mac_beacon_irq_handle(struct mm81x *mors, u32 status)
 	}
 }
 
-static void mm81x_mac_beacon_init(struct mm81x_vif *mors_vif)
-{
-	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
-
-	INIT_WORK(&mors_vif->u.ap.beacon_work, mm81x_mac_beacon_work);
-	mm81x_mac_beacon_irq_enable(mors_vif, true);
-	atomic_inc(&mors->num_bcn_vifs);
-}
-
 static struct hw_scan_tlv_hdr mm81x_hw_scan_h_pack_tlv_hdr(u16 tag, u16 len)
 {
 	struct hw_scan_tlv_hdr hdr = { .tag = cpu_to_le16(tag),
@@ -1328,6 +1286,48 @@ static void mm81x_mac_ops_tx(struct ieee80211_hw *hw,
 				      MM81X_SKB_CHAN_DATA);
 }
 
+static void mm81x_mac_beacon_work(struct work_struct *work)
+{
+	struct mm81x_vif *mors_vif =
+		from_work(mors_vif, work, u.ap.beacon_work);
+	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
+	struct mm81x_skbq *mq;
+	struct sk_buff *beacon;
+	struct ieee80211_vif *vif = mm81x_vif_to_ieee80211_vif(mors_vif);
+	struct mm81x_skb_tx_info tx_info = { 0 };
+	int num_bcn_vifs = atomic_read(&mors->num_bcn_vifs);
+
+	mq = mm81x_hif_get_tx_beacon_queue(mors);
+	if (!mq) {
+		dev_err(mors->dev, "no matching beacon Q found");
+		return;
+	}
+
+	if (mm81x_skbq_count(mq) >= num_bcn_vifs) {
+		dev_err(mors->dev,
+			"previous beacon not consumed, dropping req [id:%d]",
+			mors_vif->id);
+		return;
+	}
+
+	beacon = ieee80211_beacon_get(mors->hw, vif, false);
+	if (!beacon)
+		return;
+
+	mm81x_beacon_h_fill_tx_info(mors, &tx_info, mors_vif,
+				    cfg80211_chandef_s1g_pri_width(&mors->chandef));
+	mm81x_skbq_skb_tx(mq, &beacon, &tx_info, MM81X_SKB_CHAN_BEACON);
+}
+
+static void mm81x_mac_beacon_init(struct mm81x_vif *mors_vif)
+{
+	struct mm81x *mors = mm81x_vif_to_mors(mors_vif);
+
+	INIT_WORK(&mors_vif->u.ap.beacon_work, mm81x_mac_beacon_work);
+	mm81x_mac_beacon_irq_enable(mors_vif, true);
+	atomic_inc(&mors->num_bcn_vifs);
+}
+
 static void mm81x_mac_ops_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct mm81x *mors = hw->priv;
-- 
2.53.0



