Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025877;
	b=5qGys8Ux7ck/vSYsPDXZsTlGU88n1oauqQnA2bQ7e7kQRtGpMLf4jIczmrAfaMk1JALS
	 R20/mA6gpXo8ihXLfhFBzC2qPwKio48k4WkRpwjUaBDN7C5KyET6AraiI5bmdw/dbWTCU
	 UVCGqhPma7gMUCz03U38RaALyYIF4acJlh8+JFB7RYZv0Uz8Fn5JWOfjzwxfBAB1JxQDO
	 4xZYrWdN7M6Vx36Y81nz15BQc3ZivdlltdteJwX648vtrPupVZHlwfZXgni4sbhZL0i0n
	 wnf6Z+9Cde/LdAmA39BgOneXrW0+2CJKN72bII+oy8AMHt59PVf42eWgF+B+Hz+jhOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JZNOYhkEMFZh6oPAwFs5dgEKA5pulZpMH/hHD87lgis=;
	b=cvnHQLA77cvKOjptBFXylAUDDh/PeB7O4y+eVxU3hi/0Y2+7avCIMdYtYtFbDDM4nWzG
	 kpKk4447V30Io4Wl1fS7QDEIj9kEuHlPfQiUramlB9QyeHq1d73BEUngQpgZ0b5BBqBsX
	 xH85h7P6B+ID/ahxiBaqq+sa8oGECjwovkCJdPR+UPJjBARvb2CMCA9yjmrPYwKWkzYnZ
	 SePi1ePhG3R6wNhY5gP2pVy6doDP4QU7WRBbhbW/eVJuWQmvDgm30MaCBTTIkYey68+MH
	 7gaZuG+9k9K3QxH1jJzWTapq/Az19juAPv7H8cvSKoVqbh67oTHvLAiDICdnA0UxipA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7Fisymg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209B6606A32A;
	Wed, 18 Nov 2026 18:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x7Fisymg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE5E1F000C4;
	Wed, 18 Nov 2026 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025877;
	bh=JZNOYhkEMFZh6oPAwFs5dgEKA5pulZpMH/hHD87lgis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7FisymggGQFQl9S61pK9xkBibXUPQTdOtQ0HH7r787GW4QTTFiz93SK3qIM6XHy0
	 mg8bKi1lv8m209ySwFU4d3Ka0J/+mxD/LxtJqmipF2F6gG22WTfFcUx2Tre1+zcNRD
	 IJasZMZXmNPlfDYQrihZkRZGWvPHihKZXyn6GhMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1234/2151] wifi: mt76: mt7996: disable the RX NAPIs before the DMA cleanup
Date: Wed, 18 Nov 2026 15:49:29 +0100
Message-ID: <20261118150207.132496827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 778a9ca8d5fa0..18d30c1790bd8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1734,6 +1734,8 @@ int mt7996_register_device(struct mt7996_dev *dev)
 
 void mt7996_unregister_device(struct mt7996_dev *dev)
 {
+	int i;
+
 	cancel_work_sync(&dev->dump_work);
 	cancel_work_sync(&dev->wed_rro.work);
 	cancel_work_sync(&dev->reset_work);
@@ -1744,6 +1746,10 @@ void mt7996_unregister_device(struct mt7996_dev *dev)
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



