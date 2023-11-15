Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECA2347D1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O56TygjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C837C3277B;
	Wed, 15 Nov 2023 20:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081327;
	bh=DCw2ub2qplKVRAcij5GgIg23ZKGw8CLoT9xxTYXvTHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O56TygjV67KGuNlrcs0xCjrshMSRcNmWw2T1M+vGKe/wYR2xub0ki+mOUVZV+UBCD
	 7Wumfp59TDCKsc86GUJm676wOpVEi15fO91PoQYCvG2odYxkDi6zDxRsECs/nBhclH
	 NnVq37g/mzx401qjwHz8zNrN+sJIkQFqvCw2hmsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <a.hajda@samsung.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/244] drm/mipi-dsi: Create devm device registration
Date: Wed, 15 Nov 2023 15:34:38 -0500
Message-ID: <20231115203553.520303417@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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
Stable-dep-of: 941882a0e96d ("drm/bridge: lt8912b: Fix bridge_detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dsi.c | 46 ++++++++++++++++++++++++++++++++++
 include/drm/drm_mipi_dsi.h     |  3 +++
 2 files changed, 49 insertions(+)

diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index 0c806e99e8690..bedbbfeab2a98 100644
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
index 1d263eb0b2e12..5105464052704 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -227,6 +227,9 @@ struct mipi_dsi_device *
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
2.42.0



