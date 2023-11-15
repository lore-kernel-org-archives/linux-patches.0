Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FAF433BE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsuUhZDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E7FC433CA;
	Wed, 15 Nov 2023 19:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076958;
	bh=UEBitcw6VyBI8X35afw2y/JVBWCsMoYjpLmOOYkv5s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsuUhZDdEsDJodo/UE0+SDJYymaqTqEqvV+r4KtsB/Ru+hMSbEynVxoujpTrZ/I70
	 Swt+BjTcMc9cqz2MBOLo4zA3x5FEvwduWbQSP+a8Cy4qI+QS23ngp0S4o49JpqlVS1
	 +jBep9pgVkDGXgWOPP8g2z2tKfZ4iYWdS7L6XeGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/603] wifi: mt76: mt7603: rework/fix rx pse hang check
Date: Wed, 15 Nov 2023 14:10:24 -0500
Message-ID: <20231115191618.592422312@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit baa19b2e4b7bbb509a7ca7939c8785477dcd40ee ]

It turns out that the code in mt7603_rx_pse_busy() does not detect actual
hardware hangs, it only checks for busy conditions in PSE.
A reset should only be performed if these conditions are true and if there
is no rx activity as well.
Reset the counter whenever a rx interrupt occurs. In order to also deal with
a fully loaded CPU that leaves interrupts disabled with continuous NAPI
polling, also check for pending rx interrupts in the function itself.

Fixes: c8846e101502 ("mt76: add driver for MT7603E and MT7628/7688")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7603/core.c  |  2 ++
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 23 +++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/core.c b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
index 60a996b63c0c0..915b8349146af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
@@ -42,11 +42,13 @@ irqreturn_t mt7603_irq_handler(int irq, void *dev_instance)
 	}
 
 	if (intr & MT_INT_RX_DONE(0)) {
+		dev->rx_pse_check = 0;
 		mt7603_irq_disable(dev, MT_INT_RX_DONE(0));
 		napi_schedule(&dev->mt76.napi[0]);
 	}
 
 	if (intr & MT_INT_RX_DONE(1)) {
+		dev->rx_pse_check = 0;
 		mt7603_irq_disable(dev, MT_INT_RX_DONE(1));
 		napi_schedule(&dev->mt76.napi[1]);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 99ae080502d80..7a506a0c46e2b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1570,20 +1570,29 @@ static bool mt7603_rx_pse_busy(struct mt7603_dev *dev)
 {
 	u32 addr, val;
 
-	if (mt76_rr(dev, MT_MCU_DEBUG_RESET) & MT_MCU_DEBUG_RESET_QUEUES)
-		return true;
-
 	if (mt7603_rx_fifo_busy(dev))
-		return false;
+		goto out;
 
 	addr = mt7603_reg_map(dev, MT_CLIENT_BASE_PHYS_ADDR + MT_CLIENT_STATUS);
 	mt76_wr(dev, addr, 3);
 	val = mt76_rr(dev, addr) >> 16;
 
-	if (is_mt7628(dev) && (val & 0x4001) == 0x4001)
-		return true;
+	if (!(val & BIT(0)))
+		return false;
+
+	if (is_mt7628(dev))
+		val &= 0xa000;
+	else
+		val &= 0x8000;
+	if (!val)
+		return false;
+
+out:
+	if (mt76_rr(dev, MT_INT_SOURCE_CSR) &
+	    (MT_INT_RX_DONE(0) | MT_INT_RX_DONE(1)))
+		return false;
 
-	return (val & 0x8001) == 0x8001 || (val & 0xe001) == 0xe001;
+	return true;
 }
 
 static bool
-- 
2.42.0



