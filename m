Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFA0415F0B;
	Fri,  4 Sep 2026 06:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501847; cv=none; b=bxWVxQRWrsc2reoP0kpUhLMNaFhBBrA2vmXZxeeEsrIF4YK+yKaJ9wtHopqo3r1sjON3CjNSe1hEjWVD3XIxjIsekKOZDOpsyXaiK/xq/IY2B4aERbcjzVS2Yl/XjvDS114920EpJyT+c5aLQwPZEXMCNoxgZH23iEIHqhLoL0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501847; c=relaxed/simple;
	bh=1hBm7HkAI/tLuj9oQsJKG7IU6/xMav9Yzsz2RCfqzPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKsPBvqViuAAn3yndTApHkC0QNTGHlAiUI5CzyL2df6RpReWtCLmsnG2xkR7P9Ux0EwDxBLIuuFd60UgHTYhy0gliefeF2GHtsdIEA+tzh5ewnOjqmKBu8BUC6i3GACXE1Buy7kTHb7jxvfGxKi+QX7aYnHkIf9ldqBYJIy19A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qzUJrGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qzUJrGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E571F00A3D;
	Fri,  4 Sep 2026 06:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501846;
	bh=lMiId92N6vkcpCX18uecL7Kv5/AZIAd8FYkL9zfyoHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qzUJrGWJKCNzMf01zD62uyxaekTaoTEiD1KWkPL2t6ndH/NAqUEeVx3XOHGk9gkR
	 lBE+Iow1VVfzjw4KdsCZJfIrpv+NH2KReSNNipz9/EE0CyShGIq+u+UQLXW14IBZ3e
	 T5A2AsUWVHlFANfMpQ2Dsv4DVjxtLSCl78C3Zc8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 534/552] wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy
Date: Fri,  4 Sep 2026 07:01:31 +0200
Message-ID: <20260904045802.721442438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


