Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574C33DE456;
	Mon,  4 May 2026 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904170; cv=none; b=uQOJhD95DkmqleJ9+gCR4H9opNUwPV+YblobE7OWG/kmhGtGUa+C3iTiejxZe9F3Dibf3syTsJLp4ibDZ52+ZXdwvEgt4/3HxBZww0xeREgOqpcQsbOeql8b8RdJ7KXFvhvSr3iwWb9qfCfCb3b9Q6ImhmIEM2VaxI8hFQsJ3z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904170; c=relaxed/simple;
	bh=8wFbz1sD507gtI2451NfEtdYJNDWkStP0Sd54+2MJqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTmvAwAd2TYzvUZXYAMSHBKZ9c9qLRcC1oOKC5PBAXzJSFJZSuG3IBXl05p9YrhxCeao+ebNc18xlCQ/hORLAd3rMRbIl3ic+WJ+4/wts3/cvix+Qo+Fm7lGaouB5QrLB9TNDXMQmbHlGG3rpQlJbn/sqqv3fCn/+lc1A961aQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZGDDKCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZGDDKCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CF5C2BCF7;
	Mon,  4 May 2026 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904169;
	bh=8wFbz1sD507gtI2451NfEtdYJNDWkStP0Sd54+2MJqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZGDDKCZfYe2SW/OWsm1B/Op5SBrJ7oVemE/GMFaofVWxgQvwlDEj/WfsZVrv8tGh
	 QSBk3pYrODXrLfrlW35J+hfebwf4QX6VrCV/ZnI4pOcYZSNXUrMGWKIabRq/lzsJ5a
	 6UE3wzfllM3tSQz8ftvNlulwjJuTT5Gh97EjVjd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH 6.18 211/275] wifi: rtl8xxxu: fix potential use of uninitialized value
Date: Mon,  4 May 2026 15:52:31 +0200
Message-ID: <20260504135150.913742871@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Yi Cong <yicong@kylinos.cn>

commit f8a2fc809bfeb49130709b31a4d357a049f28547 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c |   28 +++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -4821,20 +4821,6 @@ static const struct ieee80211_rate rtl8x
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
@@ -4944,23 +4930,25 @@ static void rtl8xxxu_set_aifs(struct rtl
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


