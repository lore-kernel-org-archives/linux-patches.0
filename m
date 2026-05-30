Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C908F3016E1;
	Sat, 30 May 2026 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160982; cv=none; b=mxiCTovSsqKqw6YisQgIPTPO4EYbaHwEkyCHbieJMo2eZXtplAhA04z8Z6dm7K3N1/zWj4RsQk6/tFO7pcuTpcHEWwEQReoGQ4uuJ8tC7RSeS/+F/vcsoXaBAEZ1ZQeK9hOlTX6SWPv8kzN9ri4OHVlWbkq61LuGXnUemJsDA+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160982; c=relaxed/simple;
	bh=9bbtsr6pttnSd0PSz+ktH9xOckp9KMTmSZtZF6Ug3wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1moP+QL36aw/oh5B/cY780kemvpDet9l4fs7FC9vOfvQBogjXR3DqlugItkqe4ysAFmuCjkFVcr/jb8PcpKsUrHdh9LpCX1ycRDWelIQJ8XE4E8I2QNxYNRa1OEgeQ0OfONzIdoT0frEWmmjRWkpxWDQeWFhwiwD675sdG52Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGudHAvh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGudHAvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50C41F00898;
	Sat, 30 May 2026 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160981;
	bh=tGj5hGL9JoKy0YkKGCwJLM3wCwQoUd8LN5T/pMQLoeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGudHAvhyzucw+4sWr4cLgg1ZqhMB9JPy+FbhEETmTwdgEmoU6zIIfirzrc5FiABt
	 T4nsOBhyfn/gBs2LYsoP48eFHzF9XoxYP6f+2L99wZF++ZN/Lygv0Pvf3iTwx3rvPL
	 oq/gb3821QkxK1XMLGXXYc4Y1+UoJppYgmhbC7vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Konyukhov <Alexander.Konyukhov@kaspersky.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 491/969] drm/komeda: fix integer overflow in AFBC framebuffer size check
Date: Sat, 30 May 2026 18:00:15 +0200
Message-ID: <20260530160313.873776396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



