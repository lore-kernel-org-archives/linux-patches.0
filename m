Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0747522A;
	Wed,  5 Feb 2025 14:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765202; cv=none; b=eYlqBaVfQKv2puPItO6z5MTAvhC1bR/xzz8t29pvnkqCKklFh582zPRwhDhCeaRliAX/CNn8i9I0yDkcTlT3elT3ZRfGJeKR0AxBC7kEvOlFd5BUtTKzXGYupJ5KRQSio9bAH8Lsof75Xq/bUufHC03s0z05+VCuJ9tujpSQ/A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765202; c=relaxed/simple;
	bh=MpLkYfjCPe4dpj83CJHAQfqrJ4nbYfX3X8FN9QOtIhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgyQ6oM98imJCq2PdjbArk3Zg0aNBunp316MAGoQrdcxhsRee7ETXuZJDTVXo1Z3eyDaIoiQb3U4D75SDiktFeaIVWpnaDzA8/Gj7VUQEVzSufdISa2naFN/0HlZkmnjrv7A89x7UZ8P8milGMRxqFAqK/4OhMbZJznEI8tgm8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NU8of6eF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NU8of6eF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D25DC4CED1;
	Wed,  5 Feb 2025 14:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765201;
	bh=MpLkYfjCPe4dpj83CJHAQfqrJ4nbYfX3X8FN9QOtIhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NU8of6eFbgYpjDQCxybakFZhtSSy20ymkjb/PZVkIOSm1avaPCK9zB09a8j89D3s0
	 Do3keKX9p/hVUmJo6YfVkbXGrKL/nHt+QgPO68nXxrWpqqEuMow0/JtYg49URysgpH
	 W/ExQbPUS0mexQvOFPHSBFS6Ik0kxSuIR7zvcPVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/590] wifi: mt76: mt7915: firmware restart on devices with a second pcie link
Date: Wed,  5 Feb 2025 14:39:14 +0100
Message-ID: <20250205134502.893014457@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 9b60e2ae511c959024ecf6578b3fbe85cd06d7cc ]

It seems that the firmware checks the register used for detecting matching
PCIe links in order to figure out if a secondary PCIe link is enabled.
Write the register again just before starting the firmware on hw reset,
in order to fix an issue that left the second band unusable after restart.

Fixes: 9093cfff72e3 ("mt76: mt7915: add support for using a secondary PCIe link for gen1")
Link: https://patch.msgid.link/20241230194202.95065-11-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h | 1 +
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index cf77ce0c87599..b890a58d37300 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1388,6 +1388,8 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	if (dev_is_pci(mdev->dev)) {
 		mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
 		if (dev->hif2) {
+			mt76_wr(dev, MT_PCIE_RECOG_ID,
+				dev->hif2->index | MT_PCIE_RECOG_ID_SEM);
 			if (is_mt7915(mdev))
 				mt76_wr(dev, MT_PCIE1_MAC_INT_ENABLE, 0xff);
 			else
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index ac0b1f0eb27c1..5fe872ef2e939 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -191,6 +191,7 @@ struct mt7915_hif {
 	struct device *dev;
 	void __iomem *regs;
 	int irq;
+	u32 index;
 };
 
 struct mt7915_phy {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index 39132894e8ea2..07b0a5766eab7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -42,6 +42,7 @@ static struct mt7915_hif *mt7915_pci_get_hif2(u32 idx)
 			continue;
 
 		get_device(hif->dev);
+		hif->index = idx;
 		goto out;
 	}
 	hif = NULL;
-- 
2.39.5



