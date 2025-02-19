Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD77A1F790B;
	Wed, 19 Feb 2025 08:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954822; cv=none; b=MhUUA5h2a2I6dCvXCzedUblUSvAG7C9Fy5Cxa/QhSQZtdaJiuzddCSBTk0jau+Sy6D6pZ5YpNuYp/ecgAqspFK36SUGdfuJjCIZtAfGSKih6Rrpz1rXLT8ePokPYq7UmNVJQOi5746VZlOm+C2Y+aXnwj21go+SPeWEqQYtASvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954822; c=relaxed/simple;
	bh=Fmt/gvnfPUyDSkrQaOmFnVXj/BjGXmbjoH1pmGDilP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdiAj47z/jhXhDpRJvfVGkc97wuojEhRwOlCZEFcrcikIGjaP3kR2YRkSLb18MVNGR7FV+TWA2K4iNWVLR2TZFrt+ZTwAGBjD+gOzCSqOiguSx5iiuU6h05bDAJPwpucOXW77MXMWxrtkSnHkGnNW5eHMSoe4H5kkGBSzCgV1Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu+IYiTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu+IYiTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6BDC4CEE6;
	Wed, 19 Feb 2025 08:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954822;
	bh=Fmt/gvnfPUyDSkrQaOmFnVXj/BjGXmbjoH1pmGDilP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu+IYiTkjvuINWUf06QhNwLxmy2BlUf1PnPOufSeERqo2qO4YrYazFtM9o4h8MsRx
	 FLzIpfeB+Nfe4Je8Iwnsy+kX2jqHDmGUZHmyfYt5I2HYtBhe4sAzV6jc6DjMeid3/l
	 SxN1ICsqmF1Gnft01TSGR9UsVyeZJTaJJf51eUz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/230] amdkfd: properly free gang_ctx_bo when failed to init user queue
Date: Wed, 19 Feb 2025 09:26:04 +0100
Message-ID: <20250219082603.551266417@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Lingshan <lingshan.zhu@amd.com>

[ Upstream commit a33f7f9660705fb2ecf3467b2c48965564f392ce ]

The destructor of a gtt bo is declared as
void amdgpu_amdkfd_free_gtt_mem(struct amdgpu_device *adev, void **mem_obj);
Which takes void** as the second parameter.

GCC allows passing void* to the function because void* can be implicitly
casted to any other types, so it can pass compiling.

However, passing this void* parameter into the function's
execution process(which expects void** and dereferencing void**)
will result in errors.

Signed-off-by: Zhu Lingshan <lingshan.zhu@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Fixes: fb91065851cd ("drm/amdkfd: Refactor queue wptr_bo GART mapping")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index dbb63ce316f11..42fd7669ac7d3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -298,7 +298,7 @@ static int init_user_queue(struct process_queue_manager *pqm,
 	return 0;
 
 free_gang_ctx_bo:
-	amdgpu_amdkfd_free_gtt_mem(dev->adev, (*q)->gang_ctx_bo);
+	amdgpu_amdkfd_free_gtt_mem(dev->adev, &(*q)->gang_ctx_bo);
 cleanup:
 	uninit_queue(*q);
 	*q = NULL;
-- 
2.39.5



