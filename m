Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B2343B6D1;
	Thu, 30 Jul 2026 14:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422261; cv=none; b=ozqqD0PbLSzM3zMGYsBvXkRKkA+OzNUtGZaIaA/ycB7JOpIrfHNrTzTtvnbxdNs+kiGGBR/P1OLh5ts2RbjZO0iIUON1fFbYbBmCL9f4VJ6vkXMxAsKnR9i2w1hxMjo6AuMocWGYpieoZmBlDSFOeic47Y2HTk4/BZI/BqvyXkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422261; c=relaxed/simple;
	bh=JauKDFkMPh09nsBNXLflOWcdqvnLTXoOjoz8zryrrPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAcRLiCaXHnTqJjj7VfSrBZYOWSc16pxLYnl3VeUHNsIlH6DvaN2+4TrFE1+Zdm5yjEonYGxbMf4n/ifjzYtsxPasozmL5WjtBz95pMYy5dLeymxAmw3gxfEGi3rezOybKiEOa0yH04C94xG/JQXEABH/dej4l+HoWI1lgypVOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXcPswhJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXcPswhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397081F000E9;
	Thu, 30 Jul 2026 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422259;
	bh=vXfoV7s+buFtfmsDqlaZbxjHaRInprpggMemb9fpdMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXcPswhJu0llv5Yer9Y5K4oqBBo1UUOS+waND1gAdY/lznx56DntGbFgD1DM2YFT8
	 OlJsuorWYd42YTklPFd3G89vvu2KZ5yjE2ChzOHpUkFqhTOxutWkGcsK9kftvGr/u0
	 8XsX/2erIEG7xeJKpIvqz139oBGNuFKE9tmRcFzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sashiko <sashiko-bot@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 7.1 379/744] drm/sysfb: Avoid truncating maximum stride
Date: Thu, 30 Jul 2026 16:10:52 +0200
Message-ID: <20260730141452.342356347@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


