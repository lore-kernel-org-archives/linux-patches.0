Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0179738E8A8;
	Sat, 12 Sep 2026 08:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200982; cv=none; b=biPaYhu4oMn59NOWPmYd3N+aDAmSVn4dBFRiOYPuxmVskkPOZdm3UmOqYnuLLgKXhfK1FI8AbPphYZLec0fTccDZ29BbH68OIZhql0itHDWCB1r+UBR1DvczSs0qdsxiePcXF/7r3tFhusbPlSIdLVxjvhY25s95RHq6Il/VgrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200982; c=relaxed/simple;
	bh=hrT6H3ZuZjK/GOxM46cg3Vb2YAxccDE57GLOUIexv+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OthynYpoVqaWuMK/bcSVoVjZbrYU00Z/oVg3wV8GLX5SfPy7sfLp+xt0DQic/ltePvBmadwswFV+JIm9jMGnqSKnvV808cOe0E2Pf3hyAZxXSlazlbRuSRNmZNKU5x0lqjtPMeuJHSldiN4TCc9tDedY8brE7U39TdRZKioQLt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJwsA6IS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJwsA6IS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F111F000FF;
	Sat, 12 Sep 2026 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200980;
	bh=J7deC4I5kyTqGfTPEeH1q0BftsLtJ3mOZD+PwQkkWvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJwsA6ISpQd4CnU9HPy4E08V5fjlWTITI5qqsHGUrfrnia0yMp2pawckjcskml9qt
	 cGQmzzW8na77p7RfTZwNBTSmWVVJ+P60HQj89KijeGMSrZEExkTmYzZls+1m3rybzz
	 hzcAZMQFmG00L7hZ+UuDP/cHyNNmvm9RKgHIhSNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0901/1815] wifi: mt76: cancel reset and rc work on device unregister
Date: Sat, 12 Sep 2026 08:44:11 +0200
Message-ID: <20260912065710.075618875@linuxfoundation.org>
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

[ Upstream commit e995d3dccc9d980af13a60ad37409ed1561f9eeb ]

Both drivers cancelled dump_work on unregister but left reset_work and
rc_work to be flushed only by destroy_workqueue() in mt76_free_device(),
which runs after the hw is unregistered and the hardware stopped. A
reset_work that fires in that window calls ieee80211_restart_hw() and
re-arms mac_work on an unregistered hw, and rc_work touches station state
being torn down. Cancel both up front, alongside dump_work.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20260724124813.3961474-10-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 250c2d2479b0c..a4ca8a46b73d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1295,6 +1295,8 @@ int mt7915_register_device(struct mt7915_dev *dev)
 void mt7915_unregister_device(struct mt7915_dev *dev)
 {
 	cancel_work_sync(&dev->dump_work);
+	cancel_work_sync(&dev->reset_work);
+	cancel_work_sync(&dev->rc_work);
 	mt7915_unregister_ext_phy(dev);
 	mt7915_coredump_unregister(dev);
 	mt7915_unregister_thermal(&dev->phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index de20553bc689d..3965127cae541 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1803,6 +1803,8 @@ void mt7996_unregister_device(struct mt7996_dev *dev)
 {
 	cancel_work_sync(&dev->dump_work);
 	cancel_work_sync(&dev->wed_rro.work);
+	cancel_work_sync(&dev->reset_work);
+	cancel_work_sync(&dev->rc_work);
 	mt7996_unregister_phy(mt7996_phy3(dev));
 	mt7996_unregister_phy(mt7996_phy2(dev));
 	mt7996_unregister_thermal(&dev->phy);
-- 
2.53.0



