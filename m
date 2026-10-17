Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CF938DC44;
	Sat, 17 Oct 2026 16:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255141; cv=none; b=f3aDv/D0EsaZhLZOOxotgczJmTsfeBRFmXBLUyZ8oJmSzYD39tZodJ5M4Vf5Nww4gAl7vM6n1IurIqKnswhoDxGGNXt/lRMUjqSMvVkK3bOqlCZWf+/EVMigaKpjr1xGgKSGs3IzY8Gpe0cnVUjbrryPsiv6AF/XVSW05imDTOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255141; c=relaxed/simple;
	bh=E6+0wDA05NAAooL0S+u6ZYPsgudLGySnLO+RoNO22n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8xJMglUImVoYLfCDKknWmVeH/j04LK4XvPOUM4TxGy4IcXhHEqwiH8GhhsvB4TYLo1Xf/DAE37Gmw+r7b+DnKe0pdv9rruBZv+wfKhed/b31QJF2H2XusFjvzK8tt38TnBpTu6Fl5EuK65wsXM6LQeHHZur6P4geHdpFRfLtwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avGAGu3f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avGAGu3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144281F000C4;
	Sat, 17 Oct 2026 16:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255140;
	bh=rwUxn0ezVprzOXGqsHYb4ZvbBCxzcipsQ1+PfmKzBrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avGAGu3fpFoxCJ6SNLdevOwxEsrxsUojM1Flu48zJR2UF5VGpxlZ4fKo1OEsaSgz7
	 +FGyOrdFxrVhCw5RavQm55gB9WTCbnZDWTgnH/gsMpoS5uGNy1fPUVt5idHuHup2uW
	 qYviCXmcu0VRN4I4a5cLSsqOpSwaRaevaKbhFEPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 678/869] wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER
Date: Sat, 17 Oct 2026 17:58:39 +0200
Message-ID: <20261017160054.365957873@linuxfoundation.org>
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

[ Upstream commit 6190db312b8230813f529f014b26247c6d9800d0 ]

mt7996_mac_reset_work() parked the tx worker and disabled the RX/TX NAPIs
before taking dev->mt76.mutex. mt76_worker_disable()/_enable() are plain
kthread park/unpark, not refcounted, and __mt76_set_channel() toggles the
same worker and the MT76_RESET bit under the mutex. An L1 SER racing a
channel switch could therefore have the worker unparked and MT76_RESET
cleared while the reset path resets the DMA rings, corrupting descriptors
or tokens. Take the mutex before disabling the worker, as mt7915 does.

Fixes: 27015b6fbcca ("wifi: mt76: mt7996: enable full system reset support")
Link: https://patch.msgid.link/20260724124813.3961474-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 24e0346ea3d88..89d8a22e967c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1916,6 +1916,9 @@ void mt7996_mac_reset_work(struct work_struct *work)
 		set_bit(MT76_RESET, &phy3->mt76->state);
 		cancel_delayed_work_sync(&phy3->mt76->mac_work);
 	}
+
+	mutex_lock(&dev->mt76.mutex);
+
 	mt76_worker_disable(&dev->mt76.tx_worker);
 	mt76_for_each_q_rx(&dev->mt76, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
@@ -1926,8 +1929,6 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	}
 	napi_disable(&dev->mt76.tx_napi);
 
-	mutex_lock(&dev->mt76.mutex);
-
 	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
 
 	if (mt7996_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
-- 
2.53.0



