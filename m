Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5334F1350D6;
	Tue, 23 Jan 2024 00:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969352; cv=none; b=Vqc6y93cp0N41Xau7IoieuxHJdQws89v6AZHwh89t89/3KyGZ6iMWkSk9wv+qmvmUwlg9aWwu1CQeuTiw1kNNGiES+XJ+mUjzEIRsMaLmCZiCWH5o7PcYeOH62cNIy55uhSQmFsCuWBBRZFw9YQlgR5p63ubhjvp3rwg5RGENq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969352; c=relaxed/simple;
	bh=LietFI/ybLJIIaagksfy74z/jOHraVht0gaPj+9Ovlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQOxVs4t50YgF3W4064op1XtXR657dNmnynmT4+uf/e4I3+oKg4w2BEBA049ArcHi6YkSswJu9siMdk6lWaoCYAxagU+nWs4mNwZo0wXlyST/fpAvurErtzR0oD+2RelhngIgPrAIpMlti4YVNuig2knzRKTNIG2s5uxbsWhIQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5t5GBH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5t5GBH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A05C43394;
	Tue, 23 Jan 2024 00:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969352;
	bh=LietFI/ybLJIIaagksfy74z/jOHraVht0gaPj+9Ovlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5t5GBH/VnpuRKlKPuxhTLxVJkifGEzrMOUkRKMhUTZI5IDXbCrvP50C1xIH458yW
	 oVp9g+7q/AfsHj07ssGtPLjZpNkh4BBS+3lW3h9MUW9ndvnKLjfBDnVKpQ0IC2u7be
	 BmIkIFfjKH42VH+Dr+uA9OHfbHOco3gRgf2kfr3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 166/641] wifi: mt76: mt7921: fix country count limitation for CLC
Date: Mon, 22 Jan 2024 15:51:10 -0800
Message-ID: <20240122235823.214157662@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit fa6ad88e023ddfa6c5dcdb466d159e89f451e305 ]

Due to the increase in the number of power tables for 6Ghz on CLC,
the variable nr_country is no longer sufficient to represent the
total quantity. Therefore, we have switched to calculating the
length of clc buf to obtain the correct power table. Additionally,
the version number has been incremented to 1.

Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 2cc2d2788f83..399d7ca6bebc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1263,13 +1263,15 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		u8 env_6g;
 		u8 rsvd[63];
 	} __packed req = {
+		.ver = 1,
 		.idx = idx,
 		.env = env_cap,
 		.env_6g = dev->phy.power_type,
 		.acpi_conf = mt792x_acpi_get_flags(&dev->phy),
 	};
 	int ret, valid_cnt = 0;
-	u8 i, *pos;
+	u16 buf_len = 0;
+	u8 *pos;
 
 	if (!clc)
 		return 0;
@@ -1279,12 +1281,15 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 	if (mt76_find_power_limits_node(&dev->mt76))
 		req.cap |= CLC_CAP_DTS_EN;
 
+	buf_len = le16_to_cpu(clc->len) - sizeof(*clc);
 	pos = clc->data;
-	for (i = 0; i < clc->nr_country; i++) {
+	while (buf_len > 16) {
 		struct mt7921_clc_rule *rule = (struct mt7921_clc_rule *)pos;
 		u16 len = le16_to_cpu(rule->len);
+		u16 offset = len + sizeof(*rule);
 
-		pos += len + sizeof(*rule);
+		pos += offset;
+		buf_len -= offset;
 		if (rule->alpha2[0] != alpha2[0] ||
 		    rule->alpha2[1] != alpha2[1])
 			continue;
-- 
2.43.0



