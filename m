Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02AA16F84F;
	Wed,  2 Oct 2024 13:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875784; cv=none; b=rbkaounEfWGVdKJ8TmmKcLNljOsI6XGf7PhSl749LZC3jL8iuPNxGRaVLKuEsMsXPHOm8ysyUa4ukuQF91szS7On17nh6jtk1aOHlmJsiN7vABxi+IY9wC1eClmPavCJ/3QHI/zwT0ht8i2ku1LgzY9dgghIA0r5vcT9s0mjP6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875784; c=relaxed/simple;
	bh=71R5oilGVpzuACevIIyf3CCLCdSM5im5f0qjvRpAVmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/SPZ2UY7VbWhDI54XJagNwtbX7ZYMx/QVXRihqq32u+fOosFdmdeBjWtv8ehxBZ39MSdaRIV9iypouv8Y9fMt9CPmUhFk6BZ5tjbBTwTbfx8emwGHicGtz9s2xDGqSVKOFKUsOuTCRZuJ15XJK4JAi4ppa+v3JbPqiU11A2nps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjCKnL4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjCKnL4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17996C4CEC5;
	Wed,  2 Oct 2024 13:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875783;
	bh=71R5oilGVpzuACevIIyf3CCLCdSM5im5f0qjvRpAVmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjCKnL4Zx80ue9Gyi1Q3dqpiGj5v7H5mwpti0E22c0ytnYSXrlRV0pCxtgNasnWcq
	 6IY8Pi7XHoB3YpeqppZHU3yixXjzhcnYoAdmqNVOntS98FI29dFirYGwHc+SKcSpYm
	 RSwJIQSLs2gHWNVgESKCQEl9IggBvT15fns3ZScs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 218/695] drm/vc4: hdmi: Handle error case of pm_runtime_resume_and_get
Date: Wed,  2 Oct 2024 14:53:36 +0200
Message-ID: <20241002125831.163407313@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit f1a54e860b1bc8d824925b5a77f510913880e8d6 ]

The commit 0f5251339eda ("drm/vc4: hdmi: Make sure the controller is
powered in detect") introduced the necessary power management handling
to avoid register access while controller is powered down.
Unfortunately it just print a warning if pm_runtime_resume_and_get()
fails and proceed anyway.

This could happen during suspend to idle. So we must assume it is unsafe
to access the HDMI register. So bail out properly.

Fixes: 0f5251339eda ("drm/vc4: hdmi: Make sure the controller is powered in detect")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240821214052.6800-3-wahrenst@gmx.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index d57c4a5948c89..cb424604484f1 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -429,6 +429,7 @@ static int vc4_hdmi_connector_detect_ctx(struct drm_connector *connector,
 {
 	struct vc4_hdmi *vc4_hdmi = connector_to_vc4_hdmi(connector);
 	enum drm_connector_status status = connector_status_disconnected;
+	int ret;
 
 	/*
 	 * NOTE: This function should really take vc4_hdmi->mutex, but
@@ -441,7 +442,12 @@ static int vc4_hdmi_connector_detect_ctx(struct drm_connector *connector,
 	 * the lock for now.
 	 */
 
-	WARN_ON(pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev));
+	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
+	if (ret) {
+		drm_err_once(connector->dev, "Failed to retain HDMI power domain: %d\n",
+			     ret);
+		return connector_status_unknown;
+	}
 
 	if (vc4_hdmi->hpd_gpio) {
 		if (gpiod_get_value_cansleep(vc4_hdmi->hpd_gpio))
-- 
2.43.0



