Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2A32594B6;
	Mon, 30 Dec 2024 15:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573620; cv=none; b=H5we7riMsVtSs0Y2yUWdW4QWA5SvW1zqlmrl1wly8Td//vvuAO1nfD1CHuIv9ZhCIM7cAIF6LCkyxCGTQ0sn4UpP+S9am9iQ0E8705ZrbflXRiQhwDjxXqVuFwRUdll46Xu15/MBZDYhMYMWGic3hEHO586/KTqGiL+/8/9NAzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573620; c=relaxed/simple;
	bh=Vi33kJO5hoX1zJZm//bmmuG8e9a9CeTFAwgdxHw/HUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qxf9E27GMlQ4ABAEph8fuIrGIqpAM2y2vXU6Zlf2Y2D/J4kg9+hSScwptYmpt1hQeXQU4M+WGgCvUxLzzq3m/jaXy7N3wpk3NyJhKvgTToKy9/VlGZPxkuUXxFqIWYqNwCYnNB2RqDrHmOa9ejAs1tZyvvtpjrW3pHr5m0ky3Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdt2nDZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdt2nDZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0FCC4CED0;
	Mon, 30 Dec 2024 15:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573620;
	bh=Vi33kJO5hoX1zJZm//bmmuG8e9a9CeTFAwgdxHw/HUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdt2nDZHQpvs6owY+qyxQvkLq9goMK5pAYZZXiYM+f9MzIwdw0ysoFEKqORxE3yAD
	 EmJBesp16uf9RzylxQB56uYibICxjPqvQo7Jnr67wsnIX5+MeeJXG2MKkhzeQkKic5
	 /KfDdGS6ju3ZT4/gk3s0vOeIl//zXSafgwGkBgl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Kartik Rajput <kkartik@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 20/60] dmaengine: tegra: Return correct DMA status when paused
Date: Mon, 30 Dec 2024 16:42:30 +0100
Message-ID: <20241230154208.055372660@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -228,6 +228,7 @@ struct tegra_dma_channel {
 	bool config_init;
 	char name[30];
 	enum dma_transfer_direction sid_dir;
+	enum dma_status status;
 	int id;
 	int irq;
 	int slave_id;
@@ -389,6 +390,8 @@ static int tegra_dma_pause(struct tegra_
 		tegra_dma_dump_chan_regs(tdc);
 	}
 
+	tdc->status = DMA_PAUSED;
+
 	return ret;
 }
 
@@ -415,6 +418,8 @@ static void tegra_dma_resume(struct tegr
 	val = tdc_read(tdc, TEGRA_GPCDMA_CHAN_CSRE);
 	val &= ~TEGRA_GPCDMA_CHAN_CSRE_PAUSE;
 	tdc_write(tdc, TEGRA_GPCDMA_CHAN_CSRE, val);
+
+	tdc->status = DMA_IN_PROGRESS;
 }
 
 static int tegra_dma_device_resume(struct dma_chan *dc)
@@ -540,6 +545,7 @@ static void tegra_dma_xfer_complete(stru
 
 	tegra_dma_sid_free(tdc);
 	tdc->dma_desc = NULL;
+	tdc->status = DMA_COMPLETE;
 }
 
 static void tegra_dma_chan_decode_error(struct tegra_dma_channel *tdc,
@@ -712,6 +718,7 @@ static int tegra_dma_terminate_all(struc
 		tdc->dma_desc = NULL;
 	}
 
+	tdc->status = DMA_COMPLETE;
 	tegra_dma_sid_free(tdc);
 	vchan_get_all_descriptors(&tdc->vc, &head);
 	spin_unlock_irqrestore(&tdc->vc.lock, flags);
@@ -765,6 +772,9 @@ static enum dma_status tegra_dma_tx_stat
 	if (ret == DMA_COMPLETE)
 		return ret;
 
+	if (tdc->status == DMA_PAUSED)
+		ret = DMA_PAUSED;
+
 	spin_lock_irqsave(&tdc->vc.lock, flags);
 	vd = vchan_find_desc(&tdc->vc, cookie);
 	if (vd) {


