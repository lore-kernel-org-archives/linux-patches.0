Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776041D1E85;
	Wed,  2 Oct 2024 14:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877843; cv=none; b=AuL8plRZBefbqTYR0l6DLd6YFpy6yYsX/HCtTt0D8Mo6Wtbpe/b0nk4EPJXxvRbVqgZc/bgJkECa/rhddY5mv/YDjdHJNW0shaT/sauE4jNTVRyJpdN+ZhXHbQ/R0c4tdNIZBLMLEWdQ1t0n4Xs26Xg3dAe4TzmEv+UgaN8/Bfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877843; c=relaxed/simple;
	bh=ZPWj33PG0MawS6MIfAPIBvHEl+emWQFD5x+8VGYwIss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HSSzPg0bqdAflnD9YhlsEngD2HPYSUtzRBHB1tbNyNViNQgmHzpDFQpBi+W6tkadjEh30hEzXgPHGiQQs+4yDdrup8m4iimpdowFnjDKfrKqHU2D6WR6ZCX24zF3oPV9uA+8bz5MnEQzXz43GEgBAWxvQYmXh63YALlt9AGwQfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXnTv7jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXnTv7jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E6AC4CEC2;
	Wed,  2 Oct 2024 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877843;
	bh=ZPWj33PG0MawS6MIfAPIBvHEl+emWQFD5x+8VGYwIss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXnTv7jrKVZ8pLDajLNYRGnmn3Mi/0RkiiuZ7V5oxxdIDRxXVFzJzftD/RlP24pAi
	 g5ZlTLKf41cW7oAa0Zm/Bn6S2d1yaUjMU8m55gwRFFWVamyd+b7191/tJLxtMzTlDx
	 /uPMYW5KekH0bboRLr6+IRYTm+GbmFFy7UvTcy/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <lang.yu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 214/634] drm/amdgpu: fix invalid fence handling in amdgpu_vm_tlb_flush
Date: Wed,  2 Oct 2024 14:55:14 +0200
Message-ID: <20241002125819.551252274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Yu <lang.yu@amd.com>

[ Upstream commit 4453808d9eab0461dea338e89372ffc4a3c50acc ]

CPU based update doesn't produce a fence, handle such cases properly.

Fixes: d8a3f0a0348d ("drm/amdgpu: implement TLB flush fence")
Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 0f7106066480e..3fdbc10aebce1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -902,10 +902,12 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_update_params *params,
 {
 	struct amdgpu_vm *vm = params->vm;
 
-	if (!fence || !*fence)
+	tlb_cb->vm = vm;
+	if (!fence || !*fence) {
+		amdgpu_vm_tlb_seq_cb(NULL, &tlb_cb->cb);
 		return;
+	}
 
-	tlb_cb->vm = vm;
 	if (!dma_fence_add_callback(*fence, &tlb_cb->cb,
 				    amdgpu_vm_tlb_seq_cb)) {
 		dma_fence_put(vm->last_tlb_flush);
-- 
2.43.0



