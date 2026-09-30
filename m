Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A135E51D508;
	Wed, 30 Sep 2026 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789801; cv=none; b=Yv60sIX9jQDaOhdb2aLuFtUDts26x6WExk7KUhwjeoJK1xXFVL5YXTUfiFzPDTfWQ7niD57qFBTD59H0vzMw9ESf3iGMRFzD+Ravd0nS0yuraDleG7cJVgIBdnzcPAuRZy5RTbTXhJDm8LxzM3Ol96my0Cy7OBnYKhiavtoh2X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789801; c=relaxed/simple;
	bh=VZNYRDN0ixkKbxzxp824Le9BexAl4wq7q7AJYWXiK1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FT2vR/uJe4Cdn4t6mXmrDWDB5qKSq0SZrqTPXsh2xXQVIwLw49mT8NGpUvJRkGLHnx/VtQH4f1awsFqP7CK4z2OcOa6d5x2aWquL6phN19XRM0y8881spKVyZ59cxo3GtNWgjjMmRGTpQ//Iy2qZG2W7Q9ePqFnruooFP5FfzNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZzeIj5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZzeIj5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095F21F000FF;
	Wed, 30 Sep 2026 17:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789800;
	bh=JqfauiRLgmU16Ul6cM6H+dkCtmYMthIQqiGcQM1tDiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZzeIj5f+wI5XhOYd00z64pkiBrNBrKeiEov4vFvkZNf9bkAet29xaYv21R5NXWU+
	 TU8Cd+EfQKU2dB9t/J5L8lKEjTOfe7ZDy+uojcTugpop3dMzrT3//AZ15yMj6nmvYa
	 QCt7yKzOdxhscycnpqaKmRNgQo1ejyk4mzbBg6Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 606/877] wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy
Date: Wed, 30 Sep 2026 17:25:17 +0200
Message-ID: <20260930152427.733177800@linuxfoundation.org>
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

[ Upstream commit 44b5adfe49499f53002737f5fe81d608c08122fc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2871,8 +2871,15 @@ int mt7915_mcu_get_eeprom(struct mt7915_
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


