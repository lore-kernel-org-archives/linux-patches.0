Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5907D18027;
	Wed, 28 Jan 2026 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616121; cv=none; b=CjR1CAxpBXQ2LQU1VJ9XDmLOjyFGQCO0w9xuzP43tJGwh815kzFUagKTu13GLhB26MczWnAaARao3M8pdvTTgaakQYQTVGyRc9FPdlYpm/YsQESGO1H+cAqskPIvJOM24s4ie1BcHsTnKYl/npvVEtyzY8fU/No95IufstehOAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616121; c=relaxed/simple;
	bh=2ewflZ9ZXxnoSmizBldznpGKd3yTy07l23W7Y4bZGcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7klcILEGR38vwX+l16wZFq7u0Fu5TPgQTOEy6m6BdlnddSah5qK3hlkyTnDivbl4PuciQTs18dN8D+xDqtIkufqtdjN3Va6YvhSkeb954hU+ETgl7vE5TEgi+vQyS0xhcMbQvMs99fSzskhbINt48y89JIVrYapi3SFPjJJ1wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuHY3EgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuHY3EgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA9BC4CEF1;
	Wed, 28 Jan 2026 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616121;
	bh=2ewflZ9ZXxnoSmizBldznpGKd3yTy07l23W7Y4bZGcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuHY3EgZW8Pba0SVs5eQQ6ULAFzPFi9xw36z1fZjxgrB6DoKry/pHmuYonCq/G3wa
	 1dAjmc0WZ66jJ5SxZD5xueQX0S2hTAuCrZn/1/xX9SmA54Apz1ham37lmLb+bP7U75
	 Rx2aAAOog2xTnu2k2SmVvdqJe4IfaoIgP9vH5WxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.18 213/227] drm/bridge: synopsys: dw-dp: fix error paths of dw_dp_bind
Date: Wed, 28 Jan 2026 16:24:18 +0100
Message-ID: <20260128145352.099322698@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 1a0f69e3c28477b97d3609569b7e8feb4b6162e8 upstream.

Fix several issues in dw_dp_bind() error handling:

1. Missing return after drm_bridge_attach() failure - the function
   continued execution instead of returning an error.

2. Resource leak: drm_dp_aux_register() is not a devm function, so
   drm_dp_aux_unregister() must be called on all error paths after
   aux registration succeeds. This affects errors from:
   - drm_bridge_attach()
   - phy_init()
   - devm_add_action_or_reset()
   - platform_get_irq()
   - devm_request_threaded_irq()

3. Bug fix: platform_get_irq() returns the IRQ number or a negative
   error code, but the error path was returning ERR_PTR(ret) instead
   of ERR_PTR(dp->irq).

Use a goto label for cleanup to ensure consistent error handling.

Fixes: 86eecc3a9c2e ("drm/bridge: synopsys: Add DW DPTX Controller support library")
Cc: stable@vger.kernel.org

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Louis Chauvet <louis.chauvet@bootlin.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260102155553.13243-1-osama.abdelkader@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-dp.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/bridge/synopsys/dw-dp.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-dp.c
@@ -2060,33 +2060,41 @@ struct dw_dp *dw_dp_bind(struct device *
 	}
 
 	ret = drm_bridge_attach(encoder, bridge, NULL, DRM_BRIDGE_ATTACH_NO_CONNECTOR);
-	if (ret)
+	if (ret) {
 		dev_err_probe(dev, ret, "Failed to attach bridge\n");
+		goto unregister_aux;
+	}
 
 	dw_dp_init_hw(dp);
 
 	ret = phy_init(dp->phy);
 	if (ret) {
 		dev_err_probe(dev, ret, "phy init failed\n");
-		return ERR_PTR(ret);
+		goto unregister_aux;
 	}
 
 	ret = devm_add_action_or_reset(dev, dw_dp_phy_exit, dp);
 	if (ret)
-		return ERR_PTR(ret);
+		goto unregister_aux;
 
 	dp->irq = platform_get_irq(pdev, 0);
-	if (dp->irq < 0)
-		return ERR_PTR(ret);
+	if (dp->irq < 0) {
+		ret = dp->irq;
+		goto unregister_aux;
+	}
 
 	ret = devm_request_threaded_irq(dev, dp->irq, NULL, dw_dp_irq,
 					IRQF_ONESHOT, dev_name(dev), dp);
 	if (ret) {
 		dev_err_probe(dev, ret, "failed to request irq\n");
-		return ERR_PTR(ret);
+		goto unregister_aux;
 	}
 
 	return dp;
+
+unregister_aux:
+	drm_dp_aux_unregister(&dp->aux);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(dw_dp_bind);
 


