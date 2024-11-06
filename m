Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2311E04BA;
	Wed,  6 Nov 2024 12:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897967; cv=none; b=OUXS6E5kv4DLCIIbvurlt9gtHjhjT8meuBmnPRk1yR0RzRF03i8nY5lKyajPiKrSinR4xwkbl6/a5IonTfe3hpcK0pOEQLzl7c4avjJHc6N9GFj2+UD3tpBAHik9OtUdhLuKYn4cH7KHOaFmRTjTModI+2GyfLwIUdJHTEFfFNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897967; c=relaxed/simple;
	bh=87E4acf6bLKF0YHcJiTWMgdhav9iBnKlTfqxzlgsaJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiD+ZDJvs4fBOSyNDXhFJyT3rZeHUPAPefOHFqUnjq8qVe+eNnWngZdRQQxbi9NRQUFh1PNZywcIbdsR4U4Zve+T3uFqKIi5kmEJ+0V/TsPLxMLkxRWn2v+zyZjoo64GB6SZea8JRwgpzf0BkAfgDcgIrC0QBjxVpzb3ogQiwpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gt4hsNjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gt4hsNjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F50EC4CECD;
	Wed,  6 Nov 2024 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897967;
	bh=87E4acf6bLKF0YHcJiTWMgdhav9iBnKlTfqxzlgsaJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gt4hsNjnGvObVnclxlDFPvrKuj47D+NSqZkVtLESRioIdVTuha1AmgHQ4iG/YsR+A
	 uZJCyqAy+UWvV3/K2mFBzztN8bkItRj5hQSj8+Lxk8tTsIgDhr+hvmIObu5x82xWf6
	 3SKqbeMhI05nDZOSLUMf1+QdmjS+qbHELgECzLhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/462] drm/msm/a5xx: properly clear preemption records on resume
Date: Wed,  6 Nov 2024 12:59:33 +0100
Message-ID: <20241106120333.483915998@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9cf9353a7ff11..0a892f4f59d1d 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -207,6 +207,8 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 		return;
 
 	for (i = 0; i < gpu->nr_rings; i++) {
+		a5xx_gpu->preempt[i]->data = 0;
+		a5xx_gpu->preempt[i]->info = 0;
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
-- 
2.43.0



