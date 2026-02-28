Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757E8340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301052; cv=none; b=p6LyABU9IIHGlleANWwEk8NTM7SeuPHzD/jo9J6t9jq2h47W1oUFgQ7CL19Tn6UBed0YshoHxBiKMWRQEkGbPJW3OF34t6KAzzftSL251W/VRhqvb927QXX++kiUCUhjR44fJmd2Azb+2Xvi+bDnmeTGl2nteYFq0xbt324XPy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301052; c=relaxed/simple;
	bh=ZBFudmBqGqzuvjbhxMMySTYyxURrpndFhaU3tMvgw0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUt3Ds2q62yj2+d2VvbDUEcG9kUEb/KRBtaK1Ny41zLMWuDIpCtFOzi2GFD81JTTLUawAj97CWKFO3uN6PjYoMrvd9xSNfF1rFKCFwklx9ibvvJQbop4Y/QbTEljywHt2rmDGMWspS4hzfhL3BMyW443P8/ezY1ykUXAKpHo53I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5XWmCIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5XWmCIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00BBC19423;
	Sat, 28 Feb 2026 17:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301052;
	bh=ZBFudmBqGqzuvjbhxMMySTYyxURrpndFhaU3tMvgw0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5XWmCIWvwO8I/EdsGgViz9iqErJwymFDfxsTVO57Pm2hYnL2xc9XvjEbcp0UwTqX
	 1MXt/zwvUQm8iVFSb5SCJtIrTwhUx8q41cdgnrTmwawRTGD2e0ujFReFc6EFwWnVwA
	 6lfhJjSFSnzC9MYhlXHMctoYRIaKNB+mks4IiuW9UjGZ6vdULQ7tRj+d9LXzasI3Fs
	 6rF1l4CHGgcu7Fuk7xU44AWobNbgAvKx623V+R1xDimNd78BX+j1z29k7nOTXG5q4H
	 CbeNu0DQcosDrvDjMg0EwYGF8vwAjrE60KvhkzQ4nsu1QrDNwVAfN0tp+GImeT+2p+
	 bK2kouAhRlYyQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Jesse.Zhang" <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 192/752] drm/amdgpu: validate user queue size constraints
Date: Sat, 28 Feb 2026 12:38:23 -0500
Message-ID: <20260228174750.1542406-192-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Jesse.Zhang" <Jesse.Zhang@amd.com>

[ Upstream commit 8079b87c02e531cc91601f72ea8336dd2262fdf1 ]

Add validation to ensure user queue sizes meet hardware requirements:
- Size must be a power of two for efficient ring buffer wrapping
- Size must be at least AMDGPU_GPU_PAGE_SIZE to prevent undersized allocations

This prevents invalid configurations that could lead to GPU faults or
unexpected behavior.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 8c41951feb437..eef65833a1c99 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -656,6 +656,17 @@ static int amdgpu_userq_input_args_validate(struct drm_device *dev,
 			drm_file_err(filp, "invalidate userq queue va or size\n");
 			return -EINVAL;
 		}
+
+		if (!is_power_of_2(args->in.queue_size)) {
+			drm_file_err(filp, "Queue size must be a power of 2\n");
+			return -EINVAL;
+		}
+
+		if (args->in.queue_size < AMDGPU_GPU_PAGE_SIZE) {
+			drm_file_err(filp, "Queue size smaller than AMDGPU_GPU_PAGE_SIZE\n");
+			return -EINVAL;
+		}
+
 		if (!args->in.wptr_va || !args->in.rptr_va) {
 			drm_file_err(filp, "invalidate userq queue rptr or wptr\n");
 			return -EINVAL;
-- 
2.51.0

