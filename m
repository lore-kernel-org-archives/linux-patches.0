Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC6434A783;
	Wed, 21 Jan 2026 18:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019958; cv=none; b=a4LC06C1AWQsdpUkuJpQ9KliM98CfzNcS0y91URAJPLlZ7q1QoyM94atuDqZcPZJxtDcwHSH1eJVteZ/Ro3k9MHuVv/QizC4jxABLui+INfTZpJ87owTge4BG6D16Lw46a2yQJP0jkLIKEB2eBeq+WyVpt+KWZyZAH22OsDQORM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019958; c=relaxed/simple;
	bh=C0a6jm9I+qsG2L38hOUeh4YNya09P5kHcsjV6ml3IEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx63NcSguQHfaf6O5HWnzNU9nbLXMUoqrnOQThkvPIH3X6jYN4UHc9nURPUDQh7wSouC8JjAymZO7jxTCmgesg0K3plwNhDlwZ6B9jwRKl6pl6GJPKsT6Blvrq1f9OoATLwtY67Lfkr1FYRzo0sqb0RdLLjk+4VX/OSxVTALvzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzft5SSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzft5SSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B2BC4CEF1;
	Wed, 21 Jan 2026 18:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019958;
	bh=C0a6jm9I+qsG2L38hOUeh4YNya09P5kHcsjV6ml3IEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzft5SSzw53epNEL1sLVfMa5LjxNFOeliMEBXOKp5gChOH0HJDWLlghWoSvlPoqy0
	 UsXOrqhtuf6JPDP0c0IQUVUtDEEByE5lQst1DpsE5vTPDtiwyIphSTCCJVF3x7GbCl
	 W+ylhSu9kmrGXrcgm6mQ1crEXFRIfgCVOcob6MAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/198] drm/bridge: dw-hdmi-qp: Fix spurious IRQ on resume
Date: Wed, 21 Jan 2026 19:14:06 +0100
Message-ID: <20260121181419.208187333@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 14adddc65340f2034751c95616861c0e888e2bb1 ]

After resume from suspend to RAM, the following splash is generated if
the HDMI driver is probed (independent of a connected cable):

[ 1194.484052] irq 80: nobody cared (try booting with the "irqpoll" option)
[ 1194.484074] CPU: 0 UID: 0 PID: 627 Comm: rtcwake Not tainted 6.17.0-rc7-g96f1a11414b3 #1 PREEMPT
[ 1194.484082] Hardware name: Rockchip RK3576 EVB V10 Board (DT)
[ 1194.484085] Call trace:
[ 1194.484087]  ... (stripped)
[ 1194.484283] handlers:
[ 1194.484285] [<00000000bc363dcb>] dw_hdmi_qp_main_hardirq [dw_hdmi_qp]
[ 1194.484302] Disabling IRQ #80

Apparently the HDMI IP is losing part of its state while the system
is suspended and generates spurious interrupts during resume. The
bug has not yet been noticed, as system suspend does not yet work
properly on upstream kernel with either the Rockchip RK3588 or RK3576
platform.

Fixes: 128a9bf8ace2 ("drm/rockchip: Add basic RK3588 HDMI output support")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20251014-rockchip-hdmi-suspend-fix-v1-1-983fcbf44839@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c   |  9 +++++++++
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c | 12 +++++++++++-
 include/drm/bridge/dw_hdmi_qp.h                |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c
index 39332c57f2c54..c85eb340e5a35 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-qp.c
@@ -143,6 +143,7 @@ struct dw_hdmi_qp {
 	} phy;
 
 	struct regmap *regm;
+	int main_irq;
 
 	unsigned long tmds_char_rate;
 };
@@ -1068,6 +1069,7 @@ struct dw_hdmi_qp *dw_hdmi_qp_bind(struct platform_device *pdev,
 
 	dw_hdmi_qp_init_hw(hdmi);
 
+	hdmi->main_irq = plat_data->main_irq;
 	ret = devm_request_threaded_irq(dev, plat_data->main_irq,
 					dw_hdmi_qp_main_hardirq, NULL,
 					IRQF_SHARED, dev_name(dev), hdmi);
@@ -1106,9 +1108,16 @@ struct dw_hdmi_qp *dw_hdmi_qp_bind(struct platform_device *pdev,
 }
 EXPORT_SYMBOL_GPL(dw_hdmi_qp_bind);
 
+void dw_hdmi_qp_suspend(struct device *dev, struct dw_hdmi_qp *hdmi)
+{
+	disable_irq(hdmi->main_irq);
+}
+EXPORT_SYMBOL_GPL(dw_hdmi_qp_suspend);
+
 void dw_hdmi_qp_resume(struct device *dev, struct dw_hdmi_qp *hdmi)
 {
 	dw_hdmi_qp_init_hw(hdmi);
+	enable_irq(hdmi->main_irq);
 }
 EXPORT_SYMBOL_GPL(dw_hdmi_qp_resume);
 
diff --git a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
index ed6e8f036f4b3..9ac45e7bc987a 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -597,6 +597,15 @@ static void dw_hdmi_qp_rockchip_remove(struct platform_device *pdev)
 	component_del(&pdev->dev, &dw_hdmi_qp_rockchip_ops);
 }
 
+static int __maybe_unused dw_hdmi_qp_rockchip_suspend(struct device *dev)
+{
+	struct rockchip_hdmi_qp *hdmi = dev_get_drvdata(dev);
+
+	dw_hdmi_qp_suspend(dev, hdmi->hdmi);
+
+	return 0;
+}
+
 static int __maybe_unused dw_hdmi_qp_rockchip_resume(struct device *dev)
 {
 	struct rockchip_hdmi_qp *hdmi = dev_get_drvdata(dev);
@@ -612,7 +621,8 @@ static int __maybe_unused dw_hdmi_qp_rockchip_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops dw_hdmi_qp_rockchip_pm = {
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, dw_hdmi_qp_rockchip_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(dw_hdmi_qp_rockchip_suspend,
+				dw_hdmi_qp_rockchip_resume)
 };
 
 struct platform_driver dw_hdmi_qp_rockchip_pltfm_driver = {
diff --git a/include/drm/bridge/dw_hdmi_qp.h b/include/drm/bridge/dw_hdmi_qp.h
index e9be6d507ad9c..8955450663e53 100644
--- a/include/drm/bridge/dw_hdmi_qp.h
+++ b/include/drm/bridge/dw_hdmi_qp.h
@@ -28,5 +28,6 @@ struct dw_hdmi_qp_plat_data {
 struct dw_hdmi_qp *dw_hdmi_qp_bind(struct platform_device *pdev,
 				   struct drm_encoder *encoder,
 				   const struct dw_hdmi_qp_plat_data *plat_data);
+void dw_hdmi_qp_suspend(struct device *dev, struct dw_hdmi_qp *hdmi);
 void dw_hdmi_qp_resume(struct device *dev, struct dw_hdmi_qp *hdmi);
 #endif /* __DW_HDMI_QP__ */
-- 
2.51.0



