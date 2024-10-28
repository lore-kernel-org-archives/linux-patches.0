Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3008837;
	Mon, 28 Oct 2024 06:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098377; cv=none; b=JseSHfDs8JiGX6BPNKDteN5k1ClFAqbTqEwVHaUtAc4OOOcsIbOoV6ekn/5YqTzXQel8hfXRVmzakTlfK8GDZas6fLoJAYAaQAOx655SBWWafO7ix8X6aG3NphDE7UfRUpInmbjGKuEq4nszEVnbqRfBZ0FsuurKh3nD0s+9oxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098377; c=relaxed/simple;
	bh=Y62o9pfJPSvZgrFzX7ECjpcUbZsHI68zBMODjN9x/Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pp8HxKHwd2Isv6KG906+uGtfVa9AsUNj43sJXyIpf6OARL70JaK2km4ogWjK5NcUGfWQKeQzt05t47ezXitBofylnVvnxMNFft5PC05amXhoOT2ltlfrBNKJ2XPX5bLSftwfFjX1Vf8NUQCSyLcxCcjGs7rMIMpl9DCZlwO/LgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snpL/4Ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snpL/4Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D830C4CEC3;
	Mon, 28 Oct 2024 06:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098376;
	bh=Y62o9pfJPSvZgrFzX7ECjpcUbZsHI68zBMODjN9x/Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snpL/4UlyYn0re+9i2ljbbon9CIb6+3XO5oyfZFpu2SWrjNgrYXbImuS1SkXCYFsz
	 7aw8kepXnZy95QCcdXao3ui6YMC1w1rGZUTMvGvB25K0/6GaNTbSU68XXOFfUIFDBv
	 O54OKK7M2pJR4Rj7VCHsqJshC0gNyDclXLo0uIN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 199/261] PCI/pwrctl: Abandon QCom WCN probe on pre-pwrseq device-trees
Date: Mon, 28 Oct 2024 07:25:41 +0100
Message-ID: <20241028062317.036492406@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ad783b9f8e78572fff3b04b6caee7bea3821eea8 ]

Old device trees for some platforms already define wifi nodes for the WCN
family of chips since before power sequencing was added upstream.

These nodes don't consume the regulator outputs from the PMU, and if we
allow this driver to bind to one of such "incomplete" nodes, we'll see a
kernel log error about the infinite probe deferral.

Extend the driver by adding a platform data struct matched against the
compatible. This struct contains the pwrseq target string as well as a
validation function called right after entering probe().

For Qualcomm WCN models, check the existence of the regulator supply
property that indicates the DT is already using power sequencing and return
-ENODEV if it's not there, indicating to the driver model that the device
should not be bound to the pwrctl driver.

Link: https://lore.kernel.org/r/20241007092447.18616-1-brgl@bgdev.pl
Fixes: 6140d185a43d ("PCI/pwrctl: Add a PCI power control driver for power sequenced devices")
Reported-by: Johan Hovold <johan@kernel.org>
Closes: https://lore.kernel.org/all/Zv565olMDDGHyYVt@hovoldconsulting.com/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctl/pci-pwrctl-pwrseq.c | 55 +++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pwrctl/pci-pwrctl-pwrseq.c b/drivers/pci/pwrctl/pci-pwrctl-pwrseq.c
index a23a4312574b9..0e6bd47671c2e 100644
--- a/drivers/pci/pwrctl/pci-pwrctl-pwrseq.c
+++ b/drivers/pci/pwrctl/pci-pwrctl-pwrseq.c
@@ -6,9 +6,9 @@
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
-#include <linux/of.h>
 #include <linux/pci-pwrctl.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 #include <linux/pwrseq/consumer.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -18,6 +18,40 @@ struct pci_pwrctl_pwrseq_data {
 	struct pwrseq_desc *pwrseq;
 };
 
+struct pci_pwrctl_pwrseq_pdata {
+	const char *target;
+	/*
+	 * Called before doing anything else to perform device-specific
+	 * verification between requesting the power sequencing handle.
+	 */
+	int (*validate_device)(struct device *dev);
+};
+
+static int pci_pwrctl_pwrseq_qcm_wcn_validate_device(struct device *dev)
+{
+	/*
+	 * Old device trees for some platforms already define wifi nodes for
+	 * the WCN family of chips since before power sequencing was added
+	 * upstream.
+	 *
+	 * These nodes don't consume the regulator outputs from the PMU, and
+	 * if we allow this driver to bind to one of such "incomplete" nodes,
+	 * we'll see a kernel log error about the indefinite probe deferral.
+	 *
+	 * Check the existence of the regulator supply that exists on all
+	 * WCN models before moving forward.
+	 */
+	if (!device_property_present(dev, "vddaon-supply"))
+		return -ENODEV;
+
+	return 0;
+}
+
+static const struct pci_pwrctl_pwrseq_pdata pci_pwrctl_pwrseq_qcom_wcn_pdata = {
+	.target = "wlan",
+	.validate_device = pci_pwrctl_pwrseq_qcm_wcn_validate_device,
+};
+
 static void devm_pci_pwrctl_pwrseq_power_off(void *data)
 {
 	struct pwrseq_desc *pwrseq = data;
@@ -27,15 +61,26 @@ static void devm_pci_pwrctl_pwrseq_power_off(void *data)
 
 static int pci_pwrctl_pwrseq_probe(struct platform_device *pdev)
 {
+	const struct pci_pwrctl_pwrseq_pdata *pdata;
 	struct pci_pwrctl_pwrseq_data *data;
 	struct device *dev = &pdev->dev;
 	int ret;
 
+	pdata = device_get_match_data(dev);
+	if (!pdata || !pdata->target)
+		return -EINVAL;
+
+	if (pdata->validate_device) {
+		ret = pdata->validate_device(dev);
+		if (ret)
+			return ret;
+	}
+
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->pwrseq = devm_pwrseq_get(dev, of_device_get_match_data(dev));
+	data->pwrseq = devm_pwrseq_get(dev, pdata->target);
 	if (IS_ERR(data->pwrseq))
 		return dev_err_probe(dev, PTR_ERR(data->pwrseq),
 				     "Failed to get the power sequencer\n");
@@ -64,17 +109,17 @@ static const struct of_device_id pci_pwrctl_pwrseq_of_match[] = {
 	{
 		/* ATH11K in QCA6390 package. */
 		.compatible = "pci17cb,1101",
-		.data = "wlan",
+		.data = &pci_pwrctl_pwrseq_qcom_wcn_pdata,
 	},
 	{
 		/* ATH11K in WCN6855 package. */
 		.compatible = "pci17cb,1103",
-		.data = "wlan",
+		.data = &pci_pwrctl_pwrseq_qcom_wcn_pdata,
 	},
 	{
 		/* ATH12K in WCN7850 package. */
 		.compatible = "pci17cb,1107",
-		.data = "wlan",
+		.data = &pci_pwrctl_pwrseq_qcom_wcn_pdata,
 	},
 	{ }
 };
-- 
2.43.0



