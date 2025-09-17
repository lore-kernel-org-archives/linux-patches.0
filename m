Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B6A1F3BA2;
	Wed, 17 Sep 2025 12:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112854; cv=none; b=NEOO3GcznoijrojN4h2MM2iP6Rcd3TrE55Wk7pmpvp0/z1Alg57IN9D/2o55/rhnjqI8id/goonim7ZTu3r6QJW0DMGBuQXiwTKGDCWCuPbkSR8aSNeP9bsrsYwK5hSEsldkt18PqeA2uhv0qrgFjMvKDiCJ0SVaN2zYr/LLaBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112854; c=relaxed/simple;
	bh=j904dOCUeD3aSsTsq7vz/bHsxJMCZdtTBs5YPnCjR+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sCIAUnSLe0wYqtXbtN5GcGIi3L1x//1M2q/miCiUST8DcJ9f/5kOktNECGwyXvhbbQWjLy0QjFQDU3yWIMm4xfD9wCIS1wztXMhIwbGRc/M7BB02GVw6VmvohleNw8TwXkihvQbZ0WGpj/RSb0NO0U+TmHBy6h8ftK5E3gp336Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDEiiQY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDEiiQY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C7AC4AF09;
	Wed, 17 Sep 2025 12:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112854;
	bh=j904dOCUeD3aSsTsq7vz/bHsxJMCZdtTBs5YPnCjR+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDEiiQY+gg9h4G3NgtySBjguqa9zmNzGTEmJkdclTvx32jGAU3YAsrZWKkh/YX5TS
	 gI+Cc2llPixbQyffRBlHigzv4SDZgIXx8QDcBSRGBrApMPjjHeHyDc4N+ZX+eljbKi
	 fKW+wT5ohX53JbCW0k452A+BE702Sw1chYwBenZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.16 095/189] drm/dp: Add an EDID quirk for the DPCD register access probe
Date: Wed, 17 Sep 2025 14:33:25 +0200
Message-ID: <20250917123354.176186541@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit b87ed522b3643f096ef183ed0ccf2d2b90ddd513 upstream.

Reading DPCD registers has side-effects and some of these can cause a
problem for instance during link training. Based on this it's better to
avoid the probing quirk done before each DPCD register read, limiting
this to the monitor which requires it. Add an EDID quirk for this. Leave
the quirk enabled by default, allowing it to be disabled after the
monitor is detected.

v2: Fix lockdep wrt. drm_dp_aux::hw_mutex when calling
    drm_dp_dpcd_set_probe_quirk() with a dependent lock already held.
v3: Add a helper for determining if DPCD probing is needed. (Jani)
v4:
- s/drm_dp_dpcd_set_probe_quirk/drm_dp_dpcd_set_probe (Jani)
- Fix documentation of drm_dp_dpcd_set_probe().
- Add comment at the end of internal quirk entries.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250609125556.109538-1-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c |   42 ++++++++++++++++++++++----------
 drivers/gpu/drm/drm_edid.c              |    8 ++++++
 include/drm/display/drm_dp_helper.h     |    6 ++++
 include/drm/drm_edid.h                  |    3 ++
 4 files changed, 46 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -692,6 +692,34 @@ void drm_dp_dpcd_set_powered(struct drm_
 EXPORT_SYMBOL(drm_dp_dpcd_set_powered);
 
 /**
+ * drm_dp_dpcd_set_probe() - Set whether a probing before DPCD access is done
+ * @aux: DisplayPort AUX channel
+ * @enable: Enable the probing if required
+ */
+void drm_dp_dpcd_set_probe(struct drm_dp_aux *aux, bool enable)
+{
+	WRITE_ONCE(aux->dpcd_probe_disabled, !enable);
+}
+EXPORT_SYMBOL(drm_dp_dpcd_set_probe);
+
+static bool dpcd_access_needs_probe(struct drm_dp_aux *aux)
+{
+	/*
+	 * HP ZR24w corrupts the first DPCD access after entering power save
+	 * mode. Eg. on a read, the entire buffer will be filled with the same
+	 * byte. Do a throw away read to avoid corrupting anything we care
+	 * about. Afterwards things will work correctly until the monitor
+	 * gets woken up and subsequently re-enters power save mode.
+	 *
+	 * The user pressing any button on the monitor is enough to wake it
+	 * up, so there is no particularly good place to do the workaround.
+	 * We just have to do it before any DPCD access and hope that the
+	 * monitor doesn't power down exactly after the throw away read.
+	 */
+	return !aux->is_remote && !READ_ONCE(aux->dpcd_probe_disabled);
+}
+
+/**
  * drm_dp_dpcd_read() - read a series of bytes from the DPCD
  * @aux: DisplayPort AUX channel (SST or MST)
  * @offset: address of the (first) register to read
@@ -712,19 +740,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 {
 	int ret;
 
-	/*
-	 * HP ZR24w corrupts the first DPCD access after entering power save
-	 * mode. Eg. on a read, the entire buffer will be filled with the same
-	 * byte. Do a throw away read to avoid corrupting anything we care
-	 * about. Afterwards things will work correctly until the monitor
-	 * gets woken up and subsequently re-enters power save mode.
-	 *
-	 * The user pressing any button on the monitor is enough to wake it
-	 * up, so there is no particularly good place to do the workaround.
-	 * We just have to do it before any DPCD access and hope that the
-	 * monitor doesn't power down exactly after the throw away read.
-	 */
-	if (!aux->is_remote) {
+	if (dpcd_access_needs_probe(aux)) {
 		ret = drm_dp_dpcd_probe(aux, DP_TRAINING_PATTERN_SET);
 		if (ret < 0)
 			return ret;
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -248,6 +248,14 @@ static const struct edid_quirk {
 	/* OSVR HDK and HDK2 VR Headsets */
 	EDID_QUIRK('S', 'V', 'R', 0x1019, BIT(EDID_QUIRK_NON_DESKTOP)),
 	EDID_QUIRK('A', 'U', 'O', 0x1111, BIT(EDID_QUIRK_NON_DESKTOP)),
+
+	/*
+	 * @drm_edid_internal_quirk entries end here, following with the
+	 * @drm_edid_quirk entries.
+	 */
+
+	/* HP ZR24w DP AUX DPCD access requires probing to prevent corruption. */
+	EDID_QUIRK('H', 'W', 'P', 0x2869, BIT(DRM_EDID_QUIRK_DP_DPCD_PROBE)),
 };
 
 /*
--- a/include/drm/display/drm_dp_helper.h
+++ b/include/drm/display/drm_dp_helper.h
@@ -523,10 +523,16 @@ struct drm_dp_aux {
 	 * @no_zero_sized: If the hw can't use zero sized transfers (NVIDIA)
 	 */
 	bool no_zero_sized;
+
+	/**
+	 * @dpcd_probe_disabled: If probing before a DPCD access is disabled.
+	 */
+	bool dpcd_probe_disabled;
 };
 
 int drm_dp_dpcd_probe(struct drm_dp_aux *aux, unsigned int offset);
 void drm_dp_dpcd_set_powered(struct drm_dp_aux *aux, bool powered);
+void drm_dp_dpcd_set_probe(struct drm_dp_aux *aux, bool enable);
 ssize_t drm_dp_dpcd_read(struct drm_dp_aux *aux, unsigned int offset,
 			 void *buffer, size_t size);
 ssize_t drm_dp_dpcd_write(struct drm_dp_aux *aux, unsigned int offset,
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -110,6 +110,9 @@ struct detailed_data_string {
 #define DRM_EDID_CVT_FLAGS_REDUCED_BLANKING  (1 << 4)
 
 enum drm_edid_quirk {
+	/* Do a dummy read before DPCD accesses, to prevent corruption. */
+	DRM_EDID_QUIRK_DP_DPCD_PROBE,
+
 	DRM_EDID_QUIRK_NUM,
 };
 


