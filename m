Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C28A30F7F8;
	Mon, 18 Aug 2025 13:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522622; cv=none; b=NOQyq1nfZGNSHrAIXhsivguvJEC325t1khTV9pptJLNkKy7FrrJwYHmiWVnHBmz+LTSOdRl8+TbIkoLaKMbuKpVU9zfVXy7rwpyiFR8GXt5msv3E2yRx6sHR5wVR89AnDceR8TOMleilgSI2P+QpSQvqwEQjDx5b+6nRLfHqWYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522622; c=relaxed/simple;
	bh=Vx/bCtmHCiYtWeYFyaLcQk5Hnt5BCY+hWI+NSqLC/JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCMj+lgs4mQPxYFUeLfjwsZDzKmUSKuQaI2Ie+YXwE8mhaVElrPeVXqqzwmQtn9vJxE4v2XmEPWw6MRJQMo0IoJ5b1xJkFyxxKWkxobRnfAz55XCSqVAh0Gg9v5ePPj1N2ZRLAY8r2d/01urKVZ6Du5/k9rGvrvLc5Lm2/hom80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLFrE6GQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLFrE6GQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F31C4CEEB;
	Mon, 18 Aug 2025 13:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522622;
	bh=Vx/bCtmHCiYtWeYFyaLcQk5Hnt5BCY+hWI+NSqLC/JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLFrE6GQRyYDbRE+BfkvaDS7LasihDpejkhlc7rfzVXFwyE7r7Q0SB3fXf3Kf8+Aa
	 4hmQeQVL5snBhgpvQGtvXelx88/tNTY8OKumy1cy53+9ZC1PYPvOfxNbjkeKwQoJnG
	 m/eSQnnJfkif/22UnQb5bdOAqlECTXFI/6ue+qwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/444] drm/amdgpu: fix vram reservation issue
Date: Mon, 18 Aug 2025 14:46:37 +0200
Message-ID: <20250818124502.806056433@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 732c79e201c6..ea4df412decf 100644
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



