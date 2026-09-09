Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AC257982E;
	Wed,  9 Sep 2026 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964123; cv=none; b=VbkAWJMrqIC+V2LiSoMYQXNYuC2gborr65aEKX0x1y0ldWfDHZxFSBUTXpUp9eTy+DxJ1yjtrmYhbIGD4IFSCibWSf3cMzbaka3/L8VepLxxf82bi91k71te8bSoH9pav4mMB8BrS6wDcVU2FLVY/tIuBzKI+ksKfJ6AlRXiFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964123; c=relaxed/simple;
	bh=jpktUb3X43BkO1mwJxUxkm3OJFsvDicybhpYZzWiQ4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2VziyDyg9msOOc+bT4kMIDSTrMxqYRjJ9gPHu3vyDt0QliquVP4Uedc5F9ja5d83Zo9uGbiYCvmhJe9jscF6NPPRbRYpKQu5wan1cb9BRPKO4ag0YeoAsx6ivFJ+ja5MK/dgd2l2Hyv3CkrpDzuK45fOQelePbz5Qrc/XCCmaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wULDv/jk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wULDv/jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBCF1F00A3A;
	Wed,  9 Sep 2026 14:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964121;
	bh=3EhH7vaGp1Emck9lbnFAkQlnrXEXOrnhBYmAJiOlVj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wULDv/jkLIzXPEeUzXDOyUB8GofG/XIEekxtEdXxI9SebosfyEmg02fCERr5C+uXP
	 d65BVF3suK+I3BdPp//n0AJiiuwbWQcWmQeJqXPHooNYLb7L0QMlL4/Ww1M8zbVFFA
	 avrJOTnW167I6iZuQA/KAOXAkQAdxAIGgb8l2hjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 312/583] media: v4l2-ctrls: Allow unknown HDR10 white point and luminance
Date: Wed,  9 Sep 2026 15:39:57 +0200
Message-ID: <20260909134248.817032464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1204,24 +1204,41 @@ static int std_validate_compound(const s
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


