Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D3338C2C0;
	Sat, 17 Oct 2026 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260141; cv=none; b=JfUlAaMdie4gixrAspaNu7PgdNbKSt/ymGcaPpmja96HxSpDaZASmqkLsFTgABAdPjXrhvzYj6s1cO/7xngttyoo5zmxMKTuzmrxbP6boMbp563tIZH5ZB4kKGs+KbZtWek6XmA7VH6bRbS5vd3SAWk//qnUpRNGzuIb3t8YAsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260141; c=relaxed/simple;
	bh=LETPtXmy/JG3Dd4j8YMyPRMd8FEU9QVriODpuMvngYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9aVcq1POyFXSGAjsBka4bE7jykv2Cv6+5A6cyVmk5mCSw/SXLnrcOPnpG7LcNn5VkvkcGKFBIazBXmuGIZmxRhPX1UNTC1gV//Jbdk0llU9mUUJDfptiuDAOn2uGKPoMR0QWpC1x+az405sdG9Sbm1K1XAHPGjdfWErSRX49cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejKQbSh4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejKQbSh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5DE1F000C4;
	Sat, 17 Oct 2026 18:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260140;
	bh=Ni0T3qT4d8m6WipETRNih8rYPxaqztUNFZ3rYDrEVEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejKQbSh4zzEn/XsVHfi/yPBzmUODKYSVRoXdAK6Nat/wiI1PXu0QkqQSiCSi8qpwG
	 GMvc+EDGfPMyhMHI3+GAzHiiF2zrkocTDIksOdENw7qU8zGjNDj7fv131Mj5Ui+0Gl
	 ucmaxrEtf1FYqtYjDz9mbQ0UmXCFHQofPUtnPMws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1446/1674] wifi: mt76: cancel reset and rc work on device unregister
Date: Sat, 17 Oct 2026 18:01:58 +0200
Message-ID: <20261017160508.299231601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index c5f4ced8f4b11..711de6b1ce5bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1261,6 +1261,8 @@ int mt7915_register_device(struct mt7915_dev *dev)
 void mt7915_unregister_device(struct mt7915_dev *dev)
 {
 	cancel_work_sync(&dev->dump_work);
+	cancel_work_sync(&dev->reset_work);
+	cancel_work_sync(&dev->rc_work);
 	mt7915_unregister_ext_phy(dev);
 	mt7915_coredump_unregister(dev);
 	mt7915_unregister_thermal(&dev->phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index ed066acfbfa92..6acd7c10d28aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -931,6 +931,8 @@ int mt7996_register_device(struct mt7996_dev *dev)
 void mt7996_unregister_device(struct mt7996_dev *dev)
 {
 	cancel_work_sync(&dev->dump_work);
+	cancel_work_sync(&dev->reset_work);
+	cancel_work_sync(&dev->rc_work);
 	mt7996_unregister_phy(mt7996_phy3(dev), MT_BAND2);
 	mt7996_unregister_phy(mt7996_phy2(dev), MT_BAND1);
 	mt7996_coredump_unregister(dev);
-- 
2.53.0



