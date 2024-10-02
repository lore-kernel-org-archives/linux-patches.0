Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722891CB32E;
	Wed,  2 Oct 2024 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875815; cv=none; b=Gaszw/aAmXVz72pxu/Z3ALMxPJs9Mq1ui6uQGnluMUzCXdjTWQHWqI11dLSYIvyL7Mc2aA+2AznQt28XwGtY/k0VOULQuvorXHfxv8wACFXLCJTYL6Q8M+tEV7xzmrhv2bfBmdzrS6LrYO4AUzFP5C9ZQ6W2iDR1eFAW/AaJ8hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875815; c=relaxed/simple;
	bh=MNFY+238xGWWe/sUMx+Sl4y1d4d76Px0t6s1fdgOvqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcrRc3mhrIwzf7wD9srNzs1cdyOXuogSINieEhEWIPwpirz58EeH7Sc35nW1zrTx0U8GpVJY8O3ad1UvWIbO2NMSUJ12wJQkmYhZqrVDXq4bplw/hiGoXE3eTMqgTTw6l7HShH+3XgHSRkWBcFKDQPc4fXTPlXP1eFi3kEwF8ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSANRQoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSANRQoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE91EC4CEC5;
	Wed,  2 Oct 2024 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875815;
	bh=MNFY+238xGWWe/sUMx+Sl4y1d4d76Px0t6s1fdgOvqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSANRQoVX54zMX/cbs1d/rWs/fczb8cBWmsfjG+STJDydyV02c0dsS4UBOL0Fbfid
	 Q+F8C6yD+Fy3GQPJi3XUa7YkgtB9yf3+sexpnmcwbC+rzdG7VYGE7PG2stuJn1vhi8
	 WBU9/WrK5E2WPo0n7GzKXI5zhJKZNWnoiaL0BGi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 231/695] drm/msm/a5xx: properly clear preemption records on resume
Date: Wed,  2 Oct 2024 14:53:49 +0200
Message-ID: <20241002125831.673017999@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f58dd564d122b..67a8ef4adf6b6 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -204,6 +204,8 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 		return;
 
 	for (i = 0; i < gpu->nr_rings; i++) {
+		a5xx_gpu->preempt[i]->data = 0;
+		a5xx_gpu->preempt[i]->info = 0;
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
-- 
2.43.0



