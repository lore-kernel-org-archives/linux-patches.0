Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D0B214409;
	Tue, 12 Nov 2024 10:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408471; cv=none; b=i1nRdu854kH2tILcCBlRKSeTnZSpGWSmijngRv3V6hDYSoAIbqFExaXXtErTkrdjJFqMgDuWp9PndJs36ykPHrsXFL7gQOOJyvgithfkKOKCXuoDD4RW6jkvGFZUx6mVK/M7SDpfZkXyexveZgeXfpA+YqxeIt6+5DIAbMzhUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408471; c=relaxed/simple;
	bh=9pqvHWWlafom3Bf48IEzA1QgBliBEY0bSlb2Zo350rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNnMzCpvHZzasyxK7Kpc0O3qVck8Hfog8KnBpH18s2Qqzdx/EWbmyE3uVUyJnpG4feE1afNNyHi0mp8K+93Dm90WH2QXmguIIG1ciO4d3x2LY9uyFkkxT0O8Tou52nhbUwC9Sf6r7hxfyar1ys+zwfZBHBeMI4U08U+9pqBDTNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEpoYT3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEpoYT3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E1AC4CECD;
	Tue, 12 Nov 2024 10:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408470;
	bh=9pqvHWWlafom3Bf48IEzA1QgBliBEY0bSlb2Zo350rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEpoYT3oSDp2QKfEU3p07JdlOSkhPjmp5AQP6KRRGkPq/hfMu38/m8y3mpcai6kOU
	 KS0gflp8CzRW5EkRtmflZPVFbsDwEOiK6QzpTPB4SLpn15jcDAtiClsa5FvEv98EOs
	 At/2IrIbbxErfXMSiwX+w0CMF8xDlGUwDnOees04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 173/184] firmware: qcom: scm: Refactor code to support multiple dload mode
Date: Tue, 12 Nov 2024 11:22:11 +0100
Message-ID: <20241112101907.504225418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <quic_mojha@quicinc.com>

[ Upstream commit c802b0a2ed0f67fcec8cc0cac685c8fd0dd0aa6f ]

Currently on Qualcomm SoC, download_mode is enabled if
CONFIG_QCOM_SCM_DOWNLOAD_MODE_DEFAULT is selected or
passed a boolean value from command line.

Refactor the code such that it supports multiple download
modes and drop CONFIG_QCOM_SCM_DOWNLOAD_MODE_DEFAULT config
instead, give interface to set the download mode from
module parameter while being backword compatible at the
same time.

Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/20240715155655.1811178-1-quic_mojha@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: d67907154808 ("firmware: qcom: scm: suppress download mode error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/Kconfig    | 11 ------
 drivers/firmware/qcom/qcom_scm.c | 60 +++++++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 19 deletions(-)

diff --git a/drivers/firmware/qcom/Kconfig b/drivers/firmware/qcom/Kconfig
index 73a1a41bf92dd..b477d54b495a6 100644
--- a/drivers/firmware/qcom/Kconfig
+++ b/drivers/firmware/qcom/Kconfig
@@ -41,17 +41,6 @@ config QCOM_TZMEM_MODE_SHMBRIDGE
 
 endchoice
 
-config QCOM_SCM_DOWNLOAD_MODE_DEFAULT
-	bool "Qualcomm download mode enabled by default"
-	depends on QCOM_SCM
-	help
-	  A device with "download mode" enabled will upon an unexpected
-	  warm-restart enter a special debug mode that allows the user to
-	  "download" memory content over USB for offline postmortem analysis.
-	  The feature can be enabled/disabled on the kernel command line.
-
-	  Say Y here to enable "download mode" by default.
-
 config QCOM_QSEECOM
 	bool "Qualcomm QSEECOM interface driver"
 	depends on QCOM_SCM=y
diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 6436bd09587a5..26b0eb7d147db 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/interconnect.h>
 #include <linux/interrupt.h>
+#include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -32,8 +33,7 @@
 #include "qcom_scm.h"
 #include "qcom_tzmem.h"
 
-static bool download_mode = IS_ENABLED(CONFIG_QCOM_SCM_DOWNLOAD_MODE_DEFAULT);
-module_param(download_mode, bool, 0);
+static u32 download_mode;
 
 struct qcom_scm {
 	struct device *dev;
@@ -135,6 +135,11 @@ static const char * const qcom_scm_convention_names[] = {
 	[SMC_CONVENTION_LEGACY] = "smc legacy",
 };
 
+static const char * const download_mode_name[] = {
+	[QCOM_DLOAD_NODUMP]	= "off",
+	[QCOM_DLOAD_FULLDUMP]	= "full",
+};
+
 static struct qcom_scm *__scm;
 
 static int qcom_scm_clk_enable(void)
@@ -527,17 +532,16 @@ static int qcom_scm_io_rmw(phys_addr_t addr, unsigned int mask, unsigned int val
 	return qcom_scm_io_writel(addr, new);
 }
 
-static void qcom_scm_set_download_mode(bool enable)
+static void qcom_scm_set_download_mode(u32 dload_mode)
 {
-	u32 val = enable ? QCOM_DLOAD_FULLDUMP : QCOM_DLOAD_NODUMP;
 	int ret = 0;
 
 	if (__scm->dload_mode_addr) {
 		ret = qcom_scm_io_rmw(__scm->dload_mode_addr, QCOM_DLOAD_MASK,
-				      FIELD_PREP(QCOM_DLOAD_MASK, val));
+				      FIELD_PREP(QCOM_DLOAD_MASK, dload_mode));
 	} else if (__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_BOOT,
 						QCOM_SCM_BOOT_SET_DLOAD_MODE)) {
-		ret = __qcom_scm_set_dload_mode(__scm->dev, enable);
+		ret = __qcom_scm_set_dload_mode(__scm->dev, !!dload_mode);
 	} else {
 		dev_err(__scm->dev,
 			"No available mechanism for setting download mode\n");
@@ -1897,6 +1901,46 @@ static irqreturn_t qcom_scm_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static int get_download_mode(char *buffer, const struct kernel_param *kp)
+{
+	if (download_mode >= ARRAY_SIZE(download_mode_name))
+		return sysfs_emit(buffer, "unknown mode\n");
+
+	return sysfs_emit(buffer, "%s\n", download_mode_name[download_mode]);
+}
+
+static int set_download_mode(const char *val, const struct kernel_param *kp)
+{
+	bool tmp;
+	int ret;
+
+	ret = sysfs_match_string(download_mode_name, val);
+	if (ret < 0) {
+		ret = kstrtobool(val, &tmp);
+		if (ret < 0) {
+			pr_err("qcom_scm: err: %d\n", ret);
+			return ret;
+		}
+
+		ret = tmp ? 1 : 0;
+	}
+
+	download_mode = ret;
+	if (__scm)
+		qcom_scm_set_download_mode(download_mode);
+
+	return 0;
+}
+
+static const struct kernel_param_ops download_mode_param_ops = {
+	.get = get_download_mode,
+	.set = set_download_mode,
+};
+
+module_param_cb(download_mode, &download_mode_param_ops, NULL, 0644);
+MODULE_PARM_DESC(download_mode,
+		"download mode: off/0/N for no dump mode, full/on/1/Y for full dump mode");
+
 static int qcom_scm_probe(struct platform_device *pdev)
 {
 	struct qcom_tzmem_pool_config pool_config;
@@ -1961,7 +2005,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	__get_convention();
 
 	/*
-	 * If requested enable "download mode", from this point on warmboot
+	 * If "download mode" is requested, from this point on warmboot
 	 * will cause the boot stages to enter download mode, unless
 	 * disabled below by a clean shutdown/reboot.
 	 */
@@ -2012,7 +2056,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 static void qcom_scm_shutdown(struct platform_device *pdev)
 {
 	/* Clean shutdown, disable download mode to allow normal restart */
-	qcom_scm_set_download_mode(false);
+	qcom_scm_set_download_mode(QCOM_DLOAD_NODUMP);
 }
 
 static const struct of_device_id qcom_scm_dt_match[] = {
-- 
2.43.0



