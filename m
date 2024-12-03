Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719AB1F7558;
	Tue,  3 Dec 2024 15:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238526; cv=none; b=c7b61sirRlWDB2f0GhanME+RCs0exjVVK8kNQN/VJC5pOtQexL1X8ESN5xeLuayJFkD+Q1dVNayUBA9nt3SGNljoIbUH+luEGjGcl5FeFck6gVbokLQTzshkZeQACoiOOAsRNYzgxCsUwQb+rU5Ls+WOeSpSLCVCUuDELJx/jTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238526; c=relaxed/simple;
	bh=bz4Smlbl3M6EV3uk21VckcizgiQ4jX0JE5Qw5kierhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJgKR1d7X67En0HyQI6mE+99jox5z70xNH7P/O2zfPAtlUdxrQh5gt1NmtIhfsVN+qV3fNjDRBxCDKoVRmDmvAcexWL0X7hKINhCGLDPN2aEeEOV7PkmdCdq22QmnWjwq+0sWTvki2/B+r12IPNpGoaNNJrSnhDANyT2SY389CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xP/BbXnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xP/BbXnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9692CC4CED6;
	Tue,  3 Dec 2024 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238526;
	bh=bz4Smlbl3M6EV3uk21VckcizgiQ4jX0JE5Qw5kierhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xP/BbXnYtwWK05oebaTaL61yWu0P/4PxOhoxjRg1m7+4HVGbOv0SiKRVODdQLda8r
	 js7XIQ+MURpufK0Vtfi0dZ4UbcbiqnDyoiNz8SsClNiARcjGS/kVU9loNy9IzFe2ab
	 gDpxLR6bPUf9GPrPE/HCsCvK4dfzVhAHc2jg1gfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 276/817] drm/bridge: tc358767: Fix link properties discovery
Date: Tue,  3 Dec 2024 15:37:28 +0100
Message-ID: <20241203144006.578981392@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 2d343723c7e1f9f6d64f721f07cfdfc2993758d1 ]

When a display controller driver uses DRM_BRIDGE_ATTACH_NO_CONNECTOR,
tc358767 will behave properly and skip the creation of the connector.

However, tc_get_display_props(), which is used to find out about the DP
monitor and link, is only called from two places: .atomic_enable() and
tc_connector_get_modes(). The latter is only used when tc358767 creates
its own connector, i.e. when DRM_BRIDGE_ATTACH_NO_CONNECTOR is _not_
set.

Thus, the driver never finds out the link properties before get_edid()
is called. With num_lanes of 0 and link_rate of 0 there are not many
valid modes...

Fix this by adding tc_get_display_props() call at the beginning of
get_edid(), so that we have up to date information before looking at the
modes.

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Closes: https://lore.kernel.org/all/24282420-b4dd-45b3-bb1c-fc37fe4a8205@siemens.com/
Fixes: de5e6c027ae6 ("drm/bridge: tc358767: add drm_panel_bridge support")
Reviewed-by: Aradhya Bhatia <a-bhatia1@ti.com>
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231108-tc358767-v2-2-25c5f70a2159@ideasonboard.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index b8b7a227addfb..c4cc7f90d112c 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1695,6 +1695,13 @@ static const struct drm_edid *tc_edid_read(struct drm_bridge *bridge,
 					   struct drm_connector *connector)
 {
 	struct tc_data *tc = bridge_to_tc(bridge);
+	int ret;
+
+	ret = tc_get_display_props(tc);
+	if (ret < 0) {
+		dev_err(tc->dev, "failed to read display props: %d\n", ret);
+		return 0;
+	}
 
 	return drm_edid_read_ddc(connector, &tc->aux.ddc);
 }
-- 
2.43.0



