Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61775266B4B;
	Wed, 23 Apr 2025 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420732; cv=none; b=IbDnngMuiqkLoPrYB7Uu/owGGaLIJ+OUtWwJZsD1qAU9f3qk7Kt4pBvIZUZkEBvA7WmFa3OPzA9occSSCTpn18KUW5UDoV5PY5DQC7RuDH9wDf0w5KtbC6K4Ze1c3WJtd9fVYVie+5yjAdgR0CP7lUEm3yYHJspPeXfLLJrNTiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420732; c=relaxed/simple;
	bh=Arz0OORay63MkiSUbEfzVlue7cSd0Fcmhum0BGssYaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQcySdMny57QeKJboZKlWXlQ1DpdCC7/A/N/g19Sv2W/6FZoq/7CnabJWuTM7Y99dZqLmHkcwCTsxkuCeqnW7Go+kau3CPaTcjLhDH+7vhE1DPyyEpl6yy9EOIgF/06Q8KQli4F0di8xREKRMKwY5+HF+cFW7guAtUNyfX6knJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSmNBUcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSmNBUcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8302C4CEE2;
	Wed, 23 Apr 2025 15:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420732;
	bh=Arz0OORay63MkiSUbEfzVlue7cSd0Fcmhum0BGssYaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSmNBUcgZ/Yvu60ELNeV4VCjlRgPYGsmTGDVCJlJWAMCHImdiKh1ip9ZtptowZ2/b
	 0zniLXiEEt1DPmsH30cJ6BcxBEd1fsYeQKbjxO6svHcNb5zE+9QvKSUsLnAuLrQOjx
	 IFG4746T5vJMPVMvbIvGhHWvZGkuzx+gajGcaE+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/393] drm/amdkfd: Fix mode1 reset crash issue
Date: Wed, 23 Apr 2025 16:39:58 +0200
Message-ID: <20250423142647.498421585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit f0b4440cdc1807bb6ec3dce0d6de81170803569b ]

If HW scheduler hangs and mode1 reset is used to recover GPU, KFD signal
user space to abort the processes. After process abort exit, user queues
still use the GPU to access system memory before h/w is reset while KFD
cleanup worker free system memory and free VRAM.

There is use-after-free race bug that KFD allocate and reuse the freed
system memory, and user queue write to the same system memory to corrupt
the data structure and cause driver crash.

To fix this race, KFD cleanup worker terminate user queues, then flush
reset_domain wq to wait for any GPU ongoing reset complete, and then
free outstanding BOs.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 64346c71c62a3..a6d08dee74f6e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -35,6 +35,7 @@
 #include <linux/pm_runtime.h>
 #include "amdgpu_amdkfd.h"
 #include "amdgpu.h"
+#include "amdgpu_reset.h"
 
 struct mm_struct;
 
@@ -1110,6 +1111,17 @@ static void kfd_process_remove_sysfs(struct kfd_process *p)
 	p->kobj = NULL;
 }
 
+/*
+ * If any GPU is ongoing reset, wait for reset complete.
+ */
+static void kfd_process_wait_gpu_reset_complete(struct kfd_process *p)
+{
+	int i;
+
+	for (i = 0; i < p->n_pdds; i++)
+		flush_workqueue(p->pdds[i]->dev->adev->reset_domain->wq);
+}
+
 /* No process locking is needed in this function, because the process
  * is not findable any more. We must assume that no other thread is
  * using it any more, otherwise we couldn't safely free the process
@@ -1123,6 +1135,11 @@ static void kfd_process_wq_release(struct work_struct *work)
 	kfd_process_dequeue_from_all_devices(p);
 	pqm_uninit(&p->pqm);
 
+	/*
+	 * If GPU in reset, user queues may still running, wait for reset complete.
+	 */
+	kfd_process_wait_gpu_reset_complete(p);
+
 	/* Signal the eviction fence after user mode queues are
 	 * destroyed. This allows any BOs to be freed without
 	 * triggering pointless evictions or waiting for fences.
-- 
2.39.5



