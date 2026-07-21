Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAE846D2B3;
	Tue, 21 Jul 2026 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655698; cv=none; b=Me4QE8ip7XHwJHyArURx2HMrbcyaluRXvwMDPHqeGleLEsVhi1lzV7b49DnrG/If0LO5Bn5nVDtFozN0/oVRgtlc/kdFe1Bsd87AvxyxZh7L3x/EaQFLbyoM36cvKo1X5vbzZnm4H4KUFe7z+ctVOKqyi42oG2iHq856dAyOOpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655698; c=relaxed/simple;
	bh=catTNOMou+eh4BR9Uq47PylKWirxkMTXjgnMgtbFMCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX2AGFhq8oeJpYvYjVhswYl9tNnjHeWZkDZH4GrVbXnRNipVwoPNCZ8Cs6tILtSfkPVTzgcSPOZCd6CUXF/lWfjQEmIcGpHAzyWCatEOecz/AXY8WHK4aK+0OR8L2IeJgfoGMseG9VUn/h+gDnoFbKnJjYg3+UEs6cd+KitN3Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIP2AB5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIP2AB5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456061F000E9;
	Tue, 21 Jul 2026 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655696;
	bh=f7pHL1xbhGLmuHk41+oC2IxWNbY+y9G/9Y2PRBFaivI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIP2AB5q2JizRki1QqoVUN8H3oEmBmAL1Sr3rCq3+0mLAKhEWNhKSd/0+K9xpxhw2
	 o9QyuQ97SL+f0LjJLLQl9+ZXH9QyzYO53UDmCXMW/VmQzUtKFrdUmyBaFAX/XkayEL
	 6eso7tm2gJwr/njn0nh2PfuLb/d/o6uO28FyRT34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0108/1611] drm/gpuvm: take refcount on DRM device
Date: Tue, 21 Jul 2026 17:03:44 +0200
Message-ID: <20260721152517.279507730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit c2d72717e0a9dd01c6a1bac61a1462a8e04bd179 ]

Currently GPUVM relies on the owner implicitly holding a refcount to the
drm device, and it does not implicitly take a refcount on the drm
device. This design is error-prone, so take a refcount on the device.

Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Fixes: 546ca4d35dcc ("drm/gpuvm: convert WARN() to drm_WARN() variants")
Link: https://patch.msgid.link/20260416-gpuvm-drm-dev-get-v1-1-f3bc06571e73@google.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gpuvm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_gpuvm.c b/drivers/gpu/drm/drm_gpuvm.c
index 23e43406a1a8be..5c8bf010cd9654 100644
--- a/drivers/gpu/drm/drm_gpuvm.c
+++ b/drivers/gpu/drm/drm_gpuvm.c
@@ -25,6 +25,7 @@
  *
  */
 
+#include <drm/drm_drv.h>
 #include <drm/drm_gpuvm.h>
 
 #include <linux/export.h>
@@ -1089,6 +1090,7 @@ drm_gpuvm_init(struct drm_gpuvm *gpuvm, const char *name,
 	gpuvm->drm = drm;
 	gpuvm->r_obj = r_obj;
 
+	drm_dev_get(drm);
 	drm_gem_object_get(r_obj);
 
 	drm_gpuvm_warn_check_overflow(gpuvm, start_offset, range);
@@ -1130,13 +1132,15 @@ static void
 drm_gpuvm_free(struct kref *kref)
 {
 	struct drm_gpuvm *gpuvm = container_of(kref, struct drm_gpuvm, kref);
+	struct drm_device *drm = gpuvm->drm;
 
 	drm_gpuvm_fini(gpuvm);
 
-	if (drm_WARN_ON(gpuvm->drm, !gpuvm->ops->vm_free))
+	if (drm_WARN_ON(drm, !gpuvm->ops->vm_free))
 		return;
 
 	gpuvm->ops->vm_free(gpuvm);
+	drm_dev_put(drm);
 }
 
 /**
-- 
2.53.0



