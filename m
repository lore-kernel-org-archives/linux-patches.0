Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C20227F737;
	Tue, 27 May 2025 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364926; cv=none; b=GMfXpGOvo5+scLtq6Xx20sm1u+kxmgx9HIooK9zzMtiE+e6eo97aDD4lvPvaAcL729uDqs9Oo2jDSjuV8m9DCQVh8hsof0ZyE64KWXns9EwLv4nFhgA+tAtIHa4iaImuaHvoaDFSczawwozmosKhr5N2JHsXZBRJJQqUOEzMQv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364926; c=relaxed/simple;
	bh=LQraXGMF3DbzaCPeV+aug2ED+7z6J2bQMZwR6QVs4/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAINsYUaY0snCHfV7U/p80wPepWfYWzSPj3BYXEjGR6Zp/Jg23fc+1nTAyhZBrSVfLUiTFDyqa5UY6S6xiW/zX/CuyzJqT/AvLgW5wj7x1DWFmmEOBwxqTVev10Se/bFRTYfeN5L9VVNgxaiZ4+5tvjGWLM0NlorPRMmBpwpckI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IA+NAeJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IA+NAeJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCE7C4CEE9;
	Tue, 27 May 2025 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364926;
	bh=LQraXGMF3DbzaCPeV+aug2ED+7z6J2bQMZwR6QVs4/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IA+NAeJe2N3shX88BVjgSz9mGXwEHTiAuyJrJHONxMMCtBPnStD+m6JttomXe5r8k
	 d6qFe1Puuv8yHRLc562zSvQw9CsMyf3gbp0/Iol/IHkBcE9W4bDs+tnim8qrn0QPAC
	 8zr/tF6a+OPtAQxVXbbxGsdu/r0qDhRzubVYF0NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/626] drm/amdkfd: Set per-process flags only once for gfx9/10/11/12
Date: Tue, 27 May 2025 18:21:42 +0200
Message-ID: <20250527162453.510945982@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 210bcc048f4c5..3264509408bc8 100644
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



