Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CA92F7EFC;
	Sat, 12 Sep 2026 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224339; cv=none; b=PnWWavHPUz2ADPYLRoRiqBXAWwNhDz0u9g3pBXGWSDWUNyyM88Om2pjBNVnG6jJSkRcqFK7wzh72d9/uWGZ1olaMS3sylyTWU62lhyOBlVG7ErubZwNX3XpI4Eajyy69tD22mPk5+Osi4IrlACjMNGVB9Tj4u/8J86msUfvVjss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224339; c=relaxed/simple;
	bh=VFv4Ena/DlOE898D3ITxGaec1O+vebVnwYgQIMx0LeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcsJqZ7wm9zklwQE87D4wqrvFGRyEzTUphnXL75jkiuZ0XxBlmAFq2eYirCa5dM5QIrk42BB1eQDe8oH39aOfotSWb/r3wWkaBdVM1ANjQIuHN84LsnEmHMVXh6DSycJhPfiuqsDz7AgyrOPLr2U+tlpDVEzQ6e24S8pRENvleM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgNPV5qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgNPV5qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E610A1F000FF;
	Sat, 12 Sep 2026 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224338;
	bh=2DlblDBWJTpumO6pcOzeAubPQxlS/NNvxLCGbkaWrhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgNPV5qolObWTFxXjKtz3qiLHysYxHvCHx3FUGHn1A6+yk8DULQO3oD8+oBQl/I2J
	 +IU4f72h6yDknE8K+A1kWrT2hHeUJCEx8FrS7EP/x+HEirpqXkuC0ugPPYOHvCZLyO
	 phadI50yob4Jt90C7U52lYajt3hqezOSKj3+VCFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0973/1424] wifi: mt76: mt7996: set MT76_MCU_RESET before waking MCU waiters on full reset
Date: Sat, 12 Sep 2026 08:56:45 +0200
Message-ID: <20260912065629.103951666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 9270a68e6a38d..74ba07577bfd4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1737,6 +1737,7 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 	phy3 = mt7996_phy3(dev);
 	dev->recovery.hw_full_reset = true;
 
+	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
 	ieee80211_stop_queues(mt76_hw(dev));
 	if (phy2)
-- 
2.53.0



