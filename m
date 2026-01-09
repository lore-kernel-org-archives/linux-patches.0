Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1082A227EA8;
	Fri,  9 Jan 2026 12:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963139; cv=none; b=aBRMnhM4C0mdzHn57ScmRSxp+If5LapNjp1VQLbyjqa+zonjFCDyGX68ndqxbLjBp37xT9OqdN1zrVT0+vdGnRKWFkoJ8SfpN5G68joRhdpegeSA0A+IW2TTqq2dp0Egwie8d7Skv4XmQ3vuv/vRdlpYD7q61PupVwIn6PHpJb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963139; c=relaxed/simple;
	bh=yKTk1N1xJ4ljtBjZW69FXQjRG6o2zc36yhFfjI33eE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UsV68bXB2NGaBGouv8kHxEKGc1fZa7du+zlsvxHaqX1Xyoni51GolceUiqZhks2TrJRYbxcnis9O93OHC6pySFwn+FmSiC/6g9A+O7FplFzXPBgp/vSH6fsC2rS59xZlH4VX27uQzZduAOYqtx6LoT2yc2odH5LeEdoKCKd1BFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/omlVvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/omlVvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CB1C16AAE;
	Fri,  9 Jan 2026 12:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963139;
	bh=yKTk1N1xJ4ljtBjZW69FXQjRG6o2zc36yhFfjI33eE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/omlVvr54lNcvNiXYcRif4BfOx2lPh65Q76/UtMOhDEGD8iZB6YC2yEkA4Xw7O+a
	 lC7gRFSku/cOzDWh+4wH8JKXY/HasDXlrhNYGUnCKJokdouHtkufmDkxaVIupTs3sc
	 H2kJmoSAI0lx3Z7pXQRA7WWU3e177MrnQMbp5G50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 593/634] drm/amdgpu: add missing lock to amdgpu_ttm_access_memory_sdma
Date: Fri,  9 Jan 2026 12:44:31 +0100
Message-ID: <20260109112139.938290357@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit 4fa944255be521b1bbd9780383f77206303a3a5c ]

Users of ttm entities need to hold the gtt_window_lock before using them
to guarantee proper ordering of jobs.

Cc: stable@vger.kernel.org
Fixes: cb5cc4f573e1 ("drm/amdgpu: improve debug VRAM access performance using sdma")
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1425,6 +1425,7 @@ static int amdgpu_ttm_access_memory_sdma
 	if (r)
 		goto out;
 
+	mutex_lock(&adev->mman.gtt_window_lock);
 	amdgpu_res_first(abo->tbo.resource, offset, len, &src_mm);
 	src_addr = amdgpu_ttm_domain_start(adev, bo->resource->mem_type) +
 		src_mm.start;
@@ -1439,6 +1440,7 @@ static int amdgpu_ttm_access_memory_sdma
 	WARN_ON(job->ibs[0].length_dw > num_dw);
 
 	fence = amdgpu_job_submit(job);
+	mutex_unlock(&adev->mman.gtt_window_lock);
 
 	if (!dma_fence_wait_timeout(fence, false, adev->sdma_timeout))
 		r = -ETIMEDOUT;


