Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FA73C76A0;
	Fri, 15 May 2026 16:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862643; cv=none; b=FGKIU9BZcqJsPtx5abBJde8vmwXQXV8pqjCXW2o+DFv8NV+IhnP/S6Pzs3JeGB87AuxDUcrgtCnMXcnTpmur6iE+J1X5jQvCGbBadEMnNPKR7VyZzHW6z3LeW22zKV9MXtL9iSCBYsX8oEds9pBOYpWJ36hqGUMejruxfTb0uFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862643; c=relaxed/simple;
	bh=+ZZGAd8xq5dJos/S8ljuweU88EvlFDAZzQDRg9v66W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c0kzK/P3Hjt4HVjJhQvflLW+Ra94SJ2UyG0C4YzudoqMLFGSnwtH8/scWdXsqHeWaNHl7+RqlMYb+yNnlRUovUtGBaXzpL8BUUtwvqM+0w3dMMi4rRxIDzoa7bvI+0cyGGx/5TXBwO5oxxk+HbnwJREyFRxtQs3Vns7DTWn4Mvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDBYh1fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDBYh1fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C28CC2BCB0;
	Fri, 15 May 2026 16:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862643;
	bh=+ZZGAd8xq5dJos/S8ljuweU88EvlFDAZzQDRg9v66W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDBYh1fhsbD4wFnRq3LDav49qPBqMeiB2UOMVGdVnOYF3eLpZ3wfxzrVbNa4BUeRB
	 pZgbngl1TywSrvnP01EsykQS8dMI2bIv5ZQeO3vyxXK0+qzqQ1JJJP/NdLmShPwLPT
	 4FZfPKDqlDGN29d2IBZ0eHlF/wSZvo/Liypwo23s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Ser <contact@emersion.fr>,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Daniel Stone <daniels@collabora.com>,
	Melissa Wen <mwen@igalia.com>,
	Sebastian Wick <sebastian.wick@redhat.com>,
	Uma Shankar <uma.shankar@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Subject: [PATCH 7.0 125/201] drm/colorop: Fix blob property reference tracking in state lifecycle
Date: Fri, 15 May 2026 17:49:03 +0200
Message-ID: <20260515154701.270677968@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit 235b333e2878d791cee09e1e72f44611a9400114 upstream.

The colorop state blob property handling had memory leaks during state
duplication, destruction, and reset operations. The implementation
failed to follow the established pattern from drm_crtc's handling of
DEGAMMA/GAMMA blob properties.

Issues fixed:
- drm_colorop_atomic_destroy_state() was freeing state memory without
  releasing the blob reference, causing a leak
- drm_colorop_reset() was directly freeing old state with kfree()
  instead of properly destroying it, leaking blob references
- drm_colorop_cleanup() had duplicate blob cleanup code

Changes:
- Add __drm_atomic_helper_colorop_destroy_state() helper to properly
  release blob references before freeing state memory
- Update drm_colorop_atomic_destroy_state() to call the helper
- Fix drm_colorop_reset() to use drm_colorop_atomic_destroy_state()
  for proper cleanup of old state
- Simplify drm_colorop_cleanup() to use the common destruction path

This matches the well-tested pattern used by drm_crtc since 2016 and
ensures proper reference counting throughout the state lifecycle.

Co-developed by Claude Sonnet 4.5.

Fixes: cfc27680ee20 ("drm/colorop: Introduce new drm_colorop mode object")
Cc: Simon Ser <contact@emersion.fr>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Daniel Stone <daniels@collabora.com>
Cc: Melissa Wen <mwen@igalia.com>
Cc: Sebastian Wick <sebastian.wick@redhat.com>
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Louis Chauvet <louis.chauvet@bootlin.com>
Cc: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Cc: <stable@vger.kernel.org> #v6.19+
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Link: https://patch.msgid.link/20260312204145.829714-1-harry.wentland@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_colorop.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/drm_colorop.c
+++ b/drivers/gpu/drm/drm_colorop.c
@@ -169,12 +169,8 @@ void drm_colorop_cleanup(struct drm_colo
 	list_del(&colorop->head);
 	config->num_colorop--;
 
-	if (colorop->state && colorop->state->data) {
-		drm_property_blob_put(colorop->state->data);
-		colorop->state->data = NULL;
-	}
-
-	kfree(colorop->state);
+	if (colorop->state)
+		drm_colorop_atomic_destroy_state(colorop, colorop->state);
 }
 EXPORT_SYMBOL(drm_colorop_cleanup);
 
@@ -458,9 +454,23 @@ drm_atomic_helper_colorop_duplicate_stat
 	return state;
 }
 
+/**
+ * __drm_atomic_helper_colorop_destroy_state - release colorop state
+ * @state: colorop state object to release
+ *
+ * Releases all resources stored in the colorop state without actually freeing
+ * the memory of the colorop state. This is useful for drivers that subclass the
+ * colorop state.
+ */
+static void __drm_atomic_helper_colorop_destroy_state(struct drm_colorop_state *state)
+{
+	drm_property_blob_put(state->data);
+}
+
 void drm_colorop_atomic_destroy_state(struct drm_colorop *colorop,
 				      struct drm_colorop_state *state)
 {
+	__drm_atomic_helper_colorop_destroy_state(state);
 	kfree(state);
 }
 
@@ -511,7 +521,9 @@ static void __drm_colorop_reset(struct d
 
 void drm_colorop_reset(struct drm_colorop *colorop)
 {
-	kfree(colorop->state);
+	if (colorop->state)
+		drm_colorop_atomic_destroy_state(colorop, colorop->state);
+
 	colorop->state = kzalloc_obj(*colorop->state);
 
 	if (colorop->state)


