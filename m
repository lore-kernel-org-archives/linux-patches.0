Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA57522A;
	Wed,  5 Feb 2025 14:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765693; cv=none; b=iJGyFcjdXVI6uzsh2uoHTkK+Fe++ydDlROlSAG2IA65XvOBOI0nF3CgJbZleuSgn9VX310ASJOefi0Eu12mwmKjV2yBujpI1HlqFbcXXqUbc53zIM9NnSaCfw/gX1D1i2tUPBM7jXyv/+vKpevg79NJmHuj3g9k/lpqPTsvCORE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765693; c=relaxed/simple;
	bh=jtiq5BRvmQjfmQR1qXtHZs4bh+3LYgaAmPToUzbTIFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3fRHl8REMVq9wZyG4FUJkj58eQgij3+acMT2EIPDEtVkyFIjgtIsWlsFAHsuSei/fcxnl414V26bbmRnrvWCmVXna9ruXU7ENzESn24taZ0Yg7Ys0zsrZatyja9ZTcs7o4n6OiCu4ucWnIeG/DeoHzXUHWqAJ/gQ+BxXWIjHqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRQlvESZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRQlvESZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADD2C4CED6;
	Wed,  5 Feb 2025 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765693;
	bh=jtiq5BRvmQjfmQR1qXtHZs4bh+3LYgaAmPToUzbTIFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRQlvESZAyNnHlSfpfnlfZibcVUkfPEYQgJCvfIL71ZEresB5wHyDbb8Hb6U0FTx8
	 iQliHfdX2uiWEqbJow2G8rJ9Y9i9CkDjD9fzk82msjH2eTgIyem1Q4DmYyB92wNk+4
	 Aj/DzBBo+jDsxdWzl9qnGlrk5/TMC8y2nLpaDS6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 205/623] wifi: mt76: mt7915: firmware restart on devices with a second pcie link
Date: Wed,  5 Feb 2025 14:39:07 +0100
Message-ID: <20250205134504.071992696@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



