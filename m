Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491E6285417;
	Mon, 23 Mar 2026 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282658; cv=none; b=BriHsf6XL8fWw7JPxxOME28+4iqXLNRoeEFIS50gAwSGzAeBBUXQiMxiWs9oZE9XPrUT/q9iBaPFeTMlOt0nGqy9y+VOs8sCs/mJISzajyfSSzJzK+s4fGr4cn6dC8/F2o+0ZqlXcdw1EqsNh2u8/ULN4rrYv+Xq2NPL4g4f1kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282658; c=relaxed/simple;
	bh=WwkL3o/iA0k7H0zb2ecsbuFlM6UvtVu2vDxqaw7aD9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5CIymkS7tTwCnMWySTSUNSNgFNPvzZPmzTSuyWBOuwapzP3vWxd7qAdbtGSO8OEgdGNJEP6Pqr+At2WwPexGv8ubNERQSQpHuAwgaxxKWVx7XF6z3mDHFkaQcqCtZ+CyCfVEvR0VEWEoGlm+4Iggche2IXaEY1GqMlNN/dYEuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gP/hnyzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gP/hnyzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F829C2BC9E;
	Mon, 23 Mar 2026 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282657;
	bh=WwkL3o/iA0k7H0zb2ecsbuFlM6UvtVu2vDxqaw7aD9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gP/hnyzJrhHMDIDVjet1l0QMVLwCZQSU1z42s+zVchWyldd/cS/jO1TsmkpoYsTbu
	 QxuR7iw2z30p6XHIAZI/+XU9ANcWfzFDZGXgZLM0V2JvepD5kieWhL4yqQiHsKAmgx
	 RXDS4vCza75x6C01NZEA9u4E498LeZaPusXdxDbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.1 231/481] drm/bridge: ti-sn65dsi86: Enable HPD polling if IRQ is not used
Date: Mon, 23 Mar 2026 14:43:33 +0100
Message-ID: <20260323134530.765481881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1307,6 +1307,7 @@ static int ti_sn_bridge_probe(struct aux
 {
 	struct ti_sn65dsi86 *pdata = dev_get_drvdata(adev->dev.parent);
 	struct device_node *np = pdata->dev->of_node;
+	const struct i2c_client *client = to_i2c_client(pdata->dev);
 	int ret;
 
 	pdata->next_bridge = devm_drm_of_get_bridge(&adev->dev, np, 1, 0);
@@ -1326,8 +1327,9 @@ static int ti_sn_bridge_probe(struct aux
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


