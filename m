Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A564392C27;
	Sat, 17 Oct 2026 16:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256027; cv=none; b=khjtFyt0xbCTcdByld9psV/N4fvRYlAnDXDqTTVkbs/p6MV2F9LCIgnpriHkSKKjCwwGOmE3S0X0cuApKNGAJGkO+XeXf8n7KxTxdmqAdUstXTkfxrbcjUNXa7CpU9HO4t9lJfr6L8223P7Kf0+3dB+OSBZVFW4wLN2aRklI/Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256027; c=relaxed/simple;
	bh=+hMYn/U5hk30/AY6PhpzzUsCIU3yw6QrOk7ZclxCtfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spOxV47OMGYtdAgu3aXo1P6pBG1Tu63527WFO3y9KqJDIRKcbw229UQKDIkfn0JCG4I0EII/Ygoq4Tfz4LscKDbjpmjy080Xj3pMLuaK5MQMCkD0NmT9b6j4AVTSX1pIxJeC//HCInRqNsuRBdhNyyqy94RHlk+anPT33jeeA0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESS+0Urm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESS+0Urm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3D81F000C4;
	Sat, 17 Oct 2026 16:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256025;
	bh=GDFp0m1bEzn/cu6e0K5EfVfZHcTwSEUWaQyIDgPU51k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESS+0Urm9ya4UFAfpv0Thgah7OjVDetfz94XmrTmuIeVwlKvpU6+OeIbquvR/Y11f
	 Q8lrag4GNmV35ewJXjh2L4NxhjpYp9nsJpCQA/5MYEW5evpMhWE3DhRBC2Sn1BkZX3
	 tkGKEK9d1K2f/YlRbCPKANvZUs/hQobrVpbb5TTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Rayyan Ansari <rayyan@ansari.sh>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0099/1674] drm/sysfb: simpledrm: Improve panel-size validation
Date: Sat, 17 Oct 2026 17:39:31 +0200
Message-ID: <20261017160433.684893101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit 3a75a0761914d01c7362adf1f906cc1d1762c189 ]

Validate the panel size from the device-tree node against the
limitations of struct drm_display_mode. The type only stores sizes
in 16-bit fields. Fail transparently on errors; do not warn.

v3:
- move comments to a more prominent place (Thierry)
v2:
- only use initialized values in debugging output (Sashiko)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 2a6d731a8f16 ("drm/simpledrm: Allow physical width and height configuration via panel node")
Cc: Rayyan Ansari <rayyan@ansari.sh>
Cc: <stable@vger.kernel.org> # v6.4+
Link: https://patch.msgid.link/20260625094509.157581-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/simpledrm.c | 49 ++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index 30676b1073034..2abe80eec793b 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -210,6 +210,39 @@ simplefb_get_memory_of(struct drm_device *dev, struct device_node *of_node)
 	return res;
 }
 
+static int __simplefb_get_panel_size_mm_of(struct drm_device *dev,
+					   struct device_node *of_panel_node,
+					   const char *name)
+{
+	int ret;
+	u32 value;
+
+	ret = of_property_read_u32(of_panel_node, name, &value);
+	if (ret) {
+		drm_dbg(dev, "simplefb: cannot parse panel %s: error %d\n",
+			name, ret);
+		return ret;
+	} else if (value > U16_MAX) {
+		drm_dbg(dev, "simplefb: panel %s of %u exceeds maximum value\n",
+			name, value);
+		return -EINVAL;
+	}
+
+	return value;
+}
+
+static int simplefb_get_panel_width_mm_of(struct drm_device *dev,
+					  struct device_node *of_panel_node)
+{
+	return __simplefb_get_panel_size_mm_of(dev, of_panel_node, "width-mm");
+}
+
+static int simplefb_get_panel_height_mm_of(struct drm_device *dev,
+					   struct device_node *of_panel_node)
+{
+	return __simplefb_get_panel_size_mm_of(dev, of_panel_node, "height-mm");
+}
+
 /*
  * Simple Framebuffer device
  */
@@ -625,7 +658,7 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 	struct simpledrm_device *sdev;
 	struct drm_device *dev;
 	int width, height, stride;
-	int width_mm = 0, height_mm = 0;
+	u16 width_mm = 0, height_mm = 0;
 	struct device_node *panel_node;
 	const struct drm_format_info *format;
 	struct resource *res, *mem = NULL;
@@ -685,8 +718,18 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 			return ERR_CAST(mem);
 		panel_node = of_parse_phandle(of_node, "panel", 0);
 		if (panel_node) {
-			simplefb_read_u32_of(dev, panel_node, "width-mm", &width_mm);
-			simplefb_read_u32_of(dev, panel_node, "height-mm", &height_mm);
+			/*
+			 * Ignore errors from parsing the physical panel
+			 * size. Using the pre-initialized sizes of 0 will
+			 * make drm_sysfb_mode() calculate a default physical
+			 * size based on a resolution of 96 dpi.
+			 */
+			ret = simplefb_get_panel_width_mm_of(dev, panel_node);
+			if (ret > 0)
+				width_mm = ret;
+			ret = simplefb_get_panel_height_mm_of(dev, panel_node);
+			if (ret > 0)
+				height_mm = ret;
 			of_node_put(panel_node);
 		}
 	} else {
-- 
2.53.0



