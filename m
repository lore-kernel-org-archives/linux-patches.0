Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8569E333456;
	Thu, 27 Nov 2025 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255975; cv=none; b=LqBTtc/L1p8GEqk6TFBN5yQe5yS/j9gM/W1t2bZ0cJ01Qn3fzi8cQ8tqrcdlB9rqJVfkvLbHL45FwNrMrsdFYA+RFAjO09/krs4LXaAMkaf0WykjsKWbyNTc9oQTWkud+Rndll6leMNwgNawtsUrEijBZL6ePJmies8hDJfGqY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255975; c=relaxed/simple;
	bh=DUxLXpnc0qnSVp0h6fs2EoiwR1Aj02i2ubOJ5fKpydw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIejt0d0heT4uJ+ZHUQI577vuxeTLVibrEPX+epm5N365IvcyuyUyRO6Awa4ygg/rKxqNB0GN+HEIpXhfoVg263/dPlMjSGoJq4tnL/p4pP24h2uOVOYnuoJfDYdb4o8pILfgjjRgfrPlCTD659+VPieOwSsPLrjmboY8ujgvmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bB5eRim0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB5eRim0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F82C113D0;
	Thu, 27 Nov 2025 15:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255975;
	bh=DUxLXpnc0qnSVp0h6fs2EoiwR1Aj02i2ubOJ5fKpydw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bB5eRim0PhxVP8Z+D8szM9a1GD209X6NNfg6DrcpCnZILIIj9SC7kfs3xoJoS6VFm
	 3vQtiZsnSdyGuPIH0w+OKyrxoiHdJUmC1x8dByuQNRnH4KwpUteZahaSuymZHrCdLv
	 J/ncYqfaOABi9apW166LRBzoAmv2yA5JtNWblasA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Subject: [PATCH 6.17 172/175] Revert "drm/i915/dp: Reject HBR3 when sink doesnt support TPS4"
Date: Thu, 27 Nov 2025 15:47:05 +0100
Message-ID: <20251127144049.239792472@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit 8c9006283e4b767003b2d11182d6e90f8b184c3d upstream.

This reverts commit 584cf613c24a4250d9be4819efc841aa2624d5b6.
Commit 584cf613c24a ("drm/i915/dp: Reject HBR3 when sink doesn't support
TPS4") introduced a blanket rejection of HBR3 link rate when the sink does
not support TPS4.

While this was intended to address instability observed on certain eDP
panels [1], there seem to be edp panels that do not follow the
specification. These eDP panels do not advertise TPS4 support, but require
HBR3 to operate at their fixed native resolution [2].

As a result, the change causes blank screens on such panels. Apparently,
Windows driver does not enforce this restriction, and the issue is not seen
there.

Therefore, revert the commit to restore functionality for such panels,
and align behaviour with Windows driver.

[1] https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/5969
[2] https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14517

v2: Update the commit message with better justification. (Ville)

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14517
Acked-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://lore.kernel.org/r/20250710052041.1238567-2-ankit.k.nautiyal@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |   49 ++++----------------------------
 1 file changed, 7 insertions(+), 42 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -173,28 +173,10 @@ int intel_dp_link_symbol_clock(int rate)
 
 static int max_dprx_rate(struct intel_dp *intel_dp)
 {
-	struct intel_display *display = to_intel_display(intel_dp);
-	struct intel_encoder *encoder = &dp_to_dig_port(intel_dp)->base;
-	int max_rate;
-
 	if (intel_dp_tunnel_bw_alloc_is_enabled(intel_dp))
-		max_rate = drm_dp_tunnel_max_dprx_rate(intel_dp->tunnel);
-	else
-		max_rate = drm_dp_bw_code_to_link_rate(intel_dp->dpcd[DP_MAX_LINK_RATE]);
+		return drm_dp_tunnel_max_dprx_rate(intel_dp->tunnel);
 
-	/*
-	 * Some broken eDP sinks illegally declare support for
-	 * HBR3 without TPS4, and are unable to produce a stable
-	 * output. Reject HBR3 when TPS4 is not available.
-	 */
-	if (max_rate >= 810000 && !drm_dp_tps4_supported(intel_dp->dpcd)) {
-		drm_dbg_kms(display->drm,
-			    "[ENCODER:%d:%s] Rejecting HBR3 due to missing TPS4 support\n",
-			    encoder->base.base.id, encoder->base.name);
-		max_rate = 540000;
-	}
-
-	return max_rate;
+	return drm_dp_bw_code_to_link_rate(intel_dp->dpcd[DP_MAX_LINK_RATE]);
 }
 
 static int max_dprx_lane_count(struct intel_dp *intel_dp)
@@ -4279,9 +4261,6 @@ static void intel_edp_mso_init(struct in
 static void
 intel_edp_set_sink_rates(struct intel_dp *intel_dp)
 {
-	struct intel_display *display = to_intel_display(intel_dp);
-	struct intel_encoder *encoder = &dp_to_dig_port(intel_dp)->base;
-
 	intel_dp->num_sink_rates = 0;
 
 	if (intel_dp->edp_dpcd[0] >= DP_EDP_14) {
@@ -4292,7 +4271,10 @@ intel_edp_set_sink_rates(struct intel_dp
 				 sink_rates, sizeof(sink_rates));
 
 		for (i = 0; i < ARRAY_SIZE(sink_rates); i++) {
-			int rate;
+			int val = le16_to_cpu(sink_rates[i]);
+
+			if (val == 0)
+				break;
 
 			/* Value read multiplied by 200kHz gives the per-lane
 			 * link rate in kHz. The source rates are, however,
@@ -4300,24 +4282,7 @@ intel_edp_set_sink_rates(struct intel_dp
 			 * back to symbols is
 			 * (val * 200kHz)*(8/10 ch. encoding)*(1/8 bit to Byte)
 			 */
-			rate = le16_to_cpu(sink_rates[i]) * 200 / 10;
-
-			if (rate == 0)
-				break;
-
-			/*
-			 * Some broken eDP sinks illegally declare support for
-			 * HBR3 without TPS4, and are unable to produce a stable
-			 * output. Reject HBR3 when TPS4 is not available.
-			 */
-			if (rate >= 810000 && !drm_dp_tps4_supported(intel_dp->dpcd)) {
-				drm_dbg_kms(display->drm,
-					    "[ENCODER:%d:%s] Rejecting HBR3 due to missing TPS4 support\n",
-					    encoder->base.base.id, encoder->base.name);
-				break;
-			}
-
-			intel_dp->sink_rates[i] = rate;
+			intel_dp->sink_rates[i] = (val * 200) / 10;
 		}
 		intel_dp->num_sink_rates = i;
 	}


