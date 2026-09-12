Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB24427F89;
	Sat, 12 Sep 2026 10:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209066; cv=none; b=lbtLctm9lu3dNDUgPMGufRuvYtCCVKpZV/ZndFu275Ri3tWT9zSlZGy9Z0d/9B+gvQ+l+ZDjo4HIvZ64NULuWsU1P2zC6l1/i2Oi5j5Va37B+eyoAkq2HEPxcyy+i3wyHCx7WSVn1BhHw2pnwYWcCk7PFDNbj7WBMbE1dTA37Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209066; c=relaxed/simple;
	bh=7vUTpkNReVPVxe8lZSfmNntLAgzf9CxCm3r9VHQfugY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+cx4vhFU3433aAAfyRF9lctSwjyB4a+PN71t34cFAAyQiOHZn1Ut2wkuxAdE9DYQjP4QORrElrp1uk7Al8L4HmKhWSAH63kILjzMw3W2EOqtBpjTqOkXgQpYgu8BWgujpkmxOzYCpzhZl7Tvx2Vuwcdpwl9y8U5oMn9qohu2ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irCMCvcb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irCMCvcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D491F000FF;
	Sat, 12 Sep 2026 10:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209064;
	bh=MnZ+CGCokCK+LldvlBtKzfpOA1PcA1nBrRPgw8yY3Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irCMCvcbXGrMUXImb5rnbwOjqyzWvPUSUDYxSJAtkZ1V0h+ogxyA4B7uL07SkopoU
	 GAZHnII2mZgIspeNKVWE/OU3YfBOQLTFGzZCrePuJkBfRQqJD8vCRCx4h4r8X0AATM
	 u6vDTqNXtefjcS+7OG3MQXXWYNl/tfd9t/JbrHxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0746/1518] wifi: mt76: mt7996: set MT76_MCU_RESET before waking MCU waiters on full reset
Date: Sat, 12 Sep 2026 08:48:35 +0200
Message-ID: <20260912065640.307371912@linuxfoundation.org>
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
index 648c27c1bf66f..11d56fdb7f26b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2516,6 +2516,7 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 
 	dev->recovery.hw_full_reset = true;
 
+	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
 	ieee80211_stop_queues(hw);
 
-- 
2.53.0



