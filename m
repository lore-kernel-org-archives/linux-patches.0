Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4423478C66;
	Mon, 15 Apr 2024 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191489; cv=none; b=LsVzgdfa2D+BU7lRElIDtJ01Po1tJ0jTzZYb9kNWsxrOdrHSn4RQADcFQuHT8Cyer3D0Jb314JT21zp9W4w5v5LRfQxICy2k7hKqaWeYylReK17Aebsryho800+8EVSilTK13+j6o8vqphsXQC1AXaoRN7qqFgrzOs47p4XCDkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191489; c=relaxed/simple;
	bh=NlM5fJIyjJcwPD1IzSG1q6SWBRFCYnKo+x+QAFcho2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSgFwQLTMdSauN5Rm9trOfby3vNKtRUPAM8R/BXdujdcZBmmnulC35lAljmeMeh9rnKX8c1FNmrhWGeDkRqM2MvK9YtML+P3nzTsTk6db5CaaqYyn+iKEJdGF0hL9++PNK2fTczCdPR2qmgYLuLsvSh0u+CzwbBm8qOBYvuZWyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bh0GZfsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bh0GZfsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1119C113CC;
	Mon, 15 Apr 2024 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191489;
	bh=NlM5fJIyjJcwPD1IzSG1q6SWBRFCYnKo+x+QAFcho2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bh0GZfscI26H17mqPLzIVrWWlcnDECug7V4djXIgXFHPo+QGBI8TixBRl+n07Ygsn
	 jRVI2KRC2OksV/M2r9iTzHeBFmS3PlSGENUdVuyj64F57lR1C4sfN+Di4ERRzxEIlC
	 E5q6/KbrDMpYvZO8USmYmX/IiFd8J4wupYGa8oX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 159/172] drm/i915/cdclk: Fix CDCLK programming order when pipes are active
Date: Mon, 15 Apr 2024 16:20:58 +0200
Message-ID: <20240415142005.186844209@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 7b1f6b5aaec0f849e19c3e99d4eea75876853cdd upstream.

Currently we always reprogram CDCLK from the
intel_set_cdclk_pre_plane_update() when using squash/crawl.
The code only works correctly for the cd2x update or full
modeset cases, and it was simply never updated to deal with
squash/crawl.

If the CDCLK frequency is increasing we must reprogram it
before we do anything else that might depend on the new
higher frequency, and conversely we must not decrease
the frequency until everything that might still depend
on the old higher frequency has been dealt with.

Since cdclk_state->pipe is only relevant when doing a cd2x
update we can't use it to determine the correct sequence
during squash/crawl. To that end introduce cdclk_state->disable_pipes
which simply indicates that we must perform the update
while the pipes are disable (ie. during
intel_set_cdclk_pre_plane_update()). Otherwise we use the
same old vs. new CDCLK frequency comparsiong as for cd2x
updates.

The only remaining problem case is when the voltage_level
needs to increase due to a DDI port, but the CDCLK frequency
is decreasing (and not all pipes are being disabled). The
current approach will not bump the voltage level up until
after the port has already been enabled, which is too late.
But we'll take care of that case separately.

v2: Don't break the "must disable pipes case"
v3: Keep the on stack 'pipe' for future use

Cc: stable@vger.kernel.org
Fixes: d62686ba3b54 ("drm/i915/adl_p: CDCLK crawl support for ADL")
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402155016.13733-2-ville.syrjala@linux.intel.com
(cherry picked from commit 3aecee90ac12a351905f12dda7643d5b0676d6ca)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c |    7 +++++--
 drivers/gpu/drm/i915/display/intel_cdclk.h |    3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -2521,7 +2521,7 @@ intel_set_cdclk_pre_plane_update(struct
 	if (IS_DG2(i915))
 		intel_cdclk_pcode_pre_notify(state);
 
-	if (pipe == INVALID_PIPE ||
+	if (new_cdclk_state->disable_pipes ||
 	    old_cdclk_state->actual.cdclk <= new_cdclk_state->actual.cdclk) {
 		drm_WARN_ON(&i915->drm, !new_cdclk_state->base.changed);
 
@@ -2553,7 +2553,7 @@ intel_set_cdclk_post_plane_update(struct
 	if (IS_DG2(i915))
 		intel_cdclk_pcode_post_notify(state);
 
-	if (pipe != INVALID_PIPE &&
+	if (!new_cdclk_state->disable_pipes &&
 	    old_cdclk_state->actual.cdclk > new_cdclk_state->actual.cdclk) {
 		drm_WARN_ON(&i915->drm, !new_cdclk_state->base.changed);
 
@@ -3036,6 +3036,7 @@ static struct intel_global_state *intel_
 		return NULL;
 
 	cdclk_state->pipe = INVALID_PIPE;
+	cdclk_state->disable_pipes = false;
 
 	return &cdclk_state->base;
 }
@@ -3214,6 +3215,8 @@ int intel_modeset_calc_cdclk(struct inte
 		if (ret)
 			return ret;
 
+		new_cdclk_state->disable_pipes = true;
+
 		drm_dbg_kms(&dev_priv->drm,
 			    "Modeset required for cdclk change\n");
 	}
--- a/drivers/gpu/drm/i915/display/intel_cdclk.h
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.h
@@ -51,6 +51,9 @@ struct intel_cdclk_state {
 
 	/* bitmask of active pipes */
 	u8 active_pipes;
+
+	/* update cdclk with pipes disabled */
+	bool disable_pipes;
 };
 
 int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state);


