Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EAA23BD03;
	Sat, 12 Sep 2026 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221852; cv=none; b=bRpoWxZUt62UCRy78xOvpqCrGmCrX+IvW2g4R59ik+51DSri1MOSvyV94Z3iVr2dt02OjaCwOI0JmWux0TK4AZXBvFO6A2cZIF+GTwnUzAvmf8OwE8lFc8D0aARlbAnpE1jZ4lsTeglvfvERfmt3g34O0UukbqvYf6gH0cTRV8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221852; c=relaxed/simple;
	bh=8KGkHUnMjOyvpZcOldgz0l0xhaC/cKNNqCMnCWn6vbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXpoMgUr3oNuSX/96GNdf4OqvmZ3mHxHzinNmaWS0Sd19JBEPWrX3O5fJlpTNhlpc6GjIlpnAV9jfkbr4OK0UcOKEmjFenR/f6bGaGiuG6d/1rg7eOe/VCXqjbrzAE6SD4bPrdwYyi0Ol5nNhTiapNhY2YPGAjDvW9v51NxHBTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyizRxDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyizRxDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF581F000FF;
	Sat, 12 Sep 2026 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221851;
	bh=u17/bJJJhEpJ1f2NwSgR2LZqYSaCV5dMWY7u+OrbA+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyizRxDjo5+6k9BeQ/YuHvzb+60bo2YuLkG3R1QCMUOOC+1sPAdDfe5UMm1ZuVA2X
	 nmziV4obyEnp/04IOrd2c+0IgNvNKL+6MTBoUgwrKOVLidz3ekzoCYZDx6FfBgW8l9
	 zB1m6AWwsM5Nqna76zlqAafP7Y7cHLrX/PFm2NOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0466/1424] media: v4l2-ctrls: Allow unknown HDR10 white point and luminance
Date: Sat, 12 Sep 2026 08:48:18 +0200
Message-ID: <20260912065617.723021959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

commit 49af0c7cad889f7dabe5cf080b019392066122a3 upstream.

SMPTE ST 2086 defines the nominal ranges for mastering display
chromaticity and luminance values. Its Annex A also documents that
CTA 861-G uses zero maximum and minimum luminance values to signal
that the corresponding values are unknown, and the xy chromaticity
coordinate (0, 0) to signal that the white point chromaticity is
unknown.

The V4L2 HDR10 mastering display compound control currently rejects
these values. Consequently, an unknown white point or luminance value
prevents the entire compound control from being updated, making the
other valid mastering display metadata unavailable to userspace.

Accept (0, 0) as an unknown white point and zero as an unknown maximum
or minimum mastering luminance. Continue to reject partially zero white
point coordinates and non-zero values outside the nominal ranges.
Display primary validation remains unchanged.

Document the newly accepted unknown values in the V4L2 userspace API.

Fixes: 1ad0de78e794 ("media: v4l: Add HDR10 static metadata controls")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/userspace-api/media/v4l/ext-ctrls-colorimetry.rst |   12 ++
 drivers/media/v4l2-core/v4l2-ctrls-core.c                       |   49 ++++++----
 2 files changed, 44 insertions(+), 17 deletions(-)

--- a/Documentation/userspace-api/media/v4l/ext-ctrls-colorimetry.rst
+++ b/Documentation/userspace-api/media/v4l/ext-ctrls-colorimetry.rst
@@ -79,15 +79,25 @@ Colorimetry Control IDs
       - ``white_point_x``
       - Specifies the normalized x chromaticity coordinate of the white
         point of the mastering display in increments of 0.00002.
+        When both ``white_point_x`` and ``white_point_y`` are zero,
+        the white point chromaticity is unknown. If either coordinate is
+        non-zero, both coordinates shall be within their valid ranges.
     * - __u16
       - ``white_point_y``
       - Specifies the normalized y chromaticity coordinate of the white
         point of the mastering display in increments of 0.00002.
+        When both ``white_point_x`` and ``white_point_y`` are zero,
+        the white point chromaticity is unknown. If either coordinate is
+        non-zero, both coordinates shall be within their valid ranges.
     * - __u32
       - ``max_luminance``
       - Specifies the nominal maximum display luminance of the mastering
         display in units of 0.0001 cd/m\ :sup:`2`.
+        A value of zero indicates that the nominal maximum display
+        luminance is unknown.
     * - __u32
       - ``min_luminance``
-      - specifies the nominal minimum display luminance of the mastering
+      - Specifies the nominal minimum display luminance of the mastering
         display in units of 0.0001 cd/m\ :sup:`2`.
+        A value of zero indicates that the nominal minimum display
+        luminance is unknown.
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -1130,24 +1130,41 @@ static int std_validate_compound(const s
 				return -EINVAL;
 		}
 
-		if (p_hdr10_mastering->white_point_x <
-			V4L2_HDR10_MASTERING_WHITE_POINT_X_LOW ||
-		    p_hdr10_mastering->white_point_x >
-			V4L2_HDR10_MASTERING_WHITE_POINT_X_HIGH ||
-		    p_hdr10_mastering->white_point_y <
-			V4L2_HDR10_MASTERING_WHITE_POINT_Y_LOW ||
-		    p_hdr10_mastering->white_point_y >
-			V4L2_HDR10_MASTERING_WHITE_POINT_Y_HIGH)
+		/*
+		 * SMPTE ST 2086 Annex A documents that CTA 861-G uses
+		 * (0, 0) to indicate that the white point chromaticity
+		 * is unknown.
+		 */
+		if (p_hdr10_mastering->white_point_x ||
+		    p_hdr10_mastering->white_point_y) {
+			if (p_hdr10_mastering->white_point_x <
+				V4L2_HDR10_MASTERING_WHITE_POINT_X_LOW ||
+			    p_hdr10_mastering->white_point_x >
+				V4L2_HDR10_MASTERING_WHITE_POINT_X_HIGH ||
+			    p_hdr10_mastering->white_point_y <
+				V4L2_HDR10_MASTERING_WHITE_POINT_Y_LOW ||
+			    p_hdr10_mastering->white_point_y >
+				V4L2_HDR10_MASTERING_WHITE_POINT_Y_HIGH)
+				return -EINVAL;
+		}
+
+		/*
+		 * SMPTE ST 2086 Annex A documents that CTA 861-G uses zero
+		 * maximum and minimum luminance values to indicate that
+		 * the corresponding values are unknown.
+		 */
+		if (p_hdr10_mastering->max_display_mastering_luminance &&
+		    (p_hdr10_mastering->max_display_mastering_luminance <
+				V4L2_HDR10_MASTERING_MAX_LUMA_LOW ||
+		     p_hdr10_mastering->max_display_mastering_luminance >
+				V4L2_HDR10_MASTERING_MAX_LUMA_HIGH))
 			return -EINVAL;
 
-		if (p_hdr10_mastering->max_display_mastering_luminance <
-			V4L2_HDR10_MASTERING_MAX_LUMA_LOW ||
-		    p_hdr10_mastering->max_display_mastering_luminance >
-			V4L2_HDR10_MASTERING_MAX_LUMA_HIGH ||
-		    p_hdr10_mastering->min_display_mastering_luminance <
-			V4L2_HDR10_MASTERING_MIN_LUMA_LOW ||
-		    p_hdr10_mastering->min_display_mastering_luminance >
-			V4L2_HDR10_MASTERING_MIN_LUMA_HIGH)
+		if (p_hdr10_mastering->min_display_mastering_luminance &&
+		    (p_hdr10_mastering->min_display_mastering_luminance <
+				V4L2_HDR10_MASTERING_MIN_LUMA_LOW ||
+		     p_hdr10_mastering->min_display_mastering_luminance >
+				V4L2_HDR10_MASTERING_MIN_LUMA_HIGH))
 			return -EINVAL;
 
 		/* The following restriction comes from ITU-T Rec. H.265 spec */


