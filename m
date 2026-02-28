Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1986B340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301076; cv=none; b=fbX6/hIiXmfb7BqY59jG19zI0YvUCVSNFSBQbc+nVfbdKYwwq8WfaMr4bH+vdSqIAB+PzoEQsPRQDUvg2ld5LfKe4bg+c1ocqsFPX8KVTTAGhYopKKfT0uS9/TyXBkyH1OyHcZ8QGswJVAJgP5/FQCvarQEU7uNCmmdTIRj9qZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301076; c=relaxed/simple;
	bh=awD29nvx2aphOkit+4HOtUSGi40fwC+8DL/sgkv8urc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uy+iCbgJuETP86pxDid3EFwCjxBmbU7okMh8E6csXRWZvqYbGbFmxg/Vz8cUDak9zhS2SmedyfH7Irdl0fKeWLVvFg9Gffkffr0fcTylvR5rGeW4+4weCZHEYJYbZjBMug7m73zpNj96YcpKzGQz0B08KtU1zQoMv0ehYNEOISk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIA4bv1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIA4bv1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7B5C19423;
	Sat, 28 Feb 2026 17:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301076;
	bh=awD29nvx2aphOkit+4HOtUSGi40fwC+8DL/sgkv8urc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIA4bv1hDZj2ktdkAU50iFXoqNDb9nPv0dlFT6k5541neNpN+al4u/kH+zkD1bf9z
	 u/Cuk+JsYfuT4IWaZcTBHZhLKMfEZDtmrUf3F4Mf0BD+vUkaEHp9Xzl6z/GI2Rwwmh
	 oNKykXJU4FbRs3aiFmEV69QX8kzEWZcgv5sRP3JGt+sPLF9QKxZupR1LZbP8nSy3FS
	 Gzb4bh2AudBVPGS+cZLQcAQEDAqEt8ffv6vKMTqT4d9nRnQ8aGTOToBipv9+sdpzYg
	 RosW514AhTO1y+wLaUtIJis1lipI4yAdU+AtnkhX12XjyYvuWXm3e0E829I1+3gGDg
	 zjvKFZIVC96pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 222/752] wifi: rtw88: Fix inadvertent sharing of struct ieee80211_supported_band data
Date: Sat, 28 Feb 2026 12:38:53 -0500
Message-ID: <20260228174750.1542406-222-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit fcac0f23d4d20b11014a39f8e2527cdc12ec9c82 ]

Internally wiphy writes to individual channels in this structure,
so we must not share one static definition of channel list between
multiple device instances, because that causes hard to debug
breakage.

For example, with two rtw88 driven devices in the system, channel
information may get incoherent, preventing channel use.

Copied from commit 0ae36391c804 ("wifi: rtw89: Fix inadverent sharing
of struct ieee80211_supported_band data").

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/e94ad653-2b6d-4284-a33c-8c694f88955b@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 34 +++++++++++++++++++----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 6f35357e73246..dde2ea6a00e06 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1658,16 +1658,41 @@ static u16 rtw_get_max_scan_ie_len(struct rtw_dev *rtwdev)
 	return len;
 }
 
+static struct ieee80211_supported_band *
+rtw_sband_dup(struct rtw_dev *rtwdev,
+	      const struct ieee80211_supported_band *sband)
+{
+	struct ieee80211_supported_band *dup;
+
+	dup = devm_kmemdup(rtwdev->dev, sband, sizeof(*sband), GFP_KERNEL);
+	if (!dup)
+		return NULL;
+
+	dup->channels = devm_kmemdup_array(rtwdev->dev, sband->channels,
+					   sband->n_channels,
+					   sizeof(*sband->channels),
+					   GFP_KERNEL);
+	if (!dup->channels)
+		return NULL;
+
+	dup->bitrates = devm_kmemdup_array(rtwdev->dev, sband->bitrates,
+					   sband->n_bitrates,
+					   sizeof(*sband->bitrates),
+					   GFP_KERNEL);
+	if (!dup->bitrates)
+		return NULL;
+
+	return dup;
+}
+
 static void rtw_set_supported_band(struct ieee80211_hw *hw,
 				   const struct rtw_chip_info *chip)
 {
 	struct ieee80211_supported_band *sband;
 	struct rtw_dev *rtwdev = hw->priv;
-	struct device *dev = rtwdev->dev;
 
 	if (chip->band & RTW_BAND_2G) {
-		sband = devm_kmemdup(dev, &rtw_band_2ghz, sizeof(*sband),
-				     GFP_KERNEL);
+		sband = rtw_sband_dup(rtwdev, &rtw_band_2ghz);
 		if (!sband)
 			goto err_out;
 		if (chip->ht_supported)
@@ -1676,8 +1701,7 @@ static void rtw_set_supported_band(struct ieee80211_hw *hw,
 	}
 
 	if (chip->band & RTW_BAND_5G) {
-		sband = devm_kmemdup(dev, &rtw_band_5ghz, sizeof(*sband),
-				     GFP_KERNEL);
+		sband = rtw_sband_dup(rtwdev, &rtw_band_5ghz);
 		if (!sband)
 			goto err_out;
 		if (chip->ht_supported)
-- 
2.51.0

