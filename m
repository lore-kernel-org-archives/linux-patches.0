Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C493BE165;
	Wed, 20 May 2026 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297166; cv=none; b=hW/KqvoE/u9gjY706KTxFoLhUnou+SF9rv5d9StcNJtYn4cNZvPDQKa/21bKJf48aF2zpFm+bOCPUF+QtUr3Y9/OISaEN3H8BYvyrw4CdxrP+cRl4lt9csSkkkvcQQfpRzVYmCz5wiQDX4nCAiev5n/OvoJf8REWMap8uHKDwmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297166; c=relaxed/simple;
	bh=inblWgbzYzxkuV0EOWEvqFx3B13aD8KM5+1uyYequLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMcZr+eZPO4ni/agUx10K28iNVKuDXGB1y8Kl4kiDWj0FNLhTVDuP1/+LDQIml6GeXxsEX5yDVuUXjiQ2DJvbKhV7+RuCHH2zcoPVrpXRVkZYsMG08in0tfufHFD0agORhksmtUYS6eCq+JamYpZv46KtN4uKSZaRDdezEq/1Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOeLudgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOeLudgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4E81F000E9;
	Wed, 20 May 2026 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297165;
	bh=wY7LznnS6Gr0+HXBi7yBCZECpag+xV+UIIvSbVKhmBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOeLudgfLUN5QHdC3s/HB+Yfa+Zg6bfzm3Y4+QuXSIcDidexTLAdxeoUuOTinsrus
	 d5YTrv48u6Tt0zvj1NJbQOdbVCIZMZtAW+XvAYLmxzv5uClzCDypSKqKXx4JfHOVPQ
	 MrrNaJ3jenFLV1CNFhVXirkzzkAgX7dabD+1xW2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 7.0 1074/1146] drm/bridge: imx8qxp-pxl2dpi: avoid ERR_PTR with device_node cleanup
Date: Wed, 20 May 2026 18:22:04 +0200
Message-ID: <20260520162212.537270960@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 53597deca0e38c30e6cd4ba2114fa42d2bcd85bb upstream.

imx8qxp_pxl2dpi_get_available_ep_from_port() returns ERR_PTR()
on errors. imx8qxp_pxl2dpi_find_next_bridge() stores its return
value in a __free(device_node) variable before checking IS_ERR().
When the function returns on the error path, the cleanup action calls
of_node_put() on the ERR_PTR() value.

Do not let a device_node cleanup variable hold error pointers. Change
imx8qxp_pxl2dpi_get_available_ep_from_port() to return an int and pass
the endpoint node through an output argument. Initialize the output
argument to NULL so callers hold either NULL on error paths or a valid
device_node pointer on successful path.

Fixes: ceea3f7806a10 ("drm/bridge: imx8qxp-pxl2dpi: simplify put of device_node pointers")
Cc: stable@vger.kernel.org
Reviewed-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260507100604.667731-1-lgs201920130244@gmail.com
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/imx/imx8qxp-pxl2dpi.c |   40 +++++++++++++++------------
 1 file changed, 23 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/bridge/imx/imx8qxp-pxl2dpi.c
+++ b/drivers/gpu/drm/bridge/imx/imx8qxp-pxl2dpi.c
@@ -222,52 +222,58 @@ static const struct drm_bridge_funcs imx
 			imx8qxp_pxl2dpi_bridge_atomic_get_output_bus_fmts,
 };
 
-static struct device_node *
+static int
 imx8qxp_pxl2dpi_get_available_ep_from_port(struct imx8qxp_pxl2dpi *p2d,
-					   u32 port_id)
+					   u32 port_id,
+					   struct device_node **ep)
 {
-	struct device_node *port, *ep;
+	struct device_node *port;
+	int ret = 0;
 	int ep_cnt;
 
+	*ep = NULL;
+
 	port = of_graph_get_port_by_id(p2d->dev->of_node, port_id);
 	if (!port) {
 		DRM_DEV_ERROR(p2d->dev, "failed to get port@%u\n", port_id);
-		return ERR_PTR(-ENODEV);
+		return -ENODEV;
 	}
 
 	ep_cnt = of_get_available_child_count(port);
 	if (ep_cnt == 0) {
 		DRM_DEV_ERROR(p2d->dev, "no available endpoints of port@%u\n",
 			      port_id);
-		ep = ERR_PTR(-ENODEV);
+		ret = -ENODEV;
 		goto out;
 	} else if (ep_cnt > 1) {
 		DRM_DEV_ERROR(p2d->dev,
 			      "invalid available endpoints of port@%u\n",
 			      port_id);
-		ep = ERR_PTR(-EINVAL);
+		ret = -EINVAL;
 		goto out;
 	}
 
-	ep = of_get_next_available_child(port, NULL);
-	if (!ep) {
+	*ep = of_get_next_available_child(port, NULL);
+	if (!*ep) {
 		DRM_DEV_ERROR(p2d->dev,
 			      "failed to get available endpoint of port@%u\n",
 			      port_id);
-		ep = ERR_PTR(-ENODEV);
+		ret = -ENODEV;
 		goto out;
 	}
 out:
 	of_node_put(port);
-	return ep;
+	return ret;
 }
 
 static int imx8qxp_pxl2dpi_find_next_bridge(struct imx8qxp_pxl2dpi *p2d)
 {
-	struct device_node *ep __free(device_node) =
-		imx8qxp_pxl2dpi_get_available_ep_from_port(p2d, 1);
-	if (IS_ERR(ep))
-		return PTR_ERR(ep);
+	struct device_node *ep __free(device_node) = NULL;
+	int ret;
+
+	ret = imx8qxp_pxl2dpi_get_available_ep_from_port(p2d, 1, &ep);
+	if (ret)
+		return ret;
 
 	struct device_node *remote __free(device_node) = of_graph_get_remote_port_parent(ep);
 	if (!remote || !of_device_is_available(remote)) {
@@ -291,9 +297,9 @@ static int imx8qxp_pxl2dpi_set_pixel_lin
 	struct of_endpoint endpoint;
 	int ret;
 
-	ep = imx8qxp_pxl2dpi_get_available_ep_from_port(p2d, 0);
-	if (IS_ERR(ep))
-		return PTR_ERR(ep);
+	ret = imx8qxp_pxl2dpi_get_available_ep_from_port(p2d, 0, &ep);
+	if (ret)
+		return ret;
 
 	ret = of_graph_parse_endpoint(ep, &endpoint);
 	if (ret) {


