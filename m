Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7642BE03C;
	Tue, 26 Aug 2025 11:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208366; cv=none; b=Y4S3u4pR3beI+lLjPjV6Nevs6lufqOEMXPP4S4p2YFLqPgTGYaMKYXf9j3cwjZbRG0Fq3x09ezM1RBBRFM/7e19chfElyCRPgMij1Tj6t/m9tPnFiTQdeeaAD8T9tTOOM9uVddhTLX0yLqciDtgMACEwcK8Mr58zLhgGdz/WLLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208366; c=relaxed/simple;
	bh=1tXcCL52Cljf7I8TlppnFRqvbBBYBSMARtYSg/CR/S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iA0eevX6yV9bYWeganektChuuaUlHmScypiDjWnnpRTegtjJH0LYofWkZ+JYRlIPeTs3Fuu8BitYoxDgVr7Nn/RefckFADeH0eYNom49P8N48QCN4vDPITIOMrkf8CjTSKUqCfCDG2Q8IKw/bULc7Pg/63X2X9iVQTXCJHjyRVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AijNPsVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AijNPsVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC5AC4CEF1;
	Tue, 26 Aug 2025 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208366;
	bh=1tXcCL52Cljf7I8TlppnFRqvbBBYBSMARtYSg/CR/S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AijNPsVjqEGItoYcnJ+YfUBLDP+p7uQ0s80DnxaOxQcRrwVwskmOKKhoNtGci54Tz
	 1PbfvRNaCICfzDHApuIiC12b7GjpVl+cVTFIwFs5r3dHE96ORixsKTVAz1XZWaBFlS
	 aLtBfTlbvy3tTUrHpKV9p88Xc5kwUviMKFTyx3yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 084/322] ASoC: SOF: amd: acp-loader: Use GFP_KERNEL for DMA allocations in resume context
Date: Tue, 26 Aug 2025 13:08:19 +0200
Message-ID: <20250826110917.703738235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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


