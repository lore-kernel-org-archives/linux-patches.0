Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05662CCC5;
	Tue, 17 Jun 2025 16:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177369; cv=none; b=J94LG+rCogXTveDiDT9AofE+nr9tuoGegn7QpBx7u0y/ug2HUcc05Ab7B8tffMX/3KG/MYLmwGbFQIX1mg1quruzpQP5OFipUhv2eYR+j1hS+Jqz9vrvFgaQRCeBWo5yNwxQpxrZ3oYLgzxGldS+66xf0ZY0CftlcqUTLIMHXyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177369; c=relaxed/simple;
	bh=FPVyktUG+yUKuoTDI1K6LIEK08UggPS01544AxjgETk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jt0vnXvzChPXHW3sDBhaB9gu/egWK3Rz8KaRl1Nc6+ey76ar3zBfBh+wvEqJLXQwwjNsWhtawbL9uiTLHUsxhGs2HdEzLwxcz1gU08jxJ+bYdU9uHYxk6v8K0SGNCb73lKVVvPNPOe0wQbjlI2G3LG5R7e3ny6gr6iuL8Ce0Tn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ms0JJbaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ms0JJbaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEF8C4CEE3;
	Tue, 17 Jun 2025 16:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177369;
	bh=FPVyktUG+yUKuoTDI1K6LIEK08UggPS01544AxjgETk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ms0JJbaLaATdAwVX65cbLlE/hjfFvBeFMTMpGyOKGUmQBQA4uUellltJ+DHf/8Bk5
	 yUDZGaolnfZVWXMspR5jXJwT+mtumaJuLjC3TPZarP6zKTQtzV4FGc+HKcjy9aGON4
	 XdzbPXDR0OBTxJweyX3prXGG50XC/bjGO7exDRak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 296/780] wifi: mt76: mt7996: Fix null-ptr-deref in mt7996_mmio_wed_init()
Date: Tue, 17 Jun 2025 17:20:04 +0200
Message-ID: <20250617152503.519757554@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 8f30e2b059757d8711a823e4c9c023db62a1d171 ]

devm_ioremap() returns NULL on error. Currently, mt7996_mmio_wed_init()
does not check for this case, which results in a NULL pointer
dereference.

Prevent null pointer dereference in mt7996_mmio_wed_init()

Fixes: 83eafc9251d6 ("wifi: mt76: mt7996: add wed tx support")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://patch.msgid.link/20250407032349.83360-1-bsdhenrymartin@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 13b188e281bdb..af9169030bad9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -323,6 +323,9 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 	wed->wlan.base = devm_ioremap(dev->mt76.dev,
 				      pci_resource_start(pci_dev, 0),
 				      pci_resource_len(pci_dev, 0));
+	if (!wed->wlan.base)
+		return -ENOMEM;
+
 	wed->wlan.phy_base = pci_resource_start(pci_dev, 0);
 
 	if (hif2) {
-- 
2.39.5



