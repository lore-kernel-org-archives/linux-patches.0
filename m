Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F20427D776;
	Tue, 27 May 2025 17:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366689; cv=none; b=sFx1WF40Mb9MbcDM7rvJ2b3YubWHF+r7G5xVVtKg61bmDigiVYvEXUFUhQODKlvc+oz8cPhZ3Mg4afDYb6o+LeTERZSSx+lw8r3gaJFOmAWEZDUFbv3xuXlfo4ABuZ6CrabLM9+PUWPc5GjqrM55MrEEfxXJzOXeKcfVrzTj8W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366689; c=relaxed/simple;
	bh=ST7EPwid2k3J9L9pXOOTYOcn5uO7WSmrbLoJNRVPc9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ux8HEefSiR5rAhKP+XFZlBKaySKgz7qsgYEF36X5fyH69Hm/4ApruVEPQBuW2a4thKja8K7uhA1BMhrFVQCPvhZLzcWYGK41BRkudztUeHCu57XM3uj3RREPiw3sYNHWztdYTu1v/TQTT13V8kcCXpgvnUxOCjGtmM9dGmOOilA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrppBprc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrppBprc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C21C4CEE9;
	Tue, 27 May 2025 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366689;
	bh=ST7EPwid2k3J9L9pXOOTYOcn5uO7WSmrbLoJNRVPc9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrppBprcg757S/htBI734OR2Mt3nllU5+66+rBcbQb9CXkhymcZkkhk5yP1kz18o7
	 su5KYikO7gGZmpH4jzVQWwXUVnbzEFqzgMkJq+v+CrIuehi04tV9GZs6zGNA22WE7u
	 WMYtO4TJBDShjbLj03Wxir2vztMgtTBBeKhnrPo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Lu <rex.lu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 119/783] wifi: mt76: mt7996: fix SER reset trigger on WED reset
Date: Tue, 27 May 2025 18:18:36 +0200
Message-ID: <20250527162517.994861812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 7a8ee6c75cf2b..9d37f82387464 100644
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



