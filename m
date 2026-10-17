Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F51396D28;
	Sat, 17 Oct 2026 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255966; cv=none; b=Rss8+pKWhKKzrvscAgLUgly6nhbBs4rhQn2E2+mit/uQSYJniKLV2/v+dajF8YV3qjsqgquvFGOJTqg7IgEK9rD22I+WXeLTv1pOdSTMv9uMuZmsytJ4ljoVCsLs6br0ngx8B33yZXS9V4bkX9Vl4tbt71gFpxseGPRl14Caihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255966; c=relaxed/simple;
	bh=DONQnb93AiguL/ug4whKGCQNSRbTAUYwxeVVA7z23/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xpu8IKPP2ZarXzo+eGWhzpzJAyAO9WIDRSfqh0Skaj398jr4MZi7kZwRlHqx7nkn2CN1NwIQf5SYDIUwQfCxcjpZveqKojbXsTNEdMYJEvvTMnbDMu3g4hbVtgk2zw9871Fr2t64hH+/kDvnSMq4kxbcu96Ea/fTS8LrUIkft1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xE5uIrj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xE5uIrj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5211F000C4;
	Sat, 17 Oct 2026 16:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255965;
	bh=PqsHR46HoidwywFuNOyyRcyWmBlezKf2HqLtNl0ecD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xE5uIrj+VwYiaxBMJP1p6NWjse18PIBslosLtCCIuL2ssCmamDgm7UkAXOvUD8GXd
	 ceiIRcNb/xxsfJid0jpCt2cQzKtIVit7Dxrkt1OYiRfQkk8aEphmkylNnoZZ6ENOsW
	 e4fqPyPbWhQJmHAV//2+2NCmN/Wp99UEQvwiglHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0081/1674] wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy
Date: Sat, 17 Oct 2026 17:39:13 +0200
Message-ID: <20261017160433.211740430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 3699a43df5a9b..6c9517e4cea43 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3107,7 +3107,13 @@ int mt7996_mcu_get_eeprom(struct mt7996_dev *dev, u32 offset)
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
-- 
2.53.0



