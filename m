Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1008B37CD32;
	Sat, 12 Sep 2026 08:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200957; cv=none; b=PeMgC2Rg/CmwkN9Uwa6xU5bLLGlCQ2GdK0FVc9TpIBkIcK88A0jZd2ZK8Uq+h7rRxCUhKGbJTxmwBkcnim+6PU2k+Qfv4MhoWMJeLle8zzeOHwPyDW1vtci38ui3cVDwXbjoypp8RLKzURbwmveLym19uEBs4gNnrs6bPamK160=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200957; c=relaxed/simple;
	bh=aQJ9hWcxUymobLKXVBjT376QnISS+Fg6Ys/c8gJ5fsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htN6GncA5YErkyzZ8zCezzZNAa6+z2mRPZx1Z0QqMkCe0WfghA70sh6T1fyOiPHKUd1z0OBAcIc/fe5BtVtSIq8ePQItxNrYaz3rP4F588rj4BcKCnA6ShAyFlMsjZji21XzG6YPtc/zrDY/AIvRORmB13pAEMGgbuMjKFOqHis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWkSUsAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWkSUsAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E0F1F000FF;
	Sat, 12 Sep 2026 08:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200956;
	bh=/27+ZYfjJpj+zsTl4i5Z8yJpmKGuMeXN77Or6IX0wDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWkSUsAC3uNrM+6qsqouiGIT45aIfOOopu8SllJZzUS/A9dzl1RaWd5W4cxmoGbos
	 mAxJ2lk5Xc8tThU5QZaftrJdCzEaJPjd3g5OoeBruGxdJXvXOMVX2Q1DG3EEy/nIBT
	 xT9jqGq99L8Ccad1v882VxHvOyH8B0KX82AA+srs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0896/1815] wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER
Date: Sat, 12 Sep 2026 08:44:06 +0200
Message-ID: <20260912065709.954623656@linuxfoundation.org>
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
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 7024fadce2048..b99a48c3664ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2575,6 +2575,8 @@ void mt7996_mac_reset_work(struct work_struct *work)
 		cancel_delayed_work_sync(&phy->mt76->mac_work);
 	}
 
+	mutex_lock(&dev->mt76.mutex);
+
 	mt76_worker_disable(&dev->mt76.tx_worker);
 	mt76_for_each_q_rx(&dev->mt76, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
@@ -2592,8 +2594,6 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	}
 	napi_disable(&dev->mt76.tx_napi);
 
-	mutex_lock(&dev->mt76.mutex);
-
 	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
 
 	if (mt7996_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
-- 
2.53.0



