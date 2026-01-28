Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624AE2F261C;
	Wed, 28 Jan 2026 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615650; cv=none; b=ZhaqWQ5E/NyqvmEI9YV7VsM6CuV/nixMnD+QpuTAKtHAxB1j1yH8OmW+99oyhKKKljmgnOyor78YgrLY4GMIkuJbv/VJF1ZcyVCwzqf5PIp4ZpoOpjc51dhZZGTZrMCUvLf/QH6oywfTEt30TZXnZCI1KZIn4Q1kj3oPlEw+xho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615650; c=relaxed/simple;
	bh=1pe81fLvU9qKpDSCb4Dl4EyA1UsvI1qVEPQ7U3/y3lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIR7baVdTCVFgQWOKE9lFptj5amSTlrb60+FN6fa3PTTWlq8khk+dd566vIsfQvqmyfXIf1w+UU79GfWegRaD3XB7N90h8dvk9CyNq4K3dsDut+nhVH99eSVySsAk6uPGyfhNKMeHXH6SicxqYPk4gfuRptGYO1riyA/Rmu4J48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpfRv2kS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpfRv2kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C602EC4CEF1;
	Wed, 28 Jan 2026 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615650;
	bh=1pe81fLvU9qKpDSCb4Dl4EyA1UsvI1qVEPQ7U3/y3lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpfRv2kS+m0ynsv4LAZOeS+Gjq+z4b0gkd4l/AkM3XZKQ4O2iIycgthuTgr/xR9Oz
	 iEWtKxj5m57fPgUFZUZl0ZVUX4iKoOmpmCVzWU2AQ0D0+9fNLrZcMUsw1NI6euf+Xl
	 A6Q4B/tL/hmcg9+/2ZGstDRjkD+RCZABnBTSnnVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	dri-devel@lists.freedesktop.org,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 6.18 073/227] drm, drm/xe: Fix xe userptr in the absence of CONFIG_DEVICE_PRIVATE
Date: Wed, 28 Jan 2026 16:21:58 +0100
Message-ID: <20260128145346.969913989@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit bdcdf968be314b6fc8835b99fb4519e7619671e6 upstream.

CONFIG_DEVICE_PRIVATE is not selected by default by some distros,
for example Fedora, and that leads to a regression in the xe driver
since userptr support gets compiled out.

It turns out that DRM_GPUSVM, which is needed for xe userptr support
compiles also without CONFIG_DEVICE_PRIVATE, but doesn't compile
without CONFIG_ZONE_DEVICE.
Exclude the drm_pagemap files from compilation with !CONFIG_ZONE_DEVICE,
and remove the CONFIG_DEVICE_PRIVATE dependency from CONFIG_DRM_GPUSVM and
the xe driver's selection of it, re-enabling xe userptr for those configs.

v2:
- Don't compile the drm_pagemap files unless CONFIG_ZONE_DEVICE is set.
- Adjust the drm_pagemap.h header accordingly.

Fixes: 9e9787414882 ("drm/xe/userptr: replace xe_hmm with gpusvm")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.18+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patch.msgid.link/20260121091048.41371-2-thomas.hellstrom@linux.intel.com
(cherry picked from commit 1e372b246199ca7a35f930177fea91b557dac16e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/Kconfig    |    2 +-
 drivers/gpu/drm/Makefile   |    4 +++-
 drivers/gpu/drm/xe/Kconfig |    2 +-
 include/drm/drm_pagemap.h  |   19 +++++++++++++++++--
 4 files changed, 22 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -210,7 +210,7 @@ config DRM_GPUVM
 
 config DRM_GPUSVM
 	tristate
-	depends on DRM && DEVICE_PRIVATE
+	depends on DRM
 	select HMM_MIRROR
 	select MMU_NOTIFIER
 	help
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -106,8 +106,10 @@ obj-$(CONFIG_DRM_EXEC) += drm_exec.o
 obj-$(CONFIG_DRM_GPUVM) += drm_gpuvm.o
 
 drm_gpusvm_helper-y := \
-	drm_gpusvm.o\
+	drm_gpusvm.o
+drm_gpusvm_helper-$(CONFIG_ZONE_DEVICE) += \
 	drm_pagemap.o
+
 obj-$(CONFIG_DRM_GPUSVM) += drm_gpusvm_helper.o
 
 obj-$(CONFIG_DRM_BUDDY) += drm_buddy.o
--- a/drivers/gpu/drm/xe/Kconfig
+++ b/drivers/gpu/drm/xe/Kconfig
@@ -39,7 +39,7 @@ config DRM_XE
 	select DRM_TTM
 	select DRM_TTM_HELPER
 	select DRM_EXEC
-	select DRM_GPUSVM if !UML && DEVICE_PRIVATE
+	select DRM_GPUSVM if !UML
 	select DRM_GPUVM
 	select DRM_SCHED
 	select MMU_NOTIFIER
--- a/include/drm/drm_pagemap.h
+++ b/include/drm/drm_pagemap.h
@@ -209,6 +209,19 @@ struct drm_pagemap_devmem_ops {
 			   struct dma_fence *pre_migrate_fence);
 };
 
+#if IS_ENABLED(CONFIG_ZONE_DEVICE)
+
+struct drm_pagemap *drm_pagemap_page_to_dpagemap(struct page *page);
+
+#else
+
+static inline struct drm_pagemap *drm_pagemap_page_to_dpagemap(struct page *page)
+{
+	return NULL;
+}
+
+#endif /* IS_ENABLED(CONFIG_ZONE_DEVICE) */
+
 /**
  * struct drm_pagemap_devmem - Structure representing a GPU SVM device memory allocation
  *
@@ -233,6 +246,8 @@ struct drm_pagemap_devmem {
 	struct dma_fence *pre_migrate_fence;
 };
 
+#if IS_ENABLED(CONFIG_ZONE_DEVICE)
+
 int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
 				  struct mm_struct *mm,
 				  unsigned long start, unsigned long end,
@@ -243,8 +258,6 @@ int drm_pagemap_evict_to_ram(struct drm_
 
 const struct dev_pagemap_ops *drm_pagemap_pagemap_ops_get(void);
 
-struct drm_pagemap *drm_pagemap_page_to_dpagemap(struct page *page);
-
 void drm_pagemap_devmem_init(struct drm_pagemap_devmem *devmem_allocation,
 			     struct device *dev, struct mm_struct *mm,
 			     const struct drm_pagemap_devmem_ops *ops,
@@ -256,4 +269,6 @@ int drm_pagemap_populate_mm(struct drm_p
 			    struct mm_struct *mm,
 			    unsigned long timeslice_ms);
 
+#endif /* IS_ENABLED(CONFIG_ZONE_DEVICE) */
+
 #endif


