Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DFA31CA76;
	Mon, 18 Aug 2025 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526207; cv=none; b=YpIsuY/eaGNsxklJMIjoK7U+MJYgP+AX8RnQt2fBThzgmJ+i+u2gFfuQR8Slctk3/w2ViLXzw19mezbexRzSCJVR9JSJXQFrbsI+8+SSPL3G3d5fohA+zFUOnAWbunEfZp24HOP52nw7rNo2GJAKWrsje4LDcd/R4kBnvVf4Asw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526207; c=relaxed/simple;
	bh=RvluxLZkhl6ZseRoNS4h9aG9wVV/H6f9OQfLj5fFgqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6YtOHvVc9RnJ2o4c0E7arBrD8RklLOf7sQUd99Lf9EVn3JsiHDCU5KX1rxl885uOyvoZms+0o0pVH+iW1GxrDuUguXRrU9hq7kfN/lnGuGO4BEa1sVOjs86kyglnRvqFPrCmRIgV0o/spHQhXYOmLDzxX1aoKndJVu0L5DJskY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2MTOGJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2MTOGJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7B6C4CEEB;
	Mon, 18 Aug 2025 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526206;
	bh=RvluxLZkhl6ZseRoNS4h9aG9wVV/H6f9OQfLj5fFgqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2MTOGJmFOUKvffHnC5Ewc+1cM3Ei/zJpY32y87+FMoBHMIVzkIg9sJPLhA9K8diz
	 SiHfLZLS5t6yRjbRxviQbVcMUGaYlgGeeU3pAY7hCwWEGNkN0Y1CjcfHI0qFkkDhwH
	 gILXuQACo405+v5CmE84g/RxKWLNgkxczdCfsV2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 481/570] drm/amdgpu: fix vram reservation issue
Date: Mon, 18 Aug 2025 14:47:48 +0200
Message-ID: <20250818124524.412933034@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit 10ef476aad1c848449934e7bec2ab2374333c7b6 ]

The vram block allocation flag must be cleared
before making vram reservation, otherwise reserving
addresses within the currently freed memory range
will always fail.

Fixes: c9cad937c0c5 ("drm/amdgpu: add drm buddy support to amdgpu")
Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d38eaf27de1b8584f42d6fb3f717b7ec44b3a7a1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 07c936e90d8e..78f9e86ccc09 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -648,9 +648,8 @@ static void amdgpu_vram_mgr_del(struct ttm_resource_manager *man,
 	list_for_each_entry(block, &vres->blocks, link)
 		vis_usage += amdgpu_vram_mgr_vis_size(adev, block);
 
-	amdgpu_vram_mgr_do_reserve(man);
-
 	drm_buddy_free_list(mm, &vres->blocks, vres->flags);
+	amdgpu_vram_mgr_do_reserve(man);
 	mutex_unlock(&mgr->lock);
 
 	atomic64_sub(vis_usage, &mgr->vis_usage);
-- 
2.50.1



