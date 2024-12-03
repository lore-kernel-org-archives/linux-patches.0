Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3073B1DAC9F;
	Tue,  3 Dec 2024 15:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240932; cv=none; b=NoHOfzssQXlgTTToDU0YDgqJSeMLvoc6p6RnqjoMqE3d9IlLw1IfIDSdo/HCvUzW8yt71zSHPbqUeav7QwMcZQhfszEghUNRTu9Yw0zyDhcpMKmV4d8Bf422cyWisT/aOlxANiHiXQK+dNoeriiZ8ik0y3br2e8kF8U8sWYEit8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240932; c=relaxed/simple;
	bh=WHP5ugFvhtq3mxEKIeH4R+fJhYMqo0ucgtassGmMl9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZYrFmPNS+skP77HukZe97dx+HPCQh3WRX9DEy2LV4y9q1478Lx6Ik47p93mm+D3X8dTQn31oPGSdnFaOdsO1+uGrK4CQlCxeU2ee+w7/41Pgp1maLIGPsbXOm6EW6Oavm/kAr5rYS3EVIJzzNqlUlygGwkJqv2K7NkJGof3skk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqcnEBV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqcnEBV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC078C4CECF;
	Tue,  3 Dec 2024 15:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240932;
	bh=WHP5ugFvhtq3mxEKIeH4R+fJhYMqo0ucgtassGmMl9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqcnEBV1bmiuopi0ldePr0IqGbuzcSRoEk7kY8tcQYXeeAOfW0ghp3i2okuGe6w8r
	 /XMkowGlYSA3dBjqhZIV0FosjyrzXvAPk+yAfLjMq2ZJgTOjkJ/BrdbIitGKYTx29l
	 vKq6F/jArbBW+m7M4f0Pjvj1P2Hv+VMmMZy6HILw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/826] drm/bridge: tc358767: Fix link properties discovery
Date: Tue,  3 Dec 2024 15:39:34 +0100
Message-ID: <20241203144753.400663430@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f3afdab55c113..47189587643a1 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1714,6 +1714,13 @@ static const struct drm_edid *tc_edid_read(struct drm_bridge *bridge,
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



