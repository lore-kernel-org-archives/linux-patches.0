Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9572263F2D;
	Wed, 23 Apr 2025 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420595; cv=none; b=K54SSLNtYX8Ww2qLP311x6lQBj8FJAMLOtVprDuz6dILm7cEMw99oYPDmvX/mLpJpxaxezrYTlQwzJkkjmwhze2hwDZhuiyOeCd79vwD78nK3iyf736W1BB11Wbc0V67bIAE4Hee9AxDruiTMka3YqUMuWzuj1DDZQibsfF6tbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420595; c=relaxed/simple;
	bh=gK8UK+op43tznwkW8uu8WkrT74XMhooNM5n9/1Ukr70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOHs9BZYlnh6t4zQc9YAlpJM1SZA0coWT1w+ZgHkGuOZ+uwNtTryz/YTlZtwX8AbWNMNHQ3io6DQDFdxutwZSkePTmpdh2YO/vcChVkPmBPiXlPQNnGusKLvX2SkVA+pIwvNd7mcIXaWYpe1bdAf0QtahaNj30+YOO2AJL/pkmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLi7a2di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLi7a2di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658A1C4CEE3;
	Wed, 23 Apr 2025 15:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420595;
	bh=gK8UK+op43tznwkW8uu8WkrT74XMhooNM5n9/1Ukr70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLi7a2dicf+yi0X6CHs9vSlOrfXY7stz1DsZKoK5LdbloVDUZ70iXwpUAJ0l2jhsh
	 nqU1Cj2lhKuTvSBOAPxBPBQ18sPeckUSyrbvwatjgOH4oU9C944eQlJj2Cu6YbX6nH
	 bWV8bg46kbYRnYYfzFOjwOBdvObqax3/lTOVOahg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/291] drm/amdkfd: Fix mode1 reset crash issue
Date: Wed, 23 Apr 2025 16:40:52 +0200
Message-ID: <20250423142626.952948222@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 99e2aef52ef26..bc01c5173ab9a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -36,6 +36,7 @@
 #include <linux/pm_runtime.h>
 #include "amdgpu_amdkfd.h"
 #include "amdgpu.h"
+#include "amdgpu_reset.h"
 
 struct mm_struct;
 
@@ -1114,6 +1115,17 @@ static void kfd_process_remove_sysfs(struct kfd_process *p)
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
@@ -1127,6 +1139,11 @@ static void kfd_process_wq_release(struct work_struct *work)
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



