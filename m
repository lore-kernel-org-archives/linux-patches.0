Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03C12110E;
	Tue, 27 May 2025 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367108; cv=none; b=GV542i2YOGAdvLLdXr4L3yOFx4PJ4kpecuZavPzmaTtyRn2/8vRyrKYCJ1l0CHcweshrFzf7jgIRgVlb28uxs/fZXjC7upJpfifAsyGVFZANqF4BiDy360oKX+0LD14d7lOvd8mTYux5uPhXyUpq16cHEEDJFh40CAaUj1c2zkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367108; c=relaxed/simple;
	bh=6BHOJVj+2lshRF0hIc3tSDfMKDcO9rNk62RlZAlKA+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpDIR42jkbCUnYD3PU589VrMMOcnHnzI41RCnysxgmk+YWSolMYey2AD0bB31VSuUG5a8jP3TGZ3KvvWfVfsN39PepmUS4CHTu6VlN0IYTfdtXVS2YvguwTTMiSOXBaaUgx5/EtCZKtDOC67hnAkb2Z+6r1GA0zTG/50mrXh+ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vE+5GXB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vE+5GXB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718CBC4CEE9;
	Tue, 27 May 2025 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367107;
	bh=6BHOJVj+2lshRF0hIc3tSDfMKDcO9rNk62RlZAlKA+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vE+5GXB3uCNWFy5FNpSIWn1fzJwzKRW3H/AFC7XctBH0InMXaFhrU7zixorACfv+0
	 dikbyuLosQRJg27NQNi4y8h0J91yA2glJFX8kX56YtXhc7Z1/3feknvy+vA7/jjyp9
	 wdLFoNQutHSP3u6hR30alTdEL+vcDyArG32dhz8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 251/783] drm/amdkfd: Set per-process flags only once for gfx9/10/11/12
Date: Tue, 27 May 2025 18:20:48 +0200
Message-ID: <20250527162523.325278707@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit 61972cd93af70738a6ad7f93e17cc7f68a01e182 ]

Define set_cache_memory_policy() for these asics and move all static
changes from update_qpd() which is called each time a queue is created
to set_cache_memory_policy() which is called once during process
initialization

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Amber Lin <Amber.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/amdkfd/kfd_device_queue_manager_v10.c | 41 +++++++++++--------
 .../amd/amdkfd/kfd_device_queue_manager_v11.c | 41 +++++++++++--------
 .../amd/amdkfd/kfd_device_queue_manager_v12.c | 41 +++++++++++--------
 .../amd/amdkfd/kfd_device_queue_manager_v9.c  | 36 +++++++++++++++-
 4 files changed, 107 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v10.c
index 245a90dfc2f6b..b5f5f141353b5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v10.c
@@ -31,10 +31,17 @@ static int update_qpd_v10(struct device_queue_manager *dqm,
 			 struct qcm_process_device *qpd);
 static void init_sdma_vm_v10(struct device_queue_manager *dqm, struct queue *q,
 			    struct qcm_process_device *qpd);
+static bool set_cache_memory_policy_v10(struct device_queue_manager *dqm,
+				   struct qcm_process_device *qpd,
+				   enum cache_policy default_policy,
+				   enum cache_policy alternate_policy,
+				   void __user *alternate_aperture_base,
+				   uint64_t alternate_aperture_size);
 
 void device_queue_manager_init_v10(
 	struct device_queue_manager_asic_ops *asic_ops)
 {
+	asic_ops->set_cache_memory_policy = set_cache_memory_policy_v10;
 	asic_ops->update_qpd = update_qpd_v10;
 	asic_ops->init_sdma_vm = init_sdma_vm_v10;
 	asic_ops->mqd_manager_init = mqd_manager_init_v10;
@@ -49,27 +56,27 @@ static uint32_t compute_sh_mem_bases_64bit(struct kfd_process_device *pdd)
 		private_base;
 }
 
-static int update_qpd_v10(struct device_queue_manager *dqm,
-			 struct qcm_process_device *qpd)
+static bool set_cache_memory_policy_v10(struct device_queue_manager *dqm,
+				   struct qcm_process_device *qpd,
+				   enum cache_policy default_policy,
+				   enum cache_policy alternate_policy,
+				   void __user *alternate_aperture_base,
+				   uint64_t alternate_aperture_size)
 {
-	struct kfd_process_device *pdd;
-
-	pdd = qpd_to_pdd(qpd);
-
-	/* check if sh_mem_config register already configured */
-	if (qpd->sh_mem_config == 0) {
-		qpd->sh_mem_config =
-			(SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
-				SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT) |
-			(3 << SH_MEM_CONFIG__INITIAL_INST_PREFETCH__SHIFT);
-		qpd->sh_mem_ape1_limit = 0;
-		qpd->sh_mem_ape1_base = 0;
-	}
-
-	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(pdd);
+	qpd->sh_mem_config = (SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
+			      SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT) |
+			      (3 << SH_MEM_CONFIG__INITIAL_INST_PREFETCH__SHIFT);
+	qpd->sh_mem_ape1_limit = 0;
+	qpd->sh_mem_ape1_base = 0;
+	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(qpd_to_pdd(qpd));
 
 	pr_debug("sh_mem_bases 0x%X\n", qpd->sh_mem_bases);
+	return true;
+}
 
+static int update_qpd_v10(struct device_queue_manager *dqm,
+			 struct qcm_process_device *qpd)
+{
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v11.c
index 2e129da7acb43..f436878d0d621 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v11.c
@@ -30,10 +30,17 @@ static int update_qpd_v11(struct device_queue_manager *dqm,
 			 struct qcm_process_device *qpd);
 static void init_sdma_vm_v11(struct device_queue_manager *dqm, struct queue *q,
 			    struct qcm_process_device *qpd);
+static bool set_cache_memory_policy_v11(struct device_queue_manager *dqm,
+				   struct qcm_process_device *qpd,
+				   enum cache_policy default_policy,
+				   enum cache_policy alternate_policy,
+				   void __user *alternate_aperture_base,
+				   uint64_t alternate_aperture_size);
 
 void device_queue_manager_init_v11(
 	struct device_queue_manager_asic_ops *asic_ops)
 {
+	asic_ops->set_cache_memory_policy = set_cache_memory_policy_v11;
 	asic_ops->update_qpd = update_qpd_v11;
 	asic_ops->init_sdma_vm = init_sdma_vm_v11;
 	asic_ops->mqd_manager_init = mqd_manager_init_v11;
@@ -48,28 +55,28 @@ static uint32_t compute_sh_mem_bases_64bit(struct kfd_process_device *pdd)
 		private_base;
 }
 
-static int update_qpd_v11(struct device_queue_manager *dqm,
-			 struct qcm_process_device *qpd)
+static bool set_cache_memory_policy_v11(struct device_queue_manager *dqm,
+				   struct qcm_process_device *qpd,
+				   enum cache_policy default_policy,
+				   enum cache_policy alternate_policy,
+				   void __user *alternate_aperture_base,
+				   uint64_t alternate_aperture_size)
 {
-	struct kfd_process_device *pdd;
-
-	pdd = qpd_to_pdd(qpd);
-
-	/* check if sh_mem_config register already configured */
-	if (qpd->sh_mem_config == 0) {
-		qpd->sh_mem_config =
-			(SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
-				SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT) |
-			(3 << SH_MEM_CONFIG__INITIAL_INST_PREFETCH__SHIFT);
-
-		qpd->sh_mem_ape1_limit = 0;
-		qpd->sh_mem_ape1_base = 0;
-	}
+	qpd->sh_mem_config = (SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
+			      SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT) |
+			      (3 << SH_MEM_CONFIG__INITIAL_INST_PREFETCH__SHIFT);
 
-	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(pdd);
+	qpd->sh_mem_ape1_limit = 0;
+	qpd->sh_mem_ape1_base = 0;
+	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(qpd_to_pdd(qpd));
 
 	pr_debug("sh_mem_bases 0x%X\n", qpd->sh_mem_bases);
+	return true;
+}
 
+static int update_qpd_v11(struct device_queue_manager *dqm,
+			 struct qcm_process_device *qpd)
+{
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v12.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v12.c
index 4f3295b29dfb1..62ca1c8fcbaf9 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v12.c
@@ -30,10 +30,17 @@ static int update_qpd_v12(struct device_queue_manager *dqm,
 			 struct qcm_process_device *qpd);
 static void init_sdma_vm_v12(struct device_queue_manager *dqm, struct queue *q,
 			    struct qcm_process_device *qpd);
+static bool set_cache_memory_policy_v12(struct device_queue_manager *dqm,
+				   struct qcm_process_device *qpd,
+				   enum cache_policy default_policy,
+				   enum cache_policy alternate_policy,
+				   void __user *alternate_aperture_base,
+				   uint64_t alternate_aperture_size);
 
 void device_queue_manager_init_v12(
 	struct device_queue_manager_asic_ops *asic_ops)
 {
+	asic_ops->set_cache_memory_policy = set_cache_memory_policy_v12;
 	asic_ops->update_qpd = update_qpd_v12;
 	asic_ops->init_sdma_vm = init_sdma_vm_v12;
 	asic_ops->mqd_manager_init = mqd_manager_init_v12;
@@ -48,28 +55,28 @@ static uint32_t compute_sh_mem_bases_64bit(struct kfd_process_device *pdd)
 		private_base;
 }
 
-static int update_qpd_v12(struct device_queue_manager *dqm,
-			 struct qcm_process_device *qpd)
+static bool set_cache_memory_policy_v12(struct device_queue_manager *dqm,
+				   struct qcm_process_device *qpd,
+				   enum cache_policy default_policy,
+				   enum cache_policy alternate_policy,
+				   void __user *alternate_aperture_base,
+				   uint64_t alternate_aperture_size)
 {
-	struct kfd_process_device *pdd;
-
-	pdd = qpd_to_pdd(qpd);
-
-	/* check if sh_mem_config register already configured */
-	if (qpd->sh_mem_config == 0) {
-		qpd->sh_mem_config =
-			(SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
-				SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT) |
-			(3 << SH_MEM_CONFIG__INITIAL_INST_PREFETCH__SHIFT);
-
-		qpd->sh_mem_ape1_limit = 0;
-		qpd->sh_mem_ape1_base = 0;
-	}
+	qpd->sh_mem_config = (SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
+			      SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT) |
+			      (3 << SH_MEM_CONFIG__INITIAL_INST_PREFETCH__SHIFT);
 
-	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(pdd);
+	qpd->sh_mem_ape1_limit = 0;
+	qpd->sh_mem_ape1_base = 0;
+	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(qpd_to_pdd(qpd));
 
 	pr_debug("sh_mem_bases 0x%X\n", qpd->sh_mem_bases);
+	return true;
+}
 
+static int update_qpd_v12(struct device_queue_manager *dqm,
+			 struct qcm_process_device *qpd)
+{
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
index 67137e674f1d0..c734eb9b505f8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v9.c
@@ -30,10 +30,17 @@ static int update_qpd_v9(struct device_queue_manager *dqm,
 			 struct qcm_process_device *qpd);
 static void init_sdma_vm_v9(struct device_queue_manager *dqm, struct queue *q,
 			    struct qcm_process_device *qpd);
+static bool set_cache_memory_policy_v9(struct device_queue_manager *dqm,
+				   struct qcm_process_device *qpd,
+				   enum cache_policy default_policy,
+				   enum cache_policy alternate_policy,
+				   void __user *alternate_aperture_base,
+				   uint64_t alternate_aperture_size);
 
 void device_queue_manager_init_v9(
 	struct device_queue_manager_asic_ops *asic_ops)
 {
+	asic_ops->set_cache_memory_policy = set_cache_memory_policy_v9;
 	asic_ops->update_qpd = update_qpd_v9;
 	asic_ops->init_sdma_vm = init_sdma_vm_v9;
 	asic_ops->mqd_manager_init = mqd_manager_init_v9;
@@ -48,10 +55,37 @@ static uint32_t compute_sh_mem_bases_64bit(struct kfd_process_device *pdd)
 		private_base;
 }
 
+static bool set_cache_memory_policy_v9(struct device_queue_manager *dqm,
+				   struct qcm_process_device *qpd,
+				   enum cache_policy default_policy,
+				   enum cache_policy alternate_policy,
+				   void __user *alternate_aperture_base,
+				   uint64_t alternate_aperture_size)
+{
+	qpd->sh_mem_config = SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
+				SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT;
+
+	if (dqm->dev->kfd->noretry)
+		qpd->sh_mem_config |= 1 << SH_MEM_CONFIG__RETRY_DISABLE__SHIFT;
+
+	if (KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 3) ||
+		KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 4, 4) ||
+		KFD_GC_VERSION(dqm->dev->kfd) == IP_VERSION(9, 5, 0))
+		qpd->sh_mem_config |= (1 << SH_MEM_CONFIG__F8_MODE__SHIFT);
+
+	qpd->sh_mem_ape1_limit = 0;
+	qpd->sh_mem_ape1_base = 0;
+	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(qpd_to_pdd(qpd));
+
+	pr_debug("sh_mem_bases 0x%X sh_mem_config 0x%X\n", qpd->sh_mem_bases,
+		 qpd->sh_mem_config);
+	return true;
+}
+
 static int update_qpd_v9(struct device_queue_manager *dqm,
 			 struct qcm_process_device *qpd)
 {
-	struct kfd_process_device *pdd;
+	struct kfd_process_device *pdd = qpd_to_pdd(qpd);
 
 	pdd = qpd_to_pdd(qpd);
 
-- 
2.39.5



