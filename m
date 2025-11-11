Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E2925484B;
	Tue, 11 Nov 2025 00:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822307; cv=none; b=V2qfRh2IiYgmUYt3HsUfDOh57bKNC3vvbEAtQyHzt2FkAd7AHm4cb9PXqS9mWMHsn5LOrB/Qwr8eJnmz9sNoNmncThIkCJakGIOsFpWpdANs3+gyr65sqfy2ccbOhXCU/XOfd9/Le559aeyijj7Bls2sFd8u/qFY7E9sndUZt+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822307; c=relaxed/simple;
	bh=D2xRAhCchAMNHFp/1SxFbRoaJlZ8itufwxgcHsURHyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqzGrhm8Jn/Q+y7bfx8ykL0jGuurKTcSuVI91S5bn5AKoodsnGtXe+ouVawxxLysPq8gjIt8OwooS4Tv/y6TiZw+P+epMW+3LHy077wSFikzEIIxmkxJM+dnNAhnMM8eYTvWp5Ss/KGgtxwZaB4EBWIENm68TTTNaYDEA9pkn/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPzUCfCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPzUCfCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24772C4CEFB;
	Tue, 11 Nov 2025 00:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822306;
	bh=D2xRAhCchAMNHFp/1SxFbRoaJlZ8itufwxgcHsURHyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPzUCfCWTR7U0zeHqzyxVNDqqd/VGbtqnYWF1709JlGV9FHHHlTVtzcgcyFKlmvIn
	 m8p3iEamGIg4Pt/PWrLpCyhLDBVedVT8CgeXu2L69+tb2ptN0sUUMpUL1KO+cbYyo9
	 t513JXbJaLyItJLSVQ5mby247V0FdjEs3Eu82Ek0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 035/849] drm/msm: make sure last_fence is always updated
Date: Tue, 11 Nov 2025 09:33:25 +0900
Message-ID: <20251111004537.293376203@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Maniscalco <anna.maniscalco2000@gmail.com>

[ Upstream commit 86404a9e3013d814a772ac407573be5d3cd4ee0d ]

Update last_fence in the vm-bind path instead of kernel managed path.

last_fence is used to wait for work to finish in vm_bind contexts but not
used for kernel managed contexts.

This fixes a bug where last_fence is not waited on context close leading
to faults as resources are freed while in use.

Fixes: 92395af63a99 ("drm/msm: Add VM_BIND submitqueue")
Signed-off-by: Anna Maniscalco <anna.maniscalco2000@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/680080/
Message-ID: <20251011-close_fence_wait_fix-v3-1-5134787755ff@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 3ab3b27134f93..75d9f35743700 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -414,6 +414,11 @@ static void submit_attach_object_fences(struct msm_gem_submit *submit)
 					 submit->user_fence,
 					 DMA_RESV_USAGE_BOOKKEEP,
 					 DMA_RESV_USAGE_BOOKKEEP);
+
+		last_fence = vm->last_fence;
+		vm->last_fence = dma_fence_unwrap_merge(submit->user_fence, last_fence);
+		dma_fence_put(last_fence);
+
 		return;
 	}
 
@@ -427,10 +432,6 @@ static void submit_attach_object_fences(struct msm_gem_submit *submit)
 			dma_resv_add_fence(obj->resv, submit->user_fence,
 					   DMA_RESV_USAGE_READ);
 	}
-
-	last_fence = vm->last_fence;
-	vm->last_fence = dma_fence_unwrap_merge(submit->user_fence, last_fence);
-	dma_fence_put(last_fence);
 }
 
 static int submit_bo(struct msm_gem_submit *submit, uint32_t idx,
-- 
2.51.0



