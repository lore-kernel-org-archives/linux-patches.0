Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511FB33D6FD;
	Wed, 30 Sep 2026 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785868; cv=none; b=OrWgk7moQqRINWiEO9auugrREdVG46z+sw1doHekgHxUTIQbZcqE33gIt4XM8h2BklOxX0QG34yd2z5vN6GYmYp3zQY5yAjhLFEFI8qWAXF+uQt0wfzvvAAU59R2nuljn56dqgzDPCAKG0pgtdiN4lIWLH/OAdOfpcqUR9foK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785868; c=relaxed/simple;
	bh=tlDOGWFttC6uGRG6wSyb7XxwE79zW7O1KewlREc8l98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAzommjPQnh+ER0Gmn3kkw1CclU+MxAKRaluBX7PqtEGz4P2VWhvfD3eoYOSS9w3mCTSxN76qN1QJWwCX00kNfPO8Mr25cVulMTPHFKuFcCtRFePA1J0H1z3rwBbN098qSSgb9DHWNPrewt7Gj06jTwqq1uKhfekH0QMvyMTLLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1DIbp5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1DIbp5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE8A1F000FF;
	Wed, 30 Sep 2026 16:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785867;
	bh=2WkD8tu/GmY0pEI2V5NOtys9N73nbnQ7SbNkDR1imi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1DIbp5SlqR2lar+ROaGR5DFr3lDTRYdvqVVCzZqrHijP9nYuSpzsmgP+P6FI1WuB
	 rrDSy4vh7j2MS26IvuCSFHWHHSt/068o8LZ7+ybc9w0U2YbhA3bDVwPQIMvwKly1GK
	 yPP6ep5ZZ4srTuscAAkfCz6HVgFic2URgITnrjiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 660/982] drm/atomic-helper: Add atomic_enable plane-helper callback
Date: Wed, 30 Sep 2026 17:23:16 +0200
Message-ID: <20260930152430.940153762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 169b9182f192e8725c8de5d7d77f00f6ae6c7fd4 ]

Add atomic_enable to struct drm_plane_helper_funcs. It enables a
plane independently from updating the plane's content. As such, it is
the inverse of the atomic_disable plane helper. Useful for hardware
where plane enable state is independent from plane content.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230209154107.30680-2-tzimmermann@suse.de
Stable-dep-of: 073a30d75f30 ("drm/vc4: Use managed KMS polling to fix UAF on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_helper.c      | 20 ++++++++++++----
 include/drm/drm_atomic_helper.h          | 26 +++++++++++++++++++++
 include/drm/drm_modeset_helper_vtables.h | 29 +++++++++++++++++++++++-
 3 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index e737e45a3a702..9199695d42ddd 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -2743,6 +2743,11 @@ void drm_atomic_helper_commit_planes(struct drm_device *dev,
 			funcs->atomic_disable(plane, old_state);
 		} else if (new_plane_state->crtc || disabling) {
 			funcs->atomic_update(plane, old_state);
+
+			if (!disabling && funcs->atomic_enable) {
+				if (drm_atomic_plane_enabling(old_plane_state, new_plane_state))
+					funcs->atomic_enable(plane, old_state);
+			}
 		}
 	}
 
@@ -2803,6 +2808,7 @@ drm_atomic_helper_commit_planes_on_crtc(struct drm_crtc_state *old_crtc_state)
 		struct drm_plane_state *new_plane_state =
 			drm_atomic_get_new_plane_state(old_state, plane);
 		const struct drm_plane_helper_funcs *plane_funcs;
+		bool disabling;
 
 		plane_funcs = plane->helper_private;
 
@@ -2812,12 +2818,18 @@ drm_atomic_helper_commit_planes_on_crtc(struct drm_crtc_state *old_crtc_state)
 		WARN_ON(new_plane_state->crtc &&
 			new_plane_state->crtc != crtc);
 
-		if (drm_atomic_plane_disabling(old_plane_state, new_plane_state) &&
-		    plane_funcs->atomic_disable)
+		disabling = drm_atomic_plane_disabling(old_plane_state, new_plane_state);
+
+		if (disabling && plane_funcs->atomic_disable) {
 			plane_funcs->atomic_disable(plane, old_state);
-		else if (new_plane_state->crtc ||
-			 drm_atomic_plane_disabling(old_plane_state, new_plane_state))
+		} else if (new_plane_state->crtc || disabling) {
 			plane_funcs->atomic_update(plane, old_state);
+
+			if (!disabling && plane_funcs->atomic_enable) {
+				if (drm_atomic_plane_enabling(old_plane_state, new_plane_state))
+					plane_funcs->atomic_enable(plane, old_state);
+			}
+		}
 	}
 
 	if (crtc_funcs && crtc_funcs->atomic_flush)
diff --git a/include/drm/drm_atomic_helper.h b/include/drm/drm_atomic_helper.h
index 06d8902a80972..8fc53d249c690 100644
--- a/include/drm/drm_atomic_helper.h
+++ b/include/drm/drm_atomic_helper.h
@@ -210,6 +210,32 @@ int drm_atomic_helper_page_flip_target(
 			      __drm_atomic_get_current_plane_state((crtc_state)->state, \
 								   plane)))
 
+/**
+ * drm_atomic_plane_enabling - check whether a plane is being enabled
+ * @old_plane_state: old atomic plane state
+ * @new_plane_state: new atomic plane state
+ *
+ * Checks the atomic state of a plane to determine whether it's being enabled
+ * or not. This also WARNs if it detects an invalid state (both CRTC and FB
+ * need to either both be NULL or both be non-NULL).
+ *
+ * RETURNS:
+ * True if the plane is being enabled, false otherwise.
+ */
+static inline bool drm_atomic_plane_enabling(struct drm_plane_state *old_plane_state,
+					     struct drm_plane_state *new_plane_state)
+{
+	/*
+	 * When enabling a plane, CRTC and FB should always be set together.
+	 * Anything else should be considered a bug in the atomic core, so we
+	 * gently warn about it.
+	 */
+	WARN_ON((!new_plane_state->crtc && new_plane_state->fb) ||
+		(new_plane_state->crtc && !new_plane_state->fb));
+
+	return !old_plane_state->crtc && new_plane_state->crtc;
+}
+
 /**
  * drm_atomic_plane_disabling - check whether a plane is being disabled
  * @old_plane_state: old atomic plane state
diff --git a/include/drm/drm_modeset_helper_vtables.h b/include/drm/drm_modeset_helper_vtables.h
index 6f19cf5c210e5..f74745435894b 100644
--- a/include/drm/drm_modeset_helper_vtables.h
+++ b/include/drm/drm_modeset_helper_vtables.h
@@ -1267,6 +1267,32 @@ struct drm_plane_helper_funcs {
 	 */
 	void (*atomic_update)(struct drm_plane *plane,
 			      struct drm_atomic_state *state);
+
+	/**
+	 * @atomic_enable:
+	 *
+	 * Drivers should use this function to unconditionally enable a plane.
+	 * This hook is called in-between the &drm_crtc_helper_funcs.atomic_begin
+	 * and drm_crtc_helper_funcs.atomic_flush callbacks. It is called after
+	 * @atomic_update, which will be called for all enabled planes. Drivers
+	 * that use @atomic_enable should set up a plane in @atomic_update and
+	 * afterwards enable the plane in @atomic_enable. If a plane needs to be
+	 * enabled before installing the scanout buffer, drivers can still do
+	 * so in @atomic_update.
+	 *
+	 * Note that the power state of the display pipe when this function is
+	 * called depends upon the exact helpers and calling sequence the driver
+	 * has picked. See drm_atomic_helper_commit_planes() for a discussion of
+	 * the tradeoffs and variants of plane commit helpers.
+	 *
+	 * This callback is used by the atomic modeset helpers, but it is
+	 * optional. If implemented, @atomic_enable should be the inverse of
+	 * @atomic_disable. Drivers that don't want to use either can still
+	 * implement the complete plane update in @atomic_update.
+	 */
+	void (*atomic_enable)(struct drm_plane *plane,
+			      struct drm_atomic_state *state);
+
 	/**
 	 * @atomic_disable:
 	 *
@@ -1287,7 +1313,8 @@ struct drm_plane_helper_funcs {
 	 * the tradeoffs and variants of plane commit helpers.
 	 *
 	 * This callback is used by the atomic modeset helpers and by the
-	 * transitional plane helpers, but it is optional.
+	 * transitional plane helpers, but it is optional. It's intended to
+	 * reverse the effects of @atomic_enable.
 	 */
 	void (*atomic_disable)(struct drm_plane *plane,
 			       struct drm_atomic_state *state);
-- 
2.53.0



