Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB32E299920;
	Sat, 12 Sep 2026 12:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217170; cv=none; b=M0v5LJW3FCkzLscfQqjf/RlVgKBAR7ChooQxJZF4ZhCHevVL3HTq91ZTJjkHx/6137AAcWi7L+Sva/349Cthym1BNByOxGeeOFVX3mIdjOZhiW82NPiGwCwsQuTlnglByeGnEf/KG2uQm0equ63qvJP4A4wB+6D/gGoO3mH+OZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217170; c=relaxed/simple;
	bh=V/IveVoaw2jk5glFHTKjw8WERAztZC5KoyBf/P3b8gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n209AL5G4IOqfnYcLv4I4GPtJIHN2oVojnqz+qvDqQOz4new+i7JFOS4sBO8Ecxa1ewf+Lsb1ta/Ouk69qwRwQTRXMchNpeFSa1axFUecbj7n3+0J4Et3W75HLcuPldd113iJ/pN5ikARLUoxE5cdPwwv1hSSbTSEb6XOqE7poE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBzbgdGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBzbgdGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC051F000FF;
	Sat, 12 Sep 2026 12:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217169;
	bh=Im4rfwqH0rZlSWxer9VQ9KuZiBWkIPPFGjoQ2Z98+gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBzbgdGKP+6Qk/3EhFD2VWBZgTVg3kT+Xo1Tt4yMiD5nMgwRm7KgOj9oGAfaV4rfN
	 ihsXIUOdcB/sgJNMuFlmchsUHSWZQSAbG3LFY+IwTeVhjKlfUlLlPpVB9LTZN8XJU1
	 shPyT5E8JSpz5I8H+hDGtPhU/LDvkjZbLthaNi8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0842/1376] wifi: mt76: mt7996: fix reg addr remap when addr is 0
Date: Sat, 12 Sep 2026 08:54:28 +0200
Message-ID: <20260912065626.313701921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit eb906eeff2d1e84b628dc210dada325269c71383 ]

When addr is less than the hardcoded threshold in __mt7996_reg_addr,
it indicates that remapping is unnecessary.
Currently, the flow remaps address 0x0 to MT_HIF_REMAP_BASE_L2,
which is incorrect.
To address this, modify __mt7996_reg_addr to return INVALID_REG_ADDR
if the address is not below the hardcoded value or is not present in
the mt7996_reg_map array.
Additionally, update the remap condition to check if addr is equal to
INVALID_REG_ADDR.

Fixes: 3687854d3e7e ("wifi: mt76: mt7996: add locking for accessing mapped registers")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Link: https://patch.msgid.link/20260727150434.1778520-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index bffee73b780cb..01d4b54a1acc6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -17,6 +17,8 @@
 static bool wed_enable;
 module_param(wed_enable, bool, 0644);
 
+#define INVALID_REG_ADDR	0xffffffff
+
 static const struct __base mt7996_reg_base[] = {
 	[WF_AGG_BASE]		= { { 0x820e2000, 0x820f2000, 0x830e2000 } },
 	[WF_ARB_BASE]		= { { 0x820e3000, 0x820f3000, 0x830e3000 } },
@@ -183,7 +185,7 @@ static u32 __mt7996_reg_addr(struct mt7996_dev *dev, u32 addr)
 		return dev->reg.map[i].mapped + ofs;
 	}
 
-	return 0;
+	return INVALID_REG_ADDR;
 }
 
 static u32 __mt7996_reg_remap_addr(struct mt7996_dev *dev, u32 addr)
@@ -212,7 +214,7 @@ void mt7996_memcpy_fromio(struct mt7996_dev *dev, void *buf, u32 offset,
 {
 	u32 addr = __mt7996_reg_addr(dev, offset);
 
-	if (addr) {
+	if (addr != INVALID_REG_ADDR) {
 		memcpy_fromio(buf, dev->mt76.mmio.regs + addr, len);
 		return;
 	}
@@ -228,7 +230,7 @@ static u32 mt7996_rr(struct mt76_dev *mdev, u32 offset)
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset), val;
 
-	if (addr)
+	if (addr != INVALID_REG_ADDR)
 		return dev->bus_ops->rr(mdev, addr);
 
 	spin_lock_bh(&dev->reg_lock);
@@ -243,7 +245,7 @@ static void mt7996_wr(struct mt76_dev *mdev, u32 offset, u32 val)
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset);
 
-	if (addr) {
+	if (addr != INVALID_REG_ADDR) {
 		dev->bus_ops->wr(mdev, addr, val);
 		return;
 	}
@@ -258,7 +260,7 @@ static u32 mt7996_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset);
 
-	if (addr)
+	if (addr != INVALID_REG_ADDR)
 		return dev->bus_ops->rmw(mdev, addr, mask, val);
 
 	spin_lock_bh(&dev->reg_lock);
-- 
2.53.0



