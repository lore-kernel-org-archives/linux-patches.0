Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD13E1F755B;
	Tue, 17 Dec 2024 17:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456439; cv=none; b=jPl5xb2tKxBWWydRA7tafoh7lhY1D5k/NY2zCVwhKmChQBlJgdRWQA+/JRa3+cMYaRtYYqtL0nitBjl+fk0ES5HftnEFyAxdJtEF4AXZioP0FQxsjWQ1ioE3NNS9ECOMz6hGihUpL6fUtD+NGZvx0CVPdVN2nQMLaypa/Rf+Dso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456439; c=relaxed/simple;
	bh=TzWhIK9mazOQLGbVOX2N2SEfysuRMBpT+u/leVTVNp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sL+2DVomTyampukmCNk/Yb4w6LR/bBC2cYJyLQbuZ0TTLKIBG0/emuWdUd6NT+LLFtLnADZfXgl0xX4dPM4FMDK5i8otScGpciDy9pBkxDuWEydIRoglDQU9lc0Zqbj/HAewkfLkjvlJt6bB7ObnnO5N9ywZ4Hd7CXUPqPbz6j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgxjSZfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgxjSZfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E418C4CED3;
	Tue, 17 Dec 2024 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456438;
	bh=TzWhIK9mazOQLGbVOX2N2SEfysuRMBpT+u/leVTVNp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgxjSZfyqWR/6uNSUaYLaOB4rnamTp5zNW1GVP7gEfTphz//VI0lPsz9DsaBR1mL4
	 d+hbR7hySqX6i5fLiHk6mwdgb0UHsuF1vNDYjmdvYBWWPEa7Zsi4EurqkoBJBsq9do
	 Sj6z6XxpY3uK9uwONenrcom3BlZo+0MJWtrTNSnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 061/172] drm/amdgpu: fix UVD contiguous CS mapping problem
Date: Tue, 17 Dec 2024 18:06:57 +0100
Message-ID: <20241217170548.807885550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 12f325bcd2411e571dbb500bf6862c812c479735 upstream.

When starting the mpv player, Radeon R9 users are observing
the below error in dmesg.

[drm:amdgpu_uvd_cs_pass2 [amdgpu]]
*ERROR* msg/fb buffer ff00f7c000-ff00f7e000 out of 256MB segment!

The patch tries to set the TTM_PL_FLAG_CONTIGUOUS for both user
flag(AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS) set and not set cases.

v2: Make the TTM_PL_FLAG_CONTIGUOUS mandatory for user BO's.
v3: revert back to v1, but fix the check instead (chk).

Closes:https://gitlab.freedesktop.org/drm/amd/-/issues/3599
Closes:https://gitlab.freedesktop.org/drm/amd/-/issues/3501
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c  | 17 +++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |  2 ++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index d891ab779ca7..5df21529b3b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1801,13 +1801,18 @@ int amdgpu_cs_find_mapping(struct amdgpu_cs_parser *parser,
 	if (dma_resv_locking_ctx((*bo)->tbo.base.resv) != &parser->exec.ticket)
 		return -EINVAL;
 
+	/* Make sure VRAM is allocated contigiously */
 	(*bo)->flags |= AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS;
-	amdgpu_bo_placement_from_domain(*bo, (*bo)->allowed_domains);
-	for (i = 0; i < (*bo)->placement.num_placement; i++)
-		(*bo)->placements[i].flags |= TTM_PL_FLAG_CONTIGUOUS;
-	r = ttm_bo_validate(&(*bo)->tbo, &(*bo)->placement, &ctx);
-	if (r)
-		return r;
+	if ((*bo)->tbo.resource->mem_type == TTM_PL_VRAM &&
+	    !((*bo)->tbo.resource->placement & TTM_PL_FLAG_CONTIGUOUS)) {
+
+		amdgpu_bo_placement_from_domain(*bo, (*bo)->allowed_domains);
+		for (i = 0; i < (*bo)->placement.num_placement; i++)
+			(*bo)->placements[i].flags |= TTM_PL_FLAG_CONTIGUOUS;
+		r = ttm_bo_validate(&(*bo)->tbo, &(*bo)->placement, &ctx);
+		if (r)
+			return r;
+	}
 
 	return amdgpu_ttm_alloc_gart(&(*bo)->tbo);
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
index 31fd30dcd593..65bb26215e86 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -551,6 +551,8 @@ static void amdgpu_uvd_force_into_uvd_segment(struct amdgpu_bo *abo)
 	for (i = 0; i < abo->placement.num_placement; ++i) {
 		abo->placements[i].fpfn = 0 >> PAGE_SHIFT;
 		abo->placements[i].lpfn = (256 * 1024 * 1024) >> PAGE_SHIFT;
+		if (abo->placements[i].mem_type == TTM_PL_VRAM)
+			abo->placements[i].flags |= TTM_PL_FLAG_CONTIGUOUS;
 	}
 }
 
-- 
2.47.1



