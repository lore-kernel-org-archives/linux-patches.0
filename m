Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC452EE993;
	Thu,  3 Jul 2025 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554938; cv=none; b=lhT1rRL0011xfOvGG6yR80rWXuUOtjQIzEUZxPwIvZKZY8rSg4RToAu8bg8KJOx7nH51cWwsaW1Ua3Myo3XqLklD8TlcDLz5ADY868qTlDPgty5RoT5XedjQ8EHxnRDtKqGXfcsmVlH2Kqy8wTQEiYQByo+KLUNCNOg+tw44Pak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554938; c=relaxed/simple;
	bh=chye80sJ54C4R8VSr9sl9HBCKGy7qaXa2QZp/7NQBFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIxrqYoGVlojvm7avctE85Ks/ICuJnI2h3gNWKbi/n4c9j0WNt8b3Nes+55kfnYv8AXdVlhhHeNHQpBow9Xao2KbOQPsRRgh4L/QsXxKaSFB3zYLHI/v9HIqSwC462B17iT99Nb1P9oKVxnceg7QzqUAfEU6XaiSbdAGCv2Qsog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERBhWDct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERBhWDct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53304C4CEF2;
	Thu,  3 Jul 2025 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554937;
	bh=chye80sJ54C4R8VSr9sl9HBCKGy7qaXa2QZp/7NQBFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERBhWDctucbJVvq2wOl/7UgcZsKMZHxZojS3oAsVnQCo54ybXyvzzbIgexqk9rfiH
	 fKMp+/CSw1JxE8q5zYqCm0UMiUmkOsgGbUm19KxCHzaZ5tWtNWIkTMotogQVwICqUv
	 r4iQZe/zM8VsvgTa4ziHHaddmDxJczQSnufaGLXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 095/263] drm/i915/display: Add check for alloc_ordered_workqueue() and alloc_workqueue()
Date: Thu,  3 Jul 2025 16:40:15 +0200
Message-ID: <20250703144008.102859492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit f4c7baa0699b69edb6887a992283b389761e0e81 ]

Add check for the return value of alloc_ordered_workqueue()
and alloc_workqueue(). Furthermore, if some allocations fail,
cleanup works are added to avoid potential memory leak problem.

Fixes: 40053823baad ("drm/i915/display: move modeset probe/remove functions to intel_display_driver.c")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20d3d096c6a4907636f8a1389b3b4dd753ca356e.1747397638.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit dcab7a228f4ea9cda3f5b0a1f0679e046d23d7f7)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/i915/display/intel_display_driver.c   | 30 +++++++++++++++----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_driver.c b/drivers/gpu/drm/i915/display/intel_display_driver.c
index 31740a677dd80..14c8b3259bbf5 100644
--- a/drivers/gpu/drm/i915/display/intel_display_driver.c
+++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
@@ -241,31 +241,45 @@ int intel_display_driver_probe_noirq(struct intel_display *display)
 	intel_dmc_init(display);
 
 	display->wq.modeset = alloc_ordered_workqueue("i915_modeset", 0);
+	if (!display->wq.modeset) {
+		ret = -ENOMEM;
+		goto cleanup_vga_client_pw_domain_dmc;
+	}
+
 	display->wq.flip = alloc_workqueue("i915_flip", WQ_HIGHPRI |
 						WQ_UNBOUND, WQ_UNBOUND_MAX_ACTIVE);
+	if (!display->wq.flip) {
+		ret = -ENOMEM;
+		goto cleanup_wq_modeset;
+	}
+
 	display->wq.cleanup = alloc_workqueue("i915_cleanup", WQ_HIGHPRI, 0);
+	if (!display->wq.cleanup) {
+		ret = -ENOMEM;
+		goto cleanup_wq_flip;
+	}
 
 	intel_mode_config_init(display);
 
 	ret = intel_cdclk_init(display);
 	if (ret)
-		goto cleanup_vga_client_pw_domain_dmc;
+		goto cleanup_wq_cleanup;
 
 	ret = intel_color_init(display);
 	if (ret)
-		goto cleanup_vga_client_pw_domain_dmc;
+		goto cleanup_wq_cleanup;
 
 	ret = intel_dbuf_init(i915);
 	if (ret)
-		goto cleanup_vga_client_pw_domain_dmc;
+		goto cleanup_wq_cleanup;
 
 	ret = intel_bw_init(i915);
 	if (ret)
-		goto cleanup_vga_client_pw_domain_dmc;
+		goto cleanup_wq_cleanup;
 
 	ret = intel_pmdemand_init(display);
 	if (ret)
-		goto cleanup_vga_client_pw_domain_dmc;
+		goto cleanup_wq_cleanup;
 
 	intel_init_quirks(display);
 
@@ -273,6 +287,12 @@ int intel_display_driver_probe_noirq(struct intel_display *display)
 
 	return 0;
 
+cleanup_wq_cleanup:
+	destroy_workqueue(display->wq.cleanup);
+cleanup_wq_flip:
+	destroy_workqueue(display->wq.flip);
+cleanup_wq_modeset:
+	destroy_workqueue(display->wq.modeset);
 cleanup_vga_client_pw_domain_dmc:
 	intel_dmc_fini(display);
 	intel_power_domains_driver_remove(display);
-- 
2.39.5



