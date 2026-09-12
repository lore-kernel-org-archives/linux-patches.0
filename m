Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90D52264AB;
	Sat, 12 Sep 2026 16:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230447; cv=none; b=i7cvq7MLAf+fDLzAjvOywpSFzuA7HPPzACzjQMs7lmpBXBPHN5hK2Sxhcxo7us6k2aqJ7THz1/xHvPGRcVoG86OHOTSFRHnTisOYeHgsI36I8ImOnz9Pec4zHPu6Wjuq2d3hVDZp5TwVHq1DCQsULwT1+k/lEXSKw0KD5r7SSZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230447; c=relaxed/simple;
	bh=8UH+ZZBL3S4V1z+8DRDAzChTTw5a+Lz5E5TanlAgeEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8HKvcFQCiFkWhnuQpuvw7uvHC8fxWJ/8NLyYyp3KwI/gLDQKwoMrG/Y22zkcpeVYvuA8lVi1q7g2mfQQJT/pNHKvfCxLtMNl/KbsnEx/VFzmf99KMmTZksiDYMdH4ceXim5HRG6H/zU9Ff6ysIkEm1QU5SmaEX58ZR/3R6giJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMiShIuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMiShIuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17461F000FF;
	Sat, 12 Sep 2026 16:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230444;
	bh=/lPc5z/LflaEO2HR/VyBsEf4o68g2cjH/L0m4m577bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMiShIuf7Z0TudlO1b9wO89BheFBxn8bIPlXwGZ1em3IwjQfkU1ArIzF1zyGFrHQ7
	 Naj76wX17Tmw/TxpS9rKiH2Ew89xTnKqEPFO6siYyr9K0I8Sa3uwpVdNMoCBt60A9C
	 otnT0pBbgMlKqvRtU/iWYx8w3FSJ7fwQvHEexlQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0796/1191] wifi: mt76: mt7921: validate CLC firmware records
Date: Sat, 12 Sep 2026 08:58:44 +0200
Message-ID: <20260912065606.152059640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 9d719dc62f3bd..d34a2a3f9326c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -369,7 +369,8 @@ static int mt7921_load_clc(struct mt7921_dev *dev, const char *fw_name)
 	struct mt76_dev *mdev = &dev->mt76;
 	struct mt7921_phy *phy = &dev->phy;
 	const struct firmware *fw;
-	int ret, i, len, offset = 0;
+	size_t clc_len, fw_data_len, len, offset = 0;
+	int ret, i;
 	u8 *clc_base = NULL, hw_encap = 0;
 
 	if (mt7921_disable_clc ||
@@ -394,13 +395,21 @@ static int mt7921_load_clc(struct mt7921_dev *dev, const char *fw_name)
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
@@ -417,8 +426,19 @@ static int mt7921_load_clc(struct mt7921_dev *dev, const char *fw_name)
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
@@ -430,7 +450,7 @@ static int mt7921_load_clc(struct mt7921_dev *dev, const char *fw_name)
 			continue;
 
 		phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
-						  le32_to_cpu(clc->len),
+						  clc_len,
 						  GFP_KERNEL);
 
 		if (!phy->clc[clc->idx]) {
-- 
2.53.0



