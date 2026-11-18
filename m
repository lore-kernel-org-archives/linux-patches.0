Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046977;
	b=WY8t7XUh6FeS1EoRXwdgMoNte0iYr4PmHgrb8T34AGsJTbyZ9SX7Lbfhrv/yX6KhDsrO
	 nbUZMkU4z/koVX28imiqDUob6DL/+5ykujEnujrLIwV7yIkyxqwTemC75pH+R4BKrSGJb
	 RKu4d6f/pWsofiexgCR/JWJ/zfDHq6J5mxGZV0XWIJGsZVdb9xWiVuWMl4SDa7GKyQYzA
	 LL4g2Dv0DxjXsixRtsJqQkv64Kk63UOZSfXFW+1eUOctLPKJgHDf+NMYgnRzSknojAUMq
	 wk2wlhzxJNjZth/jRacp/cS1C+8zGZcZkEziqdnomc2o9Vv5tISyekG2Lx+An9Na16w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6/G9F5P1tQyBCzcBcCFwIYIPB5/ttHd47N7Dx0uV1uo=;
	b=RWibxI+Qq1T8bFXhchy+vlQJGjCarZuiZZzgOC2F68H2460D5ScjmMlGvmflVRaayLRq
	 1Va2qz+jXWoani15z2+zn8qwb4YW0LAGjIlOf0Zs2iFEQ5BnR4QHNCGzKM0mrw9uNrpT9
	 thFpR7+ATtE87jJN8RiGp6nPLm9bdU3gMdYVuIaeUXcZ/9gYXzeOxVxnChQKRCktQ+Up2
	 VcsY+nQx+K5/MFdQvhgE6AHOJHtwsv/CeaqLc6U3/Oka3iJ26ijWRCB0Yi6PKOsWeXlv9
	 3EGpwydbq+IwO/V+2xFu33qJf6NxHuOjTW2hYoBWkHaGuWr4Zw/95zGS2mNxRSxqApQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxvfCHk1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D914606A32F;
	Thu, 19 Nov 2026 00:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxvfCHk1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8977D1F000C4;
	Thu, 19 Nov 2026 00:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046977;
	bh=6/G9F5P1tQyBCzcBcCFwIYIPB5/ttHd47N7Dx0uV1uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxvfCHk1NIdfoQbcXHAzZo6xyJXGQnQoQoeNIXHtkllYjzzFF7JFT6EXz6v1oyPj8
	 wW+LePGyezs4uP69oGOta5Xjs0YNIdaTtlBH6PTMleYYxKfGMsPW6EEI2vG6/UnqFU
	 OvHWWaJ9HiUXzTjq3ciN7CyLykuEA5O4Ui0AxFDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1475/2857] drm/amdkfd: fix doorbell allocation race creating duplicate allocations
Date: Wed, 18 Nov 2026 15:41:49 +0100
Message-ID: <20261118150254.420333946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted doorbell allocation locking for numeric indices instead of buffer objects. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      |  6 ++---
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c     | 23 +++++++++++--------
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h         |  5 +++-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c      |  3 +++
 .../amd/amdkfd/kfd_process_queue_manager.c    |  3 +--
 5 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 43bfd668c5480..a08c84556ace4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -333,8 +333,7 @@ static int kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p,
 		goto err_bind_process;
 	}
 
-	if (!pdd->doorbell_index &&
-	    kfd_alloc_process_doorbells(dev, &pdd->doorbell_index) < 0) {
+	if (kfd_alloc_process_doorbells(dev, pdd) < 0) {
 		err = -ENOMEM;
 		goto err_alloc_doorbells;
 	}
@@ -2203,8 +2202,7 @@ static int criu_restore_devices(struct kfd_process *p,
 			goto exit;
 		}
 
-		if (!pdd->doorbell_index &&
-		    kfd_alloc_process_doorbells(pdd->dev, &pdd->doorbell_index) < 0) {
+		if (kfd_alloc_process_doorbells(pdd->dev, pdd) < 0) {
 			ret = -ENOMEM;
 			goto exit;
 		}
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index 3ac599f74fea8..a38e3e917c437 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -277,35 +277,40 @@ uint64_t kfd_get_number_elems(struct kfd_dev *kfd)
 
 phys_addr_t kfd_get_process_doorbells(struct kfd_process_device *pdd)
 {
-	if (!pdd->doorbell_index) {
-		int r = kfd_alloc_process_doorbells(pdd->dev,
-						    &pdd->doorbell_index);
-		if (r < 0)
-			return 0;
-	}
+	if (kfd_alloc_process_doorbells(pdd->dev, pdd) < 0)
+		return 0;
 
 	return pdd->dev->doorbell_base +
 		pdd->doorbell_index * kfd_doorbell_process_slice(pdd->dev);
 }
 
-int kfd_alloc_process_doorbells(struct kfd_dev *kfd, unsigned int *doorbell_index)
+int kfd_alloc_process_doorbells(struct kfd_dev *kfd, struct kfd_process_device *pdd)
 {
 	int r = 0;
 
+	mutex_lock(&pdd->doorbell_mutex);
+
+	/* Another thread may have won the check-and-allocate race */
+	if (pdd->doorbell_index) {
+		mutex_unlock(&pdd->doorbell_mutex);
+		return 0;
+	}
+
 	if (!kfd->shared_resources.enable_mes)
 		r = ida_simple_get(&kfd->doorbell_ida, 1,
 				   kfd->max_doorbell_slices, GFP_KERNEL);
 	else
 		r = amdgpu_mes_alloc_process_doorbells(
 				(struct amdgpu_device *)kfd->adev,
-				doorbell_index);
+				&pdd->doorbell_index);
 
 	if (r > 0)
-		*doorbell_index = r;
+		pdd->doorbell_index = r;
 
 	if (r < 0)
 		pr_err("Failed to allocate process doorbells\n");
 
+	mutex_unlock(&pdd->doorbell_mutex);
 	return r;
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index cdcaba185052c..04f8098b8ba3d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -712,6 +712,9 @@ struct kfd_process_device {
 	/* per-process-per device QCM data structure */
 	struct qcm_process_device qpd;
 
+	/* Serializes process doorbell allocation for this device */
+	struct mutex doorbell_mutex;
+
 	/*Apertures*/
 	uint64_t lds_base;
 	uint64_t lds_limit;
@@ -1017,7 +1020,7 @@ unsigned int kfd_get_doorbell_dw_offset_in_bar(struct kfd_dev *kfd,
 					unsigned int doorbell_id);
 phys_addr_t kfd_get_process_doorbells(struct kfd_process_device *pdd);
 int kfd_alloc_process_doorbells(struct kfd_dev *kfd,
-				unsigned int *doorbell_index);
+				struct kfd_process_device *pdd);
 void kfd_free_process_doorbells(struct kfd_dev *kfd,
 				unsigned int doorbell_index);
 /* GTT Sub-Allocator */
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index fd7fecaa9254b..db0689c23e6ad 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1065,6 +1065,8 @@ static void kfd_process_destroy_pdds(struct kfd_process *p)
 			pdd->runtime_inuse = false;
 		}
 
+		mutex_destroy(&pdd->doorbell_mutex);
+
 		kfree(pdd);
 		p->pdds[i] = NULL;
 	}
@@ -1613,6 +1615,7 @@ struct kfd_process_device *kfd_create_process_device_data(struct kfd_dev *dev,
 		memset(pdd->proc_ctx_cpu_ptr, 0, AMDGPU_MES_PROC_CTX_SIZE);
 	}
 
+	mutex_init(&pdd->doorbell_mutex);
 	p->pdds[p->n_pdds++] = pdd;
 
 	/* Init idr used for memory handle translation */
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 7c85bb9e270e7..b28b15e2d14c1 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -868,8 +868,7 @@ int kfd_criu_restore_queue(struct kfd_process *p,
 
 	*priv_data_offset += q_extra_data_size;
 
-	if (!pdd->doorbell_index &&
-	    kfd_alloc_process_doorbells(pdd->dev, &pdd->doorbell_index) < 0) {
+	if (kfd_alloc_process_doorbells(pdd->dev, pdd) < 0) {
 		ret = -ENOMEM;
 		goto exit;
 	}
-- 
2.53.0



