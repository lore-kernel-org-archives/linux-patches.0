Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8D444213E;
	Thu, 30 Jul 2026 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422239; cv=none; b=H1//T2AGu4hsuaq1d4vammy3N3IuTP+GXvovlyEwvlbGq2OUTbj/ts4NQF2mPJ+42pnWUnbR19mfSqJ7Uj+0ysOVYWOLW09izc+PNzin5xIPGigBB9wzdSr91dXKsXfXVWtiApIXbMrkDNt62W9PABeLtm5lnRYa4HV4gs3r7VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422239; c=relaxed/simple;
	bh=64ti+WC1Zmpv4qZ8vGqWnQWBqcCi5vJ8TJSluSxyyk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xze4z16RIh6M/dfBw+KNhw7JvmkiMvAOMBoBXayTvFV6XK69fuP6ZG/L6PK2ICch6MQ8y62H4vwgj7dmFRZ6ApEJrplj1e097uwjPWxgj+2sx+QHMy77O5mFSSLKf6pVxQz7iuQtv5cgt8FqaZ0s39xXEECgzlD9oQfLCPFzMc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duNekN4O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duNekN4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73441F000E9;
	Thu, 30 Jul 2026 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422238;
	bh=P0CbWWkeIejRCd6IOeizmeRuI+wyPEwCh9aPqG4XyCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duNekN4OhGJCpyiCbJm+MqZ2GEP+AVFsf2zQG9pzjaGW+/2HTetvUsUJU8qX/rfMs
	 SxWrReDAD1L/ueW4T7+E3OrdNpcEe2eSIDf6lyyaUdrFnxf7aRMtw2Wamm2VubXQ0X
	 G/Zf8kJyGWpnHC4XweD/2UHilsPyp6+JbEpOvrb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 7.1 372/744] drm/i915/cdclk: Fix up CDCLK_FREQ_DECIMAL without a full PLL re-enable
Date: Thu, 30 Jul 2026 16:10:45 +0200
Message-ID: <20260730141452.194521228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 2ee8dbd880b14fb0b5115bf2353c7900aa33b95b upstream.

The GOP (and even Bspec on some platforms) is a bit inconsistent
on what the CDCLK_FREQ_DECIMAL divider should be. Currently any
mismatch there causes a full CDCLK PLL disable+re-enable, which
we really don't want to do if any displays are currently active.
Let's instead just reprogram CDCLK_FREQ_DECIMAL when that is the
only thing amiss. For any other (more serious) mismatch we still
punt to the full PLL reprogramming.

We also need to tweak the bxt_cdclk_cd2x_pipe() stuff a bit to
consistently select pipe==NONE since we have no idea which pipes
are enabled at this point. Since we're not actually changing the
CDCLK frequency here we don't need to sync the update to any
pipe.

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16209
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260612173653.7830-2-ville.syrjala@linux.intel.com
Reviewed-by: Michał Grzelak <michal.grzelak@intel.com>
(cherry picked from commit 3f9de66f8acbf8ff45a91b4920605ed10c6b7c06)
Fixes: ba91b9eecb47 ("drm/i915/cdclk: Decouple cdclk from state->modeset")
Fixes: d66a21947e21 ("drm/i915/bxt: Sanitize CDCLK to fix breakage during S4 resume")
Fixes: c73666f394fc ("drm/i915/skl: If needed sanitize bios programmed cdclk")
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c |   41 ++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -1256,9 +1256,22 @@ static void skl_sanitize_cdclk(struct in
 	cdctl = intel_de_read(display, CDCLK_CTL);
 	expected = (cdctl & CDCLK_FREQ_SEL_MASK) |
 		skl_cdclk_decimal(display->cdclk.hw.cdclk);
-	if (cdctl == expected)
-		/* All well; nothing to sanitize */
-		return;
+
+	if (cdctl != expected) {
+		cdctl &= ~CDCLK_FREQ_DECIMAL_MASK;
+		cdctl |= expected & CDCLK_FREQ_DECIMAL_MASK;
+
+		if (cdctl != expected)
+			goto sanitize;
+
+		drm_dbg_kms(display->drm, "Sanitizing CDCLK decimal divider (CDCLK_CTL 0x%x, expected 0x%x)\n",
+			    intel_de_read(display, CDCLK_CTL), expected);
+
+		intel_de_write(display, CDCLK_CTL, expected);
+	}
+
+	/* All well; nothing to sanitize */
+	return;
 
 sanitize:
 	drm_dbg_kms(display->drm, "Sanitizing cdclk programmed by pre-os\n");
@@ -2354,11 +2367,25 @@ static void bxt_sanitize_cdclk(struct in
 	 * (PIPE_NONE).
 	 */
 	cdctl &= ~bxt_cdclk_cd2x_pipe(display, INVALID_PIPE);
-	expected &= ~bxt_cdclk_cd2x_pipe(display, INVALID_PIPE);
+	cdctl |= bxt_cdclk_cd2x_pipe(display, INVALID_PIPE);
 
-	if (cdctl == expected)
-		/* All well; nothing to sanitize */
-		return;
+	if (cdctl != expected) {
+		if (DISPLAY_VER(display) < 20) {
+			cdctl &= ~CDCLK_FREQ_DECIMAL_MASK;
+			cdctl |= expected & CDCLK_FREQ_DECIMAL_MASK;
+		}
+
+		if (cdctl != expected)
+			goto sanitize;
+
+		drm_dbg_kms(display->drm, "Sanitizing CDCLK decimal divider (CDCLK_CTL 0x%x, expected 0x%x)\n",
+			    intel_de_read(display, CDCLK_CTL), expected);
+
+		intel_de_write(display, CDCLK_CTL, expected);
+	}
+
+	/* All well; nothing to sanitize */
+	return;
 
 sanitize:
 	drm_dbg_kms(display->drm, "Sanitizing cdclk programmed by pre-os\n");


