Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B818D3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F5FC433EF;
	Tue,  7 Feb 2023 13:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774941;
	bh=jrA2nr+ZhGjipwtw63+0/VDChevlVj9tMRYHve1F0ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLWlcFOjkwj/WjamuYdSc0vjFKZRK+j6xkRVNBPGGB/0V/vdmmV4YDo7jJuMCDiSV
	 pIUg1lYfH13sTn/s8XW8lkurmua1qfDa+h4ata77qgg3hi8szWM9bfxzA2fOTZJlYZ
	 KsjmqkJqlANs87aqdX5hfQaFcj4HKwzNXgyYbskQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/208] platform/x86/amd/pmf: Fix to update SPS thermals when power supply change
Date: Tue,  7 Feb 2023 13:55:11 +0100
Message-Id: <20230207125636.859393349@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit f21bf62290dd4d769594dcf0e6a688783d74f6a0 ]

Every power mode of static power slider has its own AC and DC power
settings.

When the power source changes from AC to DC, corresponding DC thermals
were not updated from PMF config store and this leads the system to always
run on AC power settings.

Fix it by registering with power_supply notifier and apply DC settings
upon getting notified by the power_supply handler.

Fixes: da5ce22df5fe ("platform/x86/amd/pmf: Add support for PMF core layer")
Suggested-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230125095936.3292883-6-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 23 +++++++++++++++++++++++
 drivers/platform/x86/amd/pmf/pmf.h  |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index a5f5a4bcff6d..c9f7bcef4ac8 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -58,6 +58,25 @@ static bool force_load;
 module_param(force_load, bool, 0444);
 MODULE_PARM_DESC(force_load, "Force load this driver on supported older platforms (experimental)");
 
+static int amd_pmf_pwr_src_notify_call(struct notifier_block *nb, unsigned long event, void *data)
+{
+	struct amd_pmf_dev *pmf = container_of(nb, struct amd_pmf_dev, pwr_src_notifier);
+
+	if (event != PSY_EVENT_PROP_CHANGED)
+		return NOTIFY_OK;
+
+	if (is_apmf_func_supported(pmf, APMF_FUNC_AUTO_MODE) ||
+	    is_apmf_func_supported(pmf, APMF_FUNC_DYN_SLIDER_DC) ||
+	    is_apmf_func_supported(pmf, APMF_FUNC_DYN_SLIDER_AC)) {
+		if ((pmf->amt_enabled || pmf->cnqf_enabled) && is_pprof_balanced(pmf))
+			return NOTIFY_DONE;
+	}
+
+	amd_pmf_set_sps_power_limits(pmf);
+
+	return NOTIFY_OK;
+}
+
 static int current_power_limits_show(struct seq_file *seq, void *unused)
 {
 	struct amd_pmf_dev *dev = seq->private;
@@ -372,6 +391,9 @@ static int amd_pmf_probe(struct platform_device *pdev)
 	apmf_install_handler(dev);
 	amd_pmf_dbgfs_register(dev);
 
+	dev->pwr_src_notifier.notifier_call = amd_pmf_pwr_src_notify_call;
+	power_supply_reg_notifier(&dev->pwr_src_notifier);
+
 	mutex_init(&dev->lock);
 	mutex_init(&dev->update_mutex);
 	dev_info(dev->dev, "registered PMF device successfully\n");
@@ -383,6 +405,7 @@ static int amd_pmf_remove(struct platform_device *pdev)
 {
 	struct amd_pmf_dev *dev = platform_get_drvdata(pdev);
 
+	power_supply_unreg_notifier(&dev->pwr_src_notifier);
 	mutex_destroy(&dev->lock);
 	mutex_destroy(&dev->update_mutex);
 	amd_pmf_deinit_features(dev);
diff --git a/drivers/platform/x86/amd/pmf/pmf.h b/drivers/platform/x86/amd/pmf/pmf.h
index b94e1a9030f8..06c30cdc0573 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -169,6 +169,7 @@ struct amd_pmf_dev {
 	struct mutex update_mutex; /* protects race between ACPI handler and metrics thread */
 	bool cnqf_enabled;
 	bool cnqf_supported;
+	struct notifier_block pwr_src_notifier;
 };
 
 struct apmf_sps_prop_granular {
-- 
2.39.0



