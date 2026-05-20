Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDE23F4DC0;
	Wed, 20 May 2026 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299380; cv=none; b=g5YDKDDDfWrhC/Kus9lbbCzDAAOB+xCIg9/3udgwqaElDAt0/zmv1LXkMYIYN/UCUXgUPqYFRa/ABkDTKdRG3lMmzKuUv23StaElOFh3arUhYHqWjjCQdSC55e4bNaKYi7Pgl1I1BdQ8w+e0G9FEeG9cY4Zt2VkkvKetJQ1i7IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299380; c=relaxed/simple;
	bh=iC9tk9C5Ci2AxM+yCTNGogPy/Y98MWygkfscVzdGIFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFeSPGsFGoW8D3nmwIbB0ivjc2lBDuCTWPTUve9HezJPigaailgMczukwYfP+YeSjaaZ9ZpY9Up5dQpEB1PmMNlyfMXP4vFm8SKKM9PkLRl3dNlMQG0U5Mk5XGDTpJQSSjobxlegnzCfRNxcL0Tkpqa889jqVuXD0xAZKbsbZB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaO7dEC/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaO7dEC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AD91F000E9;
	Wed, 20 May 2026 17:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299379;
	bh=G+63KSzre2EeznpKBcwDW1fEDXLmF8d2MtktH9oYVyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HaO7dEC/0oT/YfN+4tgmTeA6W+lyIv4m+d3XvqHXhxXT/NXsyWQck+NyMcSQKl85v
	 l1g9u2SG2GaH+ZuiFSQPMkioTXq2ilY0uBzRczPlZExrv2XVRqi8EdwXaxRK0efsKF
	 ZekUvWmCS+JMRudyblmRXb1Zwz7DJk+pGfL3PEOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 748/957] drm/amdgpu/gmc: Fix AMDGPU_GART_PLACEMENT_LOW to not overlap with VRAM
Date: Wed, 20 May 2026 18:20:31 +0200
Message-ID: <20260520162150.784147362@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 36d65da7570bf72ce28504fa9a81abfc728e6d96 ]

When the GART placement is set to AMDGPU_GART_PLACEMENT_LOW:
Make sure that GART does not overlap with VRAM when
VRAM is configured to be in the low address space.

Solve this according to the following logic:
- When GART fits before VRAM, use zero address for GART
- Otherwise, put GART after the end of VRAM, aligned to 4 GiB

Previously, I had assumed this was not possible
so it was OK to not handle it, but now we got a report
from a user who has a board that is configured this way.

Fixes: 917f91d8d8e8 ("drm/amdgpu/gmc: add a way to force a particular placement for GART")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3d9de5d86a1658cadb311461b001eb1df67263ad)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index b8613888c5c33..6d5f90512a74e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -313,7 +313,10 @@ void amdgpu_gmc_gart_location(struct amdgpu_device *adev, struct amdgpu_gmc *mc,
 		mc->gart_start = max_mc_address - mc->gart_size + 1;
 		break;
 	case AMDGPU_GART_PLACEMENT_LOW:
-		mc->gart_start = 0;
+		if (size_bf >= mc->gart_size)
+			mc->gart_start = 0;
+		else
+			mc->gart_start = ALIGN(mc->fb_end, four_gb);
 		break;
 	case AMDGPU_GART_PLACEMENT_BEST_FIT:
 	default:
-- 
2.53.0



