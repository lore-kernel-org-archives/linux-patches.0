Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6194C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6B0C433D7;
	Mon, 14 Nov 2022 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430446;
	bh=W6F5b4qHa+JLdhr8x8JF/5cu3rvA9ICsQ7erCH4RlXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3vLhEdn4FKop42yiYXEQbAbnXmSBDi7TE96hqEB4Rf+C0yFvNzUFZjQWxXimTLv9
	 4j5q+8NeSf+e78Vtv6x5mVlygh9OTn8VjNHKzR5v4h7PLAVSe4DLaZ/Zcddvn+4qOA
	 opPhzEhuxvwkgMNyiHg05In48B0r1/odGBRZXYcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/131] drm/amdkfd: handle CPU fault on COW mapping
Date: Mon, 14 Nov 2022 13:44:34 +0100
Message-Id: <20221114124448.974337309@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit e1f84eef313f4820cca068a238c645d0a38c6a9b ]

If CPU page fault in a page with zone_device_data svm_bo from another
process, that means it is COW mapping in the child process and the
range is migrated to VRAM by parent process. Migrate the parent
process range back to system memory to recover the CPU page fault.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5b994354af3c ("drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 42 ++++++++++++++++--------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index a458c19b371a..0cc425f198b4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -780,7 +780,7 @@ svm_migrate_to_vram(struct svm_range *prange, uint32_t best_loc,
 static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 {
 	unsigned long addr = vmf->address;
-	struct vm_area_struct *vma;
+	struct svm_range_bo *svm_bo;
 	enum svm_work_list_ops op;
 	struct svm_range *parent;
 	struct svm_range *prange;
@@ -788,29 +788,42 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 	struct mm_struct *mm;
 	int r = 0;
 
-	vma = vmf->vma;
-	mm = vma->vm_mm;
+	svm_bo = vmf->page->zone_device_data;
+	if (!svm_bo) {
+		pr_debug("failed get device page at addr 0x%lx\n", addr);
+		return VM_FAULT_SIGBUS;
+	}
+	if (!mmget_not_zero(svm_bo->eviction_fence->mm)) {
+		pr_debug("addr 0x%lx of process mm is detroyed\n", addr);
+		return VM_FAULT_SIGBUS;
+	}
+
+	mm = svm_bo->eviction_fence->mm;
+	if (mm != vmf->vma->vm_mm)
+		pr_debug("addr 0x%lx is COW mapping in child process\n", addr);
 
-	p = kfd_lookup_process_by_mm(vma->vm_mm);
+	p = kfd_lookup_process_by_mm(mm);
 	if (!p) {
 		pr_debug("failed find process at fault address 0x%lx\n", addr);
-		return VM_FAULT_SIGBUS;
+		r = VM_FAULT_SIGBUS;
+		goto out_mmput;
 	}
 	if (READ_ONCE(p->svms.faulting_task) == current) {
 		pr_debug("skipping ram migration\n");
-		kfd_unref_process(p);
-		return 0;
+		r = 0;
+		goto out_unref_process;
 	}
-	addr >>= PAGE_SHIFT;
+
 	pr_debug("CPU page fault svms 0x%p address 0x%lx\n", &p->svms, addr);
+	addr >>= PAGE_SHIFT;
 
 	mutex_lock(&p->svms.lock);
 
 	prange = svm_range_from_addr(&p->svms, addr, &parent);
 	if (!prange) {
-		pr_debug("cannot find svm range at 0x%lx\n", addr);
+		pr_debug("failed get range svms 0x%p addr 0x%lx\n", &p->svms, addr);
 		r = -EFAULT;
-		goto out;
+		goto out_unlock_svms;
 	}
 
 	mutex_lock(&parent->migrate_mutex);
@@ -834,8 +847,8 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 
 	r = svm_migrate_vram_to_ram(prange, mm);
 	if (r)
-		pr_debug("failed %d migrate 0x%p [0x%lx 0x%lx] to ram\n", r,
-			 prange, prange->start, prange->last);
+		pr_debug("failed %d migrate svms 0x%p range 0x%p [0x%lx 0x%lx]\n",
+			 r, prange->svms, prange, prange->start, prange->last);
 
 	/* xnack on, update mapping on GPUs with ACCESS_IN_PLACE */
 	if (p->xnack_enabled && parent == prange)
@@ -849,9 +862,12 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 	if (prange != parent)
 		mutex_unlock(&prange->migrate_mutex);
 	mutex_unlock(&parent->migrate_mutex);
-out:
+out_unlock_svms:
 	mutex_unlock(&p->svms.lock);
+out_unref_process:
 	kfd_unref_process(p);
+out_mmput:
+	mmput(mm);
 
 	pr_debug("CPU fault svms 0x%p address 0x%lx done\n", &p->svms, addr);
 
-- 
2.35.1



