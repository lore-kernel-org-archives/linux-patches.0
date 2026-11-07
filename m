Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063538;
	b=NSnwANwXvNJUPmbT06fuzs6a8ervMfpuuza13URqfXFF3zpnU79GNvt1HahuICJUWy60
	 9TesLh8pu/RCD1ioWr/r7ffJ4cJn/HCpc3Hd7ov1DtTPgyBMdTGj5HyQKIRAK102FHMmK
	 QYKSNs+jNnCcEUrN97J7aI63Rvw2jLyph3GB2CpKnD+B9aHLyFpxbT82+FCyBQTeLtZQL
	 +HNnJM0fMXo4offlSvEW9x+DcxticOUC9qsLikJOR0ZdOLJC1FkJZFUwnSnshToOr3QpC
	 YdkZotRQHSadKNfSOfwkfbobHMw2B9R5ifA14tRFmVcN0Qd4TSQmkHNOAUgV8CyNBnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dF8/3gNRg1Dy+faXtiqPWlLxue1JvSsN4pSJTUUWvMY=;
	b=beCFcrZRjtcWitsfW4izplorPBrPgPwQLC7e8Lgfq743MUeGhW7jTIflZloXBZBHLQwu
	 5Thc+BwPDeGJkUvoZrsiyaG9lAAJQeHxd083N9l+kcWLU10Cur71XHalRv3RwIWS68qBr
	 Cix3DHPmTPapNhaSubeGkp7sMc9pS4r0CcV91vA7CQYWZSdBPorRzRRoEpFLC7A6PVZJb
	 A5eiDIibGDkITxByieAmqNZ1yfUhKdiPug28MvkTKlNYSOYomns9bMEtXBojzpubUpPAA
	 CcLN7phefTDrU4vlcg8UTWtumGf5mXU+cOkHFifVAQ0L60mUicRuQUuIou8Ny9i/g+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hmu8pB/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE59606D802;
	Sat,  7 Nov 2026 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmu8pB/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9231F008A1;
	Sat,  7 Nov 2026 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063538;
	bh=dF8/3gNRg1Dy+faXtiqPWlLxue1JvSsN4pSJTUUWvMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmu8pB/oaK916fb4lVhA9ouPdnNb3vYzeUsIkhFdcJcC29ZHbLo2Xw960BU0HDoHo
	 4izjDpzDvDG94gXeGSRlsUeBYHazxEH8jlR2+eOlScQycUJdrhh0yw7BpAbXIJBzaA
	 UE2qJ1YK4o7fpFRmvMu/0kX0dB+5ZIA2+vRDrGI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 674/869] drm/amdkfd: fix doorbell allocation race creating duplicate allocations
Date: Sat,  7 Nov 2026 08:55:56 -0500
Message-ID: <20261107134915.952486407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit bebad45050945a3d668d6701fb77ae2571c5d44b ]

The check-and-allocate sequence on pdd->qpd.proc_doorbells is
lockless at every call site of kfd_alloc_process_doorbells():
kfd_get_process_doorbells() (mmap of /dev/kfd),
kfd_ioctl_create_queue() and the CRIU restore path each test the
pointer under different locking (or none), so two racing threads can
both observe NULL and each allocate a doorbell BO and bitmap,
orphaning one allocation and handing the two mappings different
backing pages.

Move the serialization into kfd_alloc_process_doorbells() itself,
using a new per-process-device mutex so all three call sites are
covered regardless of their own locking.  The device-global
kfd->doorbell_mutex is not suitable here: it is acquired under
dqm->lock on the kernel-doorbell path (start_cpsch() -> pm_init() ->
kq_initialize() -> kfd_get_kernel_doorbell()), so holding it across
the sleeping allocations above would create a lock-ordering
inversion with dqm->lock via TTM eviction, and it would also
serialize doorbell setup of unrelated processes behind a
device-wide lock for per-process state.

This issue was discovered by Tencent CodeBuddy Security.

v3 (Felix Kuehling):
- Removed unlocked check in kfd_get_process_doorbell flagged as
  problematic by Sashiko Bot. Fall back to the locked check inside
  kfd_alloc_process_doorbells
- Added missing mutex_destroy
v4 (Felix Kuehling):
- Removed unlocked checks around other kfd_alloc_process_doorbells calls

Fixes: 16f0013157bf ("drm/amdkfd: Allocate doorbells only when needed")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4e27ba5ad5f76932d4f6cbacd25c81c2dd40ec4a)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c  | 18 +++++++-----------
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c | 23 +++++++++++++++++------
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h     |  3 +++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c  |  2 ++
 4 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 04c2d412fa7da..c224d78a770a1 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -352,12 +352,10 @@ static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
 		}
 	}
 
-	if (!pdd->qpd.proc_doorbells) {
-		err = kfd_alloc_process_doorbells(dev->kfd, pdd);
-		if (err) {
-			pr_debug("failed to allocate process doorbells\n");
-			goto err_bind_process;
-		}
+	err = kfd_alloc_process_doorbells(dev->kfd, pdd);
+	if (err) {
+		pr_debug("failed to allocate process doorbells\n");
+		goto err_bind_process;
 	}
 
 	err = kfd_queue_acquire_buffers(pdd, &q_properties);
@@ -2282,11 +2280,9 @@ static int criu_restore_devices(struct kfd_process *p,
 			goto exit;
 		}
 
-		if (!pdd->qpd.proc_doorbells) {
-			ret = kfd_alloc_process_doorbells(dev->kfd, pdd);
-			if (ret)
-				goto exit;
-		}
+		ret = kfd_alloc_process_doorbells(dev->kfd, pdd);
+		if (ret)
+			goto exit;
 	}
 
 	/*
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index fdcf7f2d1b5b4..6af268a031f22 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -239,11 +239,9 @@ phys_addr_t kfd_get_process_doorbells(struct kfd_process_device *pdd)
 	struct amdgpu_device *adev = pdd->dev->adev;
 	uint32_t first_db_index;
 
-	if (!pdd->qpd.proc_doorbells) {
-		if (kfd_alloc_process_doorbells(pdd->dev->kfd, pdd))
-			/* phys_addr_t 0 is error */
-			return 0;
-	}
+	if (kfd_alloc_process_doorbells(pdd->dev->kfd, pdd))
+		/* phys_addr_t 0 is error */
+		return 0;
 
 	first_db_index = amdgpu_doorbell_index_on_bar(adev,
 						      pdd->qpd.proc_doorbells,
@@ -257,12 +255,21 @@ int kfd_alloc_process_doorbells(struct kfd_dev *kfd, struct kfd_process_device *
 	int r;
 	struct qcm_process_device *qpd = &pdd->qpd;
 
+	mutex_lock(&pdd->doorbell_mutex);
+
+	/* Another thread may have won the check-and-allocate race */
+	if (qpd->proc_doorbells) {
+		mutex_unlock(&pdd->doorbell_mutex);
+		return 0;
+	}
+
 	/* Allocate bitmap for dynamic doorbell allocation */
 	qpd->doorbell_bitmap = bitmap_zalloc(KFD_MAX_NUM_OF_QUEUES_PER_PROCESS,
 					     GFP_KERNEL);
 	if (!qpd->doorbell_bitmap) {
 		DRM_ERROR("Failed to allocate process doorbell bitmap\n");
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto unlock;
 	}
 
 	r = init_doorbell_bitmap(&pdd->qpd, kfd);
@@ -284,11 +291,15 @@ int kfd_alloc_process_doorbells(struct kfd_dev *kfd, struct kfd_process_device *
 		DRM_ERROR("Failed to allocate process doorbells\n");
 		goto err;
 	}
+
+	mutex_unlock(&pdd->doorbell_mutex);
 	return 0;
 
 err:
 	bitmap_free(qpd->doorbell_bitmap);
 	qpd->doorbell_bitmap = NULL;
+unlock:
+	mutex_unlock(&pdd->doorbell_mutex);
 	return r;
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index f2cda82cbed4c..ef1afeaa8d85d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -769,6 +769,9 @@ struct kfd_process_device {
 	/* per-process-per device QCM data structure */
 	struct qcm_process_device qpd;
 
+	/* Serializes process doorbell allocation for this device */
+	struct mutex doorbell_mutex;
+
 	/*Apertures*/
 	uint64_t lds_base;
 	uint64_t lds_limit;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 8ed513a77d38f..0b760aab11c6f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1089,6 +1089,7 @@ static void kfd_process_destroy_pdds(struct kfd_process *p)
 		}
 
 		atomic_dec(&pdd->dev->kfd->kfd_processes_count);
+		mutex_destroy(&pdd->doorbell_mutex);
 
 		kfree(pdd);
 		p->pdds[i] = NULL;
@@ -1628,6 +1629,7 @@ struct kfd_process_device *kfd_create_process_device_data(struct kfd_node *dev,
 	pdd->dev = dev;
 	INIT_LIST_HEAD(&pdd->qpd.queues_list);
 	INIT_LIST_HEAD(&pdd->qpd.priv_queue_list);
+	mutex_init(&pdd->doorbell_mutex);
 	pdd->qpd.dqm = dev->dqm;
 	pdd->qpd.pqm = &p->pqm;
 	pdd->qpd.evicted = 0;
-- 
2.53.0



