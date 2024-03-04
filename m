Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D3B200CD;
	Mon,  4 Mar 2024 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587813; cv=none; b=ddQf+NQmnMfrbM2NZmJB3MoGK/3+WashUj7SQsQh1a7misZuyVdHPWNVX6Kg7CG0lkp10d2LhxWM1WyIaJTKl3IpOI22PHNBQYJw3DxX5fWMwpqrohxtZGJ4FkyNk/z1/waayYmhv5ig8TpwJnjOgcCK8yD8uw+XC5ZJfnRB2HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587813; c=relaxed/simple;
	bh=zPuifXDPTZFhS5lH7VIFc7N5v0EjEGrHo+jtDx6HZUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1M0Hh7a4QRRqWM66o9jnjn4TluXDCyDv7aaJY9kA2oCI9zbkEitN+Fs3xxvpjtX5cT0uHhchAQTXMDk0ErXpSR7b6be3Vpl60siuhBeUy62kk6Cvk6gnPJgEtIsm1Knu4BDNXZyQ0gqQ82X6HY0zfVt9hM/iYszhnXaIHKbmMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7Gfcr3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7Gfcr3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F8AC433F1;
	Mon,  4 Mar 2024 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587813;
	bh=zPuifXDPTZFhS5lH7VIFc7N5v0EjEGrHo+jtDx6HZUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7Gfcr3DrvUl47PMZvCTTix58vjHTqjOfwwzMW+AcJ4mOm12MUIHlF4C4OhHYmlHO
	 R3qO7rROpmav42piPAnZDz4UvofNQSij/4wS6PBdHfiaHzwqO4ITtlmeZw7SiadiaQ
	 qFvnA7Di6qGdz4oRFjGF5RWloz7HBkmBuTGxh2yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Kerello <christophe.kerello@foss.st.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.7 100/162] mmc: mmci: stm32: fix DMA API overlapping mappings warning
Date: Mon,  4 Mar 2024 21:22:45 +0000
Message-ID: <20240304211555.029157469@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Kerello <christophe.kerello@foss.st.com>

commit 6b1ba3f9040be5efc4396d86c9752cdc564730be upstream.

Turning on CONFIG_DMA_API_DEBUG_SG results in the following warning:

DMA-API: mmci-pl18x 48220000.mmc: cacheline tracking EEXIST,
overlapping mappings aren't supported
WARNING: CPU: 1 PID: 51 at kernel/dma/debug.c:568
add_dma_entry+0x234/0x2f4
Modules linked in:
CPU: 1 PID: 51 Comm: kworker/1:2 Not tainted 6.1.28 #1
Hardware name: STMicroelectronics STM32MP257F-EV1 Evaluation Board (DT)
Workqueue: events_freezable mmc_rescan
Call trace:
add_dma_entry+0x234/0x2f4
debug_dma_map_sg+0x198/0x350
__dma_map_sg_attrs+0xa0/0x110
dma_map_sg_attrs+0x10/0x2c
sdmmc_idma_prep_data+0x80/0xc0
mmci_prep_data+0x38/0x84
mmci_start_data+0x108/0x2dc
mmci_request+0xe4/0x190
__mmc_start_request+0x68/0x140
mmc_start_request+0x94/0xc0
mmc_wait_for_req+0x70/0x100
mmc_send_tuning+0x108/0x1ac
sdmmc_execute_tuning+0x14c/0x210
mmc_execute_tuning+0x48/0xec
mmc_sd_init_uhs_card.part.0+0x208/0x464
mmc_sd_init_card+0x318/0x89c
mmc_attach_sd+0xe4/0x180
mmc_rescan+0x244/0x320

DMA API debug brings to light leaking dma-mappings as dma_map_sg and
dma_unmap_sg are not correctly balanced.

If an error occurs in mmci_cmd_irq function, only mmci_dma_error
function is called and as this API is not managed on stm32 variant,
dma_unmap_sg is never called in this error path.

Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Fixes: 46b723dd867d ("mmc: mmci: add stm32 sdmmc variant")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240207143951.938144-1-christophe.kerello@foss.st.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci_stm32_sdmmc.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -225,6 +225,8 @@ static int sdmmc_idma_start(struct mmci_
 	struct scatterlist *sg;
 	int i;
 
+	host->dma_in_progress = true;
+
 	if (!host->variant->dma_lli || data->sg_len == 1 ||
 	    idma->use_bounce_buffer) {
 		u32 dma_addr;
@@ -263,9 +265,30 @@ static int sdmmc_idma_start(struct mmci_
 	return 0;
 }
 
+static void sdmmc_idma_error(struct mmci_host *host)
+{
+	struct mmc_data *data = host->data;
+	struct sdmmc_idma *idma = host->dma_priv;
+
+	if (!dma_inprogress(host))
+		return;
+
+	writel_relaxed(0, host->base + MMCI_STM32_IDMACTRLR);
+	host->dma_in_progress = false;
+	data->host_cookie = 0;
+
+	if (!idma->use_bounce_buffer)
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
+			     mmc_get_dma_dir(data));
+}
+
 static void sdmmc_idma_finalize(struct mmci_host *host, struct mmc_data *data)
 {
+	if (!dma_inprogress(host))
+		return;
+
 	writel_relaxed(0, host->base + MMCI_STM32_IDMACTRLR);
+	host->dma_in_progress = false;
 
 	if (!data->host_cookie)
 		sdmmc_idma_unprep_data(host, data, 0);
@@ -676,6 +699,7 @@ static struct mmci_host_ops sdmmc_varian
 	.dma_setup = sdmmc_idma_setup,
 	.dma_start = sdmmc_idma_start,
 	.dma_finalize = sdmmc_idma_finalize,
+	.dma_error = sdmmc_idma_error,
 	.set_clkreg = mmci_sdmmc_set_clkreg,
 	.set_pwrreg = mmci_sdmmc_set_pwrreg,
 	.busy_complete = sdmmc_busy_complete,


