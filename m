Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AB427B359;
	Wed, 10 Dec 2025 07:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351986; cv=none; b=qqhN7ZC8DC8pMVWwuF0rndHERJCfCTMYwST8j/wWg8hCicFGqLJWrdEGQ/Hd4KGSgMyHh1ddypPjnoCAOElhabID+q42C0nY7Kew+4GPCP+UjlHWbnh9YXJ19H/kTzCzEeeSx/PaBDzP8Jt3TTb/LfZWjtPozSS6EMxboIpbmTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351986; c=relaxed/simple;
	bh=0labSrNkX8RhGQHMaf0QEfoum/+TvDAcuhrI4kGVBIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/nM3Rf6BaPbspSbFYtRrJPh6WW/imIvzbRoaX2yU+4sgvjw4scaI3h3iPn7oIxlyo0rhscSMi0vHPUkbXFo0kdb18/bIvzxx0XnBsIhhbUJ+s/7MuSOVllysxDEvxJb9PKHxjjdSTvbpserAUdmrz0HEvMMo93mTbkX3NNK59Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJF6Xvry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJF6Xvry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460B3C4CEF1;
	Wed, 10 Dec 2025 07:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351985;
	bh=0labSrNkX8RhGQHMaf0QEfoum/+TvDAcuhrI4kGVBIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJF6XvryJIDe9xEWS75ytDGV2BNeql4DR/ecq29kPG1ryw8g2RtCEcQ+5I3FgGJok
	 2DoysLQfUqTBWPNsCnYC4ZHLdWVLjhdkGtlII0DIrqV8HW0FBHVwHUssfLpGUPTU2q
	 fodXwLMWv4S2IE/cLYfx7CXu9VisJa78VyVdN+NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 6.12 48/49] bus: mhi: host: pci_generic: Add Telit FN920C04 modem support
Date: Wed, 10 Dec 2025 16:30:18 +0900
Message-ID: <20251210072949.359329136@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 6348f62ef7ecc5855b710a7d4ea682425c38bb80 upstream.

Add SDX35 based modem Telit FN920C04.

$ lspci -vv
01:00.0 Unassigned class [ff00]: Qualcomm Device 011a
        Subsystem: Device 1c5d:2020

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250401093458.2953872-1-dnlplm@gmail.com
Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |   39 +++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -698,6 +698,42 @@ static const struct mhi_pci_dev_info mhi
 	.mru_default = 32768,
 };
 
+static const struct mhi_channel_config mhi_telit_fn920c04_channels[] = {
+	MHI_CHANNEL_CONFIG_UL_SBL(2, "SAHARA", 32, 0),
+	MHI_CHANNEL_CONFIG_DL_SBL(3, "SAHARA", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(4, "DIAG", 64, 1),
+	MHI_CHANNEL_CONFIG_DL(5, "DIAG", 64, 1),
+	MHI_CHANNEL_CONFIG_UL(14, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(15, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(32, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(33, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_UL_FP(34, "FIREHOSE", 32, 0),
+	MHI_CHANNEL_CONFIG_DL_FP(35, "FIREHOSE", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(92, "DUN2", 32, 1),
+	MHI_CHANNEL_CONFIG_DL(93, "DUN2", 32, 1),
+	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 2),
+	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0", 128, 3),
+};
+
+static const struct mhi_controller_config modem_telit_fn920c04_config = {
+	.max_channels = 128,
+	.timeout_ms = 50000,
+	.num_channels = ARRAY_SIZE(mhi_telit_fn920c04_channels),
+	.ch_cfg = mhi_telit_fn920c04_channels,
+	.num_events = ARRAY_SIZE(mhi_telit_fn990_events),
+	.event_cfg = mhi_telit_fn990_events,
+};
+
+static const struct mhi_pci_dev_info mhi_telit_fn920c04_info = {
+	.name = "telit-fn920c04",
+	.config = &modem_telit_fn920c04_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.sideband_wake = false,
+	.mru_default = 32768,
+	.edl_trigger = true,
+};
+
 static const struct mhi_pci_dev_info mhi_netprisma_lcur57_info = {
 	.name = "netprisma-lcur57",
 	.edl = "qcom/prog_firehose_sdx24.mbn",
@@ -720,6 +756,9 @@ static const struct mhi_pci_dev_info mhi
 
 /* Keep the list sorted based on the PID. New VID should be added as the last entry */
 static const struct pci_device_id mhi_pci_id_table[] = {
+	/* Telit FN920C04 (sdx35) */
+	{PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x011a, 0x1c5d, 0x2020),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn920c04_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0304),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx24_info },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, PCI_VENDOR_ID_QCOM, 0x010c),


