Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6EC3203A2;
	Mon, 18 Aug 2025 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523852; cv=none; b=aYNiOCGx0V2zVQ6X76rwQP6S/Nl+O5cEmi6/LsOcYNEM0lxZDmHui9gaiNJfR8HQ3w3PRTzBK10nnVbdLxLvoE6B8pGnsITId+cVx0pMbNvvxIWXM0ZBBJtbbAE4k9kZ+AjAmYE2GeSoj+lmYUe7ws5GOzuGW7bXbjD8z5B1D1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523852; c=relaxed/simple;
	bh=xX5+bTw8wqTN+mvuQelS/9pLbWbz9rOR1r3FXvq3xaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu0lWtetFpfzLmNTgztM8bekR2CdvE8Wek+bCwpMTCcwUiPQkP7SO1VijpYmc8rbQfOeaCvNKM5yt0OIgsVciOl2WwIiuh9TO5cgAZMR+bZK6sJcTivDZMc47yimEh4F42MN72taMJZGGlW1M+mFG6wzJ1dCL/HVoeBy6J8gO+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1BRBXWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1BRBXWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F033BC4CEEB;
	Mon, 18 Aug 2025 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523852;
	bh=xX5+bTw8wqTN+mvuQelS/9pLbWbz9rOR1r3FXvq3xaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1BRBXWfCZcp25ps74JvB3luX7ShV9v9l0ocj1BIwv3otQESl6xSa5E/GDtk+BPA7
	 GeA5cAoKOnAmhQPqpMxQ+RpVGkSIrH86Gt+9L5a20r5rULxkGDypDpEfqDTn/xnum6
	 RTnwGO7fHqP8qKRyHYqdNvJV5ReyQiiaT3sUqFzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 260/515] wifi: mt76: mt7915: mcu: re-init MCU before loading FW patch
Date: Mon, 18 Aug 2025 14:44:06 +0200
Message-ID: <20250818124508.427528982@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Bauer <mail@david-bauer.net>

[ Upstream commit ac9c50c79eaef5fca0f165e45d0c5880606db53e ]

Restart the MCU and release the patch semaphore before loading the MCU
patch firmware from the host.

This fixes failures upon error recovery in case the semaphore was
previously taken and never released by the host.

This happens from time to time upon triggering a full-chip error
recovery. Under this circumstance, the hardware restart fails and the
radio is rendered inoperational.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20250402004528.1036715-3-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 25 +++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 3643c72bb68d..45dd444ce360 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2092,16 +2092,21 @@ static int mt7915_load_firmware(struct mt7915_dev *dev)
 {
 	int ret;
 
-	/* make sure fw is download state */
-	if (mt7915_firmware_state(dev, false)) {
-		/* restart firmware once */
-		mt76_connac_mcu_restart(&dev->mt76);
-		ret = mt7915_firmware_state(dev, false);
-		if (ret) {
-			dev_err(dev->mt76.dev,
-				"Firmware is not ready for download\n");
-			return ret;
-		}
+	/* Release Semaphore if taken by previous failed attempt */
+	ret = mt76_connac_mcu_patch_sem_ctrl(&dev->mt76, false);
+	if (ret != PATCH_REL_SEM_SUCCESS) {
+		dev_err(dev->mt76.dev, "Could not release semaphore\n");
+		/* Continue anyways */
+	}
+
+	/* Always restart MCU firmware */
+	mt76_connac_mcu_restart(&dev->mt76);
+
+	/* Check if MCU is ready */
+	ret = mt7915_firmware_state(dev, false);
+	if (ret) {
+		dev_err(dev->mt76.dev, "Firmware did not enter download state\n");
+		return ret;
 	}
 
 	ret = mt76_connac2_load_patch(&dev->mt76, fw_name_var(dev, ROM_PATCH));
-- 
2.39.5



