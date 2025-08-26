Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E3D33437B;
	Tue, 26 Aug 2025 11:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207254; cv=none; b=s19Zp6pnCTNOrWrRLPM0bRq8yPPAYeR1DUNu7NeqVTv6YYzBvMXAZxJh2y3NJL2d8FG9bTY4W8/p7svp2Ttt13YU0p821hu2vL9tMh1R85evijnXhQXI+L2Q6yfqqq7y3t5U6lrqlw6OgPfSS62hVA1BXHA9vmzfTdNIsSh3SH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207254; c=relaxed/simple;
	bh=EFKTXP9VoPG9QYa9yw+YYp722XYIa4P7dMkfPKQOrgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMRsiC0e0olUww3NAJ/7jVlnKiWkCvYb1O1GDjYl2UKFjcVI+LdFFP4uKWBe1NmNBHcwcNzPKuvMmhd1FOVkqHWabtB74fLdfezi9rtOWOuDB1fb7JfJLl7Hn8z2rALY2tCaWtRnqbAYpjTuVLVgIjFCSkWHl/8cmXsuahtNX74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mgwd31P9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mgwd31P9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E128C4CEF1;
	Tue, 26 Aug 2025 11:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207254;
	bh=EFKTXP9VoPG9QYa9yw+YYp722XYIa4P7dMkfPKQOrgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mgwd31P9e5JOUsbz7b0tJqcKIbIu2xR4ZV5EgSEJtFYujN5t0KRFofvZGFXTdcCb3
	 I4kAbSGPXEpVGy+lh4XHkBdWk1YuLjnJ2ZxEf3hilE41M/q+kNDvGinsdx7+M9wNaY
	 p2wRXUSkd77/ZYa7Rk8/z7WN6uqYd/a4nMeLeOCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.16 109/457] ASoC: SOF: amd: acp-loader: Use GFP_KERNEL for DMA allocations in resume context
Date: Tue, 26 Aug 2025 13:06:33 +0200
Message-ID: <20250826110940.065346051@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit eb3bb145280b6c857a748731a229698e4a7cf37b upstream.

Replace GFP_ATOMIC with GFP_KERNEL for dma_alloc_coherent() calls. This
change improves memory allocation reliability during firmware loading,
particularly during system resume when memory pressure is high. Because
of using GFP_KERNEL, reclaim can happen which can reduce the probability
of failure.

Fixes memory allocation failures observed during system resume with
fragmented memory conditions.

	snd_sof_amd_vangogh 0000:04:00.5: error: failed to load DSP firmware after resume -12

Fixes: 145d7e5ae8f4e ("ASoC: SOF: amd: add option to use sram for data bin loading")
Fixes: 7e51a9e38ab20 ("ASoC: SOF: amd: Add fw loader and renoir dsp ops to load firmware")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://patch.msgid.link/20250725190254.1081184-1-usama.anjum@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/amd/acp-loader.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/sof/amd/acp-loader.c
+++ b/sound/soc/sof/amd/acp-loader.c
@@ -65,7 +65,7 @@ int acp_dsp_block_write(struct snd_sof_d
 			dma_size = page_count * ACP_PAGE_SIZE;
 			adata->bin_buf = dma_alloc_coherent(&pci->dev, dma_size,
 							    &adata->sha_dma_addr,
-							    GFP_ATOMIC);
+							    GFP_KERNEL);
 			if (!adata->bin_buf)
 				return -ENOMEM;
 		}
@@ -77,7 +77,7 @@ int acp_dsp_block_write(struct snd_sof_d
 			adata->data_buf = dma_alloc_coherent(&pci->dev,
 							     ACP_DEFAULT_DRAM_LENGTH,
 							     &adata->dma_addr,
-							     GFP_ATOMIC);
+							     GFP_KERNEL);
 			if (!adata->data_buf)
 				return -ENOMEM;
 		}
@@ -90,7 +90,7 @@ int acp_dsp_block_write(struct snd_sof_d
 			adata->sram_data_buf = dma_alloc_coherent(&pci->dev,
 								  ACP_DEFAULT_SRAM_LENGTH,
 								  &adata->sram_dma_addr,
-								  GFP_ATOMIC);
+								  GFP_KERNEL);
 			if (!adata->sram_data_buf)
 				return -ENOMEM;
 		}


