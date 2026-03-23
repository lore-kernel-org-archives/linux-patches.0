Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06AC246BD5;
	Mon, 23 Mar 2026 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278446; cv=none; b=hqYS0xfLAKsDLCeHrCqw59NvEJqgD1oCwGy8HgiBS9Ern0ts8+XlasDaGE0DDuUQ3Tbr1vFSa/tHKzG/BzlLkr4etpl+xPkdaRGuW8fZ8+BTGPNl3dE3DDQtkNsuUKar1D8DKPSEyYiLSguTD2Ge5sFINI8xVg8xrDMkIC4O7AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278446; c=relaxed/simple;
	bh=DunqzimuA1lwS2hlZqw1qDLtOGcPleYqxrhOuTrqMfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=On+5WFzOGkqqSGQjNlps0LB6lIdzRCYQfvDeEgsAkeTZ/8e+dy7Um2Dp0CFxQsEVBUCYXAnhNgFPmNd8Xrg/W62qo2Gek9Gji7iJDtnXp5iH7GThHkPPvm7CHTiKmPti7HP9PwZ1Ddt+J+SI7nSBXtK2dC6lRrbKNSNrQ3tgNt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzfioIWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzfioIWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2FDC2BC9E;
	Mon, 23 Mar 2026 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278446;
	bh=DunqzimuA1lwS2hlZqw1qDLtOGcPleYqxrhOuTrqMfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzfioIWnaxxAVeBr+nO+j3gDmkrnnnYxYNrKlrE5+T2idJHGAJRuOYtPaDKxQ3GF5
	 jHKWvj7FnCPogwgE84beZCx75b4HwXxXG31zM4IApzPbaManmdbvsr856k4nslMX2F
	 koLqCL4iDO6EDVWIdzS5ScT8dEp0w1PVn39PoSvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.6 309/567] drm/bridge: ti-sn65dsi86: Enable HPD polling if IRQ is not used
Date: Mon, 23 Mar 2026 14:43:49 +0100
Message-ID: <20260323134541.469302569@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Franz Schnyder <franz.schnyder@toradex.com>

commit 0b87d51690dd5131cbe9fbd23746b037aab89815 upstream.

Fallback to polling to detect hotplug events on systems without
interrupts.

On systems where the interrupt line of the bridge is not connected,
the bridge cannot notify hotplug events. Only add the
DRM_BRIDGE_OP_HPD flag if an interrupt has been registered
otherwise remain in polling mode.

Fixes: 55e8ff842051 ("drm/bridge: ti-sn65dsi86: Add HPD for DisplayPort connector type")
Cc: stable@vger.kernel.org # 6.16: 9133bc3f0564: drm/bridge: ti-sn65dsi86: Add
Signed-off-by: Franz Schnyder <franz.schnyder@toradex.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
[dianders: Adjusted Fixes/stable line based on discussion]
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260206123758.374555-1-fra.schnyder@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -1326,6 +1326,7 @@ static int ti_sn_bridge_probe(struct aux
 {
 	struct ti_sn65dsi86 *pdata = dev_get_drvdata(adev->dev.parent);
 	struct device_node *np = pdata->dev->of_node;
+	const struct i2c_client *client = to_i2c_client(pdata->dev);
 	int ret;
 
 	pdata->next_bridge = devm_drm_of_get_bridge(&adev->dev, np, 1, 0);
@@ -1345,8 +1346,9 @@ static int ti_sn_bridge_probe(struct aux
 			   ? DRM_MODE_CONNECTOR_DisplayPort : DRM_MODE_CONNECTOR_eDP;
 
 	if (pdata->bridge.type == DRM_MODE_CONNECTOR_DisplayPort) {
-		pdata->bridge.ops = DRM_BRIDGE_OP_EDID | DRM_BRIDGE_OP_DETECT |
-				    DRM_BRIDGE_OP_HPD;
+		pdata->bridge.ops = DRM_BRIDGE_OP_EDID | DRM_BRIDGE_OP_DETECT;
+		if (client->irq)
+			pdata->bridge.ops |= DRM_BRIDGE_OP_HPD;
 		/*
 		 * If comms were already enabled they would have been enabled
 		 * with the wrong value of HPD_DISABLE. Update it now. Comms


