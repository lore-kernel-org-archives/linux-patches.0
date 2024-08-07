Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549EF7E0E9;
	Wed,  7 Aug 2024 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043637; cv=none; b=seyj67YwmHb1hhYVAyIS7E2t4zncNGGJfgqGKGCJr60Wqnsx9sHDLg1QmDxv0XIWjhSE/woA/7G4KGIUK31+bH0D2RWGyrKmzce5zNtdj9WozQ1Q+eDTjtTPcBRpfSxnTCdsHd5Dn4F5Iom5LiMwAGSADHFeok986+Owsm1k45A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043637; c=relaxed/simple;
	bh=7kucE2R/RG5u67+9cvOKlLSO7Q9ljCYXQB7b9D/HtPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2MOZd5l7k2T5/fWItTwW4WG/WwSYl7GYBf+yIK0zz3/RyW1QLMjWidq5BSmPwcQ36Jo62rd4hwuSKiIkfjeTHmDCzLESwlkYgtOFQdBPt3++Mm9A8WIb0myAPEkEncoQvUmfjavZN2rbpDwj/byGd6GIZ9LuelIVi7UX/32Izo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gO25PDik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gO25PDik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D567BC4AF0E;
	Wed,  7 Aug 2024 15:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043637;
	bh=7kucE2R/RG5u67+9cvOKlLSO7Q9ljCYXQB7b9D/HtPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gO25PDikjJ1cvHQsaSUjd5lm9ZW1L3izM2c0UVsrb/bNt3UmwEFZ5ZqyoYG15fRe/
	 RVYKhJsVME7it435ioRJseJxv+WjeY/xEEBpCLs+VAgdu0uu2OOndk6SlJeFRQTRgY
	 2kkE/h4X3c6U0NG5+pYVZ18FK1b2a/2YzUUwV/2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/86] drm/vmwgfx: Trigger a modeset when the screen moves
Date: Wed,  7 Aug 2024 17:00:22 +0200
Message-ID: <20240807150040.653753928@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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
index 6dd33d1258d11..e98fde90f4e0c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
@@ -1015,6 +1015,32 @@ vmw_stdu_connector_mode_valid(struct drm_connector *connector,
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
@@ -1029,7 +1055,8 @@ static const struct drm_connector_funcs vmw_stdu_connector_funcs = {
 static const struct
 drm_connector_helper_funcs vmw_stdu_connector_helper_funcs = {
 	.get_modes = vmw_connector_get_modes,
-	.mode_valid = vmw_stdu_connector_mode_valid
+	.mode_valid = vmw_stdu_connector_mode_valid,
+	.atomic_check = vmw_stdu_connector_atomic_check,
 };
 
 
-- 
2.43.0



