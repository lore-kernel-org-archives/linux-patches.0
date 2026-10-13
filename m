Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A45F4DA9D7;
	Tue, 13 Oct 2026 12:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894131; cv=none; b=NxFkaqcM0vIxhz17vVk6D8pTv9ETs3dDKsrsIH+sFC7di9zbkoDe5hEplBvzLfFBvNJBIIDUOYo+D+9HUrLFzKdbgxCja2vFrnFURe4PZve4z2DanpFwuMxqzOmiczNBtIvPqX/bfOJ0PM2vnZYCnlEukEP0du2vKvyDio7eswo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894131; c=relaxed/simple;
	bh=Q7tX349gjelqKqErXHBbHCKu8oTZA7HClNQyyA19Djo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvMtDCgKi6HjKo2m+zePRBFV+wAM1JATrccwaACor9J5OomuuXZLk1/k+z1bpTFsFMJRU2gFTg4O7XOKu3NHUSE5y/Axmg6wy4FkUOy4lfdcDTAYLKgZ2FVDfHYFIDQGTtJtAHyWeEl1DUP48sRKaNtJml30Mut8YscTxSs7OBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQWB+PKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQWB+PKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDB41F000FF;
	Tue, 13 Oct 2026 12:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894130;
	bh=ITOkowKVHpBT6BGEz5ioKiiB/yGdvp892g5/woW69I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQWB+PKoJPNeku5QCFrPaauuzETqa9z8SgJ8WoBZJgQG7f1T0rfSnHjPNFJ1XXKmr
	 g9oo7IWl0s39ULIYr8yRCPA58txqlS5yX9dt5vkdwi3/TSoHHw1Dv8XDahZcBpXWkZ
	 MRiddK7AT4JIqhkD/ZhDnGNzq/JTZIekzeHSJ45A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 457/621] wifi: mt76: cancel reset and rc work on device unregister
Date: Tue, 13 Oct 2026 13:37:32 +0200
Message-ID: <20261013112931.676864580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f247846520138..130650c18f02b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1293,6 +1293,8 @@ int mt7915_register_device(struct mt7915_dev *dev)
 void mt7915_unregister_device(struct mt7915_dev *dev)
 {
 	cancel_work_sync(&dev->dump_work);
+	cancel_work_sync(&dev->reset_work);
+	cancel_work_sync(&dev->rc_work);
 	mt7915_unregister_ext_phy(dev);
 	mt7915_coredump_unregister(dev);
 	mt7915_unregister_thermal(&dev->phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 4f50f6f482ddd..778a9ca8d5fa0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1736,6 +1736,8 @@ void mt7996_unregister_device(struct mt7996_dev *dev)
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



