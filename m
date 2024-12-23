Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951761865EB;
	Mon, 23 Dec 2024 16:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970718; cv=none; b=mOTwZd38SdRwT8cbipdcesZexuCGIDA/YwWilKMscj2TfHW/Fh7GMhboMQ1i0g7C8mx7Cite6T2iILrr2rIJmrnoyz9gvk6E+ihUdO/IIFVhuE5iR4YbvIOAARnsOTnNXKYLlxe3w/xTc92keU4h+DCNDEC7f+oRB5Ue0tinaPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970718; c=relaxed/simple;
	bh=byzeVrUNOgGEIkSrkpqRsY0r2SmAYx1KCDSvMEgMsQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WoGMjcOk8N5qFKGcCTNXt44T1pt5VH3SHq5v9b6qavHMXBaMVled1OPafIo5kkTAlC1bFDNEpV5Fw4zrnzYfjabEiqjxvvXnf7O51ukysfSCffvifiBrn3j5Rl+12NL9uRxXsfEE5QnghtMIhcIuFdroYZcujy92yRJpzTPR554=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMQHIHMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMQHIHMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A82BC4CED3;
	Mon, 23 Dec 2024 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970718;
	bh=byzeVrUNOgGEIkSrkpqRsY0r2SmAYx1KCDSvMEgMsQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMQHIHMljeSSm68bTxE55ouUeyOIcYvtBeW/QC9W2Zm4VjtHOVk/r6+6kAqC4eeIU
	 0quIGy4yXEkji1r8M/Aq9QQ1f9bwVRE3VgYCCVceFR4Kzs8Ii0Joy7WEYZvN2UUyaF
	 kMfg91XHJp8GivxS4jUdFrmfoOudPg6KdTBaKglI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 49/83] drm/amdgpu: dont access invalid sched
Date: Mon, 23 Dec 2024 16:59:28 +0100
Message-ID: <20241223155355.526931856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit a93b1020eb9386d7da11608477121b10079c076a ]

Since 2320c9e6a768 ("drm/sched: memset() 'job' in drm_sched_job_init()")
accessing job->base.sched can produce unexpected results as the initialisation
of (*job)->base.sched done in amdgpu_job_alloc is overwritten by the
memset.

This commit fixes an issue when a CS would fail validation and would
be rejected after job->num_ibs is incremented. In this case,
amdgpu_ib_free(ring->adev, ...) will be called, which would crash the
machine because the ring value is bogus.

To fix this, pass a NULL pointer to amdgpu_ib_free(): we can do this
because the device is actually not used in this function.

The next commit will remove the ring argument completely.

Fixes: 2320c9e6a768 ("drm/sched: memset() 'job' in drm_sched_job_init()")
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2ae520cb12831d264ceb97c61f72c59d33c0dbd7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index f34bc9bb7045..7f1e92110dd1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -150,7 +150,6 @@ void amdgpu_job_set_resources(struct amdgpu_job *job, struct amdgpu_bo *gds,
 
 void amdgpu_job_free_resources(struct amdgpu_job *job)
 {
-	struct amdgpu_ring *ring = to_amdgpu_ring(job->base.sched);
 	struct dma_fence *f;
 	unsigned i;
 
@@ -163,7 +162,7 @@ void amdgpu_job_free_resources(struct amdgpu_job *job)
 		f = NULL;
 
 	for (i = 0; i < job->num_ibs; ++i)
-		amdgpu_ib_free(ring->adev, &job->ibs[i], f);
+		amdgpu_ib_free(NULL, &job->ibs[i], f);
 }
 
 static void amdgpu_job_free_cb(struct drm_sched_job *s_job)
-- 
2.39.5



