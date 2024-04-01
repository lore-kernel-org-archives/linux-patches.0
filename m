Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C4C48CDD;
	Mon,  1 Apr 2024 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991004; cv=none; b=dkmYp8N4PwZdm9DhOxhB8Br6KABXOtrhOca8HM9PGXeBLJ8fTdFBGAU0J2EUc5HVdQyBnC18ETgAkW5gr77fygdlSBPObAwi0UazMdjlkVQvJuIaYnIKjPQBLiJuag77Euvvf2wdjs0Ul+sx3MiBqvVCgLS14JL0AN2FzBjCSIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991004; c=relaxed/simple;
	bh=SGDaTKwYb2uN1xx1LdnKvWkdn7r2T0mOAsAoCNqt9mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eicRs6loZRGmm1XGcvydnlCdXzLhjVRUK84nQW5vnSgZ0NpVRgXnZFOo/uSdT4/ZArdETbC6HZN/PaKQfQZMx19EBPhf9+PkuapdGfkkT9p/pUq/QRelXYdtE8gEMsVXtvrSn0sFVgBBB/1pRA8++ZDFEKPq2JL1ZhYlBshWlcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chiWRSCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chiWRSCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB836C433F1;
	Mon,  1 Apr 2024 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991004;
	bh=SGDaTKwYb2uN1xx1LdnKvWkdn7r2T0mOAsAoCNqt9mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chiWRSCoe0Ivrkz4qJIoCnTG9n5a/ut8J1b8HfcCqVBjP91c0QIDGUOksbB+DH6Kl
	 4WUyg2qMxW34VB1BJK9DbbO8NVDdTqgwBuCYKeqPbHZkjamhm1M9IGbkVrjHU8/TL4
	 bBMA+E/m8LQiCKsB0aA3df8L3aOs6dT5OOov9+Fk=
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
Subject: [PATCH 6.1 116/272] drm/panel: do not return negative error codes from drm_panel_get_modes()
Date: Mon,  1 Apr 2024 17:45:06 +0200
Message-ID: <20240401152534.285738521@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f634371c717a8..7fd3de89ed079 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -207,19 +207,24 @@ EXPORT_SYMBOL(drm_panel_disable);
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



