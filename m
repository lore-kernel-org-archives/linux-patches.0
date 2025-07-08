Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80752E6D14;
	Tue,  8 Jul 2025 16:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993981; cv=none; b=sMN9g1790OnVHG8/ZcJoyCsXTJcwDqiWHn78pPUp8LXQv7yrhVDwsMCEYWgaddIxORZ4UaLXZB8ZpmQLew4hQKQShDnaz76ZCtMMyFVjA8gxAeUpMY1XKg8QiFN6uExHXyS1hQKtoeGyTo0pEzvU3m7LItmSDm6WmvMtQ2zhKkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993981; c=relaxed/simple;
	bh=gPXPW+aOn2M/K1C0TY/arJd1gPb9TdmA2IBuzRh3Llk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYPZvyR3mXkT80W/otg90w9NawLC+CfOCCg783sPFSTMleXkWPlV20bBGkA7raHZhtlQ9KkM+c8y/FmjUYCXpU+8nqs1B4nhuw5gmGFneju9sSzMhRdee5qYfCweTRWX36GJkY5wAaqb/EJDLJaKb2XwLXSiOSakK8pEAznpz+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZEhRio9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZEhRio9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD869C4AF09;
	Tue,  8 Jul 2025 16:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993981;
	bh=gPXPW+aOn2M/K1C0TY/arJd1gPb9TdmA2IBuzRh3Llk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZEhRio9STXddenyWNNIhu5+/f3nRZn+5ix6TG0f0UgQU4ActjFAiO7TOJ1H/I6NG
	 wfmTAL82kHufen6F1RSOREY0KDvfu3mFYqipUk0lLW8RdeY/K5anY3a/PGUEf8ivb1
	 SLavaRCM/efprrsmkfbv4QTLlxwznTI6Lhp38e+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 5.15 085/160] drm/bridge: cdns-dsi: Fix connecting to next bridge
Date: Tue,  8 Jul 2025 18:22:02 +0200
Message-ID: <20250708162233.877952171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aradhya Bhatia <a-bhatia1@ti.com>

commit 688eb4d465484bc2a3471a6a6f06f833b58c7867 upstream.

Fix the OF node pointer passed to the of_drm_find_bridge() call to find
the next bridge in the display chain.

The code to find the next panel (and create its panel-bridge) works
fine, but to find the next (non-panel) bridge does not.

To find the next bridge in the pipeline, we need to pass "np" - the OF
node pointer of the next entity in the devicetree chain. Passing
"of_node" to of_drm_find_bridge (which is what the code does currently)
will fetch the bridge for the cdns-dsi which is not what's required.

Fix that.

Fixes: e19233955d9e ("drm/bridge: Add Cadence DSI driver")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Link: https://lore.kernel.org/r/20250329113925.68204-2-aradhya.bhatia@linux.dev
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/cdns-dsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -961,7 +961,7 @@ static int cdns_dsi_attach(struct mipi_d
 		bridge = drm_panel_bridge_add_typed(panel,
 						    DRM_MODE_CONNECTOR_DSI);
 	} else {
-		bridge = of_drm_find_bridge(dev->dev.of_node);
+		bridge = of_drm_find_bridge(np);
 		if (!bridge)
 			bridge = ERR_PTR(-EINVAL);
 	}


