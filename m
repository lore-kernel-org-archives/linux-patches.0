Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D773D146D6D;
	Thu, 11 Apr 2024 10:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831266; cv=none; b=iCSp8ckL3reKBZiFCfjpUifzq2k0PQADNOOWUAYTjIzamalceaikTh5M7J5bbN/HXKZGKSqXCkr1W/pTskkphkMOkfvS8nJj/aHue5IlBH4kfJWlONKFsp37Aal8rcEYEfz+3rp3MO1VqVQpPR9CAQu+q17SDmp8rPpO0GqGg48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831266; c=relaxed/simple;
	bh=EHUkWvZWxGLkNFI0tzJXcw1AbDP85DUApjNnZF3jWFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCDEB9BcMQ5haIfunMY6LqPO0b/Cgr19+doTe9sB6d4H1Yoi0gY8HMH0Zbg78izLP53hzjB/IiHa3k3anp0lE6/1tW0+yOHKC8cLK+llrifnwVvzNd/Edn0vFPapu+vr9NjEXXB4ver57FUnXv2s0U1+bDbexxq2oGbhZY45FT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlmErJ5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlmErJ5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A056C43390;
	Thu, 11 Apr 2024 10:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831266;
	bh=EHUkWvZWxGLkNFI0tzJXcw1AbDP85DUApjNnZF3jWFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlmErJ5XKTV3HGx0WoQV6fhR9I21uULI8F4leTMVe25+TKggGKNi9yIStuZreF3ng
	 h6oFgHqknYdsRFVuuGZJvyqDWCxMnIEs8ivbF7i56bCJWbdSKLwEmLMmEdM4a3dKqV
	 FNSZdH7lSCsHuPcYECPMeFaJivi3b4sh95LF7l8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/114] wifi: mt76: mt7915: add locking for accessing mapped registers
Date: Thu, 11 Apr 2024 11:55:52 +0200
Message-ID: <20240411095417.629618344@linuxfoundation.org>
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

[ Upstream commit 0937f95ab07af6e663ae932d592f630d9eb591da ]

Sicne the mapping is global, mapped register access needs to be protected
against concurrent access, otherwise a race condition might cause the reads
or writes to go towards the wrong register

Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mmio.c  | 45 ++++++++++++++++---
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |  1 +
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index f4ad7219f94f4..a306a42777d78 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -490,6 +490,11 @@ static u32 __mt7915_reg_addr(struct mt7915_dev *dev, u32 addr)
 		return dev->reg.map[i].maps + ofs;
 	}
 
+	return 0;
+}
+
+static u32 __mt7915_reg_remap_addr(struct mt7915_dev *dev, u32 addr)
+{
 	if ((addr >= MT_INFRA_BASE && addr < MT_WFSYS0_PHY_START) ||
 	    (addr >= MT_WFSYS0_PHY_START && addr < MT_WFSYS1_PHY_START) ||
 	    (addr >= MT_WFSYS1_PHY_START && addr <= MT_WFSYS1_PHY_END))
@@ -514,15 +519,30 @@ void mt7915_memcpy_fromio(struct mt7915_dev *dev, void *buf, u32 offset,
 {
 	u32 addr = __mt7915_reg_addr(dev, offset);
 
-	memcpy_fromio(buf, dev->mt76.mmio.regs + addr, len);
+	if (addr) {
+		memcpy_fromio(buf, dev->mt76.mmio.regs + addr, len);
+		return;
+	}
+
+	spin_lock_bh(&dev->reg_lock);
+	memcpy_fromio(buf, dev->mt76.mmio.regs +
+			   __mt7915_reg_remap_addr(dev, offset), len);
+	spin_unlock_bh(&dev->reg_lock);
 }
 
 static u32 mt7915_rr(struct mt76_dev *mdev, u32 offset)
 {
 	struct mt7915_dev *dev = container_of(mdev, struct mt7915_dev, mt76);
-	u32 addr = __mt7915_reg_addr(dev, offset);
+	u32 addr = __mt7915_reg_addr(dev, offset), val;
 
-	return dev->bus_ops->rr(mdev, addr);
+	if (addr)
+		return dev->bus_ops->rr(mdev, addr);
+
+	spin_lock_bh(&dev->reg_lock);
+	val = dev->bus_ops->rr(mdev, __mt7915_reg_remap_addr(dev, offset));
+	spin_unlock_bh(&dev->reg_lock);
+
+	return val;
 }
 
 static void mt7915_wr(struct mt76_dev *mdev, u32 offset, u32 val)
@@ -530,7 +550,14 @@ static void mt7915_wr(struct mt76_dev *mdev, u32 offset, u32 val)
 	struct mt7915_dev *dev = container_of(mdev, struct mt7915_dev, mt76);
 	u32 addr = __mt7915_reg_addr(dev, offset);
 
-	dev->bus_ops->wr(mdev, addr, val);
+	if (addr) {
+		dev->bus_ops->wr(mdev, addr, val);
+		return;
+	}
+
+	spin_lock_bh(&dev->reg_lock);
+	dev->bus_ops->wr(mdev, __mt7915_reg_remap_addr(dev, offset), val);
+	spin_unlock_bh(&dev->reg_lock);
 }
 
 static u32 mt7915_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
@@ -538,7 +565,14 @@ static u32 mt7915_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
 	struct mt7915_dev *dev = container_of(mdev, struct mt7915_dev, mt76);
 	u32 addr = __mt7915_reg_addr(dev, offset);
 
-	return dev->bus_ops->rmw(mdev, addr, mask, val);
+	if (addr)
+		return dev->bus_ops->rmw(mdev, addr, mask, val);
+
+	spin_lock_bh(&dev->reg_lock);
+	val = dev->bus_ops->rmw(mdev, __mt7915_reg_remap_addr(dev, offset), mask, val);
+	spin_unlock_bh(&dev->reg_lock);
+
+	return val;
 }
 
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
@@ -813,6 +847,7 @@ static int mt7915_mmio_init(struct mt76_dev *mdev,
 
 	dev = container_of(mdev, struct mt7915_dev, mt76);
 	mt76_mmio_init(&dev->mt76, mem_base);
+	spin_lock_init(&dev->reg_lock);
 
 	switch (device_id) {
 	case 0x7915:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 21984e9723709..e192211d4b23e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -287,6 +287,7 @@ struct mt7915_dev {
 
 	struct list_head sta_rc_list;
 	struct list_head twt_list;
+	spinlock_t reg_lock;
 
 	u32 hw_pattern;
 
-- 
2.43.0



