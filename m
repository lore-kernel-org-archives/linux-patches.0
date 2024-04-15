Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA767602A;
	Mon, 15 Apr 2024 14:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192095; cv=none; b=HJaGFfj1tZxUEtopiKFVFqnwJCaAHKUstIB5nO3M8SKxBAwhW5QTpT9SZK2R/iiSyWEu7VsiO+QOJZW4Mo7cvfHlpH5kivtcgZbQeqdp0hmF3ZdUhTprOnFyFYo6prM3Tk0FIpOgRsKAH1KpNblt+TA22nxtl3daofDgnc1TavI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192095; c=relaxed/simple;
	bh=Z7gmBT6XI4gSUpeVDj5c9idbV2GoNQp6a557ToM9gZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cGMmSj+XrUHZ9eIc7SiC+WgFKhIBtg7Fw07Hckn6D/NQvB67RPGJQz7oiRRKXw+/sd71JYYR7l7khjKu5jpDHgmQVStU3nc78hWgNLD9dh64Wcuk8mWJMVHXfEq6p6l9VHT7bf0cC5k+8o4wIz01ItjJvczSl8p7lDbD5RcPVIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jABNCqAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jABNCqAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B9DC113CC;
	Mon, 15 Apr 2024 14:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192095;
	bh=Z7gmBT6XI4gSUpeVDj5c9idbV2GoNQp6a557ToM9gZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jABNCqAnIa/2pcO0RNwnJGkqlyNtZKwckPxx521mFCcMPYJ51PuS3RRFeeQMcQtt6
	 txMdv+WXzmx8yeXaKPBo5TQC/+Zm6Ab5d7b9Nw+hK9w6vb5YRJnSqLjNcYnJk/SPIB
	 hZFisM83GZfTCvCtNImnNkQwkh76k079Di75XP28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 65/69] drm/i915/cdclk: Fix CDCLK programming order when pipes are active
Date: Mon, 15 Apr 2024 16:21:36 +0200
Message-ID: <20240415141948.127938011@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2152,7 +2152,7 @@ intel_set_cdclk_pre_plane_update(struct
 				 &new_cdclk_state->actual))
 		return;
 
-	if (pipe == INVALID_PIPE ||
+	if (new_cdclk_state->disable_pipes ||
 	    old_cdclk_state->actual.cdclk <= new_cdclk_state->actual.cdclk) {
 		drm_WARN_ON(&dev_priv->drm, !new_cdclk_state->base.changed);
 
@@ -2181,7 +2181,7 @@ intel_set_cdclk_post_plane_update(struct
 				 &new_cdclk_state->actual))
 		return;
 
-	if (pipe != INVALID_PIPE &&
+	if (!new_cdclk_state->disable_pipes &&
 	    old_cdclk_state->actual.cdclk > new_cdclk_state->actual.cdclk) {
 		drm_WARN_ON(&dev_priv->drm, !new_cdclk_state->base.changed);
 
@@ -2634,6 +2634,7 @@ static struct intel_global_state *intel_
 		return NULL;
 
 	cdclk_state->pipe = INVALID_PIPE;
+	cdclk_state->disable_pipes = false;
 
 	return &cdclk_state->base;
 }
@@ -2793,6 +2794,8 @@ int intel_modeset_calc_cdclk(struct inte
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


