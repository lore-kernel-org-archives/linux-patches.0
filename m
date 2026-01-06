Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381F92EFD99;
	Tue,  6 Jan 2026 18:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722585; cv=none; b=ikaSYqCiKZhyx+u8ZXYLz9wMsFz9UaHOrlZAjomuuaHPJvlnFS6Cra6Mkjci/iJ7tBVqINiXzHjHSh5SFs9H141uIvLyfukBn9QcIrebEuXZmT/2sMOLZ6S7vvCI2A6qArrYzfAFQ0IODPvfGMWmHa77o7IWjyK6THZb6U9Wwmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722585; c=relaxed/simple;
	bh=hlHLuDY67tfs+60kvpwZaLo6ha9m9Ctce98lbjFdDg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gx2hsm+987Dvwl0TNnM8Ugy+01xG48SvhdRwEBZTdrWWDtDTmIGhsaRTsVH1RWIJjM4cuzYO6FtvgA6qiuHF9aU9U3/CLW+02j4+diHko3k9CSj9ZUxaUTEkzBjMnYLuY64Gl/i9aFoxrTFlojTxdrNsbndD6MQDNfzs5dn8pC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJiaSd73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJiaSd73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B586AC116C6;
	Tue,  6 Jan 2026 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722585;
	bh=hlHLuDY67tfs+60kvpwZaLo6ha9m9Ctce98lbjFdDg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJiaSd73zunEgxa1ZYmVm8BHC8DOCt5R5/9Vh50cbOPKlu9TWJmtUZsFYDyQpsYQn
	 nCceqM8Q1u2DAD5mu5TbDgRXHbdqIN4mlZYG6mRxW5w05Fvt2if9P8bqhyv2ixBpFt
	 3Am4N3wXFYOI2FF8xm228bUO7NTdBHjQAyDbLuGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 265/312] drm/amdgpu: add missing lock to amdgpu_ttm_access_memory_sdma
Date: Tue,  6 Jan 2026 18:05:39 +0100
Message-ID: <20260106170557.432440334@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1529,6 +1529,7 @@ static int amdgpu_ttm_access_memory_sdma
 	if (r)
 		goto out;
 
+	mutex_lock(&adev->mman.gtt_window_lock);
 	amdgpu_res_first(abo->tbo.resource, offset, len, &src_mm);
 	src_addr = amdgpu_ttm_domain_start(adev, bo->resource->mem_type) +
 		src_mm.start;
@@ -1543,6 +1544,7 @@ static int amdgpu_ttm_access_memory_sdma
 	WARN_ON(job->ibs[0].length_dw > num_dw);
 
 	fence = amdgpu_job_submit(job);
+	mutex_unlock(&adev->mman.gtt_window_lock);
 
 	if (!dma_fence_wait_timeout(fence, false, adev->sdma_timeout))
 		r = -ETIMEDOUT;


