Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69609143C76;
	Thu, 11 Apr 2024 10:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831272; cv=none; b=MYqZ5tcQUDT9lC6nb4q+OmEL9p8sJuwQMqreJHqIuKi77felKyqlIYSZV3jarSmOi4VAouzWkiWxsM4OA4PRw48cfSHCgGiCHSe0RKp72f+5cjmOxFtHoh+E/U76ogku48OKrK6YFymXMLb8qCOZypfrigjvi1vdne95pqU/J3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831272; c=relaxed/simple;
	bh=u+t8wXSDs8BKQBYCa7zODCcXWh48gn1C6WoY41YRSIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/Hns3AOeBz3yeAiCDBA6zAg5zmpOTBon0cednz1i/qB72SZbHzwBy/Tv7gOYLYwwvF2KF+8c2CDlqk6LO5SUCyJ6dJHmbs+U1J2seZA/F7+lKS3hzoaOUjAL9n+moqZ+73Z3reI09kiqj8aRufXM9qB4iz7T6+sE5sD+jdPa3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHP6RXUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHP6RXUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F4EC433C7;
	Thu, 11 Apr 2024 10:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831272;
	bh=u+t8wXSDs8BKQBYCa7zODCcXWh48gn1C6WoY41YRSIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHP6RXUl8cUYHDB217iF8b2SjNGPgCEWLPWo1qfaQrqQ1N8MQP6Dyb8ocX/3qfcm9
	 bfBk/JgimghuN+kgb9d0ykf2wkJdTkkdeN5MJCXESHIgmlOkzz4/sP7DKqlMyO9rYs
	 FxvRGzPR+QSIHrqN4/1Ng7RsL/J1rbONs9VMmbjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/114] wifi: mt76: mt7996: add locking for accessing mapped registers
Date: Thu, 11 Apr 2024 11:55:54 +0200
Message-ID: <20240411095417.689539196@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 3687854d3e7e7fd760d939dd9e5a3520d5ab60fe ]

A race condition was observed when accessing mapped registers, so add
locking to protect against concurrent access.

Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mmio.c  | 64 ++++++++++++-------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  3 +-
 2 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 3a591a7b47ae6..e75becadc2e54 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -82,7 +82,6 @@ static u32 mt7996_reg_map_l1(struct mt7996_dev *dev, u32 addr)
 	u32 offset = FIELD_GET(MT_HIF_REMAP_L1_OFFSET, addr);
 	u32 base = FIELD_GET(MT_HIF_REMAP_L1_BASE, addr);
 
-	dev->reg_l1_backup = dev->bus_ops->rr(&dev->mt76, MT_HIF_REMAP_L1);
 	dev->bus_ops->rmw(&dev->mt76, MT_HIF_REMAP_L1,
 			  MT_HIF_REMAP_L1_MASK,
 			  FIELD_PREP(MT_HIF_REMAP_L1_MASK, base));
@@ -97,7 +96,6 @@ static u32 mt7996_reg_map_l2(struct mt7996_dev *dev, u32 addr)
 	u32 offset = FIELD_GET(MT_HIF_REMAP_L2_OFFSET, addr);
 	u32 base = FIELD_GET(MT_HIF_REMAP_L2_BASE, addr);
 
-	dev->reg_l2_backup = dev->bus_ops->rr(&dev->mt76, MT_HIF_REMAP_L2);
 	dev->bus_ops->rmw(&dev->mt76, MT_HIF_REMAP_L2,
 			  MT_HIF_REMAP_L2_MASK,
 			  FIELD_PREP(MT_HIF_REMAP_L2_MASK, base));
@@ -107,26 +105,10 @@ static u32 mt7996_reg_map_l2(struct mt7996_dev *dev, u32 addr)
 	return MT_HIF_REMAP_BASE_L2 + offset;
 }
 
-static void mt7996_reg_remap_restore(struct mt7996_dev *dev)
-{
-	/* remap to ori status */
-	if (unlikely(dev->reg_l1_backup)) {
-		dev->bus_ops->wr(&dev->mt76, MT_HIF_REMAP_L1, dev->reg_l1_backup);
-		dev->reg_l1_backup = 0;
-	}
-
-	if (dev->reg_l2_backup) {
-		dev->bus_ops->wr(&dev->mt76, MT_HIF_REMAP_L2, dev->reg_l2_backup);
-		dev->reg_l2_backup = 0;
-	}
-}
-
 static u32 __mt7996_reg_addr(struct mt7996_dev *dev, u32 addr)
 {
 	int i;
 
-	mt7996_reg_remap_restore(dev);
-
 	if (addr < 0x100000)
 		return addr;
 
@@ -143,6 +125,11 @@ static u32 __mt7996_reg_addr(struct mt7996_dev *dev, u32 addr)
 		return dev->reg.map[i].mapped + ofs;
 	}
 
+	return 0;
+}
+
+static u32 __mt7996_reg_remap_addr(struct mt7996_dev *dev, u32 addr)
+{
 	if ((addr >= MT_INFRA_BASE && addr < MT_WFSYS0_PHY_START) ||
 	    (addr >= MT_WFSYS0_PHY_START && addr < MT_WFSYS1_PHY_START) ||
 	    (addr >= MT_WFSYS1_PHY_START && addr <= MT_WFSYS1_PHY_END))
@@ -167,28 +154,60 @@ void mt7996_memcpy_fromio(struct mt7996_dev *dev, void *buf, u32 offset,
 {
 	u32 addr = __mt7996_reg_addr(dev, offset);
 
-	memcpy_fromio(buf, dev->mt76.mmio.regs + addr, len);
+	if (addr) {
+		memcpy_fromio(buf, dev->mt76.mmio.regs + addr, len);
+		return;
+	}
+
+	spin_lock_bh(&dev->reg_lock);
+	memcpy_fromio(buf, dev->mt76.mmio.regs +
+			   __mt7996_reg_remap_addr(dev, offset), len);
+	spin_unlock_bh(&dev->reg_lock);
 }
 
 static u32 mt7996_rr(struct mt76_dev *mdev, u32 offset)
 {
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
+	u32 addr = __mt7996_reg_addr(dev, offset), val;
+
+	if (addr)
+		return dev->bus_ops->rr(mdev, addr);
 
-	return dev->bus_ops->rr(mdev, __mt7996_reg_addr(dev, offset));
+	spin_lock_bh(&dev->reg_lock);
+	val = dev->bus_ops->rr(mdev, __mt7996_reg_remap_addr(dev, offset));
+	spin_unlock_bh(&dev->reg_lock);
+
+	return val;
 }
 
 static void mt7996_wr(struct mt76_dev *mdev, u32 offset, u32 val)
 {
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
+	u32 addr = __mt7996_reg_addr(dev, offset);
 
-	dev->bus_ops->wr(mdev, __mt7996_reg_addr(dev, offset), val);
+	if (addr) {
+		dev->bus_ops->wr(mdev, addr, val);
+		return;
+	}
+
+	spin_lock_bh(&dev->reg_lock);
+	dev->bus_ops->wr(mdev, __mt7996_reg_remap_addr(dev, offset), val);
+	spin_unlock_bh(&dev->reg_lock);
 }
 
 static u32 mt7996_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
 {
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
+	u32 addr = __mt7996_reg_addr(dev, offset);
+
+	if (addr)
+		return dev->bus_ops->rmw(mdev, addr, mask, val);
+
+	spin_lock_bh(&dev->reg_lock);
+	val = dev->bus_ops->rmw(mdev, __mt7996_reg_remap_addr(dev, offset), mask, val);
+	spin_unlock_bh(&dev->reg_lock);
 
-	return dev->bus_ops->rmw(mdev, __mt7996_reg_addr(dev, offset), mask, val);
+	return val;
 }
 
 static int mt7996_mmio_init(struct mt76_dev *mdev,
@@ -200,6 +219,7 @@ static int mt7996_mmio_init(struct mt76_dev *mdev,
 
 	dev = container_of(mdev, struct mt7996_dev, mt76);
 	mt76_mmio_init(&dev->mt76, mem_base);
+	spin_lock_init(&dev->reg_lock);
 
 	switch (device_id) {
 	case 0x7990:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index d5ef4137290db..25bb365612314 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -242,8 +242,7 @@ struct mt7996_dev {
 		u8 n_agrt;
 	} twt;
 
-	u32 reg_l1_backup;
-	u32 reg_l2_backup;
+	spinlock_t reg_lock;
 
 	u8 wtbl_size_group;
 };
-- 
2.43.0



