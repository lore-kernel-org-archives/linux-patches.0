Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5566136167E;
	Wed, 20 May 2026 16:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295169; cv=none; b=mHLSAdfKngShITSYXoV81JWYlsosroQNHhfg3ZKbqfT/aCLS+A8g4a7dy3jx7+4Eh6R2P+s3J3ImaoENDYWY9SsdcgD9pE29km0rVgrVKoDKuEykCGh84WAeiMDTpLqTwDWOGyyE4w5HUMmbB0EucYaEvdnRTCMPVm6m6Fy9kbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295169; c=relaxed/simple;
	bh=+rhQBkLwLiREU6PiwksAbDCI3y4rM20PcFC7dx660gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nh9SRPWapQm2SN3EFz44PY6xsLc8ex8FWcilz72MMxiK5AfW7nwmptrbysFKeWPQSRrdv44vzEcKk4qnxfyRXdMdii4epG7qcLPbkAggGhwRck4OLA4yIgnp+9IEsd7zNIOhbR0T/ke6D+7pM8HOXGItFENN9U9TH1OxQblzq3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qj6tVmNu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qj6tVmNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28B11F00899;
	Wed, 20 May 2026 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295166;
	bh=xjEag+hWZ54trM99PlKvbveD6sF1pLWWRONC/71+YZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qj6tVmNuubOyL3kSpS2pfd3s+0WIsxiUk/FqfFtkHOvcPjGT4vmjsG+4NkgEOZnQr
	 +e++qyZXCxOnKBQUp4qIsmIEEud/0dtsZ7svB9bdVyr15Ba8O1GrjdHLX4CYF3quz8
	 26rz71NxhKhvKUKfMq5M+/FGEGza0rsZPEBloJ9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0299/1146] drm/amdgpu: Drop redundant queue NULL check in hang detect worker
Date: Wed, 20 May 2026 18:09:09 +0200
Message-ID: <20260520162154.977689939@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 9a62a097a7f8d223d722b9e9b557a792d30600ca ]

amdgpu_userq_hang_detect_work() retrieves the queue pointer using
container_of() from the embedded work item.

Since the work structure is part of struct amdgpu_usermode_queue,
the returned queue pointer cannot be NULL in normal execution.

Remove the redundant !queue check and keep the validation for
queue->userq_mgr.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:159 amdgpu_userq_hang_detect_work() warn: can 'queue' even be NULL?

Fixes: 290f46cf5726 ("drm/amdgpu: Implement user queue reset functionality")
Cc: Jesse Zhang <Jesse.Zhang@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 0a1b93259887a..caca0c4aeefe7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -156,7 +156,7 @@ static void amdgpu_userq_hang_detect_work(struct work_struct *work)
 	struct dma_fence *fence;
 	struct amdgpu_userq_mgr *uq_mgr;
 
-	if (!queue || !queue->userq_mgr)
+	if (!queue->userq_mgr)
 		return;
 
 	uq_mgr = queue->userq_mgr;
-- 
2.53.0



