Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25F31E98F1;
	Thu, 30 Jan 2025 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247156; cv=none; b=Dh69OqZmno11/UP409hFUrJ8ieWlEVn42cTDgockrt+Vi1CTMMjwNpewwq7mDYtOvaYKVCjk+xxlG5E7jQavlN9Rk9aqOrTUwJls27IAIWjEdFqLgleH1uYeVzYXb8+IOTyYdDF21rRpB3R47Dt5UE7nVMpkgoZXzvkRzGn/yvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247156; c=relaxed/simple;
	bh=ar9bApVvHLTMr9/ngIDonaJPMbij4ploO4Tzl0kJ2Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZnT3SjjqNdpPxvhUGrMYAwArRGoaOO3PAr+5z/UFkV59Fktz/3LzFQa42UjjjkRo90Qy80wiDJ7ygPL7K/8IhgH3KjbggmbaKkv17DVy+xIcGAg1X9pzZHBetTlE6/EBY8uQg43h/igzQSCGZzA4+NRMf9PnXg927yfBQM9cKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+qakpaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+qakpaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F84C4CED2;
	Thu, 30 Jan 2025 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247156;
	bh=ar9bApVvHLTMr9/ngIDonaJPMbij4ploO4Tzl0kJ2Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+qakpaAdjY+b99G3C60m3oClSZ4PltzvSbryfW283TPGk4vuGcD7pAI5dQ1l3RGj
	 xaH5PcwufAxKMfwuNC475KRiVhTGsqXVuBX6pEMu/td3G/RodVCy+fdrTYJ7Rxr5gN
	 f7T1/MkmqivDOOkdym+13ZtJtYF58zN5IWLcg99I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <a.hajda@samsung.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/133] drm/mipi-dsi: Create devm device registration
Date: Thu, 30 Jan 2025 15:00:51 +0100
Message-ID: <20250130140145.015753362@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit a1419fb4a73e47f0eab2985dff594ed52397471b ]

Devices that take their data through the MIPI-DSI bus but are controlled
through a secondary bus like I2C have to register a secondary device on
the MIPI-DSI bus through the mipi_dsi_device_register_full() function.

At removal or when an error occurs, that device needs to be removed
through a call to mipi_dsi_device_unregister().

Let's create a device-managed variant of the registration function that
will automatically unregister the device at unbind.

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210910101218.1632297-4-maxime@cerno.tech
Stable-dep-of: 81adbd3ff21c ("drm: adv7511: Fix use-after-free in adv7533_attach_dsi()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dsi.c | 46 ++++++++++++++++++++++++++++++++++
 include/drm/drm_mipi_dsi.h     |  3 +++
 2 files changed, 49 insertions(+)

diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index 107a98484f50..e53a5b14b47b 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -246,6 +246,52 @@ void mipi_dsi_device_unregister(struct mipi_dsi_device *dsi)
 }
 EXPORT_SYMBOL(mipi_dsi_device_unregister);
 
+static void devm_mipi_dsi_device_unregister(void *arg)
+{
+	struct mipi_dsi_device *dsi = arg;
+
+	mipi_dsi_device_unregister(dsi);
+}
+
+/**
+ * devm_mipi_dsi_device_register_full - create a managed MIPI DSI device
+ * @dev: device to tie the MIPI-DSI device lifetime to
+ * @host: DSI host to which this device is connected
+ * @info: pointer to template containing DSI device information
+ *
+ * Create a MIPI DSI device by using the device information provided by
+ * mipi_dsi_device_info template
+ *
+ * This is the managed version of mipi_dsi_device_register_full() which
+ * automatically calls mipi_dsi_device_unregister() when @dev is
+ * unbound.
+ *
+ * Returns:
+ * A pointer to the newly created MIPI DSI device, or, a pointer encoded
+ * with an error
+ */
+struct mipi_dsi_device *
+devm_mipi_dsi_device_register_full(struct device *dev,
+				   struct mipi_dsi_host *host,
+				   const struct mipi_dsi_device_info *info)
+{
+	struct mipi_dsi_device *dsi;
+	int ret;
+
+	dsi = mipi_dsi_device_register_full(host, info);
+	if (IS_ERR(dsi))
+		return dsi;
+
+	ret = devm_add_action_or_reset(dev,
+				       devm_mipi_dsi_device_unregister,
+				       dsi);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return dsi;
+}
+EXPORT_SYMBOL_GPL(devm_mipi_dsi_device_register_full);
+
 static DEFINE_MUTEX(host_lock);
 static LIST_HEAD(host_list);
 
diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index 0dbed65c0ca5..af8ed48749eb 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -224,6 +224,9 @@ struct mipi_dsi_device *
 mipi_dsi_device_register_full(struct mipi_dsi_host *host,
 			      const struct mipi_dsi_device_info *info);
 void mipi_dsi_device_unregister(struct mipi_dsi_device *dsi);
+struct mipi_dsi_device *
+devm_mipi_dsi_device_register_full(struct device *dev, struct mipi_dsi_host *host,
+				   const struct mipi_dsi_device_info *info);
 struct mipi_dsi_device *of_find_mipi_dsi_device_by_node(struct device_node *np);
 int mipi_dsi_attach(struct mipi_dsi_device *dsi);
 int mipi_dsi_detach(struct mipi_dsi_device *dsi);
-- 
2.39.5



