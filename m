Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A967B432E98;
	Thu, 30 Jul 2026 15:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424269; cv=none; b=WbrtD8cX0taXaUDd6+1IIfgaOQYTHKbRwpzl5SdSfvyt20H5i5hl+W0iMK6KGwql6dK5+wlqrpX7UN9B8C+UUV3eAAiFJPsNnrcWHINjl0kkvMmj1k/oVTxOaMKJE53siHX88K2ub0LyEzDAYYymrpR//2y8RVHUaYEodMpzX/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424269; c=relaxed/simple;
	bh=GY1XN02zuXK5Fxn9wYOkxyjo6MyiSMXZUCeqGDfykik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+n8DccmfAOiQejwfrlZUgonu4Q4y41HQwugbqvn91/MFWZNSjOBS5c856AvCRtVkzBPq+PgoHUvcur60+qS//BNw93mCPC94xIphg7wCgl/eGdQ13n3XJmz2UVcls2OL4SS4pJ5zCTfP49Y5fk6ka2affGoWPsI1ngWJ8Nnoxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RV+szUFv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RV+szUFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FC11F000E9;
	Thu, 30 Jul 2026 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424267;
	bh=9hCoRFFr6ONgyGLppSGIhHoOh7RFE2PJ8UT1C+jb5F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RV+szUFvshwgHlPwecgHaFo/0MOVSyIa8BHi9vOk5N1kGV2XD4T+Ymg3RXGCy4FiM
	 2OLCiOSCqZ7ShZW7FUOLlzCkVrz87cmpMR90HGrYdBNONtN8+vhm3RZaQdZprrkwof
	 Qf8pUpIb7g4ByJEc1BemrDqNYGkXT1KCkqRms4MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sashiko <sashiko-bot@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.18 334/675] drm/sysfb: Avoid truncating maximum stride
Date: Thu, 30 Jul 2026 16:11:04 +0200
Message-ID: <20260730141452.227299335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 9206b22fb959f4a9cf1921f34aed0df1dcb1ab04 upstream.

Passing a maximum as 64-bit type to drm_sysfb_get_validated_int0()
can truncate the value to 32 bits. Use drm_sysfb_get_validated_size0(),
which uses 64-bit arithmetics. Then test the returned stride against
the limits of int to avoid truncations in the returned value. A valid
stride is in the range of [1, INT_MAX] inclusive.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/dri-devel/20260617114016.5A5991F000E9@smtp.kernel.org/
Fixes: 32ae90c66fb6 ("drm/sysfb: Add efidrm for EFI displays")
Fixes: a84eb6abe2b6 ("drm/sysfb: Add vesadrm for VESA displays")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.16+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260618084327.46567-5-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c
+++ b/drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c
@@ -56,11 +56,17 @@ int drm_sysfb_get_stride_si(struct drm_d
 			    unsigned int width, unsigned int height, u64 size)
 {
 	u64 lfb_linelength = si->lfb_linelength;
+	s64 stride;
 
 	if (!lfb_linelength)
 		lfb_linelength = drm_format_info_min_pitch(format, 0, width);
 
-	return drm_sysfb_get_validated_int0(dev, "stride", lfb_linelength, div64_u64(size, height));
+	stride = drm_sysfb_get_validated_size0(dev, "stride", lfb_linelength,
+					       div64_u64(size, height));
+	if (stride < INT_MIN || stride > INT_MAX)
+		return -EINVAL;
+
+	return (int)stride; /* stride or negative errno code */
 }
 EXPORT_SYMBOL(drm_sysfb_get_stride_si);
 


