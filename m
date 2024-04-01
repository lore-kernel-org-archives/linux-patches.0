Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5AD4EB24;
	Mon,  1 Apr 2024 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990408; cv=none; b=diZu59vGybOOikgMGpKxurizn2mNdjiNasyObaTLCbNjjihqDF/giR/81nP+x+45IK8N1v+yhueEut+2M1hrcsIO3u0SHoae72LhXzgstPezwoxvc3Q6RT4UHhLfrVgpXBXFUPl1HI3eHDv5sX8tKN6IhVlSkHfaQH2syZ6m0vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990408; c=relaxed/simple;
	bh=u62Z3+QVD3e4QMHArHi801BYg3ckW8J5KaEJIAX3qCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dYIJXX2s+g9C84NdiWmdS9klELq4/iN/71PyadVgnCjxqH74sU1VHhjZV1aRPzbqOd5V0b/YalbY6o1FOH34u+eKCyk3ysj1qzqyVrYJ/LSQDtMz1jXwk0IAHfsF8agprxLjm3soVNiuzs+CNX0frxLifOAesovPAIhfnvyUkMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQAiFhHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQAiFhHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5DEC433C7;
	Mon,  1 Apr 2024 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990408;
	bh=u62Z3+QVD3e4QMHArHi801BYg3ckW8J5KaEJIAX3qCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQAiFhHiVFtCe59fm7EHh+VI2+UYY8fEWp6lkbrltHYqYmkn7iPvfPp1lUPa8t+F3
	 H2ZB8tDvYlLgCG1Ozg3MirP59lPwohghci6fII3cC8NBw6zWqyA/bhnuGUPn6MRqZy
	 UzTryQsy1seS/vHzJCxJrfCO8WSt5diW+/CLwyRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.6 344/396] drm/i915/dsi: Go back to the previous INIT_OTP/DISPLAY_ON order, mostly
Date: Mon,  1 Apr 2024 17:46:33 +0200
Message-ID: <20240401152558.174066120@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 18846627ef1210dcd55d65342b055ea97a46ffff upstream.

Reinstate commit 88b065943cb5 ("drm/i915/dsi: Do display on
sequence later on icl+"), for the most part. Turns out some
machines (eg. Chuwi Minibook X) really do need that updated order.
It is also the order the Windows driver uses.

However we can't just undo the revert since that would again
break Lenovo 82TQ. After staring at the VBT sequences for both
machines I've concluded that the Lenovo 82TQ sequences look
somewhat broken:
 - INIT_OTP is not present at all
 - what should be in INIT_OTP is found in DISPLAY_ON
 - what should be in DISPLAY_ON is found in BACKLIGHT_ON
   (along with the actual backlight stuff)

The Chuwi Minibook X on the other hand has a full complement
of sequences in its VBT.

So let's try to deal with the broken sequences in the
Lenovo 82TQ VBT by simply swapping the (non-existent)
INIT_OTP sequence with the DISPLAY_ON sequence. Thus we
execute DISPLAY_ON when intending to execute INIT_OTP,
and execute nothing at all when intending to execute
DISPLAY_ON. That should be 100% equivalent to the
revert, for such broken VBTs.

Cc: stable@vger.kernel.org
Fixes: 6992eb815d08 ("Revert "drm/i915/dsi: Do display on sequence later on icl+"")
References: https://gitlab.freedesktop.org/drm/intel/-/issues/10071
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10334
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240305083659.8396-1-ville.syrjala@linux.intel.com
Acked-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 94ae4612ea336bfc3c12b3fc68467c6711a4f39b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c    |    3 +-
 drivers/gpu/drm/i915/display/intel_bios.c |   43 +++++++++++++++++++++++++-----
 2 files changed, 39 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -1155,7 +1155,6 @@ static void gen11_dsi_powerup_panel(stru
 	}
 
 	intel_dsi_vbt_exec_sequence(intel_dsi, MIPI_SEQ_INIT_OTP);
-	intel_dsi_vbt_exec_sequence(intel_dsi, MIPI_SEQ_DISPLAY_ON);
 
 	/* ensure all panel commands dispatched before enabling transcoder */
 	wait_for_cmds_dispatched_to_panel(encoder);
@@ -1256,6 +1255,8 @@ static void gen11_dsi_enable(struct inte
 	/* step6d: enable dsi transcoder */
 	gen11_dsi_enable_transcoder(encoder);
 
+	intel_dsi_vbt_exec_sequence(intel_dsi, MIPI_SEQ_DISPLAY_ON);
+
 	/* step7: enable backlight */
 	intel_backlight_enable(crtc_state, conn_state);
 	intel_dsi_vbt_exec_sequence(intel_dsi, MIPI_SEQ_BACKLIGHT_ON);
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1945,16 +1945,12 @@ static int get_init_otp_deassert_fragmen
  * these devices we split the init OTP sequence into a deassert sequence and
  * the actual init OTP part.
  */
-static void fixup_mipi_sequences(struct drm_i915_private *i915,
-				 struct intel_panel *panel)
+static void vlv_fixup_mipi_sequences(struct drm_i915_private *i915,
+				     struct intel_panel *panel)
 {
 	u8 *init_otp;
 	int len;
 
-	/* Limit this to VLV for now. */
-	if (!IS_VALLEYVIEW(i915))
-		return;
-
 	/* Limit this to v1 vid-mode sequences */
 	if (panel->vbt.dsi.config->is_cmd_mode ||
 	    panel->vbt.dsi.seq_version != 1)
@@ -1990,6 +1986,41 @@ static void fixup_mipi_sequences(struct
 	panel->vbt.dsi.sequence[MIPI_SEQ_INIT_OTP] = init_otp + len - 1;
 }
 
+/*
+ * Some machines (eg. Lenovo 82TQ) appear to have broken
+ * VBT sequences:
+ * - INIT_OTP is not present at all
+ * - what should be in INIT_OTP is in DISPLAY_ON
+ * - what should be in DISPLAY_ON is in BACKLIGHT_ON
+ *   (along with the actual backlight stuff)
+ *
+ * To make those work we simply swap DISPLAY_ON and INIT_OTP.
+ *
+ * TODO: Do we need to limit this to specific machines,
+ *       or examine the contents of the sequences to
+ *       avoid false positives?
+ */
+static void icl_fixup_mipi_sequences(struct drm_i915_private *i915,
+				     struct intel_panel *panel)
+{
+	if (!panel->vbt.dsi.sequence[MIPI_SEQ_INIT_OTP] &&
+	    panel->vbt.dsi.sequence[MIPI_SEQ_DISPLAY_ON]) {
+		drm_dbg_kms(&i915->drm, "Broken VBT: Swapping INIT_OTP and DISPLAY_ON sequences\n");
+
+		swap(panel->vbt.dsi.sequence[MIPI_SEQ_INIT_OTP],
+		     panel->vbt.dsi.sequence[MIPI_SEQ_DISPLAY_ON]);
+	}
+}
+
+static void fixup_mipi_sequences(struct drm_i915_private *i915,
+				 struct intel_panel *panel)
+{
+	if (DISPLAY_VER(i915) >= 11)
+		icl_fixup_mipi_sequences(i915, panel);
+	else if (IS_VALLEYVIEW(i915))
+		vlv_fixup_mipi_sequences(i915, panel);
+}
+
 static void
 parse_mipi_sequence(struct drm_i915_private *i915,
 		    struct intel_panel *panel)


