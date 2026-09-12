Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724F62737FC;
	Sat, 12 Sep 2026 09:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205931; cv=none; b=alshl/mza8s/dJP9lLKUKhjmDvAfov2smXFnR5omlK5lVqRbIlFNPFTiV3lO7VYiFmjB6zOpcKF89dsGnz8hsa4flF40zTV+TpKa2Pvys9bAEGYqbSDSZ0vgFV1P7QxfOYzNZBLCBX8/l6MSzwQjYp6M3f7Nlkj7pA0JGODNHcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205931; c=relaxed/simple;
	bh=MORZd+SJxjjp/ZH0bPQppU2XYbRnJf4Fx23o0uaMXM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zm6fcZ7bzm5F5tJQLuJEfTj77sx6Ons1BbTTutxKuMfslmbNt4aGGH1OKuKaf26ICD3iX5QQaanf4Cwl7WIiYrPkttrG+44bzHKx4jHsP86Q3xbO9HHwgN6WdNNw1dxqongcBhFs1gxgLXIo+04OZa/EPfKv077T/Tq674Cv8DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4HSSNP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4HSSNP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2951F000FF;
	Sat, 12 Sep 2026 09:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205930;
	bh=aOVNv8gFy336/viXy+9V4Vil2hxhFHdUU4CO/mp8rGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4HSSNP68vlrJjb5FAW1C5B82er8K31puvW0Uv47emYUnMINqjwl6gBLLiOt+AGpJ
	 cA7rhipxs8WsVM3rp/mO5ZZd/PRYWdcM9QDHU0514DfOABwLP+hw+Mfea1cHZAvapo
	 W4oRhbGKiMeJDKQbDoM1SOUTMyWw43tKTJ1B1P9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0103/1518] drm/rockchip: analogix_dp: Fix OF node reference leak via auto cleanup
Date: Sat, 12 Sep 2026 08:37:52 +0200
Message-ID: <20260912065625.809217189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 33e9183837487..7100fcb1650aa 100644
--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -8,6 +8,7 @@
  *         Jeff Chen <jeff.chen@rock-chips.com>
  */
 
+#include <linux/cleanup.h>
 #include <linux/component.h>
 #include <linux/mfd/syscon.h>
 #include <linux/of.h>
@@ -223,7 +224,6 @@ static void rockchip_dp_drm_encoder_enable(struct drm_encoder *encoder,
 	struct drm_crtc *crtc;
 	struct drm_crtc_state *old_crtc_state;
 	struct of_endpoint endpoint;
-	struct device_node *remote_port, *remote_port_parent;
 	char name[32];
 	u32 port_id;
 	int ret;
@@ -247,18 +247,22 @@ static void rockchip_dp_drm_encoder_enable(struct drm_encoder *encoder,
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



