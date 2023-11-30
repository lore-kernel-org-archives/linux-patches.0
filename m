Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61160495C2;
	Thu, 30 Nov 2023 16:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQzsCsiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D96C433C8;
	Thu, 30 Nov 2023 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361438;
	bh=YzaIDP0EVhHq/C8F8+UVDXvrFw42wJQrjNlu+mwohb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQzsCsiF5gPmW0LBjfZHVpaftPm9vNaUHi/fuIjzngjHyfUJgBhvVIjMWcPicvs6h
	 ciQRDYvoECcg9/pE0ealjHiPMYtjNCbP0cwXmnjU+KWXm0djpjmMefNKAP9M28HvnU
	 r7P2sECkAVRxK4LIAK/GeR+GpI2AcYl0MKWhmCS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/112] drm/i915: do not clean GT table on error path
Date: Thu, 30 Nov 2023 16:21:09 +0000
Message-ID: <20231130162141.029506287@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andrzej Hajda <andrzej.hajda@intel.com>

[ Upstream commit 0561794b6b642b84b879bf97061c4b4fa692839e ]

The only task of intel_gt_release_all is to zero gt table. Calling
it on error path prevents intel_gt_driver_late_release_all (called from
i915_driver_late_release) to cleanup GTs, causing leakage.
After i915_driver_late_release GT array is not used anymore so
it does not need cleaning at all.

Sample leak report:

BUG i915_request (...): Objects remaining in i915_request on __kmem_cache_shutdown()
...
Object 0xffff888113420040 @offset=64
Allocated in __i915_request_create+0x75/0x610 [i915] age=18339 cpu=1 pid=1454
 kmem_cache_alloc+0x25b/0x270
 __i915_request_create+0x75/0x610 [i915]
 i915_request_create+0x109/0x290 [i915]
 __engines_record_defaults+0xca/0x440 [i915]
 intel_gt_init+0x275/0x430 [i915]
 i915_gem_init+0x135/0x2c0 [i915]
 i915_driver_probe+0x8d1/0xdc0 [i915]

v2: removed whole intel_gt_release_all

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8489
Fixes: bec68cc9ea42 ("drm/i915: Prepare for multiple GTs")
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231115-dont_clean_gt_on_error_path-v2-1-54250125470a@intel.com
(cherry picked from commit e899505533852bf1da133f2f4c9a9655ff77f7e5)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt.c | 11 -----------
 drivers/gpu/drm/i915/i915_driver.c |  4 +---
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 449f0b7fc8434..95631e8f39e7b 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -967,8 +967,6 @@ int intel_gt_probe_all(struct drm_i915_private *i915)
 
 err:
 	i915_probe_error(i915, "Failed to initialize %s! (%d)\n", gtdef->name, ret);
-	intel_gt_release_all(i915);
-
 	return ret;
 }
 
@@ -987,15 +985,6 @@ int intel_gt_tiles_init(struct drm_i915_private *i915)
 	return 0;
 }
 
-void intel_gt_release_all(struct drm_i915_private *i915)
-{
-	struct intel_gt *gt;
-	unsigned int id;
-
-	for_each_gt(gt, i915, id)
-		i915->gt[id] = NULL;
-}
-
 void intel_gt_info_print(const struct intel_gt_info *info,
 			 struct drm_printer *p)
 {
diff --git a/drivers/gpu/drm/i915/i915_driver.c b/drivers/gpu/drm/i915/i915_driver.c
index ec4d26b3c17cc..8dc5f85b7747b 100644
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -777,7 +777,7 @@ int i915_driver_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = i915_driver_mmio_probe(i915);
 	if (ret < 0)
-		goto out_tiles_cleanup;
+		goto out_runtime_pm_put;
 
 	ret = i915_driver_hw_probe(i915);
 	if (ret < 0)
@@ -837,8 +837,6 @@ int i915_driver_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	i915_ggtt_driver_late_release(i915);
 out_cleanup_mmio:
 	i915_driver_mmio_release(i915);
-out_tiles_cleanup:
-	intel_gt_release_all(i915);
 out_runtime_pm_put:
 	enable_rpm_wakeref_asserts(&i915->runtime_pm);
 	i915_driver_late_release(i915);
-- 
2.42.0



