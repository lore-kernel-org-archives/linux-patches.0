Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60397E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D119C433C1;
	Wed,  2 Nov 2022 02:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357519;
	bh=2jaVAY5VOnoMLrvZNN+tNs3ZI4k3eK4CQjEvvCDeT40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+nq0BZSUrS/XC/pL42a8upiZgy+MxpNI0C7WgeEMxX08hGoD2KI4DK1XipjmFZ6Z
	 vtdisFrghj2H+r9Ic8uThp77AHC6oorXotK9p52VXzp4hD0tsC/oaAaJhrl6nvyg9h
	 iRwWSPaOmoMsZmALZ3esFGPCjGtJWaFhtqiLt9iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Chao Song <chao.song@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 156/240] ASoC: SOF: Intel: pci-tgl: fix ADL-N descriptor
Date: Wed,  2 Nov 2022 03:32:11 +0100
Message-Id: <20221102022114.909866320@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 05de5cf6fb7d73d2bf0a0c882433f31db5c93f63 ]

ADL-N uses a different signing key, which means we can't reuse the
regular ADL descriptor used for ADL-P/M/S.

Fixes: cd57eb3c403cb ("ASoC: SOF: Intel: pci-tgl: add ADL-N support")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Chao Song <chao.song@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221019154926.163539-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-tgl.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index aac47cd007e8..4644a78bc95d 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -159,6 +159,34 @@ static const struct sof_dev_desc adl_desc = {
 	.ops_init = sof_tgl_ops_init,
 };
 
+static const struct sof_dev_desc adl_n_desc = {
+	.machines               = snd_soc_acpi_intel_adl_machines,
+	.alt_machines           = snd_soc_acpi_intel_adl_sdw_machines,
+	.use_acpi_target_states = true,
+	.resindex_lpe_base      = 0,
+	.resindex_pcicfg_base   = -1,
+	.resindex_imr_base      = -1,
+	.irqindex_host_ipc      = -1,
+	.chip_info = &tgl_chip_info,
+	.ipc_supported_mask	= BIT(SOF_IPC) | BIT(SOF_INTEL_IPC4),
+	.ipc_default		= SOF_IPC,
+	.default_fw_path = {
+		[SOF_IPC] = "intel/sof",
+		[SOF_INTEL_IPC4] = "intel/avs/adl-n",
+	},
+	.default_tplg_path = {
+		[SOF_IPC] = "intel/sof-tplg",
+		[SOF_INTEL_IPC4] = "intel/avs-tplg",
+	},
+	.default_fw_filename = {
+		[SOF_IPC] = "sof-adl-n.ri",
+		[SOF_INTEL_IPC4] = "dsp_basefw.bin",
+	},
+	.nocodec_tplg_filename = "sof-adl-nocodec.tplg",
+	.ops = &sof_tgl_ops,
+	.ops_init = sof_tgl_ops_init,
+};
+
 static const struct sof_dev_desc rpls_desc = {
 	.machines               = snd_soc_acpi_intel_rpl_machines,
 	.alt_machines           = snd_soc_acpi_intel_rpl_sdw_machines,
@@ -242,7 +270,7 @@ static const struct pci_device_id sof_pci_ids[] = {
 	{ PCI_DEVICE(0x8086, 0x51cc), /* ADL-M */
 		.driver_data = (unsigned long)&adl_desc},
 	{ PCI_DEVICE(0x8086, 0x54c8), /* ADL-N */
-		.driver_data = (unsigned long)&adl_desc},
+		.driver_data = (unsigned long)&adl_n_desc},
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, sof_pci_ids);
-- 
2.35.1



