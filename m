Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7214417A2FC;
	Wed, 20 May 2026 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302039; cv=none; b=F1AITyKrm0r/Lj+mORD79N0FeE/9K/m1pO2diI2rtW8W84RAopXxd5+5b0PDLhfDTcR7dxv5pc1oVJswzXnJEm19NESAdvaqM5eLurfC2dMIJtbZ7ff3m0m1V4UT9DTmW+3sloxxgNBKYW3BIJGz30oHTLPod83gDVZ2aU/xTwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302039; c=relaxed/simple;
	bh=keh/4Hj0xmB7G257dy2n2RueLaKcKorHg/T+hfgYbFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kALThfRJBpHIkOdxMw+5bwn0zWRIoq3u8l7t3vbhh8hPpJdRi6TICMk9Nox8vqtXlJpQys3smdNRBtldvBanALQvQ32D9l6fqij8/DLujA+vm6SjUWsFD9bcevhhnNgIGLFU/wnS4FszK2qBa7FpF3IyJKbbRiXxI/HxhfoIBZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnmGAy+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnmGAy+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EE61F000E9;
	Wed, 20 May 2026 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302038;
	bh=VR67rIaUfetI5n5isBmPVKrdYrjuy7sn83uaTVb5oI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnmGAy+tvUGtDf12bL1qX/cdj/tZv1ydhkvi9BHNwkBTFzUAiLyvTFSTtQUYdv4k0
	 aJjtc9qgtXiXxBR/6NHgSlPCLHabl5CLja1GUlVB/JebpTR+uCBsRjfUTnnfHNJmV2
	 jZC5I2y0rpDBukJa9TB4bqvugaEr0mGujoFHnQmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/508] drm/amdgpu/gfx10: look at the right prop for gfx queue priority
Date: Wed, 20 May 2026 18:18:57 +0200
Message-ID: <20260520162101.098008221@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 355d96cdec5c61fd83f7eb54f1a28e38809645d6 ]

Look at hqd_queue_priority rather than hqd_pipe_priority.
In practice, it didn't matter as both were always set for
kernel queues, but that will change in the future.

Fixes: b07d1d73b09e ("drm/amd/amdgpu: Enable high priority gfx queue")
Reviewed-by：Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 1c29b4d04a2ca..afa9eb7050751 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6338,7 +6338,7 @@ static void gfx_v10_0_gfx_mqd_set_priority(struct amdgpu_device *adev,
 	/* set up default queue priority level
 	 * 0x0 = low priority, 0x1 = high priority
 	 */
-	if (prop->hqd_pipe_priority == AMDGPU_GFX_PIPE_PRIO_HIGH)
+	if (prop->hqd_queue_priority == AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM)
 		priority = 1;
 
 	tmp = RREG32_SOC15(GC, 0, mmCP_GFX_HQD_QUEUE_PRIORITY);
-- 
2.53.0



