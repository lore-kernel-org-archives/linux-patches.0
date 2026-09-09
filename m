Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313BB4F55A5;
	Wed,  9 Sep 2026 14:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964382; cv=none; b=hFYTq4z60PFhDxqxJMKx3iyj1+6Fbtod26SkekTwjjeHvNP4aCqMnZyccz3CvITD6KYIf50vqtEMgAj6OCfbvcjLQXdVjDnpj1S3uju9BXQxjpBQ8AXHPPexxWlzc6Y0uFybfpxN21BQX9D60p6BPlx7Q+G8swBIogVR8Qct62k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964382; c=relaxed/simple;
	bh=A0zhfI18BaD3kx+dTfPS61RZ9FJA9GEuDW63kzjOBMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xs1fxVbLaPfAecnru2qutHTOzTF1GqXGaOdoPBE3yKkUy181Rzydec94t3lO2a4hXZiZ14EBHab9yxbdhqCPPObY9Nd0k620J6V6Kj5FHwRGInvwW1tKvCvZ/cAaJ5TUbl9U3up7AScelT7u/qWZNVSm7AuCLIGC/S0m6hrHiZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KA7rEuKO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KA7rEuKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48361F00A3A;
	Wed,  9 Sep 2026 14:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964381;
	bh=MVB1CqwTuBjoRQhRpTdIfF2qw6Q0ap7Kr8XGpHWBDL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KA7rEuKOyUl9FOQmzisOA07+GSjiBuSiXSvvgSctxit6ebe+XlQIkTzExkmdQhEFf
	 Ku191BUNYjELWzTVSN7lwJOHaSnHoulKigfntX5OxvPH35k66m7Cq420ipJT2GMBlO
	 pl3CY+NRaOBDPQwLV2u9XkUGg82uBNrlEpt03zL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.18 404/583] drm/sysfb: simpledrm: Improve framebuffer-size validation
Date: Wed,  9 Sep 2026 15:41:29 +0200
Message-ID: <20260909134251.992309806@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 03f1a3545b721fa7fdadd00080e237519a286a97 upstream.

Validate the framebuffer size from the firmware against the
limitations of struct drm_display_mode. The type only stores sizes
in 16-bit fields. Fail probing on errors.

v2:
- remove unused function simplefb_get_validated_int0() (Sashiko)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Cc: <stable@vger.kernel.org> # v5.14+
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Link: https://patch.msgid.link/20260625094509.157581-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/simpledrm.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/sysfb/simpledrm.c
+++ b/drivers/gpu/drm/sysfb/simpledrm.c
@@ -44,13 +44,6 @@ simplefb_get_validated_int(struct drm_de
 	return drm_sysfb_get_validated_int(dev, name, value, INT_MAX);
 }
 
-static int
-simplefb_get_validated_int0(struct drm_device *dev, const char *name,
-			    uint32_t value)
-{
-	return drm_sysfb_get_validated_int0(dev, name, value, INT_MAX);
-}
-
 static const struct drm_format_info *
 simplefb_get_validated_format(struct drm_device *dev, const char *format_name)
 {
@@ -84,14 +77,14 @@ static int
 simplefb_get_width_pd(struct drm_device *dev,
 		      const struct simplefb_platform_data *pd)
 {
-	return simplefb_get_validated_int0(dev, "width", pd->width);
+	return drm_sysfb_get_validated_int0(dev, "width", pd->width, U16_MAX);
 }
 
 static int
 simplefb_get_height_pd(struct drm_device *dev,
 		       const struct simplefb_platform_data *pd)
 {
-	return simplefb_get_validated_int0(dev, "height", pd->height);
+	return drm_sysfb_get_validated_int0(dev, "height", pd->height, U16_MAX);
 }
 
 static int
@@ -140,7 +133,7 @@ simplefb_get_width_of(struct drm_device
 
 	if (ret)
 		return ret;
-	return simplefb_get_validated_int0(dev, "width", width);
+	return drm_sysfb_get_validated_int0(dev, "width", width, U16_MAX);
 }
 
 static int
@@ -151,7 +144,7 @@ simplefb_get_height_of(struct drm_device
 
 	if (ret)
 		return ret;
-	return simplefb_get_validated_int0(dev, "height", height);
+	return drm_sysfb_get_validated_int0(dev, "height", height, U16_MAX);
 }
 
 static int


