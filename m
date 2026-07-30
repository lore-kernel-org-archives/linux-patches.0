Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F01F3D75C4;
	Thu, 30 Jul 2026 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422291; cv=none; b=pg1xpR7JUkfHswdnVOwCQqWasyGefQ3iuMyMqHnuy6XQ7TebvJM8e61XqM8ERDTNM0/HOewCTjyJzctvt9YaMxbh5QnBaQ8ZbOonSsBDh23e0nTH5LRfNv5hnswnw1neN9ukAFRRP/JKt2O/nRHxxRFFNN7H0oPlH+34fW4FBU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422291; c=relaxed/simple;
	bh=BLEasqNY67LRmFceQjRWQo3ZqZCbuAzVMH8t0yvlY/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxbMJu9/BvioDwqCr+CwzEziFQQihYEYJIDL0u2gHc8xocqiiQwL1RmCARIcddr96oQsvgODN94aKt5hq9mmaJKpdwXKuL1kw5iCoyf+LhbalRBZZANXjA1e4HcV8xL5KaVa65G4bRvE69s0C9UQ7SVAJaAGF/oAQN1dC7DSECs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgjbtJAt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgjbtJAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE41E1F000E9;
	Thu, 30 Jul 2026 14:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422290;
	bh=CwpbS7vnTrYtlqaZ2peuRHloZDVBRTveTiaDA5ynQwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgjbtJAt92i2Uxdd0Qh7tvpay6OsVLsKHZBlCZi0bIrlivKT57AQjD5zbSRM7HsSM
	 PtRn5moo9akBxOwAodQFUBu1cTIZ/e+W3ivBRrCA8eicJifHvCfbW2U5PHMqUkpbiG
	 kUhOfsMkpEddqJJeDcu3/uakh26gNDpzCfyaXLQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sashiko <sashiko-bot@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 7.1 388/744] drm/sysfb: Avoid possible truncation with calculating visible size
Date: Thu, 30 Jul 2026 16:11:01 +0200
Message-ID: <20260730141452.533821620@linuxfoundation.org>
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

commit b771974988ec7ce077a7246fa0fa588c246fe581 upstream.

Calculating the visible size of the system framebuffer can result in
truncation of the result. The calculation uses 32-bit arithmetics,
which can overflow if the values for height and stride are large. Fix
the issue by multiplying with mul_u32_u32().

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 32ae90c66fb6 ("drm/sysfb: Add efidrm for EFI displays")
Fixes: a84eb6abe2b6 ("drm/sysfb: Add vesadrm for VESA displays")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/dri-devel/20260617114027.1F2A71F000E9@smtp.kernel.org/
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.16+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260618084327.46567-3-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c
+++ b/drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c
@@ -2,6 +2,7 @@
 
 #include <linux/export.h>
 #include <linux/limits.h>
+#include <linux/math64.h>
 #include <linux/minmax.h>
 #include <linux/screen_info.h>
 
@@ -73,7 +74,7 @@ EXPORT_SYMBOL(drm_sysfb_get_stride_si);
 u64 drm_sysfb_get_visible_size_si(struct drm_device *dev, const struct screen_info *si,
 				  unsigned int height, unsigned int stride, u64 size)
 {
-	u64 vsize = height * stride;
+	u64 vsize = mul_u32_u32(height, stride);
 
 	return drm_sysfb_get_validated_size0(dev, "visible size", vsize, size);
 }


