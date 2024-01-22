Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1C05397;
	Tue, 23 Jan 2024 00:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970799; cv=none; b=jQKFPs9MoxYoHfAPKWL0SkxbdXBekHbPF4iSV7KOGezgTiCJakOUJyBVG90TLluWpxgXWwjygvGNvMu1fsxTF8G8ft9uABxKftG6d5tbdH1POJlrYZ+VK4e46YuBfRm+2LFsSJHCUHtSNIkmN0X+SyM58iLpETbvUr/pvvzfZcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970799; c=relaxed/simple;
	bh=6hnrx0SvnfjRkGCcyFvggChq9UWdEHRebMyRuRIso4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glIBsiZ6KPHOfSXXF8kExMXlcObghV4HNnYA+AkHes7QiKOq/rfK1Z8nKB2JkBUhmDZ79egv4KHpCM5aM9/KU4z94Op2vEzpL+YnymSC8wQZ2Tg/FCC0shIZCMmo/rU6O7jjWH2BsGTqtwmVFlHJGp3FXET+jG5axUZJzq+KrKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alOvC3NA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alOvC3NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FD1C433F1;
	Tue, 23 Jan 2024 00:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970799;
	bh=6hnrx0SvnfjRkGCcyFvggChq9UWdEHRebMyRuRIso4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alOvC3NAK3CDOP+RuL/WlkCJstKiHE0N5EtyJ+9pYN9YXVLYWsNzywAEh/f2ltcZM
	 V9mesOciZQPNHwt2h0KN7200RCPW4EGWomiA0N9aroXsSN0lmfCWbdzZPsij9utyWG
	 i6+P9rhnuEbgAeYm6LM4GHWrkVmU8SY8+II1lJA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/417] wifi: mt76: mt7921: fix country count limitation for CLC
Date: Mon, 22 Jan 2024 15:54:39 -0800
Message-ID: <20240122235755.604143170@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 10dda1693d7d..19640ff76bdc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1036,21 +1036,26 @@ int __mt7921_mcu_set_clc(struct mt7921_dev *dev, u8 *alpha2,
 		u8 type[2];
 		u8 rsvd[64];
 	} __packed req = {
+		.ver = 1,
 		.idx = idx,
 		.env = env_cap,
 	};
 	int ret, valid_cnt = 0;
-	u8 i, *pos;
+	u16 buf_len = 0;
+	u8 *pos;
 
 	if (!clc)
 		return 0;
 
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



