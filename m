Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71130168C4;
	Mon, 27 May 2024 19:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837755; cv=none; b=a58HUt9FAeb8LoHy4GhV+B23NcXrA4QFD432NEafcnBkleG748X+U3tSLw8ctMYSc7JJgfH7jiC9MuKhmVbwTjEwwhdVTRuvT3YGz7MjXaxnJ33pPcnYU/mfTpvWibmXNmhpKiqJE6TGyxgkzm8XaMxIOamsXb8LRpseQvmGuRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837755; c=relaxed/simple;
	bh=+nR2cwsfbJPq998eNNUHPDISmi/aYea+d288DvNLN5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSWRYj/HdUoR2/vJrPil+7MfMFzCVIkDJ2aO5QDRNSO5GRUZLSpjd1fMJCBEyO1OBaU1WUYxA5ERJDBcvSyiOlBIrRFJWksNanXMvD1CJHdcfNvakYDfx9jzBrKqVieNydYA/bnZOXfDETPaSJ28dX46txcxyaf4+mpsu7rl2U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6S0K1Xo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6S0K1Xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B34C2BBFC;
	Mon, 27 May 2024 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837755;
	bh=+nR2cwsfbJPq998eNNUHPDISmi/aYea+d288DvNLN5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6S0K1XovfPDP6ro1h9t9FU1CLVL5FniFJJP3k29LgjSubq2XuFH1o6/KHZcQsUbx
	 TtI3VPdEz6q+973nfBx7xJJQWu65l3Qy85ceQV3YkaVAgQ1ffJsITvg0WLcBvosY+m
	 5ns+hCDMfZTShj/SSV002e3jjBIyF/EeVa487wtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 092/493] drm/amdgpu: Fix VRAM memory accounting
Date: Mon, 27 May 2024 20:51:34 +0200
Message-ID: <20240527185633.406959066@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index daa66eb4f722b..b1e2dd52e643d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -220,7 +220,7 @@ int amdgpu_amdkfd_reserve_mem_limit(struct amdgpu_device *adev,
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



