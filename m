Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CF02376FF;
	Mon,  2 Jun 2025 14:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873411; cv=none; b=r5ytnABJNTEMm5rG1+ggIO0Y9Eo4zTegzNcfOew3+TnLQcedr7otr5Z21QwbVOZ7tWbPaBJdl1307O7luqWiVfMbEXRkhkClF9T5cF7uoU2cTzEu+JqB7ZvjvP/13RybVCmJus2CF2g8+pdzFu4oPb6b3LhtVbQ97CRfNMp3pcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873411; c=relaxed/simple;
	bh=vDDImfvBoGfmGz01C2hCWfR6G/VqEYMqidskNksTU+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUKMCxqhS/4ObRYNCjFT5uPwmFEnKI6zRgvlyJh/7mWu4i5mAM6FmMYfIy8MbQ/N8ICpo2f5bl1Jh1N2xxl2haezJshSgAjLhtHiJtornU9TJ9A3d4LnNCpL+2hVGskvqV4koRrCiHvPabTgObc4nrcangNG/W+Al8S/ORzniYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwCOIiVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwCOIiVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79E2C4CEEB;
	Mon,  2 Jun 2025 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873411;
	bh=vDDImfvBoGfmGz01C2hCWfR6G/VqEYMqidskNksTU+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwCOIiVflw/73cDOYGlL+YGwx51fISi40xIF0nodxSFI00G5zY8bYIFRt6ncnkvxu
	 KhL5Is4mecUhVHSZ2gRbi9Tu15u2ZdOXQSl2niKoLAJD7fW8NLRRBehfy7+ES/t9p+
	 uRAYnRYEN0KCJ+cpB1n8k3PfNluNIqn83UzkE+wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/444] drm/amdkfd: Set per-process flags only once cik/vi
Date: Mon,  2 Jun 2025 15:43:16 +0200
Message-ID: <20250602134346.251888319@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit 289e68503a4533b014f8447e2af28ad44c92c221 ]

Set per-process static sh_mem config only once during process
initialization. Move all static changes from update_qpd() which is
called each time a queue is created to set_cache_memory_policy() which
is called once during process initialization.

set_cache_memory_policy() is currently defined only for cik and vi
family. So this commit only focuses on these two. A separate commit will
address other asics.

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Amber Lin <Amber.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 39 +---------
 .../amd/amdkfd/kfd_device_queue_manager_cik.c | 69 ++++++++++++------
 .../amd/amdkfd/kfd_device_queue_manager_vi.c  | 71 ++++++++++++-------
 3 files changed, 94 insertions(+), 85 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 4d9a406925e18..fd4a75073364c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2147,14 +2147,6 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 	return retval;
 }
 
-/*
- * Low bits must be 0000/FFFF as required by HW, high bits must be 0 to
- * stay in user mode.
- */
-#define APE1_FIXED_BITS_MASK 0xFFFF80000000FFFFULL
-/* APE1 limit is inclusive and 64K aligned. */
-#define APE1_LIMIT_ALIGNMENT 0xFFFF
-
 static bool set_cache_memory_policy(struct device_queue_manager *dqm,
 				   struct qcm_process_device *qpd,
 				   enum cache_policy default_policy,
@@ -2169,34 +2161,6 @@ static bool set_cache_memory_policy(struct device_queue_manager *dqm,
 
 	dqm_lock(dqm);
 
-	if (alternate_aperture_size == 0) {
-		/* base > limit disables APE1 */
-		qpd->sh_mem_ape1_base = 1;
-		qpd->sh_mem_ape1_limit = 0;
-	} else {
-		/*
-		 * In FSA64, APE1_Base[63:0] = { 16{SH_MEM_APE1_BASE[31]},
-		 *			SH_MEM_APE1_BASE[31:0], 0x0000 }
-		 * APE1_Limit[63:0] = { 16{SH_MEM_APE1_LIMIT[31]},
-		 *			SH_MEM_APE1_LIMIT[31:0], 0xFFFF }
-		 * Verify that the base and size parameters can be
-		 * represented in this format and convert them.
-		 * Additionally restrict APE1 to user-mode addresses.
-		 */
-
-		uint64_t base = (uintptr_t)alternate_aperture_base;
-		uint64_t limit = base + alternate_aperture_size - 1;
-
-		if (limit <= base || (base & APE1_FIXED_BITS_MASK) != 0 ||
-		   (limit & APE1_FIXED_BITS_MASK) != APE1_LIMIT_ALIGNMENT) {
-			retval = false;
-			goto out;
-		}
-
-		qpd->sh_mem_ape1_base = base >> 16;
-		qpd->sh_mem_ape1_limit = limit >> 16;
-	}
-
 	retval = dqm->asic_ops.set_cache_memory_policy(
 			dqm,
 			qpd,
@@ -2205,6 +2169,9 @@ static bool set_cache_memory_policy(struct device_queue_manager *dqm,
 			alternate_aperture_base,
 			alternate_aperture_size);
 
+	if (retval)
+		goto out;
+
 	if ((dqm->sched_policy == KFD_SCHED_POLICY_NO_HWS) && (qpd->vmid != 0))
 		program_sh_mem_settings(dqm, qpd);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_cik.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_cik.c
index d4d95c7f2e5d4..32bedef912b3b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_cik.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_cik.c
@@ -27,6 +27,14 @@
 #include "oss/oss_2_4_sh_mask.h"
 #include "gca/gfx_7_2_sh_mask.h"
 
+/*
+ * Low bits must be 0000/FFFF as required by HW, high bits must be 0 to
+ * stay in user mode.
+ */
+#define APE1_FIXED_BITS_MASK 0xFFFF80000000FFFFULL
+/* APE1 limit is inclusive and 64K aligned. */
+#define APE1_LIMIT_ALIGNMENT 0xFFFF
+
 static bool set_cache_memory_policy_cik(struct device_queue_manager *dqm,
 				   struct qcm_process_device *qpd,
 				   enum cache_policy default_policy,
@@ -84,6 +92,36 @@ static bool set_cache_memory_policy_cik(struct device_queue_manager *dqm,
 {
 	uint32_t default_mtype;
 	uint32_t ape1_mtype;
+	unsigned int temp;
+	bool retval = true;
+
+	if (alternate_aperture_size == 0) {
+		/* base > limit disables APE1 */
+		qpd->sh_mem_ape1_base = 1;
+		qpd->sh_mem_ape1_limit = 0;
+	} else {
+		/*
+		 * In FSA64, APE1_Base[63:0] = { 16{SH_MEM_APE1_BASE[31]},
+		 *			SH_MEM_APE1_BASE[31:0], 0x0000 }
+		 * APE1_Limit[63:0] = { 16{SH_MEM_APE1_LIMIT[31]},
+		 *			SH_MEM_APE1_LIMIT[31:0], 0xFFFF }
+		 * Verify that the base and size parameters can be
+		 * represented in this format and convert them.
+		 * Additionally restrict APE1 to user-mode addresses.
+		 */
+
+		uint64_t base = (uintptr_t)alternate_aperture_base;
+		uint64_t limit = base + alternate_aperture_size - 1;
+
+		if (limit <= base || (base & APE1_FIXED_BITS_MASK) != 0 ||
+		   (limit & APE1_FIXED_BITS_MASK) != APE1_LIMIT_ALIGNMENT) {
+			retval = false;
+			goto out;
+		}
+
+		qpd->sh_mem_ape1_base = base >> 16;
+		qpd->sh_mem_ape1_limit = limit >> 16;
+	}
 
 	default_mtype = (default_policy == cache_policy_coherent) ?
 			MTYPE_NONCACHED :
@@ -97,37 +135,22 @@ static bool set_cache_memory_policy_cik(struct device_queue_manager *dqm,
 			| ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED)
 			| DEFAULT_MTYPE(default_mtype)
 			| APE1_MTYPE(ape1_mtype);
-
-	return true;
-}
-
-static int update_qpd_cik(struct device_queue_manager *dqm,
-			  struct qcm_process_device *qpd)
-{
-	struct kfd_process_device *pdd;
-	unsigned int temp;
-
-	pdd = qpd_to_pdd(qpd);
-
-	/* check if sh_mem_config register already configured */
-	if (qpd->sh_mem_config == 0) {
-		qpd->sh_mem_config =
-			ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED) |
-			DEFAULT_MTYPE(MTYPE_NONCACHED) |
-			APE1_MTYPE(MTYPE_NONCACHED);
-		qpd->sh_mem_ape1_limit = 0;
-		qpd->sh_mem_ape1_base = 0;
-	}
-
 	/* On dGPU we're always in GPUVM64 addressing mode with 64-bit
 	 * aperture addresses.
 	 */
-	temp = get_sh_mem_bases_nybble_64(pdd);
+	temp = get_sh_mem_bases_nybble_64(qpd_to_pdd(qpd));
 	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(temp);
 
 	pr_debug("is32bit process: %d sh_mem_bases nybble: 0x%X and register 0x%X\n",
 		qpd->pqm->process->is_32bit_user_mode, temp, qpd->sh_mem_bases);
 
+out:
+	return retval;
+}
+
+static int update_qpd_cik(struct device_queue_manager *dqm,
+			  struct qcm_process_device *qpd)
+{
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_vi.c
index b291ee0fab943..320518f418903 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_vi.c
@@ -27,6 +27,14 @@
 #include "gca/gfx_8_0_sh_mask.h"
 #include "oss/oss_3_0_sh_mask.h"
 
+/*
+ * Low bits must be 0000/FFFF as required by HW, high bits must be 0 to
+ * stay in user mode.
+ */
+#define APE1_FIXED_BITS_MASK 0xFFFF80000000FFFFULL
+/* APE1 limit is inclusive and 64K aligned. */
+#define APE1_LIMIT_ALIGNMENT 0xFFFF
+
 static bool set_cache_memory_policy_vi(struct device_queue_manager *dqm,
 				       struct qcm_process_device *qpd,
 				       enum cache_policy default_policy,
@@ -85,6 +93,36 @@ static bool set_cache_memory_policy_vi(struct device_queue_manager *dqm,
 {
 	uint32_t default_mtype;
 	uint32_t ape1_mtype;
+	unsigned int temp;
+	bool retval = true;
+
+	if (alternate_aperture_size == 0) {
+		/* base > limit disables APE1 */
+		qpd->sh_mem_ape1_base = 1;
+		qpd->sh_mem_ape1_limit = 0;
+	} else {
+		/*
+		 * In FSA64, APE1_Base[63:0] = { 16{SH_MEM_APE1_BASE[31]},
+		 *			SH_MEM_APE1_BASE[31:0], 0x0000 }
+		 * APE1_Limit[63:0] = { 16{SH_MEM_APE1_LIMIT[31]},
+		 *			SH_MEM_APE1_LIMIT[31:0], 0xFFFF }
+		 * Verify that the base and size parameters can be
+		 * represented in this format and convert them.
+		 * Additionally restrict APE1 to user-mode addresses.
+		 */
+
+		uint64_t base = (uintptr_t)alternate_aperture_base;
+		uint64_t limit = base + alternate_aperture_size - 1;
+
+		if (limit <= base || (base & APE1_FIXED_BITS_MASK) != 0 ||
+		   (limit & APE1_FIXED_BITS_MASK) != APE1_LIMIT_ALIGNMENT) {
+			retval = false;
+			goto out;
+		}
+
+		qpd->sh_mem_ape1_base = base >> 16;
+		qpd->sh_mem_ape1_limit = limit >> 16;
+	}
 
 	default_mtype = (default_policy == cache_policy_coherent) ?
 			MTYPE_UC :
@@ -100,40 +138,21 @@ static bool set_cache_memory_policy_vi(struct device_queue_manager *dqm,
 			default_mtype << SH_MEM_CONFIG__DEFAULT_MTYPE__SHIFT |
 			ape1_mtype << SH_MEM_CONFIG__APE1_MTYPE__SHIFT;
 
-	return true;
-}
-
-static int update_qpd_vi(struct device_queue_manager *dqm,
-			 struct qcm_process_device *qpd)
-{
-	struct kfd_process_device *pdd;
-	unsigned int temp;
-
-	pdd = qpd_to_pdd(qpd);
-
-	/* check if sh_mem_config register already configured */
-	if (qpd->sh_mem_config == 0) {
-		qpd->sh_mem_config =
-				SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
-					SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT |
-				MTYPE_UC <<
-					SH_MEM_CONFIG__DEFAULT_MTYPE__SHIFT |
-				MTYPE_UC <<
-					SH_MEM_CONFIG__APE1_MTYPE__SHIFT;
-
-		qpd->sh_mem_ape1_limit = 0;
-		qpd->sh_mem_ape1_base = 0;
-	}
-
 	/* On dGPU we're always in GPUVM64 addressing mode with 64-bit
 	 * aperture addresses.
 	 */
-	temp = get_sh_mem_bases_nybble_64(pdd);
+	temp = get_sh_mem_bases_nybble_64(qpd_to_pdd(qpd));
 	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(temp);
 
 	pr_debug("sh_mem_bases nybble: 0x%X and register 0x%X\n",
 		temp, qpd->sh_mem_bases);
+out:
+	return retval;
+}
 
+static int update_qpd_vi(struct device_queue_manager *dqm,
+			 struct qcm_process_device *qpd)
+{
 	return 0;
 }
 
-- 
2.39.5



