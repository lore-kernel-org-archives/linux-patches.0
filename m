Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019229;
	b=ehGEFHgYXNox2i7Njo8QD+KP+WRumAh/93hd0Iea682tmmr6JhVxSO4KfoVstpRgdvwc
	 4cqKz6G8aTsBJQ8hhaE+TFAqvR342llmoYgh5i9smMIopfBpDGVkWt4hchv7FcbJ2I/ea
	 sB1ZSD4hnuM/SeBAkbkQAV5uo/sOmIPcYzwaPDm/JREqXrltjl/OXIXUSDMhGi48U+hVo
	 aUdtfinn6RAgDqg4+Gx5fCgh7ZbUQB4xVyfJY5BqjnPFKFGhm7OXKsUXHKUBRB+8awWZy
	 7VeBzSqNaKAfiVshGD1gH7It46D6AF4YNCpULK95LS5Vc+vCQLvzbeoPXOeAD+3Ad8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pFUXkRjEHNr0IX0VdfGu/zVNOQK6tE4GMF4r6612WhY=;
	b=NP+pJpioIMnvQmGInjDosVr5Eu8BwYDFIixsznBnMWwBdaAln+FMCyJWLjXSdK096vwR
	 xTtgzPs17upBQp6GvMAOMa1teHOWWLdPBcnv+uUXM5wZMInhyI8CA6Z1gQ6rhDl+efaDb
	 wVKXPpfQJbhTCWoulcL5RHKsk1dsBdDe5W0/XimEou2K2irEgm3RCvZq3nBioEI3ahPqx
	 Ucv6I8YYfxRw4AB4If3jsPiSm/sMC1sf6tgcUIi5OzJtqi6TaJjTRkPGep1iZuJURQFge
	 hWnJe/6KEL9v1l6TuGwJFeDVvwDnA4TtrQ0+Y/Sq4RDcQGEILrGPjZGnfPQSTOyZCcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j5/rrLPi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AC1606A33B;
	Wed, 18 Nov 2026 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5/rrLPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322501F000C4;
	Wed, 18 Nov 2026 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019229;
	bh=pFUXkRjEHNr0IX0VdfGu/zVNOQK6tE4GMF4r6612WhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5/rrLPiYFeYZC8BSPSEIw0ZPGuEIqBBAddQA6Cl1wEBd36I8+2Mt7j6zrp5lQXQE
	 hnn77uKarYF+s89pn+ue4kYzRhzZWLeq2oHVmXHWXhTPjjdB/RaROM1IlgMvY/9yTD
	 33pwIlFR2XYVaYCml6LWLsnTPMpiydj8jFXvvggc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1485/2651] wifi: mt76: mt7996: disable the RX NAPIs before the DMA cleanup
Date: Wed, 18 Nov 2026 15:45:25 +0100
Message-ID: <20261118150341.482330928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Crispin <john@phrozen.org>

[ Upstream commit 7a5a3843178c61d99d939b231318692d08fff79b ]

mt7996_unregister_device() leaves the RX NAPIs enabled, so
mt76_dma_cleanup() deletes enabled NAPIs and destroys page pools that
are still bound to them. On rmmod, the kernel warns in
__netif_napi_del_locked() for every RX queue and in
page_pool_disable_direct_recycling(). Until the IRQ tasklet is disabled,
an interrupt can still schedule a NAPI that was already deleted.

Disable every RX NAPI that was added before the MCU exit and the DMA
cleanup. This includes the host RRO queues: mt76_dma_init() skips them,
but mt7996_dma_rro_start() adds their NAPIs later when WED is not
active, so a check for mt76_queue_is_wed_rro() would miss them.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: John Crispin <john@phrozen.org>
Link: https://patch.msgid.link/20261006205936.669125-27-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index c1d8600298012..36944c096e401 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1810,6 +1810,8 @@ int mt7996_register_device(struct mt7996_dev *dev)
 
 void mt7996_unregister_device(struct mt7996_dev *dev)
 {
+	int i;
+
 	cancel_work_sync(&dev->dump_work);
 	cancel_work_sync(&dev->wed_rro.work);
 	cancel_work_sync(&dev->reset_work);
@@ -1820,6 +1822,10 @@ void mt7996_unregister_device(struct mt7996_dev *dev)
 	mt7996_coredump_unregister(dev);
 	mt76_unregister_device(&dev->mt76);
 	mt7996_wed_rro_free(dev);
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++) {
+		if (dev->mt76.napi[i].dev)
+			napi_disable(&dev->mt76.napi[i]);
+	}
 	mt7996_mcu_exit(dev);
 	mt7996_tx_token_put(dev);
 	mt7996_dma_cleanup(dev);
-- 
2.53.0



