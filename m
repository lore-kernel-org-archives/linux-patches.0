Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BF618D65E;
	Thu,  5 Sep 2024 09:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530324; cv=none; b=mBmQGMTnN/myCzBIguT9emDcEvdldBbEJeFBYgATR3dv8I/HuSc5RhmOaXtBO9jfS+8AmDl8k12aaS6AR6+1rv5ciED18WDPJbb0BSl0R2ZQpRU/GayNyxoeDl4mBsZ/mfmVMjfndKRDNpI02DXDlbL6eBJIUon6f2b6iUfkJeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530324; c=relaxed/simple;
	bh=PwB4GYQgi7DLTG3SY+YBiMgjnCxfuKuk7UQqxcWJwrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRKUHn+GrJAFtad3WYw2qYMB3eszc6ELkRFLENMHpj8AVqZXCTcJ3FIK7w0s43P86YpIwgf2bg6TZGiwi+RDYNF0aa0dSf1XcgtBS9ckF4mxSiZLVh1SkkETFRajP+NFHW5BrHISslcCg8eKuk76FUJFF21t5VYz9rcaXRxnwKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3gZa/Ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3gZa/Ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5426C4CEC3;
	Thu,  5 Sep 2024 09:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530324;
	bh=PwB4GYQgi7DLTG3SY+YBiMgjnCxfuKuk7UQqxcWJwrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3gZa/IrVQ4MZFA4PFB1Dpn2H7mD/mT+iDxo42wFhR1YZXTQQIoiSFvsANNvMDoTq
	 K7bpA27lSw6kxNAcETq7A8q+cBcuFkxd7EP+Tcitc5D8QGR8JH/5Pd7XHuy1FxufWG
	 S8uLhNw6+DOipiyfkNrUBKbeXsZOhosT9WnkbfNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/132] drm/amdgpu: add lock in kfd_process_dequeue_from_device
Date: Thu,  5 Sep 2024 11:41:49 +0200
Message-ID: <20240905093726.961940227@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit d225960c2330e102370815367b877baaf8bb8b5d ]

We need to take the reset domain lock before talking to MES. While in
this case we can take the lock inside the mes helper. We can't do so for
most other mes helpers since they are used during reset. So for
consistency sake we add the lock here.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 43eff221eae5..8aca92624a77 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -28,6 +28,7 @@
 #include "kfd_priv.h"
 #include "kfd_kernel_queue.h"
 #include "amdgpu_amdkfd.h"
+#include "amdgpu_reset.h"
 
 static inline struct process_queue_node *get_queue_by_qid(
 			struct process_queue_manager *pqm, unsigned int qid)
@@ -87,8 +88,12 @@ void kfd_process_dequeue_from_device(struct kfd_process_device *pdd)
 		return;
 
 	dev->dqm->ops.process_termination(dev->dqm, &pdd->qpd);
-	if (dev->kfd->shared_resources.enable_mes)
-		amdgpu_mes_flush_shader_debugger(dev->adev, pdd->proc_ctx_gpu_addr);
+	if (dev->kfd->shared_resources.enable_mes &&
+	    down_read_trylock(&dev->adev->reset_domain->sem)) {
+		amdgpu_mes_flush_shader_debugger(dev->adev,
+						 pdd->proc_ctx_gpu_addr);
+		up_read(&dev->adev->reset_domain->sem);
+	}
 	pdd->already_dequeued = true;
 }
 
-- 
2.43.0



