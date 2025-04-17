Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6ED2561DF;
	Thu, 17 Apr 2025 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912506; cv=none; b=BnEjDN6mgigzvliONOzUqyv7WQDxZEsCkRByjo4VbYh8OcTswKVxa2PlBjkUyDd6j+82SVOX6Cp2tn4oxu6CAU+oc6/bKwgh87lWbQNMCun+4MXK3acmaNmw54oyZvWcyPxOz+Ea0M1zo3DMydNhJLZq5zoZvLQupf9MIGDgf3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912506; c=relaxed/simple;
	bh=e71SNCBrWu94h9OPHCRuhoMn3pUxwGAwzi/BlusGeZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtG9r/Pgd68QgGRR529q78msBwCgQj/6kBGRm2Q86TSTynMtXFXoyQkG5bxGzKLJCqejqAg8QsizBN99a3llqJ4LuFvi2CJbID9Jcd8fg0/M+o+JefIJkjwaGOkAFvZdPGjrTmwerDeMP949ALRTE2grlumiTKgsJDniQZnUmDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpWfVjdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpWfVjdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1C5C4CEE4;
	Thu, 17 Apr 2025 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912506;
	bh=e71SNCBrWu94h9OPHCRuhoMn3pUxwGAwzi/BlusGeZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpWfVjdKXbFlGXKlHdRyWaW+rs27Ol+U1Pn/Bpu/0XqqfYxKiw+YbV6pzCtC8jXAl
	 1s/dtBqJ3xPL/XOVDwsU3/VakXtnjPQ8Tdd0ho2P7bolnvNYAP1quBmSVTMORyeWF5
	 y8X9G+JkZZTHP0w/9ziARhCEcCMysUgX+G1/PAUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 031/449] drm/i915/huc: Fix fence not released on early probe errors
Date: Thu, 17 Apr 2025 19:45:19 +0200
Message-ID: <20250417175119.249284884@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>

[ Upstream commit e3ea2eae70692a455e256787e4f54153fb739b90 ]

HuC delayed loading fence, introduced with commit 27536e03271da
("drm/i915/huc: track delayed HuC load with a fence"), is registered with
object tracker early on driver probe but unregistered only from driver
remove, which is not called on early probe errors.  Since its memory is
allocated under devres, then released anyway, it may happen to be
allocated again to the fence and reused on future driver probes, resulting
in kernel warnings that taint the kernel:

<4> [309.731371] ------------[ cut here ]------------
<3> [309.731373] ODEBUG: init destroyed (active state 0) object: ffff88813d7dd2e0 object type: i915_sw_fence hint: sw_fence_dummy_notify+0x0/0x20 [i915]
<4> [309.731575] WARNING: CPU: 2 PID: 3161 at lib/debugobjects.c:612 debug_print_object+0x93/0xf0
...
<4> [309.731693] CPU: 2 UID: 0 PID: 3161 Comm: i915_module_loa Tainted: G     U             6.14.0-CI_DRM_16362-gf0fd77956987+ #1
...
<4> [309.731700] RIP: 0010:debug_print_object+0x93/0xf0
...
<4> [309.731728] Call Trace:
<4> [309.731730]  <TASK>
...
<4> [309.731949]  __debug_object_init+0x17b/0x1c0
<4> [309.731957]  debug_object_init+0x34/0x50
<4> [309.732126]  __i915_sw_fence_init+0x34/0x60 [i915]
<4> [309.732256]  intel_huc_init_early+0x4b/0x1d0 [i915]
<4> [309.732468]  intel_uc_init_early+0x61/0x680 [i915]
<4> [309.732667]  intel_gt_common_init_early+0x105/0x130 [i915]
<4> [309.732804]  intel_root_gt_init_early+0x63/0x80 [i915]
<4> [309.732938]  i915_driver_probe+0x1fa/0xeb0 [i915]
<4> [309.733075]  i915_pci_probe+0xe6/0x220 [i915]
<4> [309.733198]  local_pci_probe+0x44/0xb0
<4> [309.733203]  pci_device_probe+0xf4/0x270
<4> [309.733209]  really_probe+0xee/0x3c0
<4> [309.733215]  __driver_probe_device+0x8c/0x180
<4> [309.733219]  driver_probe_device+0x24/0xd0
<4> [309.733223]  __driver_attach+0x10f/0x220
<4> [309.733230]  bus_for_each_dev+0x7d/0xe0
<4> [309.733236]  driver_attach+0x1e/0x30
<4> [309.733239]  bus_add_driver+0x151/0x290
<4> [309.733244]  driver_register+0x5e/0x130
<4> [309.733247]  __pci_register_driver+0x7d/0x90
<4> [309.733251]  i915_pci_register_driver+0x23/0x30 [i915]
<4> [309.733413]  i915_init+0x34/0x120 [i915]
<4> [309.733655]  do_one_initcall+0x62/0x3f0
<4> [309.733667]  do_init_module+0x97/0x2a0
<4> [309.733671]  load_module+0x25ff/0x2890
<4> [309.733688]  init_module_from_file+0x97/0xe0
<4> [309.733701]  idempotent_init_module+0x118/0x330
<4> [309.733711]  __x64_sys_finit_module+0x77/0x100
<4> [309.733715]  x64_sys_call+0x1f37/0x2650
<4> [309.733719]  do_syscall_64+0x91/0x180
<4> [309.733763]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
<4> [309.733792]  </TASK>
...
<4> [309.733806] ---[ end trace 0000000000000000 ]---

That scenario is most easily reproducible with
igt@i915_module_load@reload-with-fault-injection.

Fix the issue by moving the cleanup step to driver release path.

Fixes: 27536e03271da ("drm/i915/huc: track delayed HuC load with a fence")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13592
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Krzysztof Karas <krzysztof.karas@intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://lore.kernel.org/r/20250402172057.209924-2-janusz.krzysztofik@linux.intel.com
(cherry picked from commit 795dbde92fe5c6996a02a5b579481de73035e7bf)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_huc.c | 11 +++++------
 drivers/gpu/drm/i915/gt/uc/intel_huc.h |  1 +
 drivers/gpu/drm/i915/gt/uc/intel_uc.c  |  1 +
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_huc.c b/drivers/gpu/drm/i915/gt/uc/intel_huc.c
index b3cbf85c00cbd..eb59c1f2dccdc 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_huc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_huc.c
@@ -317,6 +317,11 @@ void intel_huc_init_early(struct intel_huc *huc)
 	}
 }
 
+void intel_huc_fini_late(struct intel_huc *huc)
+{
+	delayed_huc_load_fini(huc);
+}
+
 #define HUC_LOAD_MODE_STRING(x) (x ? "GSC" : "legacy")
 static int check_huc_loading_mode(struct intel_huc *huc)
 {
@@ -414,12 +419,6 @@ int intel_huc_init(struct intel_huc *huc)
 
 void intel_huc_fini(struct intel_huc *huc)
 {
-	/*
-	 * the fence is initialized in init_early, so we need to clean it up
-	 * even if HuC loading is off.
-	 */
-	delayed_huc_load_fini(huc);
-
 	if (huc->heci_pkt)
 		i915_vma_unpin_and_release(&huc->heci_pkt, 0);
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_huc.h b/drivers/gpu/drm/i915/gt/uc/intel_huc.h
index d5e441b9e08d6..921ad4b1687f0 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_huc.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_huc.h
@@ -55,6 +55,7 @@ struct intel_huc {
 
 int intel_huc_sanitize(struct intel_huc *huc);
 void intel_huc_init_early(struct intel_huc *huc);
+void intel_huc_fini_late(struct intel_huc *huc);
 int intel_huc_init(struct intel_huc *huc);
 void intel_huc_fini(struct intel_huc *huc);
 int intel_huc_auth(struct intel_huc *huc, enum intel_huc_authentication_type type);
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc.c b/drivers/gpu/drm/i915/gt/uc/intel_uc.c
index 5b8080ec5315b..4f751ce74214d 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc.c
@@ -136,6 +136,7 @@ void intel_uc_init_late(struct intel_uc *uc)
 
 void intel_uc_driver_late_release(struct intel_uc *uc)
 {
+	intel_huc_fini_late(&uc->huc);
 }
 
 /**
-- 
2.39.5



