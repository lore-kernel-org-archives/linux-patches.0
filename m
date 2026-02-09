Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25921378D85;
	Mon,  9 Feb 2026 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647788; cv=none; b=VP/4oKN7VmSGx1m0ZiXhjXWOG2dXtJ3EL/TauBAUZBVfRS14ZFLo+wBMR0d/hYtlFmlG8f9sFTs5FI5vKDBWH6yVQjmMzyZiBFtjr/0v5QeqQIiqJ73W/RTLj8ENbWhzhR00vW7nO6kN5mlbhRQfY2el+7ZhxC4i9rYcNZdlj6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647788; c=relaxed/simple;
	bh=Lp1Lv6xrEGs/66LJGvqEmSWxCMHVhEIA95UfLpXAYTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmFF90+fioKXt20SSAWS6N29P9Dw36I2F2exvsxTtP6ZnJM+m/C3eiE4FLLRIyug5FDr1GLvIrOBKBlTUoB/4Sjd0uP4owgZS3o2vqxS5oXLGdhBVnTlNI8WbGeexPX4ssMd4eJZaJbdSFGVlbXfU5UmHn5qyX1jSpwmjunOTAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaBa5fhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaBa5fhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6BDC116C6;
	Mon,  9 Feb 2026 14:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647787;
	bh=Lp1Lv6xrEGs/66LJGvqEmSWxCMHVhEIA95UfLpXAYTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaBa5fhdXOlUv9GfMx5M+6dJJ4Ca4eDuAiRJ05QXlBfQWuAegXl/1w/F1RI2UuEuX
	 ZzDNFItR7QQQttKubqpqrTQSKa9S2LTzq45JcXmXG+IbAzB6yqKo2c7IpdP2sFZzMF
	 LdfgxWJRQsl/JqiL/mtO51ta/FxEDJBliON/kOzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.12 007/113] pmdomain: imx8mp-blk-ctrl: Keep gpc power domain on for system wakeup
Date: Mon,  9 Feb 2026 15:22:36 +0100
Message-ID: <20260209142310.473576716@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit e9ab2b83893dd03cf04d98faded81190e635233f upstream.

Current design will power off all dependent GPC power domains in
imx8mp_blk_ctrl_suspend(), even though the user device has enabled
wakeup capability. The result is that wakeup function never works
for such device.

An example will be USB wakeup on i.MX8MP. PHY device '382f0040.usb-phy'
is attached to power domain 'hsioblk-usb-phy2' which is spawned by hsio
block control. A virtual power domain device 'genpd:3:32f10000.blk-ctrl'
is created to build connection with 'hsioblk-usb-phy2' and it depends on
GPC power domain 'usb-otg2'. If device '382f0040.usb-phy' enable wakeup,
only power domain 'hsioblk-usb-phy2' keeps on during system suspend,
power domain 'usb-otg2' is off all the time. So the wakeup event can't
happen.

In order to further establish a connection between the power domains
related to GPC and block control during system suspend, register a genpd
power on/off notifier for the power_dev. This allows us to prevent the GPC
power domain from being powered off, in case the block control power
domain is kept on to serve system wakeup.

Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Fixes: 556f5cf9568a ("soc: imx: add i.MX8MP HSIO blk-ctrl")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
@@ -65,6 +65,7 @@ struct imx8mp_blk_ctrl_domain {
 	struct icc_bulk_data paths[DOMAIN_MAX_PATHS];
 	struct device *power_dev;
 	struct imx8mp_blk_ctrl *bc;
+	struct notifier_block power_nb;
 	int num_paths;
 	int id;
 };
@@ -594,6 +595,20 @@ static int imx8mp_blk_ctrl_power_off(str
 	return 0;
 }
 
+static int imx8mp_blk_ctrl_gpc_notifier(struct notifier_block *nb,
+					unsigned long action, void *data)
+{
+	struct imx8mp_blk_ctrl_domain *domain =
+			container_of(nb, struct imx8mp_blk_ctrl_domain, power_nb);
+
+	if (action == GENPD_NOTIFY_PRE_OFF) {
+		if (domain->genpd.status == GENPD_STATE_ON)
+			return NOTIFY_BAD;
+	}
+
+	return NOTIFY_OK;
+}
+
 static struct lock_class_key blk_ctrl_genpd_lock_class;
 
 static int imx8mp_blk_ctrl_probe(struct platform_device *pdev)
@@ -698,6 +713,14 @@ static int imx8mp_blk_ctrl_probe(struct
 			goto cleanup_pds;
 		}
 
+		domain->power_nb.notifier_call = imx8mp_blk_ctrl_gpc_notifier;
+		ret = dev_pm_genpd_add_notifier(domain->power_dev, &domain->power_nb);
+		if (ret) {
+			dev_err_probe(dev, ret, "failed to add power notifier\n");
+			dev_pm_domain_detach(domain->power_dev, true);
+			goto cleanup_pds;
+		}
+
 		domain->genpd.name = data->name;
 		domain->genpd.power_on = imx8mp_blk_ctrl_power_on;
 		domain->genpd.power_off = imx8mp_blk_ctrl_power_off;
@@ -707,6 +730,7 @@ static int imx8mp_blk_ctrl_probe(struct
 		ret = pm_genpd_init(&domain->genpd, NULL, true);
 		if (ret) {
 			dev_err_probe(dev, ret, "failed to init power domain\n");
+			dev_pm_genpd_remove_notifier(domain->power_dev);
 			dev_pm_domain_detach(domain->power_dev, true);
 			goto cleanup_pds;
 		}
@@ -755,6 +779,7 @@ cleanup_provider:
 cleanup_pds:
 	for (i--; i >= 0; i--) {
 		pm_genpd_remove(&bc->domains[i].genpd);
+		dev_pm_genpd_remove_notifier(bc->domains[i].power_dev);
 		dev_pm_domain_detach(bc->domains[i].power_dev, true);
 	}
 
@@ -774,6 +799,7 @@ static void imx8mp_blk_ctrl_remove(struc
 		struct imx8mp_blk_ctrl_domain *domain = &bc->domains[i];
 
 		pm_genpd_remove(&domain->genpd);
+		dev_pm_genpd_remove_notifier(domain->power_dev);
 		dev_pm_domain_detach(domain->power_dev, true);
 	}
 


