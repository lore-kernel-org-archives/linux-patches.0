Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4504E73BA;
	Thu, 17 Sep 2026 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658384; cv=none; b=JuHtp4RhmibAKPwPMzFrn2LrkLHbS8Fu4JoX2zHwWXsuHZ3/AiVPSLacDn7JgwfSq57l62G+uBIMxrb7L44Gzq/5AbpM28YnwV6qgIQ9DGLs02Zj79EQDNSDMNOp/V5666boYMtkrYyMPv5WdGiJcBVvkK/+U4bfAniOEP7Samk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658384; c=relaxed/simple;
	bh=Ny1ZwU/Y1nwk8E1KwYyK5v1usI5/lFdrUOac8ye46bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZwHLjEKxZ4jgWm71ly8OUYWyZfPRofh0mkUOTB3V4f1L7aIycbRu9xMOHATX2V4U+Aw17H7YkSGSZB6KghRQaCHIrF7cUdtGP6hhKBdYpn35InCauumowasL0fL3mqCUjPc2eEFt5/FRdcvojsXZOZQLE1MFJYWm0zTrqOymmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IknfMxGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IknfMxGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666DC1F00893;
	Thu, 17 Sep 2026 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658374;
	bh=/wo454y5jCYZX5S0Jw7Ox6lX0WYIK5rCVEANn9Uu8iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IknfMxGY4i11yyzOuOq4gylqzG0oooCpXhSlzwkgpKLAG+reVQ3/Kc6Dtg+u1lVqT
	 W5wXlINDN2dU3fXbRDBDcy1EIzvLzBUwsN5mHtuLHm/Ph2qbwlPO4aE78oDGWNLzyI
	 O84bXFg5en9v8DO98ZwoxtttpxkE++ry2EfafzPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 002/733] wifi: mt76: mt7921: validate CLC firmware records
Date: Thu, 17 Sep 2026 16:05:10 +0100
Message-ID: <20260917151350.676180416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit 9417c5818a0146980c2608fda94c908e604eb033 ]

The CLC region is supplied by firmware, but the loader trusts the
region count and each record length. A malformed image can make the
region table pointer precede the firmware buffer, make the record loop
fail to advance, or index phy->clc past its end. Validate the table and
record bounds before dereferencing or copying.

Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Link: https://patch.msgid.link/CAMyXUJmh=WfwC4_KHupNxYR5e2Gy5QhBDL5TSG6XEW-XLa+X4Q@mail.gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 28 ++++++++++++++++---
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 25b9437250f7b..564dd836e0b38 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -415,7 +415,8 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	struct mt76_dev *mdev = &dev->mt76;
 	struct mt792x_phy *phy = &dev->phy;
 	const struct firmware *fw;
-	int ret, i, len, offset = 0;
+	size_t clc_len, fw_data_len, len, offset = 0;
+	int ret, i;
 	u8 *clc_base = NULL, hw_encap = 0;
 
 	dev->phy.clc_chan_conf = 0xff;
@@ -441,13 +442,21 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	}
 
 	hdr = (const void *)(fw->data + fw->size - sizeof(*hdr));
+	if (hdr->n_region > (fw->size - sizeof(*hdr)) / sizeof(*region)) {
+		dev_err(mdev->dev, "Invalid firmware region table\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	fw_data_len = fw->size - sizeof(*hdr) -
+		      hdr->n_region * sizeof(*region);
+
 	for (i = 0; i < hdr->n_region; i++) {
 		region = (const void *)((const u8 *)hdr -
 					(hdr->n_region - i) * sizeof(*region));
 		len = le32_to_cpu(region->len);
 
 		/* check if we have valid buffer size */
-		if (offset + len > fw->size) {
+		if (len > fw_data_len - offset) {
 			dev_err(mdev->dev, "Invalid firmware region\n");
 			ret = -EINVAL;
 			goto out;
@@ -464,8 +473,19 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	if (!clc_base)
 		goto out;
 
-	for (offset = 0; offset < len; offset += le32_to_cpu(clc->len)) {
+	for (offset = 0; offset < len; offset += clc_len) {
+		if (len - offset < sizeof(*clc)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		clc = (const struct mt7921_clc *)(clc_base + offset);
+		clc_len = le32_to_cpu(clc->len);
+		if (clc_len < sizeof(*clc) || clc_len > len - offset ||
+		    clc->idx >= ARRAY_SIZE(phy->clc)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		/* do not init buf again if chip reset triggered */
 		if (phy->clc[clc->idx])
@@ -477,7 +497,7 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 			continue;
 
 		phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
-						  le32_to_cpu(clc->len),
+						  clc_len,
 						  GFP_KERNEL);
 
 		if (!phy->clc[clc->idx]) {
-- 
2.53.0



