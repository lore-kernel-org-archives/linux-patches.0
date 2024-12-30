Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630FC15E8B;
	Mon, 30 Dec 2024 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573755; cv=none; b=NjFjghVfj/FgqvTA1dff4ur0vs2fNv6bMziFyo1Ssd1DuuQjiDEk447KU9qxR8kB0jWShF1TLWn2nYlNbqo/nUiCEIbH06JmOy/KGJCErqpMMeN4rd/JCTGJPSgEup0RGfebWIIwZ51OhuMi6CAW8KHtF7IgcH9fci+DDjhbeeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573755; c=relaxed/simple;
	bh=C15WwY3yEduRov/sNthv4aFqVADys7fUMKJiuAJtOWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWDdwoSaXyaUtX+n5Tk3VGTRuvHKQlRwKk65HZp+4pxurPVm+I+6JBMvupHxegrfw/P493AP1YYJSOPaglsovRa7moDvp4+t/EM7bL/RvmjtFe3sYujozrH/txUxRdndHkvQI5eU4Qb+FGounHOONt5kleZwCR55NxWWTmXIszM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8LVNsKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8LVNsKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2A8C4CED0;
	Mon, 30 Dec 2024 15:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573755;
	bh=C15WwY3yEduRov/sNthv4aFqVADys7fUMKJiuAJtOWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8LVNsKvMNSfyCuAUQ/Cj40+wdTF0Lsjmjw0fLN1HL5/wY9u03wc1qf8qtt8SC/dV
	 gLuT/cV5no2WIKLs/fPWj913rz5xGilTZgEpdjKbeAhDEihV9CsFWXoj8SbLN4OjF1
	 P0+r+f0X1XW1HLJmuHuod1AHIl67JAtzTCSCLD2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Kartik Rajput <kkartik@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 24/86] dmaengine: tegra: Return correct DMA status when paused
Date: Mon, 30 Dec 2024 16:42:32 +0100
Message-ID: <20241230154212.641929150@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


