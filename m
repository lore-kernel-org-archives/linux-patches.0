Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC602737FC;
	Sat, 12 Sep 2026 08:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200875; cv=none; b=Su6v5XpuH7RkTuFGdisMeN5Yv9V+gSZ92RMESsduK7lx2z7Wxtjh3tk8kBh5prhrdD22wWlqqojYMm3d5EED9BtlDvD5WGZfTMKTOZHooiwwpeRtyVesXFHX2B5dwZkxBYcerUPQKvRd+7bMjwZ3CQUlr+z79g6e9eIc/XxHTYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200875; c=relaxed/simple;
	bh=EWmVmP5KCp/pisJiTE3eyfHGPf6/2K+uuW0KjpV24uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0lRrs/5se3480W5aizsSmrS556CpUe2bZS0KqUe4C/pA74XkCLJaJ+8q9x+4XoSu0IP1it2U+1lcIo0VoZhCulWrJPDsPazapZwREvGYhJPQgXyFTbkMQnu8sauEe68/JjcBEsUK2RiBqoQm/CFs/vN91YFB9VDfhotbzt+Wkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZ+pBU6M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZ+pBU6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DD01F00893;
	Sat, 12 Sep 2026 08:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200874;
	bh=ILZrP4hMNw/+ogpuRJkmWSpIbdeeE44bfV98RbgFuN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZ+pBU6MOcw6I0MQtj8FdWrKAlSP6pNuTV0lDP1lhhvxqHAi4xuN3+lTusURB7vq6
	 NIKp5xXhmLHlA+LPdxMDuQO/7Tp/P2J+nqZL+fx7RLAWigMNbVpYQVXLzEMFFQZoJj
	 J7h176deHmjBer2VpCQg3DdGaoq0QVqAvFlo1RRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0881/1815] wifi: mt76: mt7996: set MT76_MCU_RESET before waking MCU waiters on full reset
Date: Sat, 12 Sep 2026 08:43:51 +0200
Message-ID: <20260912065709.603202783@linuxfoundation.org>
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
index 7f915aa20367d..6530fb9b45c1c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2460,6 +2460,7 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 
 	dev->recovery.hw_full_reset = true;
 
+	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
 	ieee80211_stop_queues(hw);
 
-- 
2.53.0



