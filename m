Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E382B1E7C25;
	Thu, 30 Jan 2025 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247067; cv=none; b=rXQ4X5UoK84UUJ5jTSB0Z9wAlg6EgJD/fNp3HaT/uGBHd7o/n4prCs4fepgTxko+ZLE8tAaQQkzBnYnc4/QRMudxRTIuXkigca4O4HWToBYY8OMpOKUu6AgpWEdVJz0l+9+6hOzUNYajEFxA9yr1HTKP9yl9t60lsdaQmEs2p08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247067; c=relaxed/simple;
	bh=PggC1I/mMTVKyrVKgKjf6qD/ACyOswhL3vW9yTra5Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avysYkxAM35n8wQV/37C1tGInDXdkqZzvle0mekBhdsflkm1/cWBAmLGhmqGxmGj33t3CIlmRW52D79wq+RcjYkDO8xbhjnYbCvyDBs5e94BH5YXHwOXCqJVdE51La+4rxC84LyauMDXrZB4lyYD0Pxa2hbIEm9vuCs6aajcoUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7rQ4Cbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7rQ4Cbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA82C4CED2;
	Thu, 30 Jan 2025 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247066;
	bh=PggC1I/mMTVKyrVKgKjf6qD/ACyOswhL3vW9yTra5Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7rQ4CbnTNpKnlaPoVwkfBvYU0GeZUxykJJA8iPh0wV5BF4HXkMMDEKT5vMMiL/kM
	 qn2gx6+CT98K2ew/9m7Dvzd8oe4iGjgOWG+WhxZaz9LNWfqy0OaTtQMt26l5VEts0B
	 W/WfTWIEUOXrOmBT9tv+U4oDxoWujQWtzrJQy8j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <a.hajda@samsung.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/133] drm/mipi-dsi: Create devm device attachment
Date: Thu, 30 Jan 2025 15:00:52 +0100
Message-ID: <20250130140145.053563613@linuxfoundation.org>
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

[ Upstream commit db6568498b35a4d5d5a99420df27ed25fae31406 ]

MIPI-DSI devices need to call mipi_dsi_attach() when their probe is done
to attach against their host.

However, at removal or when an error occurs, that attachment needs to be
undone through a call to mipi_dsi_detach().

Let's create a device-managed variant of the attachment function that
will automatically detach the device at unbind.

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20210910101218.1632297-5-maxime@cerno.tech
Stable-dep-of: 81adbd3ff21c ("drm: adv7511: Fix use-after-free in adv7533_attach_dsi()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_mipi_dsi.c | 35 ++++++++++++++++++++++++++++++++++
 include/drm/drm_mipi_dsi.h     |  1 +
 2 files changed, 36 insertions(+)

diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index e53a5b14b47b..468a3a7cb6a5 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -405,6 +405,41 @@ int mipi_dsi_detach(struct mipi_dsi_device *dsi)
 }
 EXPORT_SYMBOL(mipi_dsi_detach);
 
+static void devm_mipi_dsi_detach(void *arg)
+{
+	struct mipi_dsi_device *dsi = arg;
+
+	mipi_dsi_detach(dsi);
+}
+
+/**
+ * devm_mipi_dsi_attach - Attach a MIPI-DSI device to its DSI Host
+ * @dev: device to tie the MIPI-DSI device attachment lifetime to
+ * @dsi: DSI peripheral
+ *
+ * This is the managed version of mipi_dsi_attach() which automatically
+ * calls mipi_dsi_detach() when @dev is unbound.
+ *
+ * Returns:
+ * 0 on success, a negative error code on failure.
+ */
+int devm_mipi_dsi_attach(struct device *dev,
+			 struct mipi_dsi_device *dsi)
+{
+	int ret;
+
+	ret = mipi_dsi_attach(dsi);
+	if (ret)
+		return ret;
+
+	ret = devm_add_action_or_reset(dev, devm_mipi_dsi_detach, dsi);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_mipi_dsi_attach);
+
 static ssize_t mipi_dsi_device_transfer(struct mipi_dsi_device *dsi,
 					struct mipi_dsi_msg *msg)
 {
diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index af8ed48749eb..75995f3f2099 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -230,6 +230,7 @@ devm_mipi_dsi_device_register_full(struct device *dev, struct mipi_dsi_host *hos
 struct mipi_dsi_device *of_find_mipi_dsi_device_by_node(struct device_node *np);
 int mipi_dsi_attach(struct mipi_dsi_device *dsi);
 int mipi_dsi_detach(struct mipi_dsi_device *dsi);
+int devm_mipi_dsi_attach(struct device *dev, struct mipi_dsi_device *dsi);
 int mipi_dsi_shutdown_peripheral(struct mipi_dsi_device *dsi);
 int mipi_dsi_turn_on_peripheral(struct mipi_dsi_device *dsi);
 int mipi_dsi_set_maximum_return_packet_size(struct mipi_dsi_device *dsi,
-- 
2.39.5



