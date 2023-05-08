Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59897168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F95C433EF;
	Mon,  8 May 2023 10:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540443;
	bh=w5C8CBf8JYLki40zmMz8vriq2OtJZT9NS7ySBj04M6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnf5UeNNKGuZnRax0tB+cgali+/qlPfY9u2AJXapBzBfyuH1vF6/Og3QePVYSMWve
	 ouU1+7h5i0EY4dKreragqKejou/e9J3BtWJg/xPP9A+9DfaC/Y14whmhiLASkX8us1
	 U5LyJ3Vfd6TiQUrwUdoHZ3vrURqNufQw34IGku/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 366/611] mt76: mt7921: fix kernel panic by accessing unallocated eeprom.data
Date: Mon,  8 May 2023 11:43:28 +0200
Message-Id: <20230508094434.273148792@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 12db28c3ef31f719bd18fa186a40bb152e6a527c ]

The MT7921 driver no longer uses eeprom.data, but the relevant code has not
been removed completely since
commit 16d98b548365 ("mt76: mt7921: rely on mcu_get_nic_capability").
This could result in potential invalid memory access.

To fix the kernel panic issue in mt7921, it is necessary to avoid accessing
unallocated eeprom.data which can lead to invalid memory access.

Furthermore, it is possible to entirely eliminate the
mt7921_mcu_parse_eeprom function and solely depend on
mt7921_mcu_parse_response to divide the RxD header.

[2.702735] BUG: kernel NULL pointer dereference, address: 0000000000000550
[2.702740] #PF: supervisor write access in kernel mode
[2.702741] #PF: error_code(0x0002) - not-present page
[2.702743] PGD 0 P4D 0
[2.702747] Oops: 0002 [#1] PREEMPT SMP NOPTI
[2.702755] RIP: 0010:mt7921_mcu_parse_response+0x147/0x170 [mt7921_common]
[2.702758] RSP: 0018:ffffae7c00fef828 EFLAGS: 00010286
[2.702760] RAX: ffffa367f57be024 RBX: ffffa367cc7bf500 RCX: 0000000000000000
[2.702762] RDX: 0000000000000550 RSI: 0000000000000000 RDI: ffffa367cc7bf500
[2.702763] RBP: ffffae7c00fef840 R08: ffffa367cb167000 R09: 0000000000000005
[2.702764] R10: 0000000000000000 R11: ffffffffc04702e4 R12: ffffa367e8329f40
[2.702766] R13: 0000000000000000 R14: 0000000000000001 R15: ffffa367e8329f40
[2.702768] FS:  000079ee6cf20c40(0000) GS:ffffa36b2f940000(0000) knlGS:0000000000000000
[2.702769] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2.702775] CR2: 0000000000000550 CR3: 00000001233c6004 CR4: 0000000000770ee0
[2.702776] PKRU: 55555554
[2.702777] Call Trace:
[2.702782]  mt76_mcu_skb_send_and_get_msg+0xc3/0x11e [mt76 <HASH:1bc4 5>]
[2.702785]  mt7921_run_firmware+0x241/0x853 [mt7921_common <HASH:6a2f 6>]
[2.702789]  mt7921e_mcu_init+0x2b/0x56 [mt7921e <HASH:d290 7>]
[2.702792]  mt7921_register_device+0x2eb/0x5a5 [mt7921_common <HASH:6a2f 6>]
[2.702795]  ? mt7921_irq_tasklet+0x1d4/0x1d4 [mt7921e <HASH:d290 7>]
[2.702797]  mt7921_pci_probe+0x2d6/0x319 [mt7921e <HASH:d290 7>]
[2.702799]  pci_device_probe+0x9f/0x12a

Fixes: 16d98b548365 ("mt76: mt7921: rely on mcu_get_nic_capability")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 67bf92969a7b7..d3507e86e9cf5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -16,24 +16,6 @@ static bool mt7921_disable_clc;
 module_param_named(disable_clc, mt7921_disable_clc, bool, 0644);
 MODULE_PARM_DESC(disable_clc, "disable CLC support");
 
-static int
-mt7921_mcu_parse_eeprom(struct mt76_dev *dev, struct sk_buff *skb)
-{
-	struct mt7921_mcu_eeprom_info *res;
-	u8 *buf;
-
-	if (!skb)
-		return -EINVAL;
-
-	skb_pull(skb, sizeof(struct mt76_connac2_mcu_rxd));
-
-	res = (struct mt7921_mcu_eeprom_info *)skb->data;
-	buf = dev->eeprom.data + le32_to_cpu(res->addr);
-	memcpy(buf, res->data, 16);
-
-	return 0;
-}
-
 int mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 			      struct sk_buff *skb, int seq)
 {
@@ -60,8 +42,6 @@ int mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
 		skb_pull(skb, sizeof(*rxd) + 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
-	} else if (cmd == MCU_EXT_CMD(EFUSE_ACCESS)) {
-		ret = mt7921_mcu_parse_eeprom(mdev, skb);
 	} else if (cmd == MCU_UNI_CMD(DEV_INFO_UPDATE) ||
 		   cmd == MCU_UNI_CMD(BSS_INFO_UPDATE) ||
 		   cmd == MCU_UNI_CMD(STA_REC_UPDATE) ||
-- 
2.39.2



