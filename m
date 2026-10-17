Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87873AB47A;
	Sat, 17 Oct 2026 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255138; cv=none; b=Ar048cAr2NW7iZm7BbaSb82auSSFanNAjn9pO8d6ruKcARzRnIGL5URFQVvOzx09sATAMFDX4GUDYI56JTODix3WX73Jy5ljoXw54g0xkHjKE13VGmBPnvjt4HCruDq7bHxQLG6gGtiWQoxhsmjwfOLuV4Fyn/qZtyVCRFZVxJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255138; c=relaxed/simple;
	bh=jKT0MTsaJ/SVYoltbIL08bY9gHPo+XdXNlX0Z4ycI0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjvYo8chiIa1a14+Yd4E/2nXsSFiLb07D86ROPiAbWnhFxt7H/Cft0J2oyTpV0ZngUVT8FdGvx3K8RDI8hsoy6iECjxkc1yeV+LDckJ9ZrYn18EDJlqQ/8n5Rj7JGU74h4dR5KxU87ZB0r0laEGxhGUj57iNAEhGTy/nyLu5oUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTMNXP95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTMNXP95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5568E1F000C6;
	Sat, 17 Oct 2026 16:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255137;
	bh=OGLK5JAoy/FX24iuvmITlDG+WReJJeOb7z2PYdfSGiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTMNXP95I9ErLFgnywS36J4ocwR4CSZC/kWRy9/R7BAwwhqdSm2FbfajBVPmADFC5
	 Zpu+O6whcnxWEir4Wmm8/Ap/xrsCkErcz5IvVXC8KxAKni5rjrHps5kp7VYBJ0s5n8
	 6ZSfO3BFrDAizy7S1U1N3rxE5iCnKrqLGNAytMpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 677/869] wifi: mt76: cancel reset and rc work on device unregister
Date: Sat, 17 Oct 2026 17:58:38 +0200
Message-ID: <20261017160054.341795763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 9b0f326c231c8..cd18540dc98ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1288,6 +1288,8 @@ int mt7915_register_device(struct mt7915_dev *dev)
 void mt7915_unregister_device(struct mt7915_dev *dev)
 {
 	cancel_work_sync(&dev->dump_work);
+	cancel_work_sync(&dev->reset_work);
+	cancel_work_sync(&dev->rc_work);
 	mt7915_unregister_ext_phy(dev);
 	mt7915_coredump_unregister(dev);
 	mt7915_unregister_thermal(&dev->phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index d3d63f07d7b05..6da42d9411656 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1405,6 +1405,8 @@ void mt7996_unregister_device(struct mt7996_dev *dev)
 {
 	cancel_work_sync(&dev->dump_work);
 	cancel_work_sync(&dev->wed_rro.work);
+	cancel_work_sync(&dev->reset_work);
+	cancel_work_sync(&dev->rc_work);
 	mt7996_unregister_phy(mt7996_phy3(dev), MT_BAND2);
 	mt7996_unregister_phy(mt7996_phy2(dev), MT_BAND1);
 	mt7996_unregister_thermal(&dev->phy);
-- 
2.53.0



