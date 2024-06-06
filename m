Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F99219753D;
	Thu,  6 Jun 2024 14:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683167; cv=none; b=H2ZtnBLzd+nq5RNXhZORI/kWQWYGsS/FN9eRdpLL7jqgxy9J5thfAPTDGaALp//oSfr8wcjqbVE4uIquh5IXKDjJMvdWgukBorPf7kn6Lgym3E2p3tcm+FP6OgZYkjaUmBZf0dIYoh+cQTFKDUk/st2U0feX/lS6IdO8jt8WfW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683167; c=relaxed/simple;
	bh=U9/C1uNNbQDq+1LW1Sp+jQXPIvybYsF0I2JtxVhcDMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcE+04P0mJy5VqgiygxoxPmkZf8f+mmOfNS26FTuCipZTUi7KDxr2yBO3CbwbhGANP4Li+vY+dEWTIHFuIXxzqIwzFYrlG0ZGX3Ep9OznK7+pF6iN5ePJ1Wf3bmTt7x7BClT9CoHPdwHy9bhOifnIVY/x0qB+4Ui0kFfiJmGXGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03P17tCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03P17tCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D744C2BD10;
	Thu,  6 Jun 2024 14:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683167;
	bh=U9/C1uNNbQDq+1LW1Sp+jQXPIvybYsF0I2JtxVhcDMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03P17tCcI7VJr19RCbiaEz4eCvD6HKPRTe2IhHWeHO7XNd0DNigP1WuGWBzb7BBOt
	 Dg1+TqhADVv7cOsZHyJxUs8qDTH6cQnNsTgDO41xY5s4s/yXuK2Ms5IO5mDeveDGnC
	 w4HtxMb/bhg3fs4ATVnc5KQlJiaINr2fXXmzmXJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/744] drm/amdgpu: Fix VRAM memory accounting
Date: Thu,  6 Jun 2024 15:55:48 +0200
Message-ID: <20240606131734.838740237@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit f06446ef23216090d1ee8ede1a7d7ae430c22dcc ]

Subtract the VRAM pinned memory when checking for available memory
in amdgpu_amdkfd_reserve_mem_limit function since that memory is not
available for use.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 15c5a2533ba60..704567885c7a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -213,7 +213,7 @@ int amdgpu_amdkfd_reserve_mem_limit(struct amdgpu_device *adev,
 	    (kfd_mem_limit.ttm_mem_used + ttm_mem_needed >
 	     kfd_mem_limit.max_ttm_mem_limit) ||
 	    (adev && xcp_id >= 0 && adev->kfd.vram_used[xcp_id] + vram_needed >
-	     vram_size - reserved_for_pt)) {
+	     vram_size - reserved_for_pt - atomic64_read(&adev->vram_pin_size))) {
 		ret = -ENOMEM;
 		goto release;
 	}
-- 
2.43.0



