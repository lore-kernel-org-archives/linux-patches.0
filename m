Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED31130E829;
	Sat, 30 May 2026 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161696; cv=none; b=ScgtFcPtBXJuwWmXqXIYflOCgcf3V/1HH4fCZtoUraMxMUYN1epbPw0MLjfsKg/ov7YoPnw8uk3W+bUTO+bKYv0gNKFcbVm3qQmUmL0k0dpFkneJTF9noQvGtcYPLJNHzjSTM6xrKMG65LzYAhggN0PaLKroyM3YEosT8UEq7Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161696; c=relaxed/simple;
	bh=QXfoZkVb1CQ5eVukMK5PgkbXaaYQrNrQsKlAV9yIFX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rpl5eIOQly7n9KELuABx4vynSK5G1bP/QaieivvdkjJR//uGY/rCauBtfNi1Ytlxu73tEoMxeAn6NFUsm00jA7ETndVO4c6eDqAdTztH+KNIUOG/HDkykeHVo+XxOTA/UDAUkzSd7F/XO7o6ELwZoXBWpyeme2kyHtS5vJFzE/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6hxig5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6hxig5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2BD1F00893;
	Sat, 30 May 2026 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161694;
	bh=MXQ6kJknd19HOSF2DqtuYAXB4jzlVg33qkfll7/j+ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6hxig5qms/3sr3tsPnyaIy32WeizBaPRTWZJ806NpMdrxvh9buytSsabla0tMa+M
	 kjWh7v1ZbnxnqpeoQSP1UqsCYP9CcAzrugqE5CiYzDvQ8YJnnLUw5P+vwUQTq/GnSk
	 By0uUvIHeRIR8d27Yvoym05g4QVT6mI/27VdsVTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 670/969] drm/i915: Extract intel_dbuf_mdclk_cdclk_ratio_update()
Date: Sat, 30 May 2026 18:03:14 +0200
Message-ID: <20260530160318.992459100@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Gustavo Sousa <gustavo.sousa@intel.com>

[ Upstream commit 66a0e0681392420b326f00ba732e6bda099eda29 ]

As of Xe2LPD, it is now possible to select the source of the MDCLK
as either the CD2XCLK or the CDCLK PLL.

Previous display IPs were hardcoded to use the CD2XCLK. For those, the
ratio between MDCLK and CDCLK remained constant, namely 2. For Xe2LPD,
when we select the CDCLK PLL as the source, the ratio will vary
according to the squashing configuration (since the cd2x divisor is
fixed for all supported configurations).

To help the transition to supporting changes in the ratio, extract the
function intel_dbuf_mdclk_cdclk_ratio_update() from the existing logic
and call it using 2 as hardcoded ratio. Upcoming changes will use that
function for updates in the ratio due to CDCLK changes.

Bspec: 50057, 69445, 49213, 68868
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240312163639.172321-5-gustavo.sousa@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: a97c88a176b6 ("drm/i915/wm: Verify the correct plane DDB entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 30 +++++++++++++-------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index b6951881c0570..e553192e12b76 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3346,6 +3346,21 @@ int intel_dbuf_init(struct drm_i915_private *i915)
 	return 0;
 }
 
+static void intel_dbuf_mdclk_cdclk_ratio_update(struct drm_i915_private *i915,
+						u8 ratio,
+						bool joined_mbus)
+{
+	enum dbuf_slice slice;
+
+	if (joined_mbus)
+		ratio *= 2;
+
+	for_each_dbuf_slice(i915, slice)
+		intel_de_rmw(i915, DBUF_CTL_S(slice),
+			     DBUF_MIN_TRACKER_STATE_SERVICE_MASK,
+			     DBUF_MIN_TRACKER_STATE_SERVICE(ratio - 1));
+}
+
 /*
  * Configure MBUS_CTL and all DBUF_CTL_S of each slice to join_mbus state before
  * update the request state of all DBUS slices.
@@ -3353,8 +3368,7 @@ int intel_dbuf_init(struct drm_i915_private *i915)
 static void update_mbus_pre_enable(struct intel_atomic_state *state)
 {
 	struct drm_i915_private *i915 = to_i915(state->base.dev);
-	u32 mbus_ctl, dbuf_min_tracker_val;
-	enum dbuf_slice slice;
+	u32 mbus_ctl;
 	const struct intel_dbuf_state *dbuf_state =
 		intel_atomic_get_new_dbuf_state(state);
 
@@ -3365,24 +3379,18 @@ static void update_mbus_pre_enable(struct intel_atomic_state *state)
 	 * TODO: Implement vblank synchronized MBUS joining changes.
 	 * Must be properly coordinated with dbuf reprogramming.
 	 */
-	if (dbuf_state->joined_mbus) {
+	if (dbuf_state->joined_mbus)
 		mbus_ctl = MBUS_HASHING_MODE_1x4 | MBUS_JOIN |
 			MBUS_JOIN_PIPE_SELECT_NONE;
-		dbuf_min_tracker_val = DBUF_MIN_TRACKER_STATE_SERVICE(3);
-	} else {
+	else
 		mbus_ctl = MBUS_HASHING_MODE_2x2 |
 			MBUS_JOIN_PIPE_SELECT_NONE;
-		dbuf_min_tracker_val = DBUF_MIN_TRACKER_STATE_SERVICE(1);
-	}
 
 	intel_de_rmw(i915, MBUS_CTL,
 		     MBUS_HASHING_MODE_MASK | MBUS_JOIN |
 		     MBUS_JOIN_PIPE_SELECT_MASK, mbus_ctl);
 
-	for_each_dbuf_slice(i915, slice)
-		intel_de_rmw(i915, DBUF_CTL_S(slice),
-			     DBUF_MIN_TRACKER_STATE_SERVICE_MASK,
-			     dbuf_min_tracker_val);
+	intel_dbuf_mdclk_cdclk_ratio_update(i915, 2, dbuf_state->joined_mbus);
 }
 
 void intel_dbuf_pre_plane_update(struct intel_atomic_state *state)
-- 
2.53.0



