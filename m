Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2974F4049;
	Tue, 13 Oct 2026 11:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892628; cv=none; b=l8MO4a2QFOAxEOh7d3AlMCkGA27vH5kihNTX2EBCbpeHtLiT6OeXDLjv451G+GX4tLr5s0iMIv4tLC8x5BZg7grG++y76oAmnhcaGjGowYUfCTIoI9ER3nk28h/EAkD5RNuoXrd9UAxdYI2rdaJ4VZnOj5RCkNM3HJG1SeKZ2po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892628; c=relaxed/simple;
	bh=rZPsTU+X08vT+uq6GxlJdUXKKZy4iva7dXo1eRIVFtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8pwPPPK6T5MVpp86eua/bbJIKaChV9DW2vuwqlqb0mgjPQgkKbaBvUDUR8UACov17QpRr5yNzFUBfbHlTfcwgSswP/UpQYCw+gMhfnP/A1EGTX/kWT6MUPhR1fJTE4n684jdfM8Mjz1sJ5VqPSJ7lFZt+maSZe/UdooAM2zo8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQagA3C0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQagA3C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4135F1F00893;
	Tue, 13 Oct 2026 11:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892626;
	bh=uYpVeXTfKVqDT+dM54d5miv3aTFbOWkNArc8Ly0qtFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQagA3C0banpgNTYv4Ifc/+xlMTrW898IV5fJXUDUhriPBwQ91ZEB+CEwoPKMB8lb
	 b5R9V0JbIJ+JSqdHhiTkT+s/owgu7GiReuTjR5B0j8bgP8kVbtLIxRW4pEFCSKOaHV
	 nsSJ1oa4fVsFszwccxxO1/zwb2NhuiEH5qgK21CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 236/281] wifi: mt76: mt7915: disable rx napi when removing device
Date: Tue, 13 Oct 2026 13:39:12 +0200
Message-ID: <20261013112900.876670169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit 916c484d29d82f45c281da2786fcd6a1284430ce ]

Unloading the mt7915e module with a MT7916 triggers multiples WARN in
__netif_napi_del_locked() and in page_pool_disable_direct_recycling()
because the driver does not disable the napi before destroying it.

This is troublesome since on MT7916 it is required to unload the module
and reinsert it with a different enable_6ghz parameter to change the
frequency.  The system generally becomes unstable after reinserting the
module.

Fix it by disabling rx napi inside mt7915e itself, even through napi rx is
enabled in the mt76 generic code.  Disabling it in the mt76 generic code
was previously attempted and reverted because napi was disabled too
late and rx handlers could access freed structures.  Note that the tx
side is enabled and disabled by the mt76 generic code.

It is disabled in mt7915_stop_hardware() since, unlike
mt7915_unregister_device(), is it also called in the probe path if an
error happens after rx napi is enabled.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Link: https://patch.msgid.link/20260810154923.32546-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 2ab38f9e52581..e768f4f72ed8e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1208,6 +1208,12 @@ static void mt7915_unregister_ext_phy(struct mt7915_dev *dev)
 
 static void mt7915_stop_hardware(struct mt7915_dev *dev)
 {
+	int i;
+
+	mt76_for_each_q_rx(&dev->mt76, i) {
+		if (!mt76_queue_is_wed_rro(&dev->mt76.q_rx[i]))
+			napi_disable(&dev->mt76.napi[i]);
+	}
 	mt7915_mcu_exit(dev);
 	mt76_connac2_tx_token_put(&dev->mt76);
 	mt7915_dma_cleanup(dev);
-- 
2.53.0



