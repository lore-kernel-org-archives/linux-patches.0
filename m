Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4D54CCDC7;
	Fri,  4 Sep 2026 05:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500223; cv=none; b=NclIoai6eE1sujQB1q1D+r8BC8I2JkNiDu+nr8vqdo4KCamxeHtPwb+YUUhOQv+ABWek+txgEqGDPY8guJ8AxkHq58BEkyGdtG+5SIq879SuZPpf2Bb+0wLkL4fODFNAjn/2xWxFvUJvbL+ZalWBX3ZuFxbruOMkSqe7YLZfrhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500223; c=relaxed/simple;
	bh=xnU0EC7K8JAN+tPVutmIb4DIBCmkXWcmNbUjVulou2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCf7MxLrv52v+zVzhi+4NZivkqFP1XNbCAB5D7HV29acKnkui3ETaiFNaQkIOutt1qhyG1w0lQqVy4ugjli1A8y+KOpdHbeh5MbTCzBcjPxGIrLKeUVQsTDiM8TdymhFHa34U+AVyPFh4z02zgPESewF4ZQOSUZb32HHzivzdpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O84oYV5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O84oYV5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CFC1F00A3D;
	Fri,  4 Sep 2026 05:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500222;
	bh=C+dhtaXu9JaWu48MGj6gP03bsbzKCBHlPzYYdBafI5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O84oYV5QtRO3JeOaSSRhrd9nbb6W58V2/77+Wcdo9hNBTQFoKhu194v/TlzgaA41K
	 FpT+d1dfccKFu0uiZW8rBpPQY5kTHV+EyKbq6HQYPpXeZQ3auBUjIIaN2GEuI8p8FX
	 0E0D0EKkuSyqW+vwHs8PWhXyPWvnmhFoRFXH2Q0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.2 695/713] wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy
Date: Fri,  4 Sep 2026 07:01:03 +0200
Message-ID: <20260904045819.422606626@linuxfoundation.org>
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

commit 13b3c29a782033ce4a230be9e5618032813dbcd4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4352,11 +4352,18 @@ int mt7996_mcu_get_eeprom(struct mt7996_
 	event = (struct mt7996_mcu_eeprom_access_event *)skb->data;
 	if (event->valid) {
 		u32 ret_len = le32_to_cpu(event->eeprom.ext_eeprom.data_len);
+		u32 block = mode == EEPROM_MODE_EXT ? MT7996_EXT_EEPROM_BLOCK_SIZE :
+						      MT7996_EEPROM_BLOCK_SIZE;
 
 		addr = le32_to_cpu(event->addr);
 
-		if (!buf)
+		if (!buf) {
+			if (addr > dev->mt76.eeprom.size - block) {
+				dev_kfree_skb(skb);
+				return -EINVAL;
+			}
 			buf = (u8 *)dev->mt76.eeprom.data + addr;
+		}
 
 		switch (mode) {
 		case EEPROM_MODE_EFUSE:


