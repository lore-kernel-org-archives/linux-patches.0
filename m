Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE3F2ED877;
	Tue, 15 Jul 2025 13:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587647; cv=none; b=mhXFHn5G4ttqK9KS9pg1RIwNYZgJD8/BUzjJbwxoLHaab3K087p8f5uPt+tlOFATcVxq/QegNXWZmmufPo06rJvGGZshVGHpRKBCqY0XAFGaRczXngdw7p97bKMhvVybXCwkc6T1FN9La6Pz9XxFe+P2wb4BZ9DZO9i4vclFAt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587647; c=relaxed/simple;
	bh=DCQZ7OeEK9b3EXRa0Z9WJ/nHMazp22ru5E51ZGyILWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWhYTRfjjTcNDnGK2/BAVWQLWP0tw3iSlW2Uiq6bCtw0xk4tSeZy/k0j2McVT3M0om6qhMNCNU2hMWdYflqi4uE9WM0ZGQLGMRCqIOu6ErtLCdiuJSHxf3xGwD/r3Uf8JHL864uUOzbTWD5eQnWXD/Y3MnKLPvg0IJ+cyzOcIAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3yG+4CY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3yG+4CY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0438DC4CEF7;
	Tue, 15 Jul 2025 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587647;
	bh=DCQZ7OeEK9b3EXRa0Z9WJ/nHMazp22ru5E51ZGyILWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3yG+4CYLo9tZviv8cedil/aD8VKyEzLyqPHoXa0Zvj7vLP8WZG2gPaRTCR47dhYf
	 XyOtKjTxn8ZNNDjD7ZqyQGp5VkSzdDoovlKnZ5ZAOD1KWOnHOTuMRtTn5qzXGPyzNW
	 SZImZdW1J1b0socbHdRXOW2ooSxKnHnnLopHb3WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 063/208] drm/tegra: Assign plane type before registration
Date: Tue, 15 Jul 2025 15:12:52 +0200
Message-ID: <20250715130813.475312721@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1134,10 +1134,16 @@ static struct drm_plane *tegra_dc_add_sh
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
 
@@ -1145,10 +1151,8 @@ static struct drm_plane *tegra_dc_add_sh
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
@@ -551,9 +551,9 @@ static const struct drm_plane_helper_fun
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


