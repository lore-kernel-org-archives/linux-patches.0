Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7972EFD8E;
	Thu,  3 Jul 2025 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556212; cv=none; b=uS/7ixsGbtSP5QdsY66MU+LKXeqXjX7rL+tRp6yw1MpStxXw6u/QWjftIzIBiNcRmd1Ma39RFitqZQEHzsBbxUjnVYM6q9UWoh3BB5Qh39/jZNarxYbQULzZneJwqXUfrhQppRvDeezrIc+TClfZxSR13EdHVihTJDg3HbxPzj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556212; c=relaxed/simple;
	bh=fN1IkS37/yWBUrLrvZcBAAzdZohcWUDuyI57jAjwzGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLeMKLBcisYj4AAvTKHKIQEwoaYMmAq8MKl7Ove5mhdQTYnX+/uAG1x2vardrphH3OAxGwHMtcTX8806UyKQgl1xsHo9GJn55/SMM81xcOn31CsNoEFgDzWWqBSM9h5JWd4tvUEvYlPQRGwi9btdSYqplXOFroeRpiUUoiYMwF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZYjIt/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZYjIt/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E454AC4CEE3;
	Thu,  3 Jul 2025 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556212;
	bh=fN1IkS37/yWBUrLrvZcBAAzdZohcWUDuyI57jAjwzGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZYjIt/mlc4kpM02IAJ8zCLBT5j47WkfzORIC6sISWQmUJe8i44MTq+5q3MRkXP/p
	 b5mJY3/WivmrB+6+FiJ5tFH26YIUzQ9724inAY9/TcHsg3n/ISn1yD5WrMruG6TEB+
	 FDc5rHp+ML9aglvNyOgCUyoYpdWmyoE6PKU0tqao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.1 110/132] drm/bridge: cdns-dsi: Fix connecting to next bridge
Date: Thu,  3 Jul 2025 16:43:19 +0200
Message-ID: <20250703143943.710064562@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -992,7 +992,7 @@ static int cdns_dsi_attach(struct mipi_d
 		bridge = drm_panel_bridge_add_typed(panel,
 						    DRM_MODE_CONNECTOR_DSI);
 	} else {
-		bridge = of_drm_find_bridge(dev->dev.of_node);
+		bridge = of_drm_find_bridge(np);
 		if (!bridge)
 			bridge = ERR_PTR(-EINVAL);
 	}


