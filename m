Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8F823183F;
	Mon, 13 Apr 2026 16:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098004; cv=none; b=R94x8oOFJJBMwoaRRWrDt4J/StqIJMTbie7SnQgswoq8FjMxF8M5jqUzUDNPQtaiw5W2KzB2YXxOSzaGXaRnkh85MdVzADoqFl7p95EImyYVzTbvjhteS0SIc+U0QfMabYFIw5+WVMG1DdUGEUbSKPeA2c8dJ9qEQoAyUY4Bkc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098004; c=relaxed/simple;
	bh=yrOPYlAOWyizVIjHd0SSmZMSr7mJCPIFwCuxCtWL93k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVL0jjFu/Kn2ccnO9suBZQKALcBN+yo6xPa22RQ0DBFvaZqZgFYwWdAu8i6pKkXCkicTybkbOAgvZ+bMuCmHYaqN2nFU7onFRWkcaFvS121prZlWLsRN+/WQVaPLQgSDrNe8O8eMlfS9MnvC3z2tbCEyprEuuf5fJNTMH/Lv8fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYd6ya1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYd6ya1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1911CC2BCAF;
	Mon, 13 Apr 2026 16:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098004;
	bh=yrOPYlAOWyizVIjHd0SSmZMSr7mJCPIFwCuxCtWL93k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYd6ya1NdJJaqUXrMI/OOMMB7gi3f2RQn+k6/MBsLJCP75EsaYUnM0kAYhgJWHfqD
	 1fGtsG/nOSjGg11Lq1GnCGSGEUkjze1GwW1TQd46UY+ufPSq459ce3Rn9WNn/c0qY0
	 pDpzLanu5zRtDyjfDG2xBlA8jeAPbHSO+i+oylHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 356/570] ASoC: Intel: catpt: Fix the device initialization
Date: Mon, 13 Apr 2026 17:58:07 +0200
Message-ID: <20260413155843.820018384@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 85a34e37316d0..68b01bdef2bfe 100644
--- a/sound/soc/intel/catpt/device.c
+++ b/sound/soc/intel/catpt/device.c
@@ -275,7 +275,15 @@ static int catpt_acpi_probe(struct platform_device *pdev)
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



