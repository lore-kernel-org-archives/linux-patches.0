Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF17197A69;
	Thu,  6 Jun 2024 14:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683002; cv=none; b=D7N8fh5dFjQf084ebRu+VuKVt5/KgOEsYn//On+8bujnLNCtD9FmNGFNiAmh+vFS6x9yIKCl2YHJd8wBTbp/ILpsqpcTcHT1G9Fd3rKOcr4sZ2NLI+Vt8HZR/VjuFCZ17uRh2RPow8kCQ1kcPbsP2Yv9ZPgtAmrdsU8BvapLiIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683002; c=relaxed/simple;
	bh=GgYvffRzY1j9NQ1BAEmH1F9tGV1hceW6drMMzcvG15g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJYxR6eGUFG1y5gEHcSx6SKqGcK7YpU0TjkgqNdHifzEqHQiiAY7bSw/CpSA88PKfhf/LJr4UsyKnuR5Zp0+86/nm1sj+coRrWQKH+orI6c5196oUIaOFGPfauPCHs2BYYtk/5WKDQgfRlsa3Cdja7uXQ58phh3quKZGlXFPAwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJ8uf2j8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJ8uf2j8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3D1C2BD10;
	Thu,  6 Jun 2024 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683002;
	bh=GgYvffRzY1j9NQ1BAEmH1F9tGV1hceW6drMMzcvG15g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJ8uf2j8qw2sijXwrhREp5t7Q7cmM57ZStM/l0pduvW7+wXyYoRlFMhxom94qSueo
	 NyeV+eiIgTDqt+H3t+fne0ldzgPwjic8R6jjSlTNiYDqQrU0bAJzk/rc9lDe77d6ke
	 qboBqkM8OR0dytpOne2DXM1ytWQgcyiuPLgnoIHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zan Dobersek <zdobersek@igalia.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 206/374] drm/msm/adreno: fix CP cycles stat retrieval on a7xx
Date: Thu,  6 Jun 2024 16:03:05 +0200
Message-ID: <20240606131658.723635193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zan Dobersek <zdobersek@igalia.com>

[ Upstream commit 328660262df89ab64031059909d763f7a8af9570 ]

a7xx_submit() should use the a7xx variant of the RBBM_PERFCTR_CP register
for retrieving the CP cycles value before and after the submitted command
stream execution.

Signed-off-by: Zan Dobersek <zdobersek@igalia.com>
Fixes: af66706accdf ("drm/msm/a6xx: Add skeleton A7xx support")
Patchwork: https://patchwork.freedesktop.org/patch/588445/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index cf0b1de1c0712..441dfebb36386 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -284,7 +284,7 @@ static void a7xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 
 	a6xx_set_pagetable(a6xx_gpu, ring, submit->queue->ctx);
 
-	get_stats_counter(ring, REG_A6XX_RBBM_PERFCTR_CP(0),
+	get_stats_counter(ring, REG_A7XX_RBBM_PERFCTR_CP(0),
 		rbmemptr_stats(ring, index, cpcycles_start));
 	get_stats_counter(ring, REG_A6XX_CP_ALWAYS_ON_COUNTER,
 		rbmemptr_stats(ring, index, alwayson_start));
@@ -330,7 +330,7 @@ static void a7xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	OUT_PKT7(ring, CP_SET_MARKER, 1);
 	OUT_RING(ring, 0x00e); /* IB1LIST end */
 
-	get_stats_counter(ring, REG_A6XX_RBBM_PERFCTR_CP(0),
+	get_stats_counter(ring, REG_A7XX_RBBM_PERFCTR_CP(0),
 		rbmemptr_stats(ring, index, cpcycles_end));
 	get_stats_counter(ring, REG_A6XX_CP_ALWAYS_ON_COUNTER,
 		rbmemptr_stats(ring, index, alwayson_end));
-- 
2.43.0



