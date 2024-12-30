Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D6C2E414;
	Mon, 30 Dec 2024 15:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574076; cv=none; b=h9p2OVaNUGe+yTb/G1RRLPrSzo0GNuASWMl9QUBM4Pch23VUr3D3PE+JO/7/tWYLMF2YI4339wncjCTZdVwInVMQ6fq9cGksme5Z/C+FEB8xgvzXKTUrV+2gMNcrhw3qlK5Y2ZSUfqfAnvKzSVnNhaammQw2GHaTIAXJ1p43PEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574076; c=relaxed/simple;
	bh=o/SR8FVPNyLeNrOQPCMzu8x+Sr+/pgNfwuOu7mMSyWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvRUgFk8NwrqtXeRFzXSF7x8+a0Z0sij1ntrty+wIRpRnGDJE2FU31FyKa607H+V2Y1L3Na6yWaqRZtPEKnkoAnf3jMgseoBex7sumJc8TaXN5BQJWCapL9DST2L4BUD6aim8L1Q/paXjwbBlKb0zFSrXotIx9lUBZ2uMbyPUAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYSM7KLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYSM7KLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8E7C4CED0;
	Mon, 30 Dec 2024 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574075;
	bh=o/SR8FVPNyLeNrOQPCMzu8x+Sr+/pgNfwuOu7mMSyWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYSM7KLNWDgeXKhufO0f6OVklAVBd5KYzXEKGBFFDEQGDIupUzFn3kWH+EgGtmw3m
	 +Q1cOxfmu8xHbO44IfCqNKzQXbMltNvZB4eDwPthaluTSuzgPEJcCmFIoeDJPzUK81
	 XnNuffs+mHdL4kWr49GuqR/GoU4RTcSKdmdZzvUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Kartik Rajput <kkartik@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 030/114] dmaengine: tegra: Return correct DMA status when paused
Date: Mon, 30 Dec 2024 16:42:27 +0100
Message-ID: <20241230154219.223470216@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Akhil R <akhilrajeev@nvidia.com>

commit ebc008699fd95701c9af5ebaeb0793eef81a71d5 upstream.

Currently, the driver does not return the correct DMA status when a DMA
pause is issued by the client drivers. This causes GPCDMA users to
assume that DMA is still running, while in reality, the DMA is paused.

Return DMA_PAUSED for tx_status() if the channel is paused in the middle
of a transfer.

Fixes: ee17028009d4 ("dmaengine: tegra: Add tegra gpcdma driver")
Cc: stable@vger.kernel.org
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Link: https://lore.kernel.org/r/20241212124412.5650-1-kkartik@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/tegra186-gpc-dma.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/dma/tegra186-gpc-dma.c
+++ b/drivers/dma/tegra186-gpc-dma.c
@@ -231,6 +231,7 @@ struct tegra_dma_channel {
 	bool config_init;
 	char name[30];
 	enum dma_transfer_direction sid_dir;
+	enum dma_status status;
 	int id;
 	int irq;
 	int slave_id;
@@ -393,6 +394,8 @@ static int tegra_dma_pause(struct tegra_
 		tegra_dma_dump_chan_regs(tdc);
 	}
 
+	tdc->status = DMA_PAUSED;
+
 	return ret;
 }
 
@@ -419,6 +422,8 @@ static void tegra_dma_resume(struct tegr
 	val = tdc_read(tdc, TEGRA_GPCDMA_CHAN_CSRE);
 	val &= ~TEGRA_GPCDMA_CHAN_CSRE_PAUSE;
 	tdc_write(tdc, TEGRA_GPCDMA_CHAN_CSRE, val);
+
+	tdc->status = DMA_IN_PROGRESS;
 }
 
 static int tegra_dma_device_resume(struct dma_chan *dc)
@@ -544,6 +549,7 @@ static void tegra_dma_xfer_complete(stru
 
 	tegra_dma_sid_free(tdc);
 	tdc->dma_desc = NULL;
+	tdc->status = DMA_COMPLETE;
 }
 
 static void tegra_dma_chan_decode_error(struct tegra_dma_channel *tdc,
@@ -716,6 +722,7 @@ static int tegra_dma_terminate_all(struc
 		tdc->dma_desc = NULL;
 	}
 
+	tdc->status = DMA_COMPLETE;
 	tegra_dma_sid_free(tdc);
 	vchan_get_all_descriptors(&tdc->vc, &head);
 	spin_unlock_irqrestore(&tdc->vc.lock, flags);
@@ -769,6 +776,9 @@ static enum dma_status tegra_dma_tx_stat
 	if (ret == DMA_COMPLETE)
 		return ret;
 
+	if (tdc->status == DMA_PAUSED)
+		ret = DMA_PAUSED;
+
 	spin_lock_irqsave(&tdc->vc.lock, flags);
 	vd = vchan_find_desc(&tdc->vc, cookie);
 	if (vd) {


