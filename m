Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0081527A926;
	Tue, 27 May 2025 16:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364586; cv=none; b=KEGFHobAEMxhs5hHEKEFCpAjygwnFUokwEetnjzKHR3zFxT/oWFVaSmxn5nB5gxOhVeE7kLXmLefZ1560LiufMZJeXOXnF/psTwUfZoKtBIAKmuteIv59WPJw9pvsDsbodE6tLah4pwu7wuoEna/807B3jWIAY40hWEKf19QSHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364586; c=relaxed/simple;
	bh=qtVAZvTZqIxRhPRI4L0Y3Rgp1C4jtwEe+8vkA2HmQlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDO8Fp2nRnn7PN5iV2ZzJG6yvkbWcVYy+igBboWCiMvB62dECbmH/9uCwsyGmx3fEYPsuZS9CiX6PmLsHAtfbprINdzW7h0N+ICKncMVXX1/i7ToFojRSeOqJ/jMrtF76kZQ2rCc1gqVIPl0UrDog4BNpKP89lzwQKYoZzCACKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBKlYHVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBKlYHVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531D6C4CEE9;
	Tue, 27 May 2025 16:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364585;
	bh=qtVAZvTZqIxRhPRI4L0Y3Rgp1C4jtwEe+8vkA2HmQlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBKlYHVvk/6VuX/9P0LsCXK0UbTcpwWs8WF042aVHDfrw7AHxatlkcWkFGk+T9op6
	 YEjN6WoItAfVQtEesKIdg2dFanrD2QLocFHFHYQ1kqUghJbKsrscqVb/jL+6+F1t00
	 V6yHNCghtknS8pcV9ifeksxnEHRLKN5vdrapWIi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Lu <rex.lu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/626] wifi: mt76: mt7996: fix SER reset trigger on WED reset
Date: Tue, 27 May 2025 18:19:56 +0200
Message-ID: <20250527162449.226291101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rex Lu <rex.lu@mediatek.com>

[ Upstream commit 8d38abdf6c182225c5c0a81451fa51b7b36a635d ]

The firmware needs a specific trigger when WED is being reset due to an
ethernet reset condition. This helps prevent further L1 SER failure.

Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Link: https://patch.msgid.link/20250311103646.43346-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h  | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 43468bcaffc6d..a75e1c9435bb0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -908,7 +908,8 @@ enum {
 	UNI_CMD_SER_SET_RECOVER_L3_TX_DISABLE,
 	UNI_CMD_SER_SET_RECOVER_L3_BF,
 	UNI_CMD_SER_SET_RECOVER_L4_MDP,
-	UNI_CMD_SER_SET_RECOVER_FULL,
+	UNI_CMD_SER_SET_RECOVER_FROM_ETH,
+	UNI_CMD_SER_SET_RECOVER_FULL = 8,
 	UNI_CMD_SER_SET_SYSTEM_ASSERT,
 	/* action */
 	UNI_CMD_SER_ENABLE = 1,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 442f72450352b..b6209ed1cfe01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -281,7 +281,7 @@ static int mt7996_mmio_wed_reset(struct mtk_wed_device *wed)
 	if (test_and_set_bit(MT76_STATE_WED_RESET, &mphy->state))
 		return -EBUSY;
 
-	ret = mt7996_mcu_set_ser(dev, UNI_CMD_SER_TRIGGER, UNI_CMD_SER_SET_RECOVER_L1,
+	ret = mt7996_mcu_set_ser(dev, UNI_CMD_SER_TRIGGER, UNI_CMD_SER_SET_RECOVER_FROM_ETH,
 				 mphy->band_idx);
 	if (ret)
 		goto out;
-- 
2.39.5



