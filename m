Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88256FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8EFC433EF;
	Mon,  3 Apr 2023 14:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533066;
	bh=T+y02KqbdinWzs5BHyJ64yYI5IzZszI6qc+B2eCbKfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tE1aTCX6leQ6oMJld73MvmIr4ZPFWL3eYjGLjtC3Z3dn7gqLqjqypZclgcQeMKzZ8
	 ROqeO3lQ/8Aww1hiROgqzkZSBI4Cu12sEcON1jqkd8dIyP58N57QaettOIR7mZb/4v
	 kGkba22eVu7NYSRJos+loIGW9QMbD7rddpZPhljM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 041/187] drm/amdkfd: fix potential kgd_mem UAFs
Date: Mon,  3 Apr 2023 16:08:06 +0200
Message-Id: <20230403140417.334061882@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 9da050b0d9e04439d225a2ec3044af70cdfb3933 ]

kgd_mem pointers returned by kfd_process_device_translate_handle are
only guaranteed to be valid while p->mutex is held. As soon as the mutex
is unlocked, another thread can free the BO.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index f79b8e964140e..e191d38f3da62 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1298,14 +1298,14 @@ static int kfd_ioctl_map_memory_to_gpu(struct file *filep,
 		args->n_success = i+1;
 	}
 
-	mutex_unlock(&p->mutex);
-
 	err = amdgpu_amdkfd_gpuvm_sync_memory(dev->adev, (struct kgd_mem *) mem, true);
 	if (err) {
 		pr_debug("Sync memory failed, wait interrupted by user signal\n");
 		goto sync_memory_failed;
 	}
 
+	mutex_unlock(&p->mutex);
+
 	/* Flush TLBs after waiting for the page table updates to complete */
 	for (i = 0; i < args->n_devices; i++) {
 		peer_pdd = kfd_process_device_data_by_id(p, devices_arr[i]);
@@ -1321,9 +1321,9 @@ static int kfd_ioctl_map_memory_to_gpu(struct file *filep,
 bind_process_to_device_failed:
 get_mem_obj_from_handle_failed:
 map_memory_to_gpu_failed:
+sync_memory_failed:
 	mutex_unlock(&p->mutex);
 copy_from_user_failed:
-sync_memory_failed:
 	kfree(devices_arr);
 
 	return err;
@@ -1337,6 +1337,7 @@ static int kfd_ioctl_unmap_memory_from_gpu(struct file *filep,
 	void *mem;
 	long err = 0;
 	uint32_t *devices_arr = NULL, i;
+	bool flush_tlb;
 
 	if (!args->n_devices) {
 		pr_debug("Device IDs array empty\n");
@@ -1389,16 +1390,19 @@ static int kfd_ioctl_unmap_memory_from_gpu(struct file *filep,
 		}
 		args->n_success = i+1;
 	}
-	mutex_unlock(&p->mutex);
 
-	if (kfd_flush_tlb_after_unmap(pdd->dev)) {
+	flush_tlb = kfd_flush_tlb_after_unmap(pdd->dev);
+	if (flush_tlb) {
 		err = amdgpu_amdkfd_gpuvm_sync_memory(pdd->dev->adev,
 				(struct kgd_mem *) mem, true);
 		if (err) {
 			pr_debug("Sync memory failed, wait interrupted by user signal\n");
 			goto sync_memory_failed;
 		}
+	}
+	mutex_unlock(&p->mutex);
 
+	if (flush_tlb) {
 		/* Flush TLBs after waiting for the page table updates to complete */
 		for (i = 0; i < args->n_devices; i++) {
 			peer_pdd = kfd_process_device_data_by_id(p, devices_arr[i]);
@@ -1414,9 +1418,9 @@ static int kfd_ioctl_unmap_memory_from_gpu(struct file *filep,
 bind_process_to_device_failed:
 get_mem_obj_from_handle_failed:
 unmap_memory_from_gpu_failed:
+sync_memory_failed:
 	mutex_unlock(&p->mutex);
 copy_from_user_failed:
-sync_memory_failed:
 	kfree(devices_arr);
 	return err;
 }
-- 
2.39.2



