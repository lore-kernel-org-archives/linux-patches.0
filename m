Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7DB357A4A;
	Tue, 17 Mar 2026 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766262; cv=none; b=MGUTtytfzAOvrO8iHbd3wCLu0DEK+qrOv2xuRf/49K/HhW+cHtzQOrj+aYtxR+P57C7JofMQ8aw5I2MhAkSgOWSWYROm6+ufpeIUXouhx31kQjxeHvkHBxOlfVmy9IcaC2+mJHZ7CfwBvxkA7ApYmWz6+CaYoeJEPIMuZtiC1Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766262; c=relaxed/simple;
	bh=JSxME+bIy1ukHbuKdYqpX/bum6n8zskmYfYYIVIkMT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+xlptIsllsm5Em5/GjEgZ4xxNidGTm/f3qt3eyw64/yNv5PEBoO/KCpbv2FNIgiUYJqL1KjVBrUi5bcOYFV5IxLhgHE/I4WxgFOEd6ep+qvf71bN38rUB9m7MXyK0ncUOMuolHbxuH4BtY7SH+4Iwc+25+hrCK0atBRHZW1Nuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iasqaach; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iasqaach"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A12C4CEF7;
	Tue, 17 Mar 2026 16:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766262;
	bh=JSxME+bIy1ukHbuKdYqpX/bum6n8zskmYfYYIVIkMT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IasqaachwjKAMjGrirP+TsAJk3jCZLkm+PLQlG2rJ2vsdKEx/J2BxKzVj8bNm9tYc
	 3fBdV/FTcqI6ntPCeR6XMo+2EBp7NBOpCiy/nsj53VYFNdGFC47XeljqrSEJwM6jrM
	 oRDL4bkPXEtRaZIKeTwrGFLnrs7Cc0EBYGZcTDdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Marco Schirrmeister <mschirrmeister@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.19 198/378] mmc: dw_mmc-rockchip: Fix runtime PM support for internal phase support
Date: Tue, 17 Mar 2026 17:32:35 +0100
Message-ID: <20260317163014.287277395@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 6465a8bbb0f6ad98aeb66dc9ea19c32c193a610b upstream.

RK3576 is the first platform to introduce internal phase support, and
subsequent platforms are expected to adopt a similar design. In this
architecture, runtime suspend powers off the attached power domain, which
resets registers, including vendor-specific ones such as SDMMC_TIMING_CON0,
SDMMC_TIMING_CON1, and SDMMC_MISC_CON. These registers must be saved and
restored, a requirement that falls outside the scope of the dw_mmc core.

Fixes: 59903441f5e4 ("mmc: dw_mmc-rockchip: Add internal phase support")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Tested-by: Marco Schirrmeister <mschirrmeister@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc-rockchip.c |   38 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -36,6 +36,8 @@ struct dw_mci_rockchip_priv_data {
 	int			default_sample_phase;
 	int			num_phases;
 	bool			internal_phase;
+	int                     sample_phase;
+	int                     drv_phase;
 };
 
 /*
@@ -574,9 +576,43 @@ static void dw_mci_rockchip_remove(struc
 	dw_mci_pltfm_remove(pdev);
 }
 
+static int dw_mci_rockchip_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct dw_mci *host = platform_get_drvdata(pdev);
+	struct dw_mci_rockchip_priv_data *priv = host->priv;
+
+	if (priv->internal_phase) {
+		priv->sample_phase = rockchip_mmc_get_phase(host, true);
+		priv->drv_phase = rockchip_mmc_get_phase(host, false);
+	}
+
+	return dw_mci_runtime_suspend(dev);
+}
+
+static int dw_mci_rockchip_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct dw_mci *host = platform_get_drvdata(pdev);
+	struct dw_mci_rockchip_priv_data *priv = host->priv;
+	int ret;
+
+	ret = dw_mci_runtime_resume(dev);
+	if (ret)
+		return ret;
+
+	if (priv->internal_phase) {
+		rockchip_mmc_set_phase(host, true, priv->sample_phase);
+		rockchip_mmc_set_phase(host, false, priv->drv_phase);
+		mci_writel(host, MISC_CON, MEM_CLK_AUTOGATE_ENABLE);
+	}
+
+	return ret;
+}
+
 static const struct dev_pm_ops dw_mci_rockchip_dev_pm_ops = {
 	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
-	RUNTIME_PM_OPS(dw_mci_runtime_suspend, dw_mci_runtime_resume, NULL)
+	RUNTIME_PM_OPS(dw_mci_rockchip_runtime_suspend, dw_mci_rockchip_runtime_resume, NULL)
 };
 
 static struct platform_driver dw_mci_rockchip_pltfm_driver = {


