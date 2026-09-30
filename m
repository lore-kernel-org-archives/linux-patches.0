Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBC451DAEF;
	Wed, 30 Sep 2026 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789835; cv=none; b=LBhNVt4wKXnG0CQcrjonRZidXUEgmWjJ4rnuSMG+TggxSH4Dar2PrgBIFQNq1yuDPFgb0oe6y67DOgpxFC4paP/QXzB2x9ewAD50b6iUMioKfLmKE19xNqo9carIyTlM5cTYAteidohDMJcWFinWS9KPITA1WzB2rEndCcGXD10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789835; c=relaxed/simple;
	bh=8uTEHwA0wTV2s3xxkDK51BSiL6bm+UEnJaKQXbQcc00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUFlNbjD+bu7IriY6gKA0xleflxIDjYzt8JBC2yWPAF6YUaqIqvAMgXBxe59vumBZXozDnPjYGZnWSq3R/sp8Tnd1Dy9m5N5zpNsEIFBcdYZwq++Pd/F8wgNwvTx3AewCAsgs0QZDk0F+HEEBnV+O6EfEcawJg826iHWyBj0o34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdiBi1TH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdiBi1TH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070E61F000FF;
	Wed, 30 Sep 2026 17:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789834;
	bh=9xGuKNjdI5zqkAs7H5hgF58pvxUxd0ZUL6OzXQjpqz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdiBi1THI6lOSl/jQI32kR2iG3sr4J/wu9QIq8LQIyvJt5P+PNMowaQUbvNMBF/Av
	 ru2J8h9Rr/9XxSbo9HmNqzIFsUTajh8MyKCAehskXzZb99UsAwm9W4c/iJNQIQMq1T
	 JH3l2keeyD0kzrebkpNg97djXYuiNghvfmXtfMv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 617/877] wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy
Date: Wed, 30 Sep 2026 17:25:28 +0200
Message-ID: <20260930152427.966567362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 13b3c29a782033ce4a230be9e5618032813dbcd4 ]

mt7996_mcu_get_eeprom() derives the destination of the EFUSE/EXT block
copy from the address reported by the MCU response (event->addr, a
device-controlled __le32) and clamps only the copy length, never the
destination offset into dev->mt76.eeprom.data. A malicious or
malfunctioning device can report an arbitrary address and drive an
out-of-bounds write of up to MT7996_EXT_EEPROM_BLOCK_SIZE bytes past
eeprom.data.

Reject a response whose address would place the copy outside eeprom.data
before deriving the destination pointer. Devices that echo the requested
in-bounds offset are unaffected.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260625-b4-disp-16f99062-v1-2-aee52ecf61b9@proton.me
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ adapted mt7996_mcu_get_eeprom() changes to the older fixed 16-byte EFUSE implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3586,7 +3586,13 @@ int mt7996_mcu_get_eeprom(struct mt7996_
 	valid = le32_to_cpu(*(__le32 *)(skb->data + 16));
 	if (valid) {
 		u32 addr = le32_to_cpu(*(__le32 *)(skb->data + 12));
-		u8 *buf = (u8 *)dev->mt76.eeprom.data + addr;
+		u8 *buf;
+
+		if (addr > dev->mt76.eeprom.size - MT7996_EEPROM_BLOCK_SIZE) {
+			dev_kfree_skb(skb);
+			return -EINVAL;
+		}
+		buf = (u8 *)dev->mt76.eeprom.data + addr;
 
 		skb_pull(skb, 48);
 		memcpy(buf, skb->data, MT7996_EEPROM_BLOCK_SIZE);


