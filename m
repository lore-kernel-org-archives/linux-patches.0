Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9898235C6A4;
	Sat, 12 Sep 2026 09:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205545; cv=none; b=QbK+WoH84fsT3x2fVDHfUOWfmPtdgGOiA6azvFMt6HiLiXLGYxsx/DG46lVKL7Ikdzuh3Q+HRdqSKiUDIGIZ1tw0q8TrLSQxWVIto9tujc0CFZGMPE+MoFw3eSWmzUjuoBHqxy8t/RNyigZCkrPCwy4ICOG49yxn2tr/5EoCwBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205545; c=relaxed/simple;
	bh=fCthP6kTehvz/tO2YA3hH1VtIyXtYz6Iyq8PJPq5Fig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6fYTCg4UB4WnuPR9jpjfERBYbgRVkV1qP9d2R/rfmcYpi1fdWrAGYSZ8BxeEt78IzDcn55KaK3BmutKi2Hl3pVbI+IPXlD+xRmVwOjJkJgCS/F+4ibS+4mW2+Y/qsRDFRCjgJzGuwF62w2H2HmQ2jy3HKNs1SsP37DdihCDc2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHimIGQI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHimIGQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91891F000FF;
	Sat, 12 Sep 2026 09:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205544;
	bh=QeKT9TH3FZ51uJqhRSYmqJ/0PcFZQdc4ee2z2Z+p+XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHimIGQIj7jlXgqKrxT8j92lTGNKuUu8O1AQvuVsZJYBfFp6Cb5iQvFx8O2mDnjMj
	 suWurMI/yo+ppKOQ1JibpBaFjpsQ+mmwllJiLvtDmaauOl2ywrQl4nCV09VhEo/C1M
	 mvQIoz8SO9cyJ7ZSkqynF4wXfBxBowk2945kkhIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0024/1518] wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy
Date: Sat, 12 Sep 2026 08:36:33 +0200
Message-ID: <20260912065623.967826349@linuxfoundation.org>
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
[ Replaced the mode-dependent block size with MT7996_EEPROM_BLOCK_SIZE for the older EFUSE-only implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3866,8 +3866,14 @@ int mt7996_mcu_get_eeprom(struct mt7996_
 	if (valid) {
 		u32 addr = le32_to_cpu(*(__le32 *)(skb->data + 12));
 
-		if (!buf)
+		if (!buf) {
+			if (addr > dev->mt76.eeprom.size -
+			    MT7996_EEPROM_BLOCK_SIZE) {
+				dev_kfree_skb(skb);
+				return -EINVAL;
+			}
 			buf = (u8 *)dev->mt76.eeprom.data + addr;
+		}
 		if (!buf_len || buf_len > MT7996_EEPROM_BLOCK_SIZE)
 			buf_len = MT7996_EEPROM_BLOCK_SIZE;
 


