Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E011A76B6;
	Tue, 30 Jul 2024 17:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360460; cv=none; b=Nt34j3OQZOXYGIPD5M4DXMCbudYrhjigocBgQBUxsUm3yy/SVRyww/ddm0E3EQDfIjdVfMF0aonGr9/ipDzpnzVs3MrW2HJV5qK1nAXIWZ7nD3M3Kxhbi7BhvmGQJYR7URJ6vG3HOPQ786woBztqmb3dOopxI8Pu14KiowKK8jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360460; c=relaxed/simple;
	bh=EmQps9hjZnEHzn6iZdGEmHG6Dhx2AhXdKlZjdZMZaJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oDPQPoh5RhBkMy+ED0lwyFtTFMBZIqlIYJaJGb4VwerzSfGcjslE8btk0wZhRoSA/PnTtcStgIDx7j+VHJgzXJe3siV2mnGflG1ubUK8Eugta1GHgzoijC0idOkTCq2o99jLAUS4MkCboTLQjpfuPY780KphRmEJeF7IapR9Jmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUAwEqWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUAwEqWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6921EC32782;
	Tue, 30 Jul 2024 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360459;
	bh=EmQps9hjZnEHzn6iZdGEmHG6Dhx2AhXdKlZjdZMZaJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUAwEqWZUSB9lV6f1YuSAqolwlb5m7F918EgWZf0+ndYekaKyPWkEi4TKRaUoxypw
	 oRK7qiGlMRNRpDwKnPVkHNcf/i4c7+wB5b1JtWW0xM/3KndJoZMJzQgX7hAGH234iq
	 6w1CSue3IYk5Qux9TLueYosreBQwsUJ3/S802jyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Gareth Yu <gareth.yu@intel.com>
Subject: [PATCH 6.10 706/809] drm/i915/dp: Dont switch the LTTPR mode on an active link
Date: Tue, 30 Jul 2024 17:49:42 +0200
Message-ID: <20240730151752.812742776@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 509580fad7323b6a5da27e8365cd488f3b57210e upstream.

Switching to transparent mode leads to a loss of link synchronization,
so prevent doing this on an active link. This happened at least on an
Intel N100 system / DELL UD22 dock, the LTTPR residing either on the
host or the dock. To fix the issue, keep the current mode on an active
link, adjusting the LTTPR count accordingly (resetting it to 0 in
transparent mode).

v2: Adjust code comment during link training about reiniting the LTTPRs.
   (Ville)

Fixes: 7b2a4ab8b0ef ("drm/i915: Switch to LTTPR transparent mode link training")
Reported-and-tested-by: Gareth Yu <gareth.yu@intel.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/10902
Cc: <stable@vger.kernel.org> # v5.15+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240708190029.271247-3-imre.deak@intel.com
(cherry picked from commit 211ad49cf8ccfdc798a719b4d1e000d0a8a9e588)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_link_training.c |   55 +++++++++++++++---
 1 file changed, 48 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -114,10 +114,24 @@ intel_dp_set_lttpr_transparent_mode(stru
 	return drm_dp_dpcd_write(&intel_dp->aux, DP_PHY_REPEATER_MODE, &val, 1) == 1;
 }
 
-static int intel_dp_init_lttpr(struct intel_dp *intel_dp, const u8 dpcd[DP_RECEIVER_CAP_SIZE])
+static bool intel_dp_lttpr_transparent_mode_enabled(struct intel_dp *intel_dp)
+{
+	return intel_dp->lttpr_common_caps[DP_PHY_REPEATER_MODE -
+					   DP_LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV] ==
+		DP_PHY_REPEATER_MODE_TRANSPARENT;
+}
+
+/*
+ * Read the LTTPR common capabilities and switch the LTTPR PHYs to
+ * non-transparent mode if this is supported. Preserve the
+ * transparent/non-transparent mode on an active link.
+ *
+ * Return the number of detected LTTPRs in non-transparent mode or 0 if the
+ * LTTPRs are in transparent mode or the detection failed.
+ */
+static int intel_dp_init_lttpr_phys(struct intel_dp *intel_dp, const u8 dpcd[DP_RECEIVER_CAP_SIZE])
 {
 	int lttpr_count;
-	int i;
 
 	if (!intel_dp_read_lttpr_common_caps(intel_dp, dpcd))
 		return 0;
@@ -132,6 +146,19 @@ static int intel_dp_init_lttpr(struct in
 		return 0;
 
 	/*
+	 * Don't change the mode on an active link, to prevent a loss of link
+	 * synchronization. See DP Standard v2.0 3.6.7. about the LTTPR
+	 * resetting its internal state when the mode is changed from
+	 * non-transparent to transparent.
+	 */
+	if (intel_dp->link_trained) {
+		if (lttpr_count < 0 || intel_dp_lttpr_transparent_mode_enabled(intel_dp))
+			goto out_reset_lttpr_count;
+
+		return lttpr_count;
+	}
+
+	/*
 	 * See DP Standard v2.0 3.6.6.1. about the explicit disabling of
 	 * non-transparent mode and the disable->enable non-transparent mode
 	 * sequence.
@@ -151,11 +178,25 @@ static int intel_dp_init_lttpr(struct in
 		       "Switching to LTTPR non-transparent LT mode failed, fall-back to transparent mode\n");
 
 		intel_dp_set_lttpr_transparent_mode(intel_dp, true);
-		intel_dp_reset_lttpr_count(intel_dp);
 
-		return 0;
+		goto out_reset_lttpr_count;
 	}
 
+	return lttpr_count;
+
+out_reset_lttpr_count:
+	intel_dp_reset_lttpr_count(intel_dp);
+
+	return 0;
+}
+
+static int intel_dp_init_lttpr(struct intel_dp *intel_dp, const u8 dpcd[DP_RECEIVER_CAP_SIZE])
+{
+	int lttpr_count;
+	int i;
+
+	lttpr_count = intel_dp_init_lttpr_phys(intel_dp, dpcd);
+
 	for (i = 0; i < lttpr_count; i++)
 		intel_dp_read_lttpr_phy_caps(intel_dp, dpcd, DP_PHY_LTTPR(i));
 
@@ -1372,10 +1413,10 @@ void intel_dp_start_link_train(struct in
 {
 	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 	bool passed;
-
 	/*
-	 * TODO: Reiniting LTTPRs here won't be needed once proper connector
-	 * HW state readout is added.
+	 * Reinit the LTTPRs here to ensure that they are switched to
+	 * non-transparent mode. During an earlier LTTPR detection this
+	 * could've been prevented by an active link.
 	 */
 	int lttpr_count = intel_dp_init_lttpr_and_dprx_caps(intel_dp);
 


