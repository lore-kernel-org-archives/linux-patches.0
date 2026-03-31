Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CA33EE1DD;
	Tue, 31 Mar 2026 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974449; cv=none; b=rYEDG6ETLg4ASpvgyZPUXM1CCWNYH0aVvbMqz1iiLhahTdowaUTJxLvoKor0nuiqTfY3hDInL7WyDIw4en+xHrvQYSkw8H8w2D4x2rBgS5thfnMEwp//pw/4c+0LYOKoCfvTLQUZkmA31yyOd9zmozJdexPHrPm/2UoNYW4AbMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974449; c=relaxed/simple;
	bh=wiF+c+N8TKHPPcMWF12zSaG2uVVfJ47LKfgMGEQ4l+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntCyj8Ojcvg+zw4p7CMkGmYV8VtIHTUpsSgkLiduW0/7/iF2EcRm1pcfP49swm1TrU/QbEVYmGun8aixCoFUkT8tj2Z7SdEqDHIiHmeQBEQvVVrC/XKf/ubIbuJCl9Rm9T5YZVwlfJKZrjxQ5hJf8PnqK7XUA5Qzp896m/9l4SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpxAfKWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpxAfKWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C240DC19423;
	Tue, 31 Mar 2026 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974449;
	bh=wiF+c+N8TKHPPcMWF12zSaG2uVVfJ47LKfgMGEQ4l+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpxAfKWwG0HU5S8tA+21/qQM5f74lG2EPMA/Qat8dtnGeSZb9SA+rUtoCCI7JZd1C
	 qDR8xOHqQtxfqF5uO3d63qsc6201nhpm29R84fzBFlQhWtJYbe4M7qKSXosXfC1YBg
	 kIUWW5F2/CnKQ5/6tWycOe9/9isVU8UfgxdVieBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/175] ASoC: Intel: catpt: Fix the device initialization
Date: Tue, 31 Mar 2026 18:21:14 +0200
Message-ID: <20260331161733.077357677@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 5a184f1cb43a8e035251c635f5c47da5dc3e3049 ]

The DMA mask shall be coerced before any buffer allocations for the
device are done.  At the same time explain why DMA mask of 31 bits is
used in the first place.

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: 7a10b66a5df9 ("ASoC: Intel: catpt: Device driver lifecycle")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260320101217.1243688-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/catpt/device.c | 10 +++++++++-
 sound/soc/intel/catpt/dsp.c    |  3 ---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/sound/soc/intel/catpt/device.c b/sound/soc/intel/catpt/device.c
index cac3dffbd0d9f..6cc8b241f743e 100644
--- a/sound/soc/intel/catpt/device.c
+++ b/sound/soc/intel/catpt/device.c
@@ -271,7 +271,15 @@ static int catpt_acpi_probe(struct platform_device *pdev)
 	if (IS_ERR(cdev->pci_ba))
 		return PTR_ERR(cdev->pci_ba);
 
-	/* alloc buffer for storing DRAM context during dx transitions */
+	/*
+	 * As per design HOST is responsible for preserving firmware's runtime
+	 * context during D0 -> D3 -> D0 transitions.  Addresses used for DMA
+	 * to/from HOST memory shall be outside the reserved range of 0xFFFxxxxx.
+	 */
+	ret = dma_coerce_mask_and_coherent(cdev->dev, DMA_BIT_MASK(31));
+	if (ret)
+		return ret;
+
 	cdev->dxbuf_vaddr = dmam_alloc_coherent(dev, catpt_dram_size(cdev),
 						&cdev->dxbuf_paddr, GFP_KERNEL);
 	if (!cdev->dxbuf_vaddr)
diff --git a/sound/soc/intel/catpt/dsp.c b/sound/soc/intel/catpt/dsp.c
index 346bec0003066..3cde6b7ae9237 100644
--- a/sound/soc/intel/catpt/dsp.c
+++ b/sound/soc/intel/catpt/dsp.c
@@ -125,9 +125,6 @@ int catpt_dmac_probe(struct catpt_dev *cdev)
 	dmac->dev = cdev->dev;
 	dmac->irq = cdev->irq;
 
-	ret = dma_coerce_mask_and_coherent(cdev->dev, DMA_BIT_MASK(31));
-	if (ret)
-		return ret;
 	/*
 	 * Caller is responsible for putting device in D0 to allow
 	 * for I/O and memory access before probing DW.
-- 
2.53.0



