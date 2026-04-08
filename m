Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78AD347517;
	Wed,  8 Apr 2026 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671809; cv=none; b=psILFo3lAz0D/QazUsw0BP4pkdwhxFE9nR1Dlw4X6I7hMVAZgYEmmKpIh37HFtcRO8iPgBKmYk1p8t6Mn8hk3kIEAaQ9n7/k5imEdbXshlWG6gUY9xIhkEmXuqR6WH82IfY40HKF/lslvBWA+5QZeGQzM/xs+BYpDTYpjgC/Ckk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671809; c=relaxed/simple;
	bh=XZR61XJvGpGiUJZnDNYMWem2ICTO1R6Jn/qanYHeBg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqmuvxZQ53qEqKdr3N1VtiDwfqCvGCn0Xxj1qo+KPsZzw/bF7oTPwWKRu+3id9EeI7o3hXXlIt3aY9yhkdgajy9+Jjd6+ZsCPMLKNDQPmBBfxrNl5ChwwihZcA+/f6FqshcyPh75Ane+dS3S1toW0NZZ2ngyBxGluW6Stf/XStE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+8Pwc/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+8Pwc/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCCDC19421;
	Wed,  8 Apr 2026 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671809;
	bh=XZR61XJvGpGiUJZnDNYMWem2ICTO1R6Jn/qanYHeBg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+8Pwc/J69pyE3h2lg7xsQWf4FURVDLXcLHw6+fR1K7K8k9YHbRNvifcUT/2wIruC
	 TfJuNVTco3Nw7MYK7qOqXI0KfJsmcq5SheMDdrS4dJjCsMdeWl1xqVpvrvcdum3wVw
	 lGID7n9zTinveUxukSNWZTzz95kLKv1m57whEgcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/312] ASoC: Intel: catpt: Fix the device initialization
Date: Wed,  8 Apr 2026 19:59:53 +0200
Message-ID: <20260408175936.582012322@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d5d08bd766c70..4783876ed56f1 100644
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



