Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99B51A680D;
	Mon, 23 Mar 2026 14:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275727; cv=none; b=K5xXTiiXtxA7AbXY2/dFDDKz6yXCrDRyVHIGctUw8JgwntC2xaHBCV079kWTrdYw6n10oVXtzmmH3HpOkXxruV09dd2NKIXSiNUPLvj8Nn8TzBKyMAR40HDKpqR3vZfE0LB7EbCk2p6AEoeP+rNQl6ugGLf2O78nedCU4jDT61Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275727; c=relaxed/simple;
	bh=jWcpChWD2YnUni3QLa1Ix0k55EVJg5+PIiELfp71ixo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpLe3rY4BQZBqrIYtR3NHNnBfMOi1O20AozxdaKybHDStB4eRO/3KGvk64bgqXRCFqV7K8rubzLKa5H3zT/+k3a7pm04xwI2PbmobiHfC4HQGi2aU5mIECkwJHF2IIrgL051EHT9bOuwUbsDLjQZDkfolEVwf+CvUS5gFfVy3ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHq5GE8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHq5GE8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A387C4CEF7;
	Mon, 23 Mar 2026 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275726;
	bh=jWcpChWD2YnUni3QLa1Ix0k55EVJg5+PIiELfp71ixo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHq5GE8zggbw3Q96yG/HesQVbaP9KQFIOVh2TJxnkh5bAAbzZPsqe1JccH3pH7NNQ
	 EuYdFpC6KEpXMkV4GBRVRokMCesLwXviUond3FRrz9wjbdFUK+hpxTTiDu6oA0Kma4
	 jHxyZcm/Qk4L1BHzJzAxuvkzFzZkQgk+XP5bpakY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.12 144/460] drm/bridge: ti-sn65dsi86: Enable HPD polling if IRQ is not used
Date: Mon, 23 Mar 2026 14:42:20 +0100
Message-ID: <20260323134530.122356084@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


