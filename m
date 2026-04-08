Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED24F3537DF;
	Wed,  8 Apr 2026 18:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674711; cv=none; b=hAvVHayssG1XuInJNmG2jrRpgtnFHIsY7/aTVrB9J0JZl840EJPh9S6utXlsH+bNzofIBugknu4R94uiMHVIpwCym6itpHI9OEOo5LGoiUcCakoLzRRWV8/Js0bkjJs7DpxfXScKfN30UPHZNJnYNM1WRPt1XxmxakjrrWFyUuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674711; c=relaxed/simple;
	bh=5B3LnITiuKuA7UiAA42PG+NDEj6whSa55Esb/cff7a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jbgWH7I2AhOF/83taKRfN61a44yod+lZRZwuL6R0uZfngEFb0F2sUtHsUYMrMo3YKMt8OSv0vbQH/KoDgHWCLV0bkUn1rA/nkKQs/Alnrv64W0ms1YfA1h32deD1jdlrYTnJGIMqBiyvjLknO/N9DvMuJoRO49riHqvrK6HHOx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFPVM4OL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFPVM4OL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83691C19421;
	Wed,  8 Apr 2026 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674710;
	bh=5B3LnITiuKuA7UiAA42PG+NDEj6whSa55Esb/cff7a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFPVM4OLHnFKhRCCWee0J1Qiq/365Tubielq6r5uZqOIE2+JxU7ENHhvdEXcpeemP
	 mgA5oeWnlW/b3mc/Idlo+FDhQ/pOyzO8ZN+PyOwqKscdp9tbDvYY0V8GrBixkNjOeM
	 I78MOPPnkzUBuxtuHYnJ/p679h644zQ7QbLVXvSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Rudenko <mike.rudenko@gmail.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.19 202/311] drm/i915/cdclk: Do the full CDCLK dance for min_voltage_level changes
Date: Wed,  8 Apr 2026 20:03:22 +0200
Message-ID: <20260408175946.953026348@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit e08e0754e690e4909cab83ac43fd2c93c6200514 upstream.

Apparently I forgot about the pipe min_voltage_level when I
decoupled the CDCLK calculations from modesets. Even if the
CDCLK frequency doesn't need changing we may still need to
bump the voltage level to accommodate an increase in the
port clock frequency.

Currently, even if there is a full modeset, we won't notice the
need to go through the full CDCLK calculations/programming,
unless the set of enabled/active pipes changes, or the
pipe/dbuf min CDCLK changes.

Duplicate the same logic we use the pipe's min CDCLK frequency
to also deal with its min voltage level.

Note that the 'allow_voltage_level_decrease' stuff isn't
really useful here since the min voltage level can only
change during a full modeset. But I think sticking to the
same approach in the three similar parts (pipe min cdclk,
pipe min voltage level, dbuf min cdclk) is a good idea.

Cc: stable@vger.kernel.org
Tested-by: Mikhail Rudenko <mike.rudenko@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15826
Fixes: ba91b9eecb47 ("drm/i915/cdclk: Decouple cdclk from state->modeset")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260325135849.12603-2-ville.syrjala@linux.intel.com
Reviewed-by: Michał Grzelak <michal.grzelak@intel.com>
(cherry picked from commit 0f21a14987ebae3c05ad1184ea872e7b7a7b8695)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c |   54 +++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -2930,6 +2930,53 @@ static int intel_cdclk_update_crtc_min_c
 	return 0;
 }
 
+static int intel_cdclk_update_crtc_min_voltage_level(struct intel_atomic_state *state,
+						     struct intel_crtc *crtc,
+						     u8 old_min_voltage_level,
+						     u8 new_min_voltage_level,
+						     bool *need_cdclk_calc)
+{
+	struct intel_display *display = to_intel_display(state);
+	struct intel_cdclk_state *cdclk_state;
+	bool allow_voltage_level_decrease = intel_any_crtc_needs_modeset(state);
+	int ret;
+
+	if (new_min_voltage_level == old_min_voltage_level)
+		return 0;
+
+	if (!allow_voltage_level_decrease &&
+	    new_min_voltage_level < old_min_voltage_level)
+		return 0;
+
+	cdclk_state = intel_atomic_get_cdclk_state(state);
+	if (IS_ERR(cdclk_state))
+		return PTR_ERR(cdclk_state);
+
+	old_min_voltage_level = cdclk_state->min_voltage_level[crtc->pipe];
+
+	if (new_min_voltage_level == old_min_voltage_level)
+		return 0;
+
+	if (!allow_voltage_level_decrease &&
+	    new_min_voltage_level < old_min_voltage_level)
+		return 0;
+
+	cdclk_state->min_voltage_level[crtc->pipe] = new_min_voltage_level;
+
+	ret = intel_atomic_lock_global_state(&cdclk_state->base);
+	if (ret)
+		return ret;
+
+	*need_cdclk_calc = true;
+
+	drm_dbg_kms(display->drm,
+		    "[CRTC:%d:%s] min voltage level: %d -> %d\n",
+		    crtc->base.base.id, crtc->base.name,
+		    old_min_voltage_level, new_min_voltage_level);
+
+	return 0;
+}
+
 int intel_cdclk_update_dbuf_bw_min_cdclk(struct intel_atomic_state *state,
 					 int old_min_cdclk, int new_min_cdclk,
 					 bool *need_cdclk_calc)
@@ -3345,6 +3392,13 @@ static int intel_crtcs_calc_min_cdclk(st
 							need_cdclk_calc);
 		if (ret)
 			return ret;
+
+		ret = intel_cdclk_update_crtc_min_voltage_level(state, crtc,
+								old_crtc_state->min_voltage_level,
+								new_crtc_state->min_voltage_level,
+								need_cdclk_calc);
+		if (ret)
+			return ret;
 	}
 
 	return 0;


