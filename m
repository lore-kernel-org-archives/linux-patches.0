Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCCA2E49B2;
	Tue, 15 Jul 2025 13:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586393; cv=none; b=iB0uzZ3nSl9sxp0MJKR/0+Uc693YZeY460+WPLAGDozacCtsNYwLA3mCrYr6uYGTGPjvuXyoR0n4751FmigH8TvmPfi2PjjoZPBB9cs6/iirwzBPSkbwhaiW2BPW+qGBdRqhtTIbT/y1DMjwqRkBvmE90RNQj7RyjDO6vOogMqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586393; c=relaxed/simple;
	bh=9AD283jRlP3kS607I47+sy9TlTMNeCRTAChiBlCEeiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTV0DEcdFT9baF8E8vAztkQApjG9zxEAYKF3eOtkjXZVIKkSNNEps0m+5rMYJ5EP+7JM3GmwOgTuhpgfW2mxw9kqXSnNGlj+xQPNoOtxQ04SpE0sRAMwR9LgCXIBwcXpaBblXh8ptUgm43k3bB/afMoWuIxOpYDmzf16G5QR9Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5AquWh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5AquWh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F2BC4CEE3;
	Tue, 15 Jul 2025 13:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586393;
	bh=9AD283jRlP3kS607I47+sy9TlTMNeCRTAChiBlCEeiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5AquWh4g9EU/duJxVV7A83DQOHKn45pn0UT01ewl6oyf4aTknPBSQcCf9lBzCYrF
	 V+lEJLNB8iYnUHziDMsp2vvr6G6ic+rj1IjU5V8h5PVwjCSGWJNB6tWQ9CWX5exAfE
	 mLQZR6Z7fjC4Oen0XCCWBHwk5N8UuyD2vi37FD/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 049/148] drm/tegra: Assign plane type before registration
Date: Tue, 15 Jul 2025 15:12:51 +0200
Message-ID: <20250715130802.283492667@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

commit 9ff4fdf4f44b69237c0afc1d3a8dac916ce66f3e upstream.

Changes to a plane's type after it has been registered aren't propagated
to userspace automatically. This could possibly be achieved by updating
the property, but since we can already determine which type this should
be before the registration, passing in the right type from the start is
a much better solution.

Suggested-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: stable@vger.kernel.org
Fixes: 473079549f27 ("drm/tegra: dc: Add Tegra186 support")
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250421-tegra-drm-primary-v2-1-7f740c4c2121@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/dc.c  |   12 ++++++++----
 drivers/gpu/drm/tegra/hub.c |    4 ++--
 drivers/gpu/drm/tegra/hub.h |    3 ++-
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1103,10 +1103,16 @@ static struct drm_plane *tegra_dc_add_sh
 		if (wgrp->dc == dc->pipe) {
 			for (j = 0; j < wgrp->num_windows; j++) {
 				unsigned int index = wgrp->windows[j];
+				enum drm_plane_type type;
+
+				if (primary)
+					type = DRM_PLANE_TYPE_OVERLAY;
+				else
+					type = DRM_PLANE_TYPE_PRIMARY;
 
 				plane = tegra_shared_plane_create(drm, dc,
 								  wgrp->index,
-								  index);
+								  index, type);
 				if (IS_ERR(plane))
 					return plane;
 
@@ -1114,10 +1120,8 @@ static struct drm_plane *tegra_dc_add_sh
 				 * Choose the first shared plane owned by this
 				 * head as the primary plane.
 				 */
-				if (!primary) {
-					plane->type = DRM_PLANE_TYPE_PRIMARY;
+				if (!primary)
 					primary = plane;
-				}
 			}
 		}
 	}
--- a/drivers/gpu/drm/tegra/hub.c
+++ b/drivers/gpu/drm/tegra/hub.c
@@ -533,9 +533,9 @@ static const struct drm_plane_helper_fun
 struct drm_plane *tegra_shared_plane_create(struct drm_device *drm,
 					    struct tegra_dc *dc,
 					    unsigned int wgrp,
-					    unsigned int index)
+					    unsigned int index,
+					    enum drm_plane_type type)
 {
-	enum drm_plane_type type = DRM_PLANE_TYPE_OVERLAY;
 	struct tegra_drm *tegra = drm->dev_private;
 	struct tegra_display_hub *hub = tegra->hub;
 	/* planes can be assigned to arbitrary CRTCs */
--- a/drivers/gpu/drm/tegra/hub.h
+++ b/drivers/gpu/drm/tegra/hub.h
@@ -81,7 +81,8 @@ void tegra_display_hub_cleanup(struct te
 struct drm_plane *tegra_shared_plane_create(struct drm_device *drm,
 					    struct tegra_dc *dc,
 					    unsigned int wgrp,
-					    unsigned int index);
+					    unsigned int index,
+					    enum drm_plane_type type);
 
 int tegra_display_hub_atomic_check(struct drm_device *drm,
 				   struct drm_atomic_state *state);


