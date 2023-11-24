Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601F939FC3;
	Fri, 24 Nov 2023 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESCbnmOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B90C433C7;
	Fri, 24 Nov 2023 18:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849254;
	bh=5wG5J6BHcpZJIBWMRv3qaXl3x1z+kHT8485vdOqgI9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESCbnmOltHX0ckTCiqT6pliNo2yPIabpBVHrsc5BlOlnMReKbT+1ChusKCgAei9EQ
	 dWA83X087xQBizOgIBLvbDJhQDqKVHfFGTiAGCuD1ZgpE9xSLYo08xzYkTQ+1jFNG3
	 BoYAVTYfKC40glnilV17bYLpUaRCDO2l1xw1l9OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/530] ASoC: SOF: Pass PCI SSID to machine driver
Date: Fri, 24 Nov 2023 17:44:10 +0000
Message-ID: <20231124172030.636787042@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ba2de401d32625fe538d3f2c00ca73740dd2d516 ]

Pass the PCI SSID of the audio interface through to the machine driver.
This allows the machine driver to use the SSID to uniquely identify the
specific hardware configuration and apply any platform-specific
configuration.

struct snd_sof_pdata is passed around inside the SOF code, but it then
passes configuration information to the machine driver through
struct snd_soc_acpi_mach and struct snd_soc_acpi_mach_params. So SSID
information has been added to both snd_sof_pdata and
snd_soc_acpi_mach_params.

PCI does not define 0x0000 as an invalid value so we can't use zero to
indicate that the struct member was not written. Instead a flag is
included to indicate that a value has been written to the
subsystem_vendor and subsystem_device members.

sof_pci_probe() creates the struct snd_sof_pdata. It is passed a struct
pci_dev so it can fill in the SSID value.

sof_machine_check() finds the appropriate struct snd_soc_acpi_mach. It
copies the SSID information across to the struct snd_soc_acpi_mach_params.
This done before calling any custom set_mach_params() so that it could be
used by the set_mach_params() callback to apply variant params.

The machine driver receives the struct snd_soc_acpi_mach as its
platform_data.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230912163207.3498161-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-acpi.h    | 7 +++++++
 include/sound/sof.h         | 8 ++++++++
 sound/soc/sof/sof-audio.c   | 7 +++++++
 sound/soc/sof/sof-pci-dev.c | 8 ++++++++
 4 files changed, 30 insertions(+)

diff --git a/include/sound/soc-acpi.h b/include/sound/soc-acpi.h
index 6d31d535e8f6d..23d6d6bfb0736 100644
--- a/include/sound/soc-acpi.h
+++ b/include/sound/soc-acpi.h
@@ -68,6 +68,10 @@ static inline struct snd_soc_acpi_mach *snd_soc_acpi_codec_list(void *arg)
  * @i2s_link_mask: I2S/TDM links enabled on the board
  * @num_dai_drivers: number of elements in @dai_drivers
  * @dai_drivers: pointer to dai_drivers, used e.g. in nocodec mode
+ * @subsystem_vendor: optional PCI SSID vendor value
+ * @subsystem_device: optional PCI SSID device value
+ * @subsystem_id_set: true if a value has been written to
+ *		      subsystem_vendor and subsystem_device.
  */
 struct snd_soc_acpi_mach_params {
 	u32 acpi_ipc_irq_index;
@@ -80,6 +84,9 @@ struct snd_soc_acpi_mach_params {
 	u32 i2s_link_mask;
 	u32 num_dai_drivers;
 	struct snd_soc_dai_driver *dai_drivers;
+	unsigned short subsystem_vendor;
+	unsigned short subsystem_device;
+	bool subsystem_id_set;
 };
 
 /**
diff --git a/include/sound/sof.h b/include/sound/sof.h
index d3c41f87ac319..51294f2ba302c 100644
--- a/include/sound/sof.h
+++ b/include/sound/sof.h
@@ -64,6 +64,14 @@ struct snd_sof_pdata {
 	const char *name;
 	const char *platform;
 
+	/*
+	 * PCI SSID. As PCI does not define 0 as invalid, the subsystem_id_set
+	 * flag indicates that a value has been written to these members.
+	 */
+	unsigned short subsystem_vendor;
+	unsigned short subsystem_device;
+	bool subsystem_id_set;
+
 	struct device *dev;
 
 	/*
diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index e5405f854a910..563fe6f7789f7 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -1032,6 +1032,13 @@ int sof_machine_check(struct snd_sof_dev *sdev)
 		mach = snd_sof_machine_select(sdev);
 		if (mach) {
 			sof_pdata->machine = mach;
+
+			if (sof_pdata->subsystem_id_set) {
+				mach->mach_params.subsystem_vendor = sof_pdata->subsystem_vendor;
+				mach->mach_params.subsystem_device = sof_pdata->subsystem_device;
+				mach->mach_params.subsystem_id_set = true;
+			}
+
 			snd_sof_set_mach_params(mach, sdev);
 			return 0;
 		}
diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index f42c85df88a80..69a2352f2e1a0 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -221,6 +221,14 @@ int sof_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 		return ret;
 
 	sof_pdata->name = pci_name(pci);
+
+	/* PCI defines a vendor ID of 0xFFFF as invalid. */
+	if (pci->subsystem_vendor != 0xFFFF) {
+		sof_pdata->subsystem_vendor = pci->subsystem_vendor;
+		sof_pdata->subsystem_device = pci->subsystem_device;
+		sof_pdata->subsystem_id_set = true;
+	}
+
 	sof_pdata->desc = desc;
 	sof_pdata->dev = dev;
 
-- 
2.42.0



