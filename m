Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AE2419FC9;
	Sat, 12 Sep 2026 10:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209128; cv=none; b=LYl6CC2ffnxGWvThjkDRoXRwxGUbwXbaxlrD8FntSeFTdcEIw1qgchKt3qrMgI5ib87/afYoBiYzxw+/bq38cpfCQ7VUHGVPRoFE3/SzjLjmMhvGEWLxwKO1bt/zdFJ7eGSSpp8gdjTs3/PNA9MYqQV2zAO0w/Fv5yFowb5El9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209128; c=relaxed/simple;
	bh=ufKtw9sTLQYsVVDtwnbyLRNjMXFEpQK75zY1L8tXiSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tcq3FMTvUoCOi3GrnbZKdQSFYPwElOOlXxQpDhLWAl9z8uL58qx6zOB4cTZeE/U0GzUzvJa9qtWU/443vv/wmCXaruBrYDNtYnuJ686/PNWYPIZykoB+Offr0xigCA9Dg8wOPChI6GvctVNUkV4fjpGNT1EWa9d4QLjw4mdKe9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1m8JftTk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1m8JftTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850781F00893;
	Sat, 12 Sep 2026 10:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209127;
	bh=iEn/pY6zSh7TQg99BVWd2A6iOd6DAh02p+F483h2btA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1m8JftTkFriJ63Az5Tv1cRnUUIX0G25jkQQq+iJjBYuI66SvKZSJzLM329F5uUo8t
	 AY49+1TnFTGx9m0UtVZhUOZvtxCb7COnYCR9LDGedL9cT2VMG/AN5j+s+NBcvKOVcH
	 1JwdPbmATJDX7PFs94knvc1py5u9AzTWa7GZfNLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0758/1518] wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER
Date: Sat, 12 Sep 2026 08:48:47 +0200
Message-ID: <20260912065640.576091498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 11d56fdb7f26b..cafdbd27f1e48 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2630,6 +2630,8 @@ void mt7996_mac_reset_work(struct work_struct *work)
 		cancel_delayed_work_sync(&phy->mt76->mac_work);
 	}
 
+	mutex_lock(&dev->mt76.mutex);
+
 	mt76_worker_disable(&dev->mt76.tx_worker);
 	mt76_for_each_q_rx(&dev->mt76, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
@@ -2640,8 +2642,6 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	}
 	napi_disable(&dev->mt76.tx_napi);
 
-	mutex_lock(&dev->mt76.mutex);
-
 	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
 
 	if (mt7996_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
-- 
2.53.0



