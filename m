Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECCB6FB1;
	Tue,  5 Dec 2023 03:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nwvdmezr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6422C433C8;
	Tue,  5 Dec 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747621;
	bh=gBNuvK7T8Zn8V1I2Ouc8tp5LgxACUoPua4b2f8vXWQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwvdmezrFvs1xqhH0Y3OZEgFIbD61Q+kYIlJ3CAA3tGkZ1Hj48Y7sN7YuRLpcNodK
	 oqLNOxAEu76p0X3OmLvqeTZvvK4mJ0g+Q1JME+wjaMhcylTREMP8kqYJx380U2Pqfv
	 vH/U9nmi9Nk81AfyC6UGHpS7i//5hoUaIcDjQ31I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Paul Olaru <paul.olaru@oss.nxp.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/135] ASoC: SOF: sof-pci-dev: add parameter to override topology filename
Date: Tue,  5 Dec 2023 12:17:09 +0900
Message-ID: <20231205031537.569390695@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 772627acfeb0e670ede534b7d5502dae9668d3ee ]

The existing 'tplg_path' module parameter can be used to load
alternate firmware files, be it for development or to handle
OEM-specific or board-specific releases. However the topology filename
is either hard-coded in machine descriptors or modified by specific
DMI-quirks.

For additional flexibility, this patch adds the 'tplg_filename' module
parameter to override topology names.

To avoid any confusion between DMI- and parameter-override, a variable
rename is added.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Paul Olaru <paul.olaru@oss.nxp.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220414184817.362215-7-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7dd692217b86 ("ASoC: SOF: sof-pci-dev: Fix community key quirk detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-pci-dev.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index 571dc679ff7c1..966bf28403475 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -31,17 +31,21 @@ static char *tplg_path;
 module_param(tplg_path, charp, 0444);
 MODULE_PARM_DESC(tplg_path, "alternate path for SOF topology.");
 
+static char *tplg_filename;
+module_param(tplg_filename, charp, 0444);
+MODULE_PARM_DESC(tplg_filename, "alternate filename for SOF topology.");
+
 static int sof_pci_debug;
 module_param_named(sof_pci_debug, sof_pci_debug, int, 0444);
 MODULE_PARM_DESC(sof_pci_debug, "SOF PCI debug options (0x0 all off)");
 
-static const char *sof_override_tplg_name;
+static const char *sof_dmi_override_tplg_name;
 
 #define SOF_PCI_DISABLE_PM_RUNTIME BIT(0)
 
 static int sof_tplg_cb(const struct dmi_system_id *id)
 {
-	sof_override_tplg_name = id->driver_data;
+	sof_dmi_override_tplg_name = id->driver_data;
 	return 1;
 }
 
@@ -391,9 +395,20 @@ static int sof_pci_probe(struct pci_dev *pci,
 		sof_pdata->tplg_filename_prefix =
 			sof_pdata->desc->default_tplg_path;
 
-	dmi_check_system(sof_tplg_table);
-	if (sof_override_tplg_name)
-		sof_pdata->tplg_filename = sof_override_tplg_name;
+	/*
+	 * the topology filename will be provided in the machine descriptor, unless
+	 * it is overridden by a module parameter or DMI quirk.
+	 */
+	if (tplg_filename) {
+		sof_pdata->tplg_filename = tplg_filename;
+
+		dev_dbg(dev, "Module parameter used, changed tplg filename to %s\n",
+			sof_pdata->tplg_filename);
+	} else {
+		dmi_check_system(sof_tplg_table);
+		if (sof_dmi_override_tplg_name)
+			sof_pdata->tplg_filename = sof_dmi_override_tplg_name;
+	}
 
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE)
 	/* set callback to enable runtime_pm */
-- 
2.42.0



