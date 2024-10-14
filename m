Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B851A4F20;
	Mon, 14 Oct 2024 14:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917735; cv=none; b=Z7AwcPAqf5FCKxfx4Wpb99rtXr14a4DS3m9QFhnaKfX22+yo4S8+08kKAw9WiaecI7/WhE4didZuetlji781qakjA+l+LavshHsdVNejBTCoJ5aOBn2f/reQujryyuTAuAk7f/ydOgwrvP0rgPPw9g5a9TxpP/NcAMsw2Yoa94I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917735; c=relaxed/simple;
	bh=crPq5QY2E9t+0/asrixfkzl6F4Tdc6zqNHVRZum0Alo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tmpETr+ayRAaTjmQwGHmbFKSikE9LhuEs8AUyHYOp3Mkw5Hc2CT8P0STLiREi67qExOEYcO/9wx+RFucBUqZ+SIkWnIF1alGuXiHQWcGN25CuBOg4Oh7pdGCgXZl+7S2w8YR+Fl+nWI68Li6sUskmJzoH2CF+KuuyA68TyKfwNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8pj48J6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8pj48J6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89737C4CEC3;
	Mon, 14 Oct 2024 14:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917734;
	bh=crPq5QY2E9t+0/asrixfkzl6F4Tdc6zqNHVRZum0Alo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8pj48J61Zfmoa+wxII0hR9l4nw8k2MSiZhX+G/e8SeL4aT0gkhe21T3r+t3WEnPI
	 k1KkUkw1VaiYfPAyu5LSVrewbkWFR1nM4cE5K8TxxmL2ziatI0r5Qa34CJ+UE4116Y
	 44e5gg9/tZmIH3/JqEu1VUDotlPMjb+G2VRYdzDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/798] drm/vc4: hdmi: Handle error case of pm_runtime_resume_and_get
Date: Mon, 14 Oct 2024 16:11:11 +0200
Message-ID: <20241014141222.519434195@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 072e2487b4655..971801acbde60 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -448,6 +448,7 @@ static int vc4_hdmi_connector_detect_ctx(struct drm_connector *connector,
 {
 	struct vc4_hdmi *vc4_hdmi = connector_to_vc4_hdmi(connector);
 	enum drm_connector_status status = connector_status_disconnected;
+	int ret;
 
 	/*
 	 * NOTE: This function should really take vc4_hdmi->mutex, but
@@ -460,7 +461,12 @@ static int vc4_hdmi_connector_detect_ctx(struct drm_connector *connector,
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



