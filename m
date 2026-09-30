Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F203EEAE7;
	Wed, 30 Sep 2026 19:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796093; cv=none; b=FHd2QcZILwLHI8EpRJYwnqTcrt7EcTJRPUk46SUFbzxBQFzVT4i0DGWA2QkZnU19RNwucLpGD2E7tRD54n2lbHsQnnBhoYRcbGMFjM3fliGhyqQG4FAvPbPjb10+j7rrNxqSxjPZv1sEq5/Ks8j3qRaIbE336u1mqY+MlNoj2N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796093; c=relaxed/simple;
	bh=vlXAxyCxCYmwmMqOeNEUDaeyvj7UYApXa8i+/Yms18w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoRDh/OtA4wOHYllaQhjXOAcr+k9yIaeDDbQOvatX3nM3pWA5h0kslhBrOeubuxo8KHgc4zPCLhZxvSlNrjOh4uRekMT26bQAEDtPsDVjdiJIB56EmYBnXAspQ6/dGFM00/Vey373xIX8vJDVDK2HXQ40wzx3N5gvyS6WTo/u9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwWom8Zh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwWom8Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135641F000FF;
	Wed, 30 Sep 2026 19:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796091;
	bh=4tuFkljn8c/yDQeyeMGXRtJKE7E+JOueEoYIFzX/MMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwWom8Zh+dF7Km3a9dWPGg6tZaYiQF/9GKX4iF7OP/aecxm7FdDJAGxlsIqbPNLME
	 9CsshNt21B6qyHmM0+zo1MYxqggJpN4bjEgLE+vQybmA9LW3/ANI+YD+d1vAD+Zxsd
	 Am8eIaCxVE58BwbYqdWYR5v2IuhOZrCNuKZoLrmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0790/1193] drm/ast: Automatically clean up poll helper
Date: Wed, 30 Sep 2026 17:24:34 +0200
Message-ID: <20260930152451.797180979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 10021ef27310279c850cf6cb38542c443a995e92 ]

Automatically clean up the conncetor-poll thread as part of the DRM
device release. The new helper drmm_kms_helper_poll_init() provides
a shared implementation for all drivers.

v6:
- fix kernel doc comment (Sui, kernel test robot)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Acked-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Link: https://patchwork.freedesktop.org/patch/msgid/20240325200855.21150-14-tzimmermann@suse.de
Stable-dep-of: 073a30d75f30 ("drm/vc4: Use managed KMS polling to fix UAF on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_mode.c     |  4 +++-
 drivers/gpu/drm/drm_probe_helper.c | 27 +++++++++++++++++++++++++++
 include/drm/drm_probe_helper.h     |  2 ++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 27e660e92489f..8303d808ce175 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -1976,7 +1976,9 @@ int ast_mode_config_init(struct ast_device *ast)
 
 	drm_mode_config_reset(dev);
 
-	drm_kms_helper_poll_init(dev);
+	ret = drmm_kms_helper_poll_init(dev);
+	if (ret)
+		return ret;
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
index c90afb5d08987..543ea28c312be 100644
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -37,6 +37,7 @@
 #include <drm/drm_crtc.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_fourcc.h>
+#include <drm/drm_managed.h>
 #include <drm/drm_modeset_helper_vtables.h>
 #include <drm/drm_print.h>
 #include <drm/drm_probe_helper.h>
@@ -949,6 +950,32 @@ void drm_kms_helper_poll_fini(struct drm_device *dev)
 }
 EXPORT_SYMBOL(drm_kms_helper_poll_fini);
 
+static void drm_kms_helper_poll_init_release(struct drm_device *dev, void *res)
+{
+	drm_kms_helper_poll_fini(dev);
+}
+
+/**
+ * drmm_kms_helper_poll_init - initialize and enable output polling
+ * @dev: drm_device
+ *
+ * This function initializes and then also enables output polling support for
+ * @dev similar to drm_kms_helper_poll_init(). Polling will automatically be
+ * cleaned up when the DRM device goes away.
+ *
+ * See drm_kms_helper_poll_init() for more information.
+ *
+ * Returns:
+ * 0 on success, or a negative errno code otherwise.
+ */
+int drmm_kms_helper_poll_init(struct drm_device *dev)
+{
+	drm_kms_helper_poll_init(dev);
+
+	return drmm_add_action_or_reset(dev, drm_kms_helper_poll_init_release, dev);
+}
+EXPORT_SYMBOL(drmm_kms_helper_poll_init);
+
 static bool check_connector_changed(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
diff --git a/include/drm/drm_probe_helper.h b/include/drm/drm_probe_helper.h
index fad3c4003b2b5..7066a3eca93c5 100644
--- a/include/drm/drm_probe_helper.h
+++ b/include/drm/drm_probe_helper.h
@@ -16,6 +16,8 @@ int drm_helper_probe_single_connector_modes(struct drm_connector
 int drm_helper_probe_detect(struct drm_connector *connector,
 			    struct drm_modeset_acquire_ctx *ctx,
 			    bool force);
+
+int drmm_kms_helper_poll_init(struct drm_device *dev);
 void drm_kms_helper_poll_init(struct drm_device *dev);
 void drm_kms_helper_poll_fini(struct drm_device *dev);
 bool drm_helper_hpd_irq_event(struct drm_device *dev);
-- 
2.53.0



