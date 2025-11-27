Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4228628135D;
	Thu, 27 Nov 2025 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255978; cv=none; b=mz/vZxFnT4ogWjgYqMyfqsBSVj5Glhoc7ASUiVhJKg8XY1kpz7Xn1YoTdy6kLPdHNUtRSXmgYG10D/9iQpdCFKLpsoY9CyVO9TgAzwVEICyUClqSlqs1b+4Z3l0tcMYUx3DhCzn5kl5nD1rSQjiRMY+lot7hLb9LzSSoBOpUh5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255978; c=relaxed/simple;
	bh=2slld+D6xu6AwuJudyVW8s+P+nVmJ1LOmLz5hnMXc4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RxNRKagNVBO615YvHmypKxo4ZkvpSCa/j66zhwIRPS8YVFzCTDs6gxIhCYXvjx33R8nfZ1cBnz/xOtNTvWUc1MyTv56SffFlyg2bXerOyUhKmN3FgA5nJtkmKlroCthIRWANN/BXhaR62o8IGLDYfjohTky0tBFs2DMncuuYDoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6L7PgsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6L7PgsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DB1C4CEF8;
	Thu, 27 Nov 2025 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255978;
	bh=2slld+D6xu6AwuJudyVW8s+P+nVmJ1LOmLz5hnMXc4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6L7PgsH5YN0RKCeNj9enMF2aX8uxO5Sh+GqA1GfvOrxnlln7wkzqpA/Euo53M5CV
	 RabiJG56WrwbM7dpk3pI7dAdsb2MZRQjI+2vfwC1DD0EJ9dt6fPrngYwrBoRqkS7R2
	 n+tA1kqOaQuNlqXPQQqwrqVaw8ufa2HPUu1PNq3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Subject: [PATCH 6.17 173/175] drm/i915/dp: Add device specific quirk to limit eDP rate to HBR2
Date: Thu, 27 Nov 2025 15:47:06 +0100
Message-ID: <20251127144049.275596853@linuxfoundation.org>
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

commit 21c586d9233a1f258e8d437466c441d50885d30f upstream.

Some ICL/TGL platforms with combo PHY ports suffer from signal integrity
issues at HBR3. While certain systems include a Parade PS8461 mux to
mitigate this, its presence cannot be reliably detected. Furthermore,
broken or missing VBT entries make it unsafe to rely on VBT for enforcing
link rate limits.

To address this introduce a device specific quirk to cap the eDP link rate
to HBR2 (540000 kHz). This will override any higher advertised rates from
the sink or DPCD for specific devices.

Currently, the quirk is added for Dell XPS 13 7390 2-in-1 which is reported
in gitlab issue #5969 [1].

[1] https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/5969

v2: Align the quirk with the intended quirk name and refactor the
condition to use min(). (Jani)
v3: Use condition `rate > 540000`. Drop extra parentheses. (Ville)

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/5969
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://lore.kernel.org/r/20250710052041.1238567-3-ankit.k.nautiyal@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c     |   41 +++++++++++++++++++++++-----
 drivers/gpu/drm/i915/display/intel_quirks.c |    9 ++++++
 drivers/gpu/drm/i915/display/intel_quirks.h |    1 
 3 files changed, 44 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -173,10 +173,24 @@ int intel_dp_link_symbol_clock(int rate)
 
 static int max_dprx_rate(struct intel_dp *intel_dp)
 {
+	struct intel_display *display = to_intel_display(intel_dp);
+	int max_rate;
+
 	if (intel_dp_tunnel_bw_alloc_is_enabled(intel_dp))
-		return drm_dp_tunnel_max_dprx_rate(intel_dp->tunnel);
+		max_rate = drm_dp_tunnel_max_dprx_rate(intel_dp->tunnel);
+	else
+		max_rate = drm_dp_bw_code_to_link_rate(intel_dp->dpcd[DP_MAX_LINK_RATE]);
+
+	/*
+	 * Some platforms + eDP panels may not reliably support HBR3
+	 * due to signal integrity limitations, despite advertising it.
+	 * Cap the link rate to HBR2 to avoid unstable configurations for the
+	 * known machines.
+	 */
+	if (intel_dp_is_edp(intel_dp) && intel_has_quirk(display, QUIRK_EDP_LIMIT_RATE_HBR2))
+		max_rate = min(max_rate, 540000);
 
-	return drm_dp_bw_code_to_link_rate(intel_dp->dpcd[DP_MAX_LINK_RATE]);
+	return max_rate;
 }
 
 static int max_dprx_lane_count(struct intel_dp *intel_dp)
@@ -4261,6 +4275,8 @@ static void intel_edp_mso_init(struct in
 static void
 intel_edp_set_sink_rates(struct intel_dp *intel_dp)
 {
+	struct intel_display *display = to_intel_display(intel_dp);
+
 	intel_dp->num_sink_rates = 0;
 
 	if (intel_dp->edp_dpcd[0] >= DP_EDP_14) {
@@ -4271,10 +4287,7 @@ intel_edp_set_sink_rates(struct intel_dp
 				 sink_rates, sizeof(sink_rates));
 
 		for (i = 0; i < ARRAY_SIZE(sink_rates); i++) {
-			int val = le16_to_cpu(sink_rates[i]);
-
-			if (val == 0)
-				break;
+			int rate;
 
 			/* Value read multiplied by 200kHz gives the per-lane
 			 * link rate in kHz. The source rates are, however,
@@ -4282,7 +4295,21 @@ intel_edp_set_sink_rates(struct intel_dp
 			 * back to symbols is
 			 * (val * 200kHz)*(8/10 ch. encoding)*(1/8 bit to Byte)
 			 */
-			intel_dp->sink_rates[i] = (val * 200) / 10;
+			rate = le16_to_cpu(sink_rates[i]) * 200 / 10;
+
+			if (rate == 0)
+				break;
+
+			/*
+			 * Some platforms cannot reliably drive HBR3 rates due to PHY limitations,
+			 * even if the sink advertises support. Reject any sink rates above HBR2 on
+			 * the known machines for stable output.
+			 */
+			if (rate > 540000 &&
+			    intel_has_quirk(display, QUIRK_EDP_LIMIT_RATE_HBR2))
+				break;
+
+			intel_dp->sink_rates[i] = rate;
 		}
 		intel_dp->num_sink_rates = i;
 	}
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -80,6 +80,12 @@ static void quirk_fw_sync_len(struct int
 	drm_info(display->drm, "Applying Fast Wake sync pulse count quirk\n");
 }
 
+static void quirk_edp_limit_rate_hbr2(struct intel_display *display)
+{
+	intel_set_quirk(display, QUIRK_EDP_LIMIT_RATE_HBR2);
+	drm_info(display->drm, "Applying eDP Limit rate to HBR2 quirk\n");
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -231,6 +237,9 @@ static struct intel_quirk intel_quirks[]
 	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 	/* HP Notebook - 14-r206nv */
 	{ 0x0f31, 0x103c, 0x220f, quirk_invert_brightness },
+
+	/* Dell XPS 13 7390 2-in-1 */
+	{ 0x8a12, 0x1028, 0x08b0, quirk_edp_limit_rate_hbr2 },
 };
 
 static const struct intel_dpcd_quirk intel_dpcd_quirks[] = {
--- a/drivers/gpu/drm/i915/display/intel_quirks.h
+++ b/drivers/gpu/drm/i915/display/intel_quirks.h
@@ -20,6 +20,7 @@ enum intel_quirk_id {
 	QUIRK_LVDS_SSC_DISABLE,
 	QUIRK_NO_PPS_BACKLIGHT_POWER_HOOK,
 	QUIRK_FW_SYNC_LEN,
+	QUIRK_EDP_LIMIT_RATE_HBR2,
 };
 
 void intel_init_quirks(struct intel_display *display);


