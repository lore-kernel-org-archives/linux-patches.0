Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D632737EE;
	Fri,  9 Jan 2026 12:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961047; cv=none; b=qZMQUH3VRvoELFOmtyGCfHfeWr4YnxHYRL+/dEUMCNcSDcVLHu/NQK+cRpguwxzcnzL778WnRnHRIyJ46Uh4Z92z+J0a3A0eIyU3iptda/1bE8LwjXgXqniaX1cVnG9qHM6Qe226HYj1gveGYhWgX303iWB6tjSm5VH1AZD1wPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961047; c=relaxed/simple;
	bh=zt7tZEACqd/FICh4lnXCAVZBDlRwc+/KAx6aMqAxSEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qBi9UImvuBJa5rCcHfabjXQ+PZHVWub4+qp/CzDIY4olUob6D7mWu8CLXgMJMj1HoMbgXioHRouOFnU1Y0VC3/qITFONbscmaG2ubZNdlm2JCIVYjNpJxABP7UDXNXoc9qDGZZjBF8AdlKJfva08xr3wuAHh/FnjU90UxZqIBj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frTHYNje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frTHYNje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D91C4CEF1;
	Fri,  9 Jan 2026 12:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961047;
	bh=zt7tZEACqd/FICh4lnXCAVZBDlRwc+/KAx6aMqAxSEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frTHYNjej+sjwjSBo/Tshff5IQw6AfkUjKl4lXxXT4CEC2U8btT0f15mDhSvHyBF5
	 1Vf4GQOuDRDWN4C7dItQIgTP5kx/DyUuGDl1x/tcHMfC8S6oPK6IxXeTj4RJ9n0lmD
	 p/R5ou55pxNtX+L5h7kZekC+gNkWx1xeMDHc/RIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 617/737] drm/amdgpu: add missing lock to amdgpu_ttm_access_memory_sdma
Date: Fri,  9 Jan 2026 12:42:36 +0100
Message-ID: <20260109112157.213590745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1495,6 +1495,7 @@ static int amdgpu_ttm_access_memory_sdma
 	if (r)
 		goto out;
 
+	mutex_lock(&adev->mman.gtt_window_lock);
 	amdgpu_res_first(abo->tbo.resource, offset, len, &src_mm);
 	src_addr = amdgpu_ttm_domain_start(adev, bo->resource->mem_type) +
 		src_mm.start;
@@ -1509,6 +1510,7 @@ static int amdgpu_ttm_access_memory_sdma
 	WARN_ON(job->ibs[0].length_dw > num_dw);
 
 	fence = amdgpu_job_submit(job);
+	mutex_unlock(&adev->mman.gtt_window_lock);
 
 	if (!dma_fence_wait_timeout(fence, false, adev->sdma_timeout))
 		r = -ETIMEDOUT;


