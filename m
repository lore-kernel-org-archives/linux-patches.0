Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1FA1632E6;
	Thu, 12 Dec 2024 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023920; cv=none; b=tun4BJkS1CObdBI96a457Gnw0SOjoQbcH+u1ttaw7soYhbg6/99TdSH4+Iz7fcqRlkkhGJDXWUQsY6LushRGtEa6EAo7YSx6aUCZgKkSYZIKq+cFbmS6GVRbTrDW5UKPmcpZ7xsC/v1zU/O5seUd2+ovwDoKwDLlMQgw+rSevkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023920; c=relaxed/simple;
	bh=4itDBqr9klbgZDXWK9oo++ibrgHxSFMghwGWKoPpVZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uH9NiCYqovZJHy1yDtlXR95cYPgc+CZ+x+z++/ldLmd+fzVOEEozIfn+oeJ2OrZec5Z275sPBXHxpLlgv1Q9KsRUSoqV+/Pa2CHWprtQ3y+yVqiyouURUpj8N/Z+8xJ2JZ0LvmXzrY7iOTZCSOVHb2rNYoh/OSvK00qk8/QD3rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RKzcFbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RKzcFbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CE3C4CED0;
	Thu, 12 Dec 2024 17:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023920;
	bh=4itDBqr9klbgZDXWK9oo++ibrgHxSFMghwGWKoPpVZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RKzcFbvrPmiEr4DsBdKdmcB9VlTDKbn9ZSOlTrb/zFPhZrm8fB7qFsqX+uQmif62
	 XSNYoBteFVQwCbUKHEPGmul7Y+nfHSPbWLDHMqbJugnf/s8QF2vjxhXxZBqvxaM9DU
	 xkob7/1DIGoYjeNr+3w6g74md5eE0W2BWDj60bL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/459] drm/bridge: tc358767: Fix link properties discovery
Date: Thu, 12 Dec 2024 15:57:37 +0100
Message-ID: <20241212144258.210275143@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9c905634fec79..1c7dafb5dc088 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1319,6 +1319,13 @@ static struct edid *tc_get_edid(struct drm_bridge *bridge,
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
 
 	return drm_get_edid(connector, &tc->aux.ddc);
 }
-- 
2.43.0



