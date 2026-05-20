Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB3A3546F0;
	Wed, 20 May 2026 18:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301962; cv=none; b=Yq3u0P7Rnw/vFjHT7h/kV5UHcHM6cLr0pf2ie0RuGB3hjKbCLHRW5m9nnpQYS4J3PmE53m3tyEQLzvnirTD60o7sW2xWeAGSyrh+mUb4XR8QwmIHXjRWr4awOSi/YtLLZpL2SJoPHGHX/EoJjvNfwDSLXaXWUReiLjbLYkr0rcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301962; c=relaxed/simple;
	bh=DPVVzfCDyKWobfpBVpQFi3gqFGkLJ3NXLRLJRjGLQ2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTG/fYpv8w/CFFoMJf8XfJB7yx3KzUyfZDTUTbzNid8JlLUWmL/tagBQpB5FxJ7XMXP3V36zuhPQArR8ATm6o9kRMez6mICVCKwWZAZQAHFQ16k9qgc2EQ1c+QzHWiMpSeWDf4gSyYtevrtWAB/1JDxf96F0YESfEpOb622jGeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5b9z22S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5b9z22S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBB31F000E9;
	Wed, 20 May 2026 18:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301961;
	bh=e4yEVY3A023g0MjgzVU7pTlgewkOQrSojAP9S31BGK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5b9z22SZl8jZwi4Lp37b3KuNBY+V597taXHC/9N+COs+GcXEwupZxq6Uu9fCKPqa
	 /OIj9RiVOW1/OxWgEDql3hjTOIQrV7rgGuHEubct5UPoCQlq1K9SWyquIC/5K0f7Kg
	 Z3AgUjvz6wZ6aG1OYT++QfSNJqaRl7pvg8+8UL9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Konyukhov <Alexander.Konyukhov@kaspersky.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/508] drm/komeda: fix integer overflow in AFBC framebuffer size check
Date: Wed, 20 May 2026 18:18:30 +0200
Message-ID: <20260520162100.497493244@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Alexander Konyukhov <Alexander.Konyukhov@kaspersky.com>

[ Upstream commit 779ec12c85c9e4547519e3903a371a3b26a289de ]

The AFBC framebuffer size validation calculates the minimum required
buffer size by adding the AFBC payload size to the framebuffer offset.
This addition is performed without checking for integer overflow.

If the addition oveflows, the size check may incorrectly succed and
allow userspace to provide an undersized drm_gem_object, potentially
leading to out-of-bounds memory access.

Add usage of check_add_overflow() to safely compute the minimum
required size and reject the framebuffer if an overflow is detected.
This makes the AFBC size validation more robust against malformed.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 65ad2392dd6d ("drm/komeda: Added AFBC support for komeda driver")
Signed-off-by: Alexander Konyukhov <Alexander.Konyukhov@kaspersky.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20260203134907.1587067-1-Alexander.Konyukhov@kaspersky.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_framebuffer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_framebuffer.c b/drivers/gpu/drm/arm/display/komeda/komeda_framebuffer.c
index df5da5a447555..b4f2b89651ff2 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_framebuffer.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_framebuffer.c
@@ -4,6 +4,8 @@
  * Author: James.Qian.Wang <james.qian.wang@arm.com>
  *
  */
+#include <linux/overflow.h>
+
 #include <drm/drm_device.h>
 #include <drm/drm_fb_dma_helper.h>
 #include <drm/drm_gem.h>
@@ -92,7 +94,9 @@ komeda_fb_afbc_size_check(struct komeda_fb *kfb, struct drm_file *file,
 	kfb->afbc_size = kfb->offset_payload + n_blocks *
 			 ALIGN(bpp * AFBC_SUPERBLK_PIXELS / 8,
 			       AFBC_SUPERBLK_ALIGNMENT);
-	min_size = kfb->afbc_size + fb->offsets[0];
+	if (check_add_overflow(kfb->afbc_size, fb->offsets[0], &min_size)) {
+		goto check_failed;
+	}
 	if (min_size > obj->size) {
 		DRM_DEBUG_KMS("afbc size check failed, obj_size: 0x%zx. min_size 0x%llx.\n",
 			      obj->size, min_size);
-- 
2.53.0



