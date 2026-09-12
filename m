Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560803BCD19;
	Sat, 12 Sep 2026 07:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196912; cv=none; b=Nh78koPuOyo3RZuIo65Yn6OlPstr5uyoSCB0NUFEYO6whrSeO57HLqFyOTdmX20loFt7i7gteCC8kxSfmDWhuaAsdOKJS6GjzCywzNBm+Uhr1Y0EODT+4/HtJOCSz/1zGWRMQp9egDyKBDEdSqqp30RKYsbbSFD3rVICTDw9rw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196912; c=relaxed/simple;
	bh=21kkgdLSn+HjqnLccYe5xu1PSNrk+1y8F8u29oUXUu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpr1uuRE4ZKermpXvSfUHc6WSJ7xXNGX/mt3Xm6mUnSSsDdahJm2CiAHlRa+Dpi1L6hlihwgFJ6jD60WQnSGn2fkj3mJnDr9wMMSLtNlPKC6cWmp98NiN4DbVQy0+bbNniSbMQQxRvufuuBzpgBt3ZDvxuVGm0R7HGuea2vb+WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Siql3Bqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Siql3Bqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF871F000FF;
	Sat, 12 Sep 2026 07:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196911;
	bh=Y+9unwXHmsdCLymILy8gU5y5iWWI55Qd8uUvTAXJleY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Siql3BqpfRTlfAP74Z0njOUP4tvVNnzspxQBGjiH6FkRAYIbiXfzzkLl9lJDJIozv
	 hAHclm1zLKB6CsajMMOGr9xdWFuAEUzJoBKRhHkWIJnp+lCMC111xHR6UOKmIWCS7B
	 vC74o12b11rrL7DfhHEdCMoU6SOGLnrKw2TOiw5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0045/1815] drm/rockchip: analogix_dp: Fix OF node reference leak via auto cleanup
Date: Sat, 12 Sep 2026 08:29:55 +0200
Message-ID: <20260912065650.078039127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit 87e060521371257ddbb77964b66e60d80afcc7b2 ]

Sashiko reported a reference leak in rockchip_dp_drm_encoder_enable(),
the of_get_child_by_name() function does not call of_node_put() in a
symmetrical way [1].

Fix the device node reference leak by using __free(device_node) to
automatically manage of_node_put() for all device nodes.

Fixes: 729f8eefdcad ("drm/rockchip: analogix_dp: Add support for RK3588")
Link: https://sashiko.dev/#/patchset/20260527024336.191433-1-damon.ding@rock-chips.com?part=5 #1
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260601065100.1103873-7-damon.ding@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
index d2af5eb29dbb5..b1ed25cefe5ed 100644
--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -8,6 +8,7 @@
  *         Jeff Chen <jeff.chen@rock-chips.com>
  */
 
+#include <linux/cleanup.h>
 #include <linux/component.h>
 #include <linux/mfd/syscon.h>
 #include <linux/of.h>
@@ -206,7 +207,6 @@ static void rockchip_dp_drm_encoder_enable(struct drm_encoder *encoder,
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *old_crtc_state;
 	struct of_endpoint endpoint;
-	struct device_node *remote_port, *remote_port_parent;
 	char name[32];
 	u32 port_id;
 	int ret;
@@ -230,18 +230,22 @@ static void rockchip_dp_drm_encoder_enable(struct drm_encoder *encoder,
 	if (ret < 0)
 		return;
 
-	remote_port_parent = of_graph_get_remote_port_parent(endpoint.local_node);
+	struct device_node *remote_port_parent __free(device_node) =
+		of_graph_get_remote_port_parent(endpoint.local_node);
 	if (remote_port_parent) {
-		if (of_get_child_by_name(remote_port_parent, "ports")) {
-			remote_port = of_graph_get_remote_port(endpoint.local_node);
+		struct device_node *ports __free(device_node) =
+			of_get_child_by_name(remote_port_parent, "ports");
+
+		if (ports) {
+			struct device_node *remote_port __free(device_node) =
+				of_graph_get_remote_port(endpoint.local_node);
+
 			of_property_read_u32(remote_port, "reg", &port_id);
-			of_node_put(remote_port);
 			sprintf(name, "%s vp%d", remote_port_parent->full_name, port_id);
 		} else {
 			sprintf(name, "%s %s",
 				remote_port_parent->full_name, endpoint.id ? "vopl" : "vopb");
 		}
-		of_node_put(remote_port_parent);
 
 		DRM_DEV_DEBUG(dp->dev, "vop %s output to dp\n", (ret) ? "LIT" : "BIG");
 	}
-- 
2.53.0



