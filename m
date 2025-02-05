Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1152149C53;
	Wed,  5 Feb 2025 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764561; cv=none; b=i4YtNscd0+9/qa4Sq8UXhb/dMxBX+x8KUwZEX965O/xSFA8b6N2nKUOYfGGsRbNcCSk637X2fuEJb86z3YhlM/Dj7DXddvggShiOeKqBcWsfxMpzia86fbwSveiFoKQyFXQdSEwJ5laq1Ijo5uzmhX8DlVfKyx7BuupHIJP/MmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764561; c=relaxed/simple;
	bh=2cCGfyxVuUtfUPZNUH2gOGRGeaecxVuj95ZyGrvoNCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfEaPcON/txsq34cmXC7eFXyGp+nHL9M0iuHpyb+kRu5nVq3USM7cGjRL26yMT/JXfPUnyr+J38/1HAfoZsUbrZtSRhZJMPAo2DGWun0+YJlGtB1LLxGhHgFGhIiG1jkdj6yrqdNc6V0/eryVPoZjBMu42TmWuCV6e9wZ3qP7KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkwK56eY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkwK56eY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91395C4CED1;
	Wed,  5 Feb 2025 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764561;
	bh=2cCGfyxVuUtfUPZNUH2gOGRGeaecxVuj95ZyGrvoNCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkwK56eYjhaYeXh5DWziDOthat//rqOHu37SDfgvDwbgdh4jzTF2lbxarnKNcEpy1
	 GYl/ITY3R2T0xu1oZlicLIWVGmECGLew7ayiTiEpeiBRNAV2DGshFfQwcuFIrM5Vmk
	 cqgcQADTlSj4sPrwNOTxXef5HkIxF9RgRJhSDzuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 081/623] drm/amdgpu: fix gpu recovery disable with per queue reset
Date: Wed,  5 Feb 2025 14:37:03 +0100
Message-ID: <20250205134459.322443900@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit 86bde64cb7957be393f84e5d35fb8dfc91e4ae7e ]

Per queue reset should be bypassed when gpu recovery is disabled
with module parameter.

Fixes: ee0a469cf917 ("drm/amdkfd: support per-queue reset on gfx9")
Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
index cc66ebb7bae15..441568163e20e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
@@ -1131,6 +1131,9 @@ uint64_t kgd_gfx_v9_hqd_get_pq_addr(struct amdgpu_device *adev,
 	uint32_t low, high;
 	uint64_t queue_addr = 0;
 
+	if (!amdgpu_gpu_recovery)
+		return 0;
+
 	kgd_gfx_v9_acquire_queue(adev, pipe_id, queue_id, inst);
 	amdgpu_gfx_rlc_enter_safe_mode(adev, inst);
 
@@ -1179,6 +1182,9 @@ uint64_t kgd_gfx_v9_hqd_reset(struct amdgpu_device *adev,
 	uint32_t low, high, pipe_reset_data = 0;
 	uint64_t queue_addr = 0;
 
+	if (!amdgpu_gpu_recovery)
+		return 0;
+
 	kgd_gfx_v9_acquire_queue(adev, pipe_id, queue_id, inst);
 	amdgpu_gfx_rlc_enter_safe_mode(adev, inst);
 
-- 
2.39.5



