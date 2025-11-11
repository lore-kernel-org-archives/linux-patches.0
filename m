Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90C027E7EB;
	Tue, 11 Nov 2025 01:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825496; cv=none; b=LZuv/I3QAQI862r2sBubHiOROxwW1s6+DazBvKgNOsch1Ccvs3gM5CIq9hwjmVawdTidfuBRuQB/TJWzNp2zm3T3A/r9pl+yUppcZKF8PzUkObZ3xsBhelpTg3C0heQkngZZCwgWxyeK+V6UUFo4tOdYep6NFbg7SSrLztf+YMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825496; c=relaxed/simple;
	bh=Mc5ri5fNxD+/fojv3tWSRbhgVu2ILidmz3g6yB3P+Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJs+PiPDApp0uon8ybDLuy1Gkm39uOQG26AQvP3GlHsogqRU8CWqSBH/JsWRqU+ljZqkGDImJW/reRJ3jDIdT0Jy4UPW/jeYfN276lnhV6aodnB5miTSLytogSqn+BzO8Re8UMjd4rHasO9+kiTc8OtK1oPbX4fvIcJS54njczE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3UQhSq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3UQhSq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFF0C113D0;
	Tue, 11 Nov 2025 01:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825496;
	bh=Mc5ri5fNxD+/fojv3tWSRbhgVu2ILidmz3g6yB3P+Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3UQhSq+4WT8SzEXppqXgB9Ura11wUtECN5s6O7PLiA+Fs3OUOnwam4Govo3zLnFs
	 G/E3w19YSIKnfx8fwEub6adlpkzKkjRFcpeN5xFD9JeqE2v0M/3rh8UCWpvuLZZDkM
	 VSJveIjM9K4MaApM4+OKrrH3A7nze7SL/gz8uJCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 827/849] drm/amdkfd: Dont clear PT after process killed
Date: Tue, 11 Nov 2025 09:46:37 +0900
Message-ID: <20251111004556.423195782@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit 597eb70f7ff7551ff795cd51754b81aabedab67b upstream.

If process is killed. the vm entity is stopped, submit pt update job
will trigger the error message "*ERROR* Trying to push to a killed
entity", job will not execute.

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 10c382ec6c6d1e11975a11962bec21cba6360391)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1263,6 +1263,10 @@ static int unmap_bo_from_gpuvm(struct kg
 
 	(void)amdgpu_vm_bo_unmap(adev, bo_va, entry->va);
 
+	/* VM entity stopped if process killed, don't clear freed pt bo */
+	if (!amdgpu_vm_ready(vm))
+		return 0;
+
 	(void)amdgpu_vm_clear_freed(adev, vm, &bo_va->last_pt_update);
 
 	(void)amdgpu_sync_fence(sync, bo_va->last_pt_update, GFP_KERNEL);


