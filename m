Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E102ECD36;
	Tue, 17 Jun 2025 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175963; cv=none; b=gCl/SwqUKDhAiyeTqS/j+yz8wcC7vs74YmaIjFu0olkR8+3LlZgHuP2oIIDIIRmr8jt+34898xbe7Waol5t4ymWxrxYDxWN5bGH9y4bKyZ+1SoBaTgcIkivpgL2N5kOuYVPLdrvJuMyfctegTLxgyFr/GYD4gZnU2ja4a/pOMuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175963; c=relaxed/simple;
	bh=dFjt2b+rUjEix1qyGabia9XQeLweBeN24hRNAWtYxlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwbokhezJE1cviXZSFJxVEzse+8gayFUYQ4z8d4QTv0Txzi9fIYNTnuRQ25mDQk9EUzUwz463t4jDzHU3aH7J6CcRAXXovuZHM0eQ5nPvt5V+BDHfLVMyO7H58Qnnvd47hb86DoWsa/Fq3WqB/mNfmobu/gzbRIVmH/zInFsEtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV5lT0aP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV5lT0aP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728FFC4CEF2;
	Tue, 17 Jun 2025 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175962;
	bh=dFjt2b+rUjEix1qyGabia9XQeLweBeN24hRNAWtYxlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV5lT0aPOJtzdrsrBgmdLWgelgAcsbgn3wwLmANB7jolS/y2UdjWaJAhA8qbG/ymX
	 RUH1eYWrnKQBEk22t1gRU2Cvk6IcHMSQFURwfcuONqgJ4xwKFTzu2fLu2C1m1/ETil
	 5/ukr4McA6clvqjhAks27Zdjug/UfPx8u10u2TQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/512] wifi: mt76: mt7996: Fix null-ptr-deref in mt7996_mmio_wed_init()
Date: Tue, 17 Jun 2025 17:22:29 +0200
Message-ID: <20250617152427.064228843@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b6209ed1cfe01..bffee73b780cb 100644
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



