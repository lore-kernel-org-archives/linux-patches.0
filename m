Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437B019CC3D;
	Thu,  3 Jul 2025 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556209; cv=none; b=ixhHBxxczktrLG/aWNdaP2iwi4mwrlpV6klRdEuW9lOrR03cKnREXXrKsXeEK99rsWCHHqPc3UeR9gqm5sBDxfhx/oU1Cq5+BSeuMyf0pGwIybRbs0Yw0D02e8Xkd0aYIaxMx0JMoAZon9vC42p8vAcJFpFVOQZOyhyrFaG38Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556209; c=relaxed/simple;
	bh=VRu96w1hZQpjerGJ+VhFMx6bkrepEPDzIVcvIunB7Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGXqfdx099IWXVYySpX7iCyXc0boQMgwckcHd1ckbGm9gEVSMkwmbBk+IGZ2mA0pUQYEMo1nmcAmYPvMrEb9amVgVkx501+UPSx3joH9yVjwbl1OM4jVFOs7hoM8W8OeIXIOYkVqQHJmJqRJVRLkNQqF8mh5/5SxYuTY/4O9u7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbd/oHhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbd/oHhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F70AC4CEE3;
	Thu,  3 Jul 2025 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556209;
	bh=VRu96w1hZQpjerGJ+VhFMx6bkrepEPDzIVcvIunB7Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbd/oHhFwgjtqOj0RZEykFfcQsO1hZ+5SmYXSsq8BeIRreJdGt0Ly1Da7Qz/gip3d
	 HZ4PRcK96bLRhvZ5K+cfMxYIRV9R0DyMgvsirMztrgq2lHx5lrApXscKjUVLP01uCd
	 jb+aOwfiQm2ilcPlyrZV/ozBy/T7jRJRXwof1ZNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.1 109/132] drm/bridge: cdns-dsi: Fix phy de-init and flag it so
Date: Thu,  3 Jul 2025 16:43:18 +0200
Message-ID: <20250703143943.665586457@linuxfoundation.org>
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

commit fd2611c13f69cbbc6b81d9fc7502abf4f7031d21 upstream.

The driver code doesn't have a Phy de-initialization path as yet, and so
it does not clear the phy_initialized flag while suspending. This is a
problem because after resume the driver looks at this flag to determine
if a Phy re-initialization is required or not. It is in fact required
because the hardware is resuming from a suspend, but the driver does not
carry out any re-initialization causing the D-Phy to not work at all.

Call the counterparts of phy_init() and phy_power_on(), that are
phy_exit() and phy_power_off(), from _bridge_post_disable(), and clear
the flags so that the Phy can be initialized again when required.

Fixes: fced5a364dee ("drm/bridge: cdns: Convert to phy framework")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Link: https://lore.kernel.org/r/20250329113925.68204-3-aradhya.bhatia@linux.dev
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/cdns-dsi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -718,6 +718,11 @@ static void cdns_dsi_bridge_post_disable
 	struct cdns_dsi_input *input = bridge_to_cdns_dsi_input(bridge);
 	struct cdns_dsi *dsi = input_to_dsi(input);
 
+	dsi->phy_initialized = false;
+	dsi->link_initialized = false;
+	phy_power_off(dsi->dphy);
+	phy_exit(dsi->dphy);
+
 	pm_runtime_put(dsi->base.dev);
 }
 
@@ -1187,7 +1192,6 @@ static int __maybe_unused cdns_dsi_suspe
 	clk_disable_unprepare(dsi->dsi_sys_clk);
 	clk_disable_unprepare(dsi->dsi_p_clk);
 	reset_control_assert(dsi->dsi_p_rst);
-	dsi->link_initialized = false;
 	return 0;
 }
 


