Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724052D8777;
	Tue,  6 Jan 2026 17:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721266; cv=none; b=FWbqx0A2o8ADpIMx3IbKKyQrUiYWB0EOtmtTDoo0t2HzR/LdwdJleTIFZuxeTjrhTasDVX7FVN3dlq9ghWyUKt4jc2b8X5Noch/20u0DyjTw3neLztnBdTJ9AaC8HF9koI/4u1PX04Q+6j1wqaleVUDlilkiqk7nSqLqLkV6lOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721266; c=relaxed/simple;
	bh=Cq767w4k8UhhyHJMpeWsKgKlspA/IRjV64PCA1ov3j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MiK0wCFhjCBLOsxVg6Jv8FahfmAlJIu5ivuvPxAOJSYmoUSOuWHPWzqAffsLuSuaA0Mh1Gbd1jGh6savXUpHT88uw1Hiar9o3BiNCGohKk3ZcT9ZhbcrH8nS2tF3UNUFxEeCz4FCW+eyzdCpHcXsLHRXXc/m5JjBr7NRzUPQQyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtCvbynp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtCvbynp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1048C116C6;
	Tue,  6 Jan 2026 17:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721266;
	bh=Cq767w4k8UhhyHJMpeWsKgKlspA/IRjV64PCA1ov3j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtCvbynpEhlilkHBWAalQrIguIXHRC83XCXnaDASynQRUs6zTlEkyTvqzsrkBCIOx
	 8SA/7TywuLzLzEpEYM35f3roCiVBrtmqz1SuhXkiVZmvQDkaEhIF32Cvpspu0NKVSS
	 ZjsWgUztLkCcu9yL3WAUSl/s6+78WqpuSUGmTNLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 458/567] drm/amdgpu: add missing lock to amdgpu_ttm_access_memory_sdma
Date: Tue,  6 Jan 2026 18:04:00 +0100
Message-ID: <20260106170508.287998223@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

commit 4fa944255be521b1bbd9780383f77206303a3a5c upstream.

Users of ttm entities need to hold the gtt_window_lock before using them
to guarantee proper ordering of jobs.

Cc: stable@vger.kernel.org
Fixes: cb5cc4f573e1 ("drm/amdgpu: improve debug VRAM access performance using sdma")
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1513,6 +1513,7 @@ static int amdgpu_ttm_access_memory_sdma
 	if (r)
 		goto out;
 
+	mutex_lock(&adev->mman.gtt_window_lock);
 	amdgpu_res_first(abo->tbo.resource, offset, len, &src_mm);
 	src_addr = amdgpu_ttm_domain_start(adev, bo->resource->mem_type) +
 		src_mm.start;
@@ -1527,6 +1528,7 @@ static int amdgpu_ttm_access_memory_sdma
 	WARN_ON(job->ibs[0].length_dw > num_dw);
 
 	fence = amdgpu_job_submit(job);
+	mutex_unlock(&adev->mman.gtt_window_lock);
 
 	if (!dma_fence_wait_timeout(fence, false, adev->sdma_timeout))
 		r = -ETIMEDOUT;


