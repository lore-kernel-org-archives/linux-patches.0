Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626EC8462;
	Thu, 17 Apr 2025 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915482; cv=none; b=f+emC/uzkxwVA1mLWaNqGDzygJigXMmjLyFbT8DRZJ1KqNTVBMjMIewYPwnUV/EIqx09D6gMBx18qK5s99r6cvKBg14mzXozwFR7juBNgfzlV31qq1t/GvSmYgb25XX+Kw+FWdrUA81eCd9bPVZeXWduj6YAMu1gleF2ujJa5WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915482; c=relaxed/simple;
	bh=6mIYMEFjL4d91HpgZYsOB5sB4qLlrdkuTsxN6xdMYHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/0X7QY17BwlHP1VUKnG8A4NH986s/eN6chk8Kj1ln3h0d7NsS2k2qbGRLxZjikIuCFuuAo048AkKIp505ucY0g310uvVvDUmaSKnEuKrnTB7+i+4VTc0LwNNFwKNfH6B10D0mxtL4agAlUU9nLoTc7UbMoYHFhPNeyndOGsRrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSafiyAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSafiyAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68BAC4CEEA;
	Thu, 17 Apr 2025 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915482;
	bh=6mIYMEFjL4d91HpgZYsOB5sB4qLlrdkuTsxN6xdMYHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSafiyAWBDcngpcfD2FK0qsOEd/BN9bCPlXgWYuTQFCrZ9ROwJNbgKlnLpFAlWv2l
	 Lp5TmSv1JXSYS7zeoOS7r8heIJZpt+gaxNr0sXK5JZHoWCVzTAR2tUF8ds4/6L+w3V
	 8fnNAvCKHtyAdhADtGeJOHMEwkZ4T+9cB8YEHXIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/393] drm/amdkfd: Fix mode1 reset crash issue
Date: Thu, 17 Apr 2025 19:49:10 +0200
Message-ID: <20250417175113.258394413@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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
index 264bd764f6f27..0ec8b457494bd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -35,6 +35,7 @@
 #include <linux/pm_runtime.h>
 #include "amdgpu_amdkfd.h"
 #include "amdgpu.h"
+#include "amdgpu_reset.h"
 
 struct mm_struct;
 
@@ -1140,6 +1141,17 @@ static void kfd_process_remove_sysfs(struct kfd_process *p)
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
@@ -1154,6 +1166,11 @@ static void kfd_process_wq_release(struct work_struct *work)
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



