Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8650D78C67;
	Wed,  7 Aug 2024 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043418; cv=none; b=mLXDoXNIczU/CEqb4oJiH09VubUs2smXgBtCV/MjWfrChcGDCw537ncDikRDtJgUZ4IWB6x+ZoACZ40Od95sc95QK6coUdOmxBEu1lSYKygly0c8TtuTVu2vHjItvHjFsb7tjB6voZbMvuflTZvE3opA40ZDYk2TY4EqTu1R5EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043418; c=relaxed/simple;
	bh=ouSME/tbNZnVbFx3P4ldtnzoTdJL1ghkZgpEs4T+UpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yp3dh0XRAp6uzL8TIQ8U/Goq1nyXD56KEADZLd5nHTUl+I1BpWuYpFuRXzzlAHhKGbXYeH1Z3WWjFaBJq0fgtkGpxE8+FlCZqWYm6Um1AegQKjAM34rFpa/pGja6831sm5heJK+ugVHVPCoCU+zCvC1kxKYq4bVJE79p9VUfhZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wv2RRuW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wv2RRuW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1475AC32781;
	Wed,  7 Aug 2024 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043418;
	bh=ouSME/tbNZnVbFx3P4ldtnzoTdJL1ghkZgpEs4T+UpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wv2RRuW0vD4ij0rNpBf1RA3OUByqC9xEgz32eNJuz2VbccxJgAee4+d/nQhM4qe7k
	 UqtGGTtsfM70rQNRCS6q+g1N2EAnjCF5zRP7bvIqbKl8+O5XSdon6sS3k9u6qcKVVJ
	 OiM9x5dpehJ9cUOHifcO0qSe73YwAi033rw1RxIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/121] drm/vmwgfx: Trigger a modeset when the screen moves
Date: Wed,  7 Aug 2024 16:59:47 +0200
Message-ID: <20240807150021.211369966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 75c3e8a26a35d4f3eee299b3cc7e465f166f4e2d ]

When multi-monitor is cycled the X,Y position of the Screen Target will
likely change but the resolution will not. We need to trigger a modeset
when this occurs in order to recreate the Screen Target with the correct
X,Y position.

Fixes a bug where multiple displays are shown in a single scrollable
host window rather than in 2+ windows on separate host displays.

Fixes: 426826933109 ("drm/vmwgfx: Filter modes which exceed graphics memory")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240624205951.23343-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c | 29 +++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
index 4ccab07faff08..cb03c589ab226 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
@@ -868,6 +868,32 @@ vmw_stdu_connector_mode_valid(struct drm_connector *connector,
 	return MODE_OK;
 }
 
+/*
+ * Trigger a modeset if the X,Y position of the Screen Target changes.
+ * This is needed when multi-mon is cycled. The original Screen Target will have
+ * the same mode but its relative X,Y position in the topology will change.
+ */
+static int vmw_stdu_connector_atomic_check(struct drm_connector *conn,
+					   struct drm_atomic_state *state)
+{
+	struct drm_connector_state *conn_state;
+	struct vmw_screen_target_display_unit *du;
+	struct drm_crtc_state *new_crtc_state;
+
+	conn_state = drm_atomic_get_connector_state(state, conn);
+	du = vmw_connector_to_stdu(conn);
+
+	if (!conn_state->crtc)
+		return 0;
+
+	new_crtc_state = drm_atomic_get_new_crtc_state(state, conn_state->crtc);
+	if (du->base.gui_x != du->base.set_gui_x ||
+	    du->base.gui_y != du->base.set_gui_y)
+		new_crtc_state->mode_changed = true;
+
+	return 0;
+}
+
 static const struct drm_connector_funcs vmw_stdu_connector_funcs = {
 	.dpms = vmw_du_connector_dpms,
 	.detect = vmw_du_connector_detect,
@@ -882,7 +908,8 @@ static const struct drm_connector_funcs vmw_stdu_connector_funcs = {
 static const struct
 drm_connector_helper_funcs vmw_stdu_connector_helper_funcs = {
 	.get_modes = vmw_connector_get_modes,
-	.mode_valid = vmw_stdu_connector_mode_valid
+	.mode_valid = vmw_stdu_connector_mode_valid,
+	.atomic_check = vmw_stdu_connector_atomic_check,
 };
 
 
-- 
2.43.0



