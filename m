Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FE9202F71;
	Sat, 12 Sep 2026 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216796; cv=none; b=CLDJuO2mSuh4i7nCvvRDI3uu8BL9nIGsHX9xxt3wMJjzPBiFXW2cDUzstDdTWCPc5fVN8LUjLyUkVQj5W7XOSJQ5axaeRnk6mhRfyqlI8dNRKYyuRdX08QRJBsp6/8B/PyKgsF0u6OFuL26lpauF0czNsvIBE23nXYdZWohgwoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216796; c=relaxed/simple;
	bh=jDDRa3WefwlIV0BWaGWb5cv2t4p3A9FPXrc2iUGF54k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfYmhB8UR8T5Wwj6yLAGpyWAVlNREIKizt9CVdYx9aMsCbVXZvGV9O+zxTEu3j1EUJ+pNeBBPoTO9bRpBzqdLmK04G2iCePTpap3VJp0H9za8uL/L4iZKS+WBbG3rH5+535uCKCNOODkhH0rSggJfy4VsWmdLY6mXTCGDHWHZ6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpKxWJSM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpKxWJSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A605B1F000FF;
	Sat, 12 Sep 2026 12:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216794;
	bh=To6bxLVyaW/VbLlrGVvDkaDMBvFmhY88H8mD6lYmLDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OpKxWJSM79i3aTtuH3yQ0ROzXuY89n3GdJKinbniiUa3KOzTmNQef7yDpRqyeMjcZ
	 UfqmFaIzyzshWNqUew5JBhZzCu8RXQ2Jkqc51xyVxLsxnNmNEiewKAiLxy+nxcxWyH
	 wgOi7E4aphnOcZc3d0AiC9HwSHmrKMoqIVwK4zzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0809/1376] wifi: mt76: mt7996: set MT76_MCU_RESET before waking MCU waiters on full reset
Date: Sat, 12 Sep 2026 08:53:55 +0200
Message-ID: <20260912065625.572155657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

[ Upstream commit 6469ae71e7e5d0132c934972f628f346ad0379cd ]

mt7996_mac_full_reset() called wake_up(&dev->mt76.mcu.wait) without first
setting MT76_MCU_RESET. The MCU response wait condition only checks the
response queue and that bit, so the wake-up released nobody: a thread
blocked in an MCU command against the dead firmware (typically holding
dev->mt76.mutex) stayed asleep until its multi-second timeout, stalling
recovery. Set the bit before the wake-up, as mt7915 does.

Fixes: 27015b6fbcca ("wifi: mt76: mt7996: enable full system reset support")
Link: https://patch.msgid.link/20260722082610.2699628-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 116050a987a61..24e0346ea3d88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1798,6 +1798,7 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 	phy3 = mt7996_phy3(dev);
 	dev->recovery.hw_full_reset = true;
 
+	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
 	ieee80211_stop_queues(mt76_hw(dev));
 	if (phy2)
-- 
2.53.0



