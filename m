Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D182196D99;
	Thu,  6 Jun 2024 14:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683001; cv=none; b=HMVAmJXEiBjVubCIkh4pzAIrzjspMSdqHieSUnmGEeZAElLAr7BRhqITaXXzrhubfX3r96aqwYCHSKQO+AHYQ82dRbXwHECbprL5Eg8VsClbXjVKVNvi9b51d6ScGllrW5IVzQ1OXVTKq+OYKdSnNbWWE6pfS3OymVswJcCbpI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683001; c=relaxed/simple;
	bh=xSH9TtkRF79ZsG/DkYxLcRPkSWinCc5+KMv6p2Weuow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsOb3afRKRGJL7amYloZcVZsGnd2KMX47yzoagdY3RTOHavUxuUeqaY9gVjRu6yULwKYNxUz+3bspPGa625r5TLnSsVISAzp4QUzTx/RGiBefRKC8Bik4Awn2pyNDpzuq/PHsrM78zCxNmqiHV1PFTzbYx6hNKQMCKitur6fGL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1dqkdNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1dqkdNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C429C32786;
	Thu,  6 Jun 2024 14:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683001;
	bh=xSH9TtkRF79ZsG/DkYxLcRPkSWinCc5+KMv6p2Weuow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1dqkdNuIcIqZvoZZDjLDtslpnxEXFushTkF7gXDrRRwOnyXWWkBlK5InJHMhWXRd
	 K8E4NCabpNW33+8dVZAhhDSL3MP2ADXjMUbDRyZe7v1ehIZFSHjpiHCPry4TV2oGEu
	 l9TvgpTxp9YMmIgZlBt/DXK3MoGrBO8kc8qudrAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 204/374] ASoC: amd: acp: fix for acp platform device creation failure
Date: Thu,  6 Jun 2024 16:03:03 +0200
Message-ID: <20240606131658.663708413@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 09068d624c490c0e89f33f963c402f1859964467 ]

ACP pin configuration varies based on acp version.
ACP PCI driver should read the ACP PIN config value and based on config
value, it has to create a platform device in below two conditions.
1) If ACP PDM configuration is selected from BIOS and ACP PDM controller
exists.
2) If ACP I2S configuration is selected from BIOS.

Other than above scenarios, ACP PCI driver should skip the platform
device creation logic, i.e. ACP PCI driver probe sequence should never
fail if other acp pin configuration is selected. It should skip platform
device creation logic.

check_acp_pdm() function was implemented for ACP6.x platforms to check
ACP PDM configuration. Previously, this code was safe guarded by
FLAG_AMD_LEGACY_ONLY_DMIC flag check.

This implementation breaks audio use cases for Huawei Matebooks which are
based on ACP3.x varaint uses I2S configuration.
In current scenario, check_acp_pdm() function returns -ENODEV value
which results in ACP PCI driver probe failure without creating a platform
device even in case of valid ACP pin configuration.

Implement check_acp_config() as a common function which invokes platform
specific acp pin configuration check functions for ACP3.x, ACP6.0 & ACP6.3
& ACP7.0 variants and checks for ACP PDM controller.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218780
Fixes: 4af565de9f8c ("ASoC: amd: acp: fix for acp pdm configuration check")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20240502140340.4049021-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-legacy-common.c | 96 ++++++++++++++++++++++-----
 sound/soc/amd/acp/acp-pci.c           |  9 ++-
 sound/soc/amd/acp/amd.h               | 10 ++-
 sound/soc/amd/acp/chip_offset_byte.h  |  1 +
 4 files changed, 95 insertions(+), 21 deletions(-)

diff --git a/sound/soc/amd/acp/acp-legacy-common.c b/sound/soc/amd/acp/acp-legacy-common.c
index b5aff3f230be5..3be7c6d55a6f8 100644
--- a/sound/soc/amd/acp/acp-legacy-common.c
+++ b/sound/soc/amd/acp/acp-legacy-common.c
@@ -358,11 +358,25 @@ int smn_read(struct pci_dev *dev, u32 smn_addr)
 }
 EXPORT_SYMBOL_NS_GPL(smn_read, SND_SOC_ACP_COMMON);
 
-int check_acp_pdm(struct pci_dev *pci, struct acp_chip_info *chip)
+static void check_acp3x_config(struct acp_chip_info *chip)
 {
-	struct acpi_device *pdm_dev;
-	const union acpi_object *obj;
-	u32 pdm_addr, val;
+	u32 val;
+
+	val = readl(chip->base + ACP3X_PIN_CONFIG);
+	switch (val) {
+	case ACP_CONFIG_4:
+		chip->is_i2s_config = true;
+		chip->is_pdm_config = true;
+		break;
+	default:
+		chip->is_pdm_config = true;
+		break;
+	}
+}
+
+static void check_acp6x_config(struct acp_chip_info *chip)
+{
+	u32 val;
 
 	val = readl(chip->base + ACP_PIN_CONFIG);
 	switch (val) {
@@ -371,42 +385,94 @@ int check_acp_pdm(struct pci_dev *pci, struct acp_chip_info *chip)
 	case ACP_CONFIG_6:
 	case ACP_CONFIG_7:
 	case ACP_CONFIG_8:
-	case ACP_CONFIG_10:
 	case ACP_CONFIG_11:
+	case ACP_CONFIG_14:
+		chip->is_pdm_config = true;
+		break;
+	case ACP_CONFIG_9:
+		chip->is_i2s_config = true;
+		break;
+	case ACP_CONFIG_10:
 	case ACP_CONFIG_12:
 	case ACP_CONFIG_13:
+		chip->is_i2s_config = true;
+		chip->is_pdm_config = true;
+		break;
+	default:
+		break;
+	}
+}
+
+static void check_acp70_config(struct acp_chip_info *chip)
+{
+	u32 val;
+
+	val = readl(chip->base + ACP_PIN_CONFIG);
+	switch (val) {
+	case ACP_CONFIG_4:
+	case ACP_CONFIG_5:
+	case ACP_CONFIG_6:
+	case ACP_CONFIG_7:
+	case ACP_CONFIG_8:
+	case ACP_CONFIG_11:
 	case ACP_CONFIG_14:
+	case ACP_CONFIG_17:
+	case ACP_CONFIG_18:
+		chip->is_pdm_config = true;
+		break;
+	case ACP_CONFIG_9:
+		chip->is_i2s_config = true;
+		break;
+	case ACP_CONFIG_10:
+	case ACP_CONFIG_12:
+	case ACP_CONFIG_13:
+	case ACP_CONFIG_19:
+	case ACP_CONFIG_20:
+		chip->is_i2s_config = true;
+		chip->is_pdm_config = true;
 		break;
 	default:
-		return -EINVAL;
+		break;
 	}
+}
+
+void check_acp_config(struct pci_dev *pci, struct acp_chip_info *chip)
+{
+	struct acpi_device *pdm_dev;
+	const union acpi_object *obj;
+	u32 pdm_addr;
 
 	switch (chip->acp_rev) {
 	case ACP3X_DEV:
 		pdm_addr = ACP_RENOIR_PDM_ADDR;
+		check_acp3x_config(chip);
 		break;
 	case ACP6X_DEV:
 		pdm_addr = ACP_REMBRANDT_PDM_ADDR;
+		check_acp6x_config(chip);
 		break;
 	case ACP63_DEV:
 		pdm_addr = ACP63_PDM_ADDR;
+		check_acp6x_config(chip);
 		break;
 	case ACP70_DEV:
 		pdm_addr = ACP70_PDM_ADDR;
+		check_acp70_config(chip);
 		break;
 	default:
-		return -EINVAL;
+		break;
 	}
 
-	pdm_dev = acpi_find_child_device(ACPI_COMPANION(&pci->dev), pdm_addr, 0);
-	if (pdm_dev) {
-		if (!acpi_dev_get_property(pdm_dev, "acp-audio-device-type",
-					   ACPI_TYPE_INTEGER, &obj) &&
-					   obj->integer.value == pdm_addr)
-			return 0;
+	if (chip->is_pdm_config) {
+		pdm_dev = acpi_find_child_device(ACPI_COMPANION(&pci->dev), pdm_addr, 0);
+		if (pdm_dev) {
+			if (!acpi_dev_get_property(pdm_dev, "acp-audio-device-type",
+						   ACPI_TYPE_INTEGER, &obj) &&
+						   obj->integer.value == pdm_addr)
+				chip->is_pdm_dev = true;
+		}
 	}
-	return -ENODEV;
 }
-EXPORT_SYMBOL_NS_GPL(check_acp_pdm, SND_SOC_ACP_COMMON);
+EXPORT_SYMBOL_NS_GPL(check_acp_config, SND_SOC_ACP_COMMON);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/sound/soc/amd/acp/acp-pci.c b/sound/soc/amd/acp/acp-pci.c
index 5f35b90eab8d3..ad320b29e87dc 100644
--- a/sound/soc/amd/acp/acp-pci.c
+++ b/sound/soc/amd/acp/acp-pci.c
@@ -100,7 +100,6 @@ static int acp_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id
 		ret = -EINVAL;
 		goto release_regions;
 	}
-
 	dmic_dev = platform_device_register_data(dev, "dmic-codec", PLATFORM_DEVID_NONE, NULL, 0);
 	if (IS_ERR(dmic_dev)) {
 		dev_err(dev, "failed to create DMIC device\n");
@@ -119,6 +118,10 @@ static int acp_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id
 	if (ret)
 		goto unregister_dmic_dev;
 
+	check_acp_config(pci, chip);
+	if (!chip->is_pdm_dev && !chip->is_i2s_config)
+		goto skip_pdev_creation;
+
 	res = devm_kcalloc(&pci->dev, num_res, sizeof(struct resource), GFP_KERNEL);
 	if (!res) {
 		ret = -ENOMEM;
@@ -136,10 +139,6 @@ static int acp_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id
 		}
 	}
 
-	ret = check_acp_pdm(pci, chip);
-	if (ret < 0)
-		goto skip_pdev_creation;
-
 	chip->flag = flag;
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
 
diff --git a/sound/soc/amd/acp/amd.h b/sound/soc/amd/acp/amd.h
index 5017e868f39b9..d75b4eb34de8d 100644
--- a/sound/soc/amd/acp/amd.h
+++ b/sound/soc/amd/acp/amd.h
@@ -138,6 +138,9 @@ struct acp_chip_info {
 	void __iomem *base;	/* ACP memory PCI base */
 	struct platform_device *chip_pdev;
 	unsigned int flag;	/* Distinguish b/w Legacy or Only PDM */
+	bool is_pdm_dev;	/* flag set to true when ACP PDM controller exists */
+	bool is_pdm_config;	/* flag set to true when PDM configuration is selected from BIOS */
+	bool is_i2s_config;	/* flag set to true when I2S configuration is selected from BIOS */
 };
 
 struct acp_stream {
@@ -212,6 +215,11 @@ enum acp_config {
 	ACP_CONFIG_13,
 	ACP_CONFIG_14,
 	ACP_CONFIG_15,
+	ACP_CONFIG_16,
+	ACP_CONFIG_17,
+	ACP_CONFIG_18,
+	ACP_CONFIG_19,
+	ACP_CONFIG_20,
 };
 
 extern const struct snd_soc_dai_ops asoc_acp_cpu_dai_ops;
@@ -240,7 +248,7 @@ void restore_acp_pdm_params(struct snd_pcm_substream *substream,
 int restore_acp_i2s_params(struct snd_pcm_substream *substream,
 			   struct acp_dev_data *adata, struct acp_stream *stream);
 
-int check_acp_pdm(struct pci_dev *pci, struct acp_chip_info *chip);
+void check_acp_config(struct pci_dev *pci, struct acp_chip_info *chip);
 
 static inline u64 acp_get_byte_count(struct acp_dev_data *adata, int dai_id, int direction)
 {
diff --git a/sound/soc/amd/acp/chip_offset_byte.h b/sound/soc/amd/acp/chip_offset_byte.h
index cfd6c4d075944..18da734c0e9e7 100644
--- a/sound/soc/amd/acp/chip_offset_byte.h
+++ b/sound/soc/amd/acp/chip_offset_byte.h
@@ -20,6 +20,7 @@
 #define ACP_SOFT_RESET                          0x1000
 #define ACP_CONTROL                             0x1004
 #define ACP_PIN_CONFIG				0x1440
+#define ACP3X_PIN_CONFIG			0x1400
 
 #define ACP_EXTERNAL_INTR_REG_ADDR(adata, offset, ctrl) \
 	(adata->acp_base + adata->rsrc->irq_reg_offset + offset + (ctrl * 0x04))
-- 
2.43.0



