Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421A6FBE0;
	Mon, 11 Dec 2023 18:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2gqKBaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF84C433C8;
	Mon, 11 Dec 2023 18:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319442;
	bh=mIZD2AtwbZnGgC4AzJSsWVMxaPNKpE27eNtwnJ6Scag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2gqKBaf5GggJBePsqMBdqNsfbrDzHNUriPy8icRs33AIHUigFfcPyzJ6pU7bTjn8
	 o7K3LN0ckedBXXOSRNELpTdkW/QnLrFEYAPR+uYJ68p81DqKPuUYgUg7dA+jJbLgxm
	 WKDIRtu3P0Tv15hCD0HeOQ+YdstDNFvJyt/yAIys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Koenig <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Shashank Sharma <shashank.sharma@amd.com>,
	Arvind Yadav <Arvind.Yadav@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/244] drm/amdkfd: get doorbells absolute offset based on the db_size
Date: Mon, 11 Dec 2023 19:19:29 +0100
Message-ID: <20231211182049.197578165@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Arvind Yadav <Arvind.Yadav@amd.com>

[ Upstream commit 367a0af43373d4f791cc8b466a659ecf5aa52377 ]

Here, Adding db_size in byte to find the doorbell's
absolute offset for both 32-bit and 64-bit doorbell sizes.
So that doorbell offset will be aligned based on the doorbell
size.

v2:
- Addressed the review comment from Felix.
v3:
- Adding doorbell_size as parameter to get db absolute offset.
v4:
  Squash the two patches into one.

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Shashank Sharma <shashank.sharma@amd.com>
Signed-off-by: Arvind Yadav <Arvind.Yadav@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell.h        |  5 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell_mgr.c    | 13 +++++++++----
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c   |  3 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c           | 10 ++++++++--
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c  |  3 ++-
 5 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell.h
index 09f6727e7c73a..4a8b33f55f6bc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell.h
@@ -357,8 +357,9 @@ int amdgpu_doorbell_init(struct amdgpu_device *adev);
 void amdgpu_doorbell_fini(struct amdgpu_device *adev);
 int amdgpu_doorbell_create_kernel_doorbells(struct amdgpu_device *adev);
 uint32_t amdgpu_doorbell_index_on_bar(struct amdgpu_device *adev,
-				       struct amdgpu_bo *db_bo,
-				       uint32_t doorbell_index);
+				      struct amdgpu_bo *db_bo,
+				      uint32_t doorbell_index,
+				      uint32_t db_size);
 
 #define RDOORBELL32(index) amdgpu_mm_rdoorbell(adev, (index))
 #define WDOORBELL32(index, v) amdgpu_mm_wdoorbell(adev, (index), (v))
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell_mgr.c
index 599aece42017a..3f3662e8b8710 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_doorbell_mgr.c
@@ -114,19 +114,24 @@ void amdgpu_mm_wdoorbell64(struct amdgpu_device *adev, u32 index, u64 v)
  * @adev: amdgpu_device pointer
  * @db_bo: doorbell object's bo
  * @doorbell_index: doorbell relative index in this doorbell object
+ * @db_size: doorbell size is in byte
  *
  * returns doorbell's absolute index in BAR
  */
 uint32_t amdgpu_doorbell_index_on_bar(struct amdgpu_device *adev,
-				       struct amdgpu_bo *db_bo,
-				       uint32_t doorbell_index)
+				      struct amdgpu_bo *db_bo,
+				      uint32_t doorbell_index,
+				      uint32_t db_size)
 {
 	int db_bo_offset;
 
 	db_bo_offset = amdgpu_bo_gpu_offset_no_check(db_bo);
 
-	/* doorbell index is 32 bit but doorbell's size is 64-bit, so *2 */
-	return db_bo_offset / sizeof(u32) + doorbell_index * 2;
+	/* doorbell index is 32 bit but doorbell's size can be 32 bit
+	 * or 64 bit, so *db_size(in byte)/4 for alignment.
+	 */
+	return db_bo_offset / sizeof(u32) + doorbell_index *
+	       DIV_ROUND_UP(db_size, 4);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 0d3d538b64ebc..e07652e724965 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -407,7 +407,8 @@ static int allocate_doorbell(struct qcm_process_device *qpd,
 
 	q->properties.doorbell_off = amdgpu_doorbell_index_on_bar(dev->adev,
 								  qpd->proc_doorbells,
-								  q->doorbell_id);
+								  q->doorbell_id,
+								  dev->kfd->device_info.doorbell_size);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index 7b38537c7c99b..05c74887fd6fd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -161,7 +161,10 @@ void __iomem *kfd_get_kernel_doorbell(struct kfd_dev *kfd,
 	if (inx >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
 		return NULL;
 
-	*doorbell_off = amdgpu_doorbell_index_on_bar(kfd->adev, kfd->doorbells, inx);
+	*doorbell_off = amdgpu_doorbell_index_on_bar(kfd->adev,
+						     kfd->doorbells,
+						     inx,
+						     kfd->device_info.doorbell_size);
 	inx *= 2;
 
 	pr_debug("Get kernel queue doorbell\n"
@@ -240,7 +243,10 @@ phys_addr_t kfd_get_process_doorbells(struct kfd_process_device *pdd)
 			return 0;
 	}
 
-	first_db_index = amdgpu_doorbell_index_on_bar(adev, pdd->qpd.proc_doorbells, 0);
+	first_db_index = amdgpu_doorbell_index_on_bar(adev,
+						      pdd->qpd.proc_doorbells,
+						      0,
+						      pdd->dev->kfd->device_info.doorbell_size);
 	return adev->doorbell.base + first_db_index * sizeof(uint32_t);
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index adb5e4bdc0b20..77649392e2331 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -377,7 +377,8 @@ int pqm_create_queue(struct process_queue_manager *pqm,
 		 */
 		uint32_t first_db_index = amdgpu_doorbell_index_on_bar(pdd->dev->adev,
 								       pdd->qpd.proc_doorbells,
-								       0);
+								       0,
+								       pdd->dev->kfd->device_info.doorbell_size);
 
 		*p_doorbell_offset_in_process = (q->properties.doorbell_off
 						- first_db_index) * sizeof(uint32_t);
-- 
2.42.0



