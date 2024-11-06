Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DED1DE3B8;
	Wed,  6 Nov 2024 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894962; cv=none; b=YgnSZCWWTu7iu82/Xh9KdveWIOcvmJC5WRuGQWPLqtCijhcm6g2mmy84mpYYh8z9OCoWfTq/glFVEKiSqu8yVTV5wkkl3XSYusuFYj0wbZqS+JPU0c7tD6XzPkGiuSXR8LtwtFE69YUy28LLDCdAT5CQeuK2uetGk5No9F1FWSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894962; c=relaxed/simple;
	bh=K1oa1jjuCT+wgXBIlSfA7zuNPvdfMn6ABuM0Skg3kb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cL/mCmJNeeh64JGg7pTm4PvK5pVTp2cMqtAHufgCR4rxX3GHFzFG8ESxSi7FA1NEP9EeFUErfYSA+eXDcnz+Bk/0RAE4Ygpr4Vsk+dhe23F8hmS7ckovq3E0JYQbVscQ2Yr9Zxj3m0Cp7PG4nT78InOU34RyZAvh++Y+S3WwlWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIaPwcLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIaPwcLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F011C4CECD;
	Wed,  6 Nov 2024 12:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894962;
	bh=K1oa1jjuCT+wgXBIlSfA7zuNPvdfMn6ABuM0Skg3kb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIaPwcLDuEKIjAlnVGyRA2Id4tTwAJudFgWASkozPDeE42I46ieMCnD3ZVL3dJALY
	 THQ00F8W7qg1kn4hV/tgclCuqkHZ10xeRXmho62V8VvJrUjQY/0Ii3+4OS8trcxEz0
	 LjZojeeM+gL9gsNn030lEdGO3bJjzHIDt+tvHzpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/350] drm/msm/a5xx: properly clear preemption records on resume
Date: Wed,  6 Nov 2024 12:59:47 +0100
Message-ID: <20241106120322.348673745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Lypak <vladimir.lypak@gmail.com>

[ Upstream commit 64fd6d01a52904bdbda0ce810a45a428c995a4ca ]

Two fields of preempt_record which are used by CP aren't reset on
resume: "data" and "info". This is the reason behind faults which happen
when we try to switch to the ring that was active last before suspend.
In addition those faults can't be recovered from because we use suspend
and resume to do so (keeping values of those fields again).

Fixes: b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/612043/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
index 970c7963ae29b..d6dc4168558e0 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -209,6 +209,8 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 	int i;
 
 	for (i = 0; i < gpu->nr_rings; i++) {
+		a5xx_gpu->preempt[i]->data = 0;
+		a5xx_gpu->preempt[i]->info = 0;
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
-- 
2.43.0



