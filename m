Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C44527599;
	Wed, 23 Sep 2026 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172863; cv=none; b=HDLcHMV2VcWEK05WjRmgQIFRP+Y8bQWWSSuE7sqqv8Vm9YThdYNHFLAHXFWtbvjGy8IonNurmyCnUvp0SDqmmKRKGFBH4UjnHfHwgGYdp9QGt89d3N/EzslHQ7bQ4cvzAGOKjVl/iJiFkH01hCx5pxF2IZPvRU+4RKiYM3+ZjCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172863; c=relaxed/simple;
	bh=vzMc/pDERlwXfOYlLfQzAOW4DA3Isod0TdFGOfZkwig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pru/Szu5ubat1NlTvlsoKkoprZt15BeXaOFM7tXrQoZUq6NIGH1GuB3x9zB0Nyvn025Ye3K7v1InvRrBxNdwHU0PhrWfcOV0/zg8g0i0yew1ksZKDH2vhV+h1lldWv3iBgNflDDsiUdgSf7hNYu/iX9Ax8q3YPHc8ZE974o3Ki0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9KlL60B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9KlL60B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2506D1F000FF;
	Wed, 23 Sep 2026 14:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172861;
	bh=GQZ8fRLlrSSkz2CmHRK+DDZvNH0Hgjyxh6fQCqI/SuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9KlL60BB9r5iroPxo0EGFakwNqV9TqcGr1HjCl0m+JDeHyVjoXCJP1XNxoUH90hz
	 b2dnRz7R0YRZD/wC/5B8bA4RfsuTPY7+yFLj4BZvj7Q9RaazllQdJJV3fURvkxnM9R
	 wUd4qAFL2FC/ZGKtT+7p2HcxFFqKteJCKQdenob4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 047/438] wifi: mac80211: include TIM bitmap control for buffered S1G mcast traffic
Date: Wed, 23 Sep 2026 16:01:08 +0200
Message-ID: <20260923140646.004543723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit af72b5946d493cecced27d0951ea37c1d178601e ]

Currently when building the S1G TIM element, we only build the bitmap
control if we have buffered unicast traffic. Since AID 0 sits within
the bitmap control if we have buffered multicast traffic with no
buffered unicast traffic the bitmap control won't be emitted and
dozing stations will be unaware of buffered multicast.

To fix, only exclude the bitmap control byte when we don't have
both buffered unicast and multicast traffic.

Fixes: ee6360945483 ("wifi: mac80211: support block bitmap S1G TIM encoding")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260827054302.254124-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index fd4c379b3f201..7cb9dd1b27314 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5063,10 +5063,18 @@ static void ieee80211_beacon_add_tim_pvb(struct ps_data *ps,
  */
 static void ieee80211_s1g_beacon_add_tim_pvb(struct ps_data *ps,
 					     struct sk_buff *skb,
-					     bool mcast_traffic)
+					     bool mcast_traffic,
+					     bool ucast_traffic)
 {
 	int blk;
 
+	/*
+	 * if no unicast and multicast traffic don't emit a bitmap control
+	 * or pvb
+	 */
+	if (!mcast_traffic && !ucast_traffic)
+		return;
+
 	/*
 	 * Emit a bitmap control block with a page slice number of 31 and a
 	 * page index of 0 which indicates as per IEEE80211-2024 9.4.2.5.1
@@ -5075,6 +5083,10 @@ static void ieee80211_s1g_beacon_add_tim_pvb(struct ps_data *ps,
 	 */
 	skb_put_u8(skb, mcast_traffic | (31 << 1));
 
+	/* If there's no unicast traffic we don't need to include a PVB. */
+	if (!ucast_traffic)
+		return;
+
 	/* Emit an encoded block for each non-zero sub-block */
 	for (blk = 0; blk < IEEE80211_MAX_SUPPORTED_S1G_TIM_BLOCKS; blk++) {
 		u8 blk_bmap = 0;
@@ -5156,25 +5168,16 @@ static void __ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 
 	ps->dtim_bc_mc = mcast_traffic;
 
-	if (have_bits) {
-		if (s1g)
-			ieee80211_s1g_beacon_add_tim_pvb(ps, skb,
-							 mcast_traffic);
-		else
-			ieee80211_beacon_add_tim_pvb(ps, skb, mcast_traffic);
+	if (s1g) {
+		ieee80211_s1g_beacon_add_tim_pvb(ps, skb, mcast_traffic,
+						 have_bits);
+	} else if (have_bits) {
+		ieee80211_beacon_add_tim_pvb(ps, skb, mcast_traffic);
 	} else {
-		/*
-		 * If there is no buffered unicast traffic for an S1G
-		 * interface, we can exclude the bitmap control. This is in
-		 * contrast to other phy types as they do include the bitmap
-		 * control and pvb even when there is no buffered traffic.
-		 */
-		if (!s1g) {
-			/* Bitmap control */
-			skb_put_u8(skb, mcast_traffic);
-			/* Part Virt Bitmap */
-			skb_put_u8(skb, 0);
-		}
+		/* Bitmap control */
+		skb_put_u8(skb, mcast_traffic);
+		/* Part Virt Bitmap */
+		skb_put_u8(skb, 0);
 	}
 
 	tim->datalen = skb_tail_pointer(skb) - tim->data;
-- 
2.53.0



