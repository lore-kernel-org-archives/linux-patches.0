Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAB817552;
	Mon,  1 Apr 2024 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987098; cv=none; b=kKtwuYh/SzOiJ4ycCX0GKwPflY+ddIMTDJLb/sZ4Kv61ZEM7KnKV3EaEJxUjBOOJBMPMXJtsAS/3o9DQRJ5cOT3mcJtRG7AqjOaDikaQGNGAetmnkaOiBmee444MSJNDFVnGKnFCMU9tQAyG7vxx8SfogqlJ65KUO1dMqNRxjcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987098; c=relaxed/simple;
	bh=VMXdYOl0RJ4IjAjyJMAgUT3dA4a2SOCPYxivh8cc1Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLQlVdaPVD7J5/p933Q0t2AFCehbwxRBggYdqqyS2lDvPK5i8QBvDci/MHp+XTmO1MRzfyMCMlx+LrF7WDp7v/Yepf4ofJJwEyuXm2zf1omqtodEE6C8p6kipyB6hXB75vXteD/qkEoRIjO+MFrSN/mi9DU2VL4YoMxLdJMl2bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJGppWzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJGppWzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AD9C433C7;
	Mon,  1 Apr 2024 15:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987098;
	bh=VMXdYOl0RJ4IjAjyJMAgUT3dA4a2SOCPYxivh8cc1Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJGppWzSMTUO7VDVd8UAdCyHUbp+dqZNF0TNeK0IOyCoMqp57nuhTdqGp/W2UEEYi
	 5B0hSH5ACe8BaFxQ3ElJR1IAO9Tkk6RfMvMYxB+N7C6/MKF7eVwUaPxb6ktrqpcdeP
	 6Y6wUYGET3vHUBOCvhYlrRZJXpfbLWcitPWBvvKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 166/399] drm/panel: do not return negative error codes from drm_panel_get_modes()
Date: Mon,  1 Apr 2024 17:42:12 +0200
Message-ID: <20240401152554.135176506@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit fc4e97726530241d96dd7db72eb65979217422c9 ]

None of the callers of drm_panel_get_modes() expect it to return
negative error codes. Either they propagate the return value in their
struct drm_connector_helper_funcs .get_modes() hook (which is also not
supposed to return negative codes), or add it to other counts leading to
bogus values.

On the other hand, many of the struct drm_panel_funcs .get_modes() hooks
do return negative error codes, so handle them gracefully instead of
propagating further.

Return 0 for no modes, whatever the reason.

Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Jessica Zhang <quic_jesszhan@quicinc.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: stable@vger.kernel.org
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/79f559b72d8c493940417304e222a4b04dfa19c4.1709913674.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index e814020bbcd3b..cfbe020de54e0 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -274,19 +274,24 @@ EXPORT_SYMBOL(drm_panel_disable);
  * The modes probed from the panel are automatically added to the connector
  * that the panel is attached to.
  *
- * Return: The number of modes available from the panel on success or a
- * negative error code on failure.
+ * Return: The number of modes available from the panel on success, or 0 on
+ * failure (no modes).
  */
 int drm_panel_get_modes(struct drm_panel *panel,
 			struct drm_connector *connector)
 {
 	if (!panel)
-		return -EINVAL;
+		return 0;
 
-	if (panel->funcs && panel->funcs->get_modes)
-		return panel->funcs->get_modes(panel, connector);
+	if (panel->funcs && panel->funcs->get_modes) {
+		int num;
 
-	return -EOPNOTSUPP;
+		num = panel->funcs->get_modes(panel, connector);
+		if (num > 0)
+			return num;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(drm_panel_get_modes);
 
-- 
2.43.0



