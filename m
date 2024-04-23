Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD19F20B3E;
	Tue, 23 Apr 2024 21:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908460; cv=none; b=m8trShmyRqui6TrP0cN/Il491un9BXU1LnUrIYnoqxi+B99KPqltyC84oP6ZTO8kPSTz5a718bbXSeDrbYpCQ9uLSPh/CDIMp7irnn3/LW2wLVv4z5NsmEeasj3ndYN7sz1L74GwMXlOD2UnNFh3dp/7fM9XXSl4tqwxoQaIQgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908460; c=relaxed/simple;
	bh=VLEZAEAobQYCHft0RSL/dTCC84qxW88MKTJwI5ULTow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n4T7Mqdkwt53dtVRWRbIMv1nYs4YzBzIPEHfZHA2S+drwutus/KFLG3sfwKtQZapv0dd7kUXWnIpZZZphTye/kYixerBFuvZD06zaKeJa2SMXLMYXhh3Oh/UU6ms5fnkk2WqFnONmXMJf09zifSSSEmIwcAy01Gsu7NME6pFOY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsNcxXIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsNcxXIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB20C116B1;
	Tue, 23 Apr 2024 21:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908459;
	bh=VLEZAEAobQYCHft0RSL/dTCC84qxW88MKTJwI5ULTow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsNcxXIfxvTB4F4lpkY+zESKawNmt1ElXHtPg3+ZuiCowtn3xcAdhW9suAf5E8s2Y
	 FI9pZrohHvapAZcKLxOiMkrJc+EHIyBV6exw01D42S7OoWb4TFTNclqK6klHS6rkQZ
	 h1FxFkCpXbEC1tLyge6Zsi52uThr2wxDfvqafuG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 002/158] drm/i915/cdclk: Fix voltage_level programming edge case
Date: Tue, 23 Apr 2024 14:37:04 -0700
Message-ID: <20240423213855.907918037@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

[ Upstream commit 6154cc9177ccea00c89ce0bf93352e474b819ff2 ]

Currently we only consider the relationship of the
old and new CDCLK frequencies when determining whether
to do the repgramming from intel_set_cdclk_pre_plane_update()
or intel_set_cdclk_post_plane_update().

It is technically possible to have a situation where the
CDCLK frequency is decreasing, but the voltage_level is
increasing due a DDI port. In this case we should bump
the voltage level already in intel_set_cdclk_pre_plane_update()
(so that the voltage_level will have been increased by the
time the port gets enabled), while leaving the CDCLK frequency
unchanged (as active planes/etc. may still depend on it).
We can then reduce the CDCLK frequency to its final value
from intel_set_cdclk_post_plane_update().

In order to handle that correctly we shall construct a
suitable amalgam of the old and new cdclk states in
intel_set_cdclk_pre_plane_update().

And we can simply call intel_set_cdclk() unconditionally
in both places as it will not do anything if nothing actually
changes vs. the current hw state.

v2: Handle cdclk_state->disable_pipes
v3: Only synchronize the cd2x update against the pipe's vblank
    when the cdclk frequency is changing during the current
    commit phase (Gustavo)

Cc: stable@vger.kernel.org
Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402155016.13733-3-ville.syrjala@linux.intel.com
(cherry picked from commit 34d127e2bdef73a923aa0dcd95cbc3257ad5af52)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c | 37 ++++++++++++++++------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
index 6e36a15284537..7ba30d26f620c 100644
--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -2512,7 +2512,8 @@ intel_set_cdclk_pre_plane_update(struct intel_atomic_state *state)
 		intel_atomic_get_old_cdclk_state(state);
 	const struct intel_cdclk_state *new_cdclk_state =
 		intel_atomic_get_new_cdclk_state(state);
-	enum pipe pipe = new_cdclk_state->pipe;
+	struct intel_cdclk_config cdclk_config;
+	enum pipe pipe;
 
 	if (!intel_cdclk_changed(&old_cdclk_state->actual,
 				 &new_cdclk_state->actual))
@@ -2521,12 +2522,25 @@ intel_set_cdclk_pre_plane_update(struct intel_atomic_state *state)
 	if (IS_DG2(i915))
 		intel_cdclk_pcode_pre_notify(state);
 
-	if (new_cdclk_state->disable_pipes ||
-	    old_cdclk_state->actual.cdclk <= new_cdclk_state->actual.cdclk) {
-		drm_WARN_ON(&i915->drm, !new_cdclk_state->base.changed);
+	if (new_cdclk_state->disable_pipes) {
+		cdclk_config = new_cdclk_state->actual;
+		pipe = INVALID_PIPE;
+	} else {
+		if (new_cdclk_state->actual.cdclk >= old_cdclk_state->actual.cdclk) {
+			cdclk_config = new_cdclk_state->actual;
+			pipe = new_cdclk_state->pipe;
+		} else {
+			cdclk_config = old_cdclk_state->actual;
+			pipe = INVALID_PIPE;
+		}
 
-		intel_set_cdclk(i915, &new_cdclk_state->actual, pipe);
+		cdclk_config.voltage_level = max(new_cdclk_state->actual.voltage_level,
+						 old_cdclk_state->actual.voltage_level);
 	}
+
+	drm_WARN_ON(&i915->drm, !new_cdclk_state->base.changed);
+
+	intel_set_cdclk(i915, &cdclk_config, pipe);
 }
 
 /**
@@ -2544,7 +2558,7 @@ intel_set_cdclk_post_plane_update(struct intel_atomic_state *state)
 		intel_atomic_get_old_cdclk_state(state);
 	const struct intel_cdclk_state *new_cdclk_state =
 		intel_atomic_get_new_cdclk_state(state);
-	enum pipe pipe = new_cdclk_state->pipe;
+	enum pipe pipe;
 
 	if (!intel_cdclk_changed(&old_cdclk_state->actual,
 				 &new_cdclk_state->actual))
@@ -2554,11 +2568,14 @@ intel_set_cdclk_post_plane_update(struct intel_atomic_state *state)
 		intel_cdclk_pcode_post_notify(state);
 
 	if (!new_cdclk_state->disable_pipes &&
-	    old_cdclk_state->actual.cdclk > new_cdclk_state->actual.cdclk) {
-		drm_WARN_ON(&i915->drm, !new_cdclk_state->base.changed);
+	    new_cdclk_state->actual.cdclk < old_cdclk_state->actual.cdclk)
+		pipe = new_cdclk_state->pipe;
+	else
+		pipe = INVALID_PIPE;
 
-		intel_set_cdclk(i915, &new_cdclk_state->actual, pipe);
-	}
+	drm_WARN_ON(&i915->drm, !new_cdclk_state->base.changed);
+
+	intel_set_cdclk(i915, &new_cdclk_state->actual, pipe);
 }
 
 static int intel_pixel_rate_to_cdclk(const struct intel_crtc_state *crtc_state)
-- 
2.43.0



