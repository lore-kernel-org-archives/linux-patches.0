Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361443E0097;
	Fri, 15 May 2026 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861627; cv=none; b=a8paNUUCASzcrJY60Z9aa2LqJOR9/wn7ffdpTHlEmwWXpG5kv2avHPlMJFjBnMpOv38hhotDoXwh1ml1+xivVF/SLtGMD2Q2nZOU0YRH2A1Erh5+t9hhHlrxIbVfo6jIpNsvcPiABSmRCmpDcqYI9C3L+yVRQJA/EiMYnCqxhFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861627; c=relaxed/simple;
	bh=wRsKkyfS/w9BLQT6UjrO+iKwtraII8Lxqar5G+xvZ6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mzgow8BX4o4/vULm7kI7mLc6IrxthUCxhOstUMniLAMYvtJESTdoCI+1+l2+GKHzVBL3eF2trATNxOQx6T10EOCP38PAHg9xH8Sigv2vgzWivNGTFiryL2Kqavdn8HrmV0mQD5dIH1/UGxvX+h1CK/eZZel7fFA63s0mZwYJBLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7Jc/+F0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7Jc/+F0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDEDC2BCB0;
	Fri, 15 May 2026 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861627;
	bh=wRsKkyfS/w9BLQT6UjrO+iKwtraII8Lxqar5G+xvZ6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7Jc/+F0rtaF2t1slH7D1srMiOMk/lFbh4ZFoTVdBAlOmHZTGkOCia3H/cQ6Us8LH
	 zX9cSua7xd9G4HJWypkiRPV7UyX7pQes36kDR7Ea0CClKzQSCkSQsm4ZY5uLau5vIh
	 xGrZjDrdwCJkoVKlBrTwUsvD0DnBkCjW/QG+f1kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Yi Cong <yicong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 401/474] wifi: rtl8xxxu: fix potential use of uninitialized value
Date: Fri, 15 May 2026 17:48:30 +0200
Message-ID: <20260515154723.724606449@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Yi Cong <yicong@kylinos.cn>

[ Upstream commit f8a2fc809bfeb49130709b31a4d357a049f28547 ]

The local variables 'mcs' and 'nss' in rtl8xxxu_update_ra_report() are
passed to rtl8xxxu_desc_to_mcsrate() as output parameters. If the helper
function encounters an unhandled rate index, it may return without setting
these values, leading to the use of uninitialized stack data.

Remove the helper rtl8xxxu_desc_to_mcsrate() and inline the logic into
rtl8xxxu_update_ra_report(). This fixes the use of uninitialized 'mcs'
and 'nss' variables for legacy rates.

The new implementation explicitly handles:
- Legacy rates: Set bitrate only.
- HT rates (MCS0-15): Set MCS flags, index, and NSS (1 or 2) directly.
- Invalid rates: Return early.

Fixes: 7de16123d9e2 ("wifi: rtl8xxxu: Introduce rtl8xxxu_update_ra_report")
Cc: stable@vger.kernel.org
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yi Cong <yicong@kylinos.cn>
Link: https://lore.kernel.org/all/96e31963da0c42dcb52ce44f818963d7@realtek.com/
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260306071627.56501-1-cong.yi@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |   28 +++++-------------
 1 file changed, 8 insertions(+), 20 deletions(-)

--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4809,20 +4809,6 @@ static const struct ieee80211_rate rtl8x
 	{.bitrate = 540, .hw_value = 0x0b,},
 };
 
-static void rtl8xxxu_desc_to_mcsrate(u16 rate, u8 *mcs, u8 *nss)
-{
-	if (rate <= DESC_RATE_54M)
-		return;
-
-	if (rate >= DESC_RATE_MCS0 && rate <= DESC_RATE_MCS15) {
-		if (rate < DESC_RATE_MCS8)
-			*nss = 1;
-		else
-			*nss = 2;
-		*mcs = rate - DESC_RATE_MCS0;
-	}
-}
-
 static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
 {
 	struct ieee80211_hw *hw = priv->hw;
@@ -4927,23 +4913,25 @@ static void rtl8xxxu_set_aifs(struct rtl
 void rtl8xxxu_update_ra_report(struct rtl8xxxu_ra_report *rarpt,
 			       u8 rate, u8 sgi, u8 bw)
 {
-	u8 mcs, nss;
-
 	rarpt->txrate.flags = 0;
 
 	if (rate <= DESC_RATE_54M) {
 		rarpt->txrate.legacy = rtl8xxxu_legacy_ratetable[rate].bitrate;
-	} else {
-		rtl8xxxu_desc_to_mcsrate(rate, &mcs, &nss);
+	} else if (rate >= DESC_RATE_MCS0 && rate <= DESC_RATE_MCS15) {
 		rarpt->txrate.flags |= RATE_INFO_FLAGS_MCS;
+		if (rate < DESC_RATE_MCS8)
+			rarpt->txrate.nss = 1;
+		else
+			rarpt->txrate.nss = 2;
 
-		rarpt->txrate.mcs = mcs;
-		rarpt->txrate.nss = nss;
+		rarpt->txrate.mcs = rate - DESC_RATE_MCS0;
 
 		if (sgi)
 			rarpt->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
 
 		rarpt->txrate.bw = bw;
+	} else {
+		return;
 	}
 
 	rarpt->bit_rate = cfg80211_calculate_bitrate(&rarpt->txrate);


