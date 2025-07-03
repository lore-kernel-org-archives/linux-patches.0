Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B9A2EFD94;
	Thu,  3 Jul 2025 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554327; cv=none; b=u6b4p8Y3E2A1wn5R5Ihux/K/7GvCzBjx7Wp3SUb/uIEFs74RMtg/UtltxWUG+9rmnzvBOQW8hoh62xdJ1tFOK+LSB1kQiI+/ZBzfLBmyANcDQTaGXtFgFxR4aKu1bugQbM2F0MR2agm2QkCGpaOA1OSHJHnrbwkfoZcm4B5Ypdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554327; c=relaxed/simple;
	bh=jr32VKFARZiDUktzfKYJVQP2q/vMN6SgYDKLaEc2l9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss54YuePrLFVSBn0ZaPCJKLm96JrqpdBGH9NefyMY5EEO3bXkjk6zfq9FVRoCbZzZkIhrqAuCeKClGdScpoTmvqb+no6aTnwVgjQPUUqDAODEdUyw758XqSn17E5w06Mx0hZg/yOdUmonKSfqfmm18+dW8yHg+/8ohLYrANrfGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsmlBy3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsmlBy3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66039C4CEEE;
	Thu,  3 Jul 2025 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554326;
	bh=jr32VKFARZiDUktzfKYJVQP2q/vMN6SgYDKLaEc2l9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsmlBy3se0R+QFckDXAGPfz4xMUSpYpw1rBFr433gBWG+QEBWJQ0uziUgPgjWBl5C
	 GXrAAdW5NOK0KtPtFaUEL+rZ6daFNULzZN1KBdmL5/Jg6ebF8KEZA0wFD4QtO0CTfl
	 M18Zc12XtKMbn0tXSGWroKVmgZbfi4VfZAFNZvao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 151/218] drm/tegra: Assign plane type before registration
Date: Thu,  3 Jul 2025 16:41:39 +0200
Message-ID: <20250703144002.187412849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1320,10 +1320,16 @@ static struct drm_plane *tegra_dc_add_sh
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
 
@@ -1331,10 +1337,8 @@ static struct drm_plane *tegra_dc_add_sh
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
@@ -755,9 +755,9 @@ static const struct drm_plane_helper_fun
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
 	struct tegra_shared_plane *plane;
--- a/drivers/gpu/drm/tegra/hub.h
+++ b/drivers/gpu/drm/tegra/hub.h
@@ -80,7 +80,8 @@ void tegra_display_hub_cleanup(struct te
 struct drm_plane *tegra_shared_plane_create(struct drm_device *drm,
 					    struct tegra_dc *dc,
 					    unsigned int wgrp,
-					    unsigned int index);
+					    unsigned int index,
+					    enum drm_plane_type type);
 
 int tegra_display_hub_atomic_check(struct drm_device *drm,
 				   struct drm_atomic_state *state);


