Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11661C29E
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsGViOWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51481C433C8;
	Wed,  4 Oct 2023 18:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444610;
	bh=rUEORMoJQaTfrUd8oQTfIOHZXD9e0tH9+Ivt7gkeI0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsGViOWnEmtBdPhbV0L7RzyEwwyjeRPhe3ex244bL0McUlDApjvCmM0cq+J0lYBUQ
	 Qn4lOZ7sQa35N1M5YeG+KCEqz1xUHR4xySjCjp48Aw0g0hkGLckqpQTEc4lAGxVTk7
	 VfommeZx9JlPu4083TETviIUaPjam04XHktVZI78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuBiao Wang <YuBiao.Wang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 312/321] drm/amdkfd: Use gpu_offset for user queues wptr
Date: Wed,  4 Oct 2023 19:57:37 +0200
Message-ID: <20231004175243.741903022@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuBiao Wang <YuBiao.Wang@amd.com>

commit cc39f9ccb82426e576734b493e1777ea01b144a8 upstream.

Directly use tbo's start address will miss the domain start offset. Need
to use gpu_offset instead.

Signed-off-by: YuBiao Wang <YuBiao.Wang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -216,7 +216,7 @@ static int add_queue_mes(struct device_q
 
 	if (q->wptr_bo) {
 		wptr_addr_off = (uint64_t)q->properties.write_ptr & (PAGE_SIZE - 1);
-		queue_input.wptr_mc_addr = ((uint64_t)q->wptr_bo->tbo.resource->start << PAGE_SHIFT) + wptr_addr_off;
+		queue_input.wptr_mc_addr = amdgpu_bo_gpu_offset(q->wptr_bo) + wptr_addr_off;
 	}
 
 	queue_input.is_kfd_process = 1;


