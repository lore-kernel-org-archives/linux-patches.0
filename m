Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B8329B78B;
	Sat, 30 May 2026 18:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164111; cv=none; b=GFizJvWCcGulHFBgz7IIZgYCo60uCpQ0JKdA4XSubKuM77/kNjoG3bAaCSI2B6rtQuHGmjiyHozevqHNeRe4F6tFc/9cebBZQKHkAsRlFr76nonWtxUjJCQ4+2PLEh99/bNRWlzdL1MAlS46WPKBBEGb4QWoH59s2U/PdKP3Rtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164111; c=relaxed/simple;
	bh=4X4eeILMXv0tXUiWnbdnQt6dNsN49hYJfj9QfQ2qzUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca6d8K5FFww1e8W3QdqXMLPEWvxWK1P9GnVEzuER21SNVRliM/MU0zBdZKiztEYUBX8vQWdonR/DS5Tf5K8iy5RFMkcRcacB2IgzB0+eLzUg2B3yc7/4nFxhCL0xjtNJktRhAwXh47VBL/9UvFFR48IPkixL96Kwagx9jauoEiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQ/+RAm/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQ/+RAm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C7B1F00893;
	Sat, 30 May 2026 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164110;
	bh=t19G1jHRvklXq7hJhOcQ2cbLlda3zkzc8g80qh8PZfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQ/+RAm/pWOtD9qIDu+/estU2aHuoT7oeztu6WvRZLKbkNCoCleuFZSIalshJOdWP
	 wCwzHEWRMF9SfJ1y8LBChhIWezG+xlIDX/26yq9unIS5SpbUiRXc6v9XggDVK8K2hk
	 7pMgej8Ee3jZeFwE0mnycp4+nJ77AJkYD0wxMYFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Konyukhov <Alexander.Konyukhov@kaspersky.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/776] drm/komeda: fix integer overflow in AFBC framebuffer size check
Date: Sat, 30 May 2026 18:02:24 +0200
Message-ID: <20260530160251.555150361@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3c372d2deb0a6..4bc2b9101354a 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_framebuffer.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_framebuffer.c
@@ -4,6 +4,8 @@
  * Author: James.Qian.Wang <james.qian.wang@arm.com>
  *
  */
+#include <linux/overflow.h>
+
 #include <drm/drm_device.h>
 #include <drm/drm_fb_cma_helper.h>
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



