Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B54433A6F2;
	Wed, 20 May 2026 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294625; cv=none; b=aONASd62J4AwCgtSsYdB7ZMCaPkXTDNewvrCvlqoNOezkixovQLkuXBBwfREy6psTRnt/CE0AHRoNnHQ9tyV5SLMcGaPITg0WbZ6e2qsA7Pd/qeK+vRKisvAZcuHu7CposAqa98n0hR/nMGBMFSCcwRlCc6u5mWLaoEhPrrUb4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294625; c=relaxed/simple;
	bh=F47Nmhv6pQUzrXcFpU/DSNpaekse94h0T6kxV12lx+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oELF4SyhpEeQqxXNxOqMlhpIRJtYZq4qbr4De+mTcdQPD7Qh0t1aA/mkbxko2rPKOzOtGLm4Set9DOunqd41oDzH/Nnmtpja3forkkCmP0wqnOLmNoZXVHq+MtQNEoe2IjKR0zhhMywnTLtRXB1hHGeDtHRNq/W4ew6HmK8TmJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7xIcvBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7xIcvBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79A61F000E9;
	Wed, 20 May 2026 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294624;
	bh=Mn7coqszGeA/1ZwsuCvUTQJNdedn83tMnCLeeF+B3tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7xIcvBWIy2BcmMUMNnLtjeQMWIgpw0Uanr1NNbUIVruJY32/1CfPWEJFj7JhESDt
	 qE5kqMlVmffy/uLiTERNR8zW6XJsVHjsTymaa/05fL4oNhmDjgNwHF5qCtWyKhx1B2
	 UtcLdQZoxf8ZoCIdRdNN4WDWy9alt13Eq05MQJvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@airoha.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0109/1146] wifi: mt76: mt7996: Fix NPU stop procedure
Date: Wed, 20 May 2026 18:05:59 +0200
Message-ID: <20260520162150.806650919@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 7aed20bd9fe427b192cce80a164429584b298bbe ]

Move mt7996_npu_hw_stop routine before disabling rx NAPIs in order to
fix NPU stop procedure used during device L1 SER recovery.
Add missing usleep_range in mt7996_npu_hw_stop().

Fixes: 377aa17d2aedc ("wifi: mt76: mt7996: Add NPU offload support to MT7996 driver")
Tested-by: Kang Yang <kang.yang@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260122-mt76-npu-eagle-offload-v2-1-2374614c0de6@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  3 +--
 .../net/wireless/mediatek/mt76/mt7996/npu.c   | 23 +++++++++++--------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index ac7f2343076b1..7fa15b374ed49 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2543,6 +2543,7 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	if (mtk_wed_device_active(&dev->mt76.mmio.wed))
 		mtk_wed_device_stop(&dev->mt76.mmio.wed);
 
+	mt7996_npu_hw_stop(dev);
 	ieee80211_stop_queues(mt76_hw(dev));
 
 	set_bit(MT76_RESET, &dev->mphy.state);
@@ -2569,8 +2570,6 @@ void mt7996_mac_reset_work(struct work_struct *work)
 
 	mutex_lock(&dev->mt76.mutex);
 
-	mt7996_npu_hw_stop(dev);
-
 	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
 
 	if (mt7996_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/npu.c b/drivers/net/wireless/mediatek/mt76/mt7996/npu.c
index 29bb735da4cb8..067ef647e4040 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/npu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/npu.c
@@ -320,33 +320,38 @@ int mt7996_npu_hw_init(struct mt7996_dev *dev)
 int mt7996_npu_hw_stop(struct mt7996_dev *dev)
 {
 	struct airoha_npu *npu;
-	int i, err;
+	int i, err = 0;
 	u32 info;
 
+	mutex_lock(&dev->mt76.mutex);
+
 	npu = rcu_dereference_protected(dev->mt76.mmio.npu, &dev->mt76.mutex);
 	if (!npu)
-		return 0;
+		goto unlock;
 
 	err = mt76_npu_send_msg(npu, 4, WLAN_FUNC_SET_WAIT_INODE_TXRX_REG_ADDR,
 				0, GFP_KERNEL);
 	if (err)
-		return err;
+		goto unlock;
 
 	for (i = 0; i < 10; i++) {
 		err = mt76_npu_get_msg(npu, 3, WLAN_FUNC_GET_WAIT_NPU_INFO,
 				       &info, GFP_KERNEL);
-		if (err)
-			continue;
+		if (!err && !info)
+			break;
 
-		if (info) {
-			err = -ETIMEDOUT;
-			continue;
-		}
+		err = -ETIMEDOUT;
+		usleep_range(10000, 15000);
 	}
 
 	if (!err)
 		err = mt76_npu_send_msg(npu, 6,
 					WLAN_FUNC_SET_WAIT_INODE_TXRX_REG_ADDR,
 					0, GFP_KERNEL);
+	else
+		dev_err(dev->mt76.dev, "npu stop failed\n");
+unlock:
+	mutex_unlock(&dev->mt76.mutex);
+
 	return err;
 }
-- 
2.53.0



