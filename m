Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F544F85C7;
	Tue, 13 Oct 2026 12:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894471; cv=none; b=ZxCLu/w0llVjtkFcLtD9T8qWZlYmsLwtOqEIOOyfzyM/VWQu+uPkyGFf0dma0hNBI2H1XNsA3iQ2v4KaU5v2KSFetbRtE4wPyKUEIKq5BohBXYOf/EFztccgIYaJPzSxEv2c6MucIfOz00SZf6DDPH2IXlrBgCVQ4bvCgEjRKlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894471; c=relaxed/simple;
	bh=I2TbP7aL92xJ7sA8IVjQIdC8NyvZDiy/IB6RO7ZG2tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZFLoJ6CvGfnd2GSJZFN4mghnoq4x6e1pRKPSpM0OFPPLPnV1AE3lHnOoiG6m7WKEJtdhiJSmjKm2PuMuuUzBZ1XkgQTXp1Ae/qqz8cBlAu0a2FRuqaNDWvMUQu7kwkbiRsyJvbM+inPNxZ9T2QDht8VzCb3SuxTpqy/rFEUF68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZFcVMIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZFcVMIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D7D1F00893;
	Tue, 13 Oct 2026 12:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894469;
	bh=G4n08v+V5oSSnQq/KDKhWKz7epeyU5ScGgl8Lnjq8kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZFcVMIbcVOfYYwUC6nVqdzISzbFqlpVUmYoelmgiaJVW+pXWSZH775jJH17weaa6
	 kn/qmZJovATFVamNE33o+SDBSIGoYybZVkNK3nM8ym4ykq91CFKe7Jxnrw+aYIlets
	 +Wux1fyENT3/I2usmZfki5QscTT1+YFI0PMiX+dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 569/621] wifi: mt76: mt7915: disable rx napi when removing device
Date: Tue, 13 Oct 2026 13:39:24 +0200
Message-ID: <20261013112934.309365243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 130650c18f02b..75fc990f2dd78 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1201,6 +1201,12 @@ static void mt7915_unregister_ext_phy(struct mt7915_dev *dev)
 
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



