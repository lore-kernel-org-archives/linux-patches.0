Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE601E834B;
	Wed, 19 Feb 2025 08:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953983; cv=none; b=E1HHyuX/fqz/ysAA0j5PpUGfafcNA0vwXSZGSFU4XkNsoZCBBmVj4+UCz2v0vjUX73dSmsgxz0Q0CFgHIkxH8ROCnUvkeIvFG+mjTXeFNBZzxHTN4gUDASdHonaWeaqy4cy4zJOh4ekqV9EUlQZdj/2LEKylF1gOLpctvWnskF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953983; c=relaxed/simple;
	bh=EUhjnmL6wuOZbap+Js5rJkPiYm8ANizVokso0af1jsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALkZlG7T4W0yK4qIID6shsMZY5aZ9np0gcmWh9z3RdHxutYLUm1MuZLY5ggLWWr/LA/+jesp0nR89jH0LtCHw788ycuD6q9HQySVzVrBLajQmI/9oxdmsL7iCDsfCp+JBYQQn65GL1m/xgIiO7W+wYV9+kKdrw6YDqRwH7e2K+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1e66RmIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1e66RmIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43975C4CEE7;
	Wed, 19 Feb 2025 08:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953982;
	bh=EUhjnmL6wuOZbap+Js5rJkPiYm8ANizVokso0af1jsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1e66RmIfDzoq1bqAHPNeV6UkYQ67EJZaWmmy9tR9TeqoFfR+Sd+dC3pM238HgYeqS
	 C0pDw0HVJmAPlme4rlWuIN3WovF56XZF38WSkmvkHi3WZrvYEoOaQcQq6rcyvQUA9r
	 ynd0yoNpuiNJgxFiDonkuN17hKPb2AL9Dm/5/CCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 058/274] amdkfd: properly free gang_ctx_bo when failed to init user queue
Date: Wed, 19 Feb 2025 09:25:12 +0100
Message-ID: <20250219082611.899582759@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index bd595b1db15f2..1d538e874140c 100644
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



