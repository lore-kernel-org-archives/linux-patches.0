Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2F7391832;
	Wed, 23 Sep 2026 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174208; cv=none; b=BDDYB3m0B0Yt82Fejkx8/hSZmi2RXxAluTtr4ufut2LovCg7aefB+S6kF6XfdlP/rJyulv3xABg9BtWokJghuxKHTLKUlJ76LFHrb6QQdE9MX2LupUHg1yGaI4xJgcbE9nTDxPkgF8HYJP3jPBFRz4JSKF6v+D/TwP3YTwR2VIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174208; c=relaxed/simple;
	bh=DxKBt0n1mwMVxkS9L73unl//mUtVq1l0HsnqpiNCRmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P46EA2TyCcsIrEkyY5vNozFn5z3cmRnwdLA7u8I8+af0HrD0jiHtZ46GKlwBWSoisWOfPPPLrJ26T0Wm06V1A3Oj8wHQ95rX8qVZqsgegIFLXZKWr6JUTYwUBWsWq2SgBsiOFFvmGBL2tb2qeaW0fHVLwPYSV0fWoC3BVVM9wHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oupCwpRx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oupCwpRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D081F000FF;
	Wed, 23 Sep 2026 14:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174207;
	bh=ZtcEx/9gYDCO+JnIEU/tYqXCugsZ6QoszboCX5pwR/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oupCwpRx77qYRk2jJntKEKFVQqvW3Cl4wG9bFdWZU+4EqU2Eo4RexqUEmbK4IaLWL
	 S9Lx7J2FB8qraDnVhs5O38JJGOPQ8XsSomX47njZr2daLRW43bWT0a93pitwBlPQ9P
	 pSK6Jwi7KM2gTAdB7/M29uRr0c8aEp/GaGqe6Amk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/398] wifi: mac80211: include TIM bitmap control for buffered S1G mcast traffic
Date: Wed, 23 Sep 2026 16:01:58 +0200
Message-ID: <20260923140644.567821092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e7df1a0c85911..cd1d814cdb824 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4954,10 +4954,18 @@ static void ieee80211_beacon_add_tim_pvb(struct ps_data *ps,
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
@@ -4966,6 +4974,10 @@ static void ieee80211_s1g_beacon_add_tim_pvb(struct ps_data *ps,
 	 */
 	skb_put_u8(skb, mcast_traffic | (31 << 1));
 
+	/* If there's no unicast traffic we don't need to include a PVB. */
+	if (!ucast_traffic)
+		return;
+
 	/* Emit an encoded block for each non-zero sub-block */
 	for (blk = 0; blk < IEEE80211_MAX_SUPPORTED_S1G_TIM_BLOCKS; blk++) {
 		u8 blk_bmap = 0;
@@ -5047,25 +5059,16 @@ static void __ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 
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



