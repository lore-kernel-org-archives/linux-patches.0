Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDF9186E40;
	Tue, 26 Aug 2025 12:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212969; cv=none; b=JuBg8cy2y83YZFLu+eBK2Rq0DxAUhIpwzijzY7lHKAMD7SLIg7JzoPmuFgjcr4/1lxODw856BFL1JBPwE+CopFqHvP7ZJevhf7GlCJlJVLPAeKOHa0kq9RI9d0XrhsU899MDFa1j83b0TC2h5OEFdbUWAyywOOlNDCBucQ9ESjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212969; c=relaxed/simple;
	bh=BSDTeq59FHEJpPcGGku+xu5M8whnQfTsiergUkqjGlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWrY2lZtfhHWVllVm66uEL1KKn1kZr5gHojQovrxadA+E35CCX2NoqZl2IG/oTSP++zydt3f1x/kX8T61BIEl/3XzgUPoX7i5EWJYXbqoc6rLqlnQaM/Sz+vfrJ2INVz/Y6k/R+BChhW/xjGOCXZr79QYIjW7YosUsyn1hlV89U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLWWOLkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLWWOLkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43740C4CEF4;
	Tue, 26 Aug 2025 12:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212969;
	bh=BSDTeq59FHEJpPcGGku+xu5M8whnQfTsiergUkqjGlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLWWOLkQp8wD42RBPIs7rktsqmOyl3nsMGOUcNPYjucJcNmtU1FFdiqTp1TXn0BM6
	 QZ78vyb+nmenDppSrzsWGcJAdcgg123mlVIfKR52kaHCYXIoBqB6KO0pSbjZr3nQAY
	 B1fGh/0Z2+iUjym9pquT0+/ivp//KXIFKWFeoPwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/587] wifi: mt76: mt7915: mcu: re-init MCU before loading FW patch
Date: Tue, 26 Aug 2025 13:05:21 +0200
Message-ID: <20250826110957.320092380@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f0226db2e57c..fae9ec98da3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2060,16 +2060,21 @@ static int mt7915_load_firmware(struct mt7915_dev *dev)
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



