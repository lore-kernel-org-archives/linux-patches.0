Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8B433689D;
	Sat, 12 Sep 2026 08:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200986; cv=none; b=NHNuEixWQ8xr+gLcJ6oVlI2AYylV0WgHthulnq/O80zXknMomgZJE0Ay7CPXPDjpa53QcF1jIERSzUJ1YZxVZmD9joE4Fd1Bs07EJ5VlgBhNJhi00gJZxHjaS98buXS5y7tBTJCaNQo6DjnvnEGfepM66eXFNt1HZqjpC9eXIVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200986; c=relaxed/simple;
	bh=8LqdK1jrs6LVf9o4tKaS9vYScADTEXoxjqFeFF2LKTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2iBzajpiIezaJmIwSV5Ivd4EzYuNOZxDF/lgTTJdULHdoU08zRjDCCfVkGW6bwyhV3JxZkm1bBwwJ4P0zzC2YepLaoFxFkatW5CZo2fHJM+Wa3yZ4taU+86KI2B1yRFaWqos1yopnXOV0jc2yxxYwZ+an2aqyxmNSjxnGD1dAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rV5y3XuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rV5y3XuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C8E1F000FF;
	Sat, 12 Sep 2026 08:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200985;
	bh=euY4ZbGzE2U1twR/23EHq3r8vJMRMpWbIUVJxiSosFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rV5y3XuVECPoWT6w+bDDaX71nLAVhVUZ5m0Kd0KbNmNdW5uo3OesqLnOmV9tqWB4v
	 j9RdZcDELzoZf8tCIv2ca5fVibVmCW2PcHBwFamOQB8IfquMalEdBejb/1AdCgp9+U
	 e5wTwFAYbZddRbugkNnwDcF1kByL76u8QNKNSfXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0902/1815] wifi: mt76: report data NSS for STBC frames in RX rate decode
Date: Sat, 12 Sep 2026 08:44:12 +0200
Message-ID: <20260912065710.099094661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 4238535e85d41abe6fad545bbcdb3d91d191637f ]

The RX rate decoder set status->nss straight from the PRXV NSTS field,
which for STBC frames is twice the data spatial-stream count. cfg80211
then reported a doubled RX bitrate in station dumps and radiotap. Halve
nss for STBC, matching the TX status path.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Fixes: d832f5e73815 ("mt76: connac: move mt76_connac2_mac_fill_rx_rate in connac module")
Link: https://patch.msgid.link/20260724124813.3961474-11-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c      | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 780320198f6ac..976043521f44f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -1069,6 +1069,10 @@ int mt76_connac2_mac_fill_rx_rate(struct mt76_dev *dev,
 		bw = FIELD_GET(MT_CRXV_FRAME_MODE, v2);
 	}
 
+	/* the hardware reports NSTS; report the data NSS for STBC frames */
+	if (stbc && nss > 1)
+		nss >>= 1;
+
 	switch (*mode) {
 	case MT_PHY_TYPE_CCK:
 		cck = true;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 259b18dcdc880..86120e3851bb9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -294,6 +294,10 @@ mt7996_mac_fill_rx_rate(struct mt7996_dev *dev,
 	dcm = FIELD_GET(MT_PRXV_DCM, v2);
 	bw = FIELD_GET(MT_PRXV_FRAME_MODE, v2);
 
+	/* the hardware reports NSTS; report the data NSS for STBC frames */
+	if (stbc && nss > 1)
+		nss >>= 1;
+
 	switch (*mode) {
 	case MT_PHY_TYPE_CCK:
 		cck = true;
-- 
2.53.0



