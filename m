Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C79B230BDB;
	Sat, 12 Sep 2026 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224325; cv=none; b=DkQq3r+8v9fQRjLquKP+WKOgRe9+D7jrj5n3OE0twu5Gs+8CZs5KsFCjTD3wcOkPrj307mY4Ue3YegrbjYRIBjJArSRwSQATInFiSjcrmeuay8rKHYVMrOYwlq+yTjWT4UkYzZcP0zqHgPxyBz6AyU7zH0R/iZjW+P4I/OmwKok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224325; c=relaxed/simple;
	bh=vehlUecLpha69w5rtnsmJB1mSbP4gmVqrQvnZKVvZJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEYDx33xONfmaCKo8db2laPntHWuAnIk3sRTtz310KDEcJVyUEH3QEZZOvwm4SI2fwQcWhiaWExQjf0cPGTT2LHV9cDCK2IEG/FFrXMYfrJi/1m2jaCKLUgNbj/ilA+b5Ta1HDdtrcyIWD2yKhgN7kyTaHvHX4Lidy4hfglpg4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzyRB9T8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzyRB9T8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313DA1F000FF;
	Sat, 12 Sep 2026 14:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224324;
	bh=0WbzYxenT1An9cyUef+QdDD0etduVg7i4wTDVTpZjN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzyRB9T841NtHK7r6PwLHugKC4Yc02rhYLuPUsPHYb+sBT/2VlhaJOM/8kYa7Ww5S
	 57EwAr4ZkMxq7ZgrmiTgi0gS6zzU4CtBDj4E414qbgY9Qe8vC4lIcwptUi0YsClTV8
	 sYcj3oRuUljjXSrxn4hTOo/d46vXs4C43XKA5jl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0970/1424] wifi: mt76: mt7921: validate CLC firmware records
Date: Sat, 12 Sep 2026 08:56:42 +0200
Message-ID: <20260912065629.035699070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 80a07e5f3a27e..8308de5017d74 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -372,7 +372,8 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	struct mt76_dev *mdev = &dev->mt76;
 	struct mt792x_phy *phy = &dev->phy;
 	const struct firmware *fw;
-	int ret, i, len, offset = 0;
+	size_t clc_len, fw_data_len, len, offset = 0;
+	int ret, i;
 	u8 *clc_base = NULL, hw_encap = 0;
 
 	if (mt7921_disable_clc ||
@@ -397,13 +398,21 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
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
@@ -420,8 +429,19 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
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
@@ -433,7 +453,7 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 			continue;
 
 		phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
-						  le32_to_cpu(clc->len),
+						  clc_len,
 						  GFP_KERNEL);
 
 		if (!phy->clc[clc->idx]) {
-- 
2.53.0



