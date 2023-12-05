Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498F86AC2;
	Tue,  5 Dec 2023 03:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+ESN2dT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B78C433C8;
	Tue,  5 Dec 2023 03:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747753;
	bh=gKfdn9fJaxUkEn9uINhdoUo0J4rWKr2I+vtQrEI0pyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+ESN2dTBgqSVSTMQMKHXyF6GEL+iAxq8DeetZ16pIeHQKb2l50AEMG2zso4iylCF
	 31p5xJdmMX3031c4InF+6F7Gpy2v5jyzHQS+wdhsjgbYepBknYhO+fxVxTZjeWeRsL
	 D0F4GBrvMnkM7Ym9mplpYUQFy2qHwtEb003qammw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 55/67] ASoC: SOF: sof-pci-dev: dont use the community key on APL Chromebooks
Date: Tue,  5 Dec 2023 12:17:40 +0900
Message-ID: <20231205031523.056416167@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit d81e4ba5ef1c1033b6c720b22fc99feeb71e71a0 ]

As suggested by MrChromebox, the SOF driver can be used with the SOF
firmware binary signed with the production key. This patch adds an
additional check for the ApolloLake SoC before modifying the default
firmware path.

Note that ApolloLake Chromebooks officially ship with the Skylake
driver, so to use SOF the users have to explicitly opt-in with
'options intel-dspcfg dsp_driver=3'. There is no plan to change the
default selection.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20220421163358.319489-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7dd692217b86 ("ASoC: SOF: sof-pci-dev: Fix community key quirk detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-pci-dev.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index 6b103118cfd1b..9f0732461a611 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -12,6 +12,7 @@
 #include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/platform_data/x86/soc.h>
 #include <linux/pm_runtime.h>
 #include <sound/soc-acpi.h>
 #include <sound/soc-acpi-intel-match.h>
@@ -36,6 +37,7 @@ module_param_named(sof_pci_debug, sof_pci_debug, int, 0444);
 MODULE_PARM_DESC(sof_pci_debug, "SOF PCI debug options (0x0 all off)");
 
 static const char *sof_dmi_override_tplg_name;
+static bool sof_dmi_use_community_key;
 
 #define SOF_PCI_DISABLE_PM_RUNTIME BIT(0)
 
@@ -66,15 +68,35 @@ static const struct dmi_system_id sof_tplg_table[] = {
 	{}
 };
 
+/* all Up boards use the community key */
+static int up_use_community_key(const struct dmi_system_id *id)
+{
+	sof_dmi_use_community_key = true;
+	return 1;
+}
+
+/*
+ * For ApolloLake Chromebooks we want to force the use of the Intel production key.
+ * All newer platforms use the community key
+ */
+static int chromebook_use_community_key(const struct dmi_system_id *id)
+{
+	if (!soc_intel_is_apl())
+		sof_dmi_use_community_key = true;
+	return 1;
+}
+
 static const struct dmi_system_id community_key_platforms[] = {
 	{
 		.ident = "Up boards",
+		.callback = up_use_community_key,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "AAEON"),
 		}
 	},
 	{
 		.ident = "Google Chromebooks",
+		.callback = chromebook_use_community_key,
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "Google"),
 		}
@@ -167,7 +189,7 @@ int sof_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 			"Module parameter used, changed fw path to %s\n",
 			sof_pdata->fw_filename_prefix);
 
-	} else if (dmi_check_system(community_key_platforms)) {
+	} else if (dmi_check_system(community_key_platforms) && sof_dmi_use_community_key) {
 		sof_pdata->fw_filename_prefix =
 			devm_kasprintf(dev, GFP_KERNEL, "%s/%s",
 				       sof_pdata->desc->default_fw_path,
-- 
2.42.0



