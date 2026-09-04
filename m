Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3554D4CCDC7;
	Fri,  4 Sep 2026 05:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500218; cv=none; b=XpjYyIIEljwlSSd/Lpru+MPDUMq6ophpQRaFw8Hl8WiOl/fK+KJzg9r6VooMkPL59pMLXVb8JFDVHTVjClIcHAWD2aq/Obt64y0DWwmRZC4Rc06JzGtI3xvh/flSm+gBPmNPK/u6L7sHn4RmvX3RGLwmcxkExUzR2adAx3KoP+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500218; c=relaxed/simple;
	bh=RU2NXlVL5iuVzuiZfMi88Mcq91r0kC1gi+nmDWv0z2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+qIuTWcmtdt7bQc1/0LFTVkBrYdLrx9SJA8NkMSTbSp7vXIjvM4f2YVFrJ62yf9kwfSl7nkgOPWS62lxkdIhD9mUYeAVdgNsCAllQCo+pOLbKBvxuEgBHas8tyF89ejrt9DDsiqiRxeJA1Ikb40FTUfZsxYoLrUX4WcLLjBgoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5LEGv5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5LEGv5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBF61F00A3D;
	Fri,  4 Sep 2026 05:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500217;
	bh=e7NH/dm1PgWQmbnY4eAqiONqZTa0L+z+O8l/KrzNG8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5LEGv5TgfDuBvzcvNx7hm7gYlBHfjKh1K5he/35FvHKUPUouUFTP3olduUbX9BKE
	 rhvY17yksMABhtCYcU+8FJRcQ1vXVJE8p6X26J0IF/LWYvRyjt5lT18DLIJ7VaLlqy
	 Q31edb8wMYgY2K6naIFzYe0THJWyE9qOT0lvusK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.2 693/713] wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy
Date: Fri,  4 Sep 2026 07:01:01 +0200
Message-ID: <20260904045819.378695706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 44b5adfe49499f53002737f5fe81d608c08122fc upstream.

mt7915_mcu_get_eeprom() copies a fixed EFUSE block into the driver's
dev->mt76.eeprom.data buffer at the offset reported by the MCU response
(res->addr, a device-controlled __le32) without checking it against the
buffer size. A malicious or malfunctioning device can report an arbitrary
address and drive a 16-byte out-of-bounds write past eeprom.data.

Reject a response whose address would place the copy outside eeprom.data
before deriving the destination pointer. Devices that echo the requested
in-bounds offset are unaffected.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260625-b4-disp-16f99062-v1-1-aee52ecf61b9@proton.me
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2917,8 +2917,15 @@ int mt7915_mcu_get_eeprom(struct mt7915_
 		return ret;
 
 	res = (struct mt7915_mcu_eeprom_info *)skb->data;
-	if (!buf)
-		buf = dev->mt76.eeprom.data + le32_to_cpu(res->addr);
+	if (!buf) {
+		u32 addr = le32_to_cpu(res->addr);
+
+		if (addr > dev->mt76.eeprom.size - MT7915_EEPROM_BLOCK_SIZE) {
+			dev_kfree_skb(skb);
+			return -EINVAL;
+		}
+		buf = dev->mt76.eeprom.data + addr;
+	}
 	memcpy(buf, res->data, MT7915_EEPROM_BLOCK_SIZE);
 
 	dev_kfree_skb(skb);


