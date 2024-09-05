Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D0E195FCE;
	Thu,  5 Sep 2024 09:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529946; cv=none; b=JbzcMeV8iaLes9/n8DUMPAH6xUF6tTnH3USEWBrghJBbCSVgsNHGKpBPvTwSLCJP/yjJgQu//wszU7MRIoBuox9Jjj3KLP1ZWOHNlLsTi1jxXTLxxXOQ8ZVkx62wEXNgkG+cmi/3wKOGX6BMCvR91bC0L+UuZXM4KMnKTxZxz3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529946; c=relaxed/simple;
	bh=zKXY+B/G3Gqj1+YBffMay+NNo9GmkFfMhRcoyKU6kY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhGTi6Xm2Zjy2XoJpRGkm2EGQe+X7Mq555VU8opX3LVZKULxaoy0EKUaezj2GfNpT2IcCuNefB4RAE0PuBB5e6kwugyUKtgBFdUv0V4Ko2GCpdVhgavVLoTjI330Gh9bGlfx5MycQWNcmae5Om73nUAIvoxLrnH8YkR9YV46YKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRGyedrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRGyedrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D12C4CEC3;
	Thu,  5 Sep 2024 09:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529946;
	bh=zKXY+B/G3Gqj1+YBffMay+NNo9GmkFfMhRcoyKU6kY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRGyedrXanVm60P/avYMaQq0RUTAiIO235u89I/H2p1eL4zN03DlsLQLc0zDgyp/x
	 wcriS3v+bqkkbZHlj6QYYnmJN6m0snR4QtN7wER87FUbUvvUr+EnOzoTQHHRzhB2fa
	 2LKIRvQDW7RuC5Or7Rnm2D2pICVXC3RowkMqGMRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 165/184] drm/amdgpu: add lock in kfd_process_dequeue_from_device
Date: Thu,  5 Sep 2024 11:41:18 +0200
Message-ID: <20240905093738.781794931@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4858112f9a53..a5bdc3258ae5 100644
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



