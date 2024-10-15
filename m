Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C211A76DA;
	Tue, 15 Oct 2024 11:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992767; cv=none; b=grf7I2nD0w3hKFJwy5fWvqHfL7NmZHUbBos0jwjYUHBHF8JPquL2LRbnqHMS+hlt9TJR+QiaAihmPx3Ydd26QVHU+hZsyjNG1dM2P7Uhv4TUgB4gi3SJbViqhWgLJx8UcrNpiHc7WChPHoq3ZwmYoAHGDBL+LpUSHhRKFcgZgqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992767; c=relaxed/simple;
	bh=BgEkzLQPoKz6w7/pDBe/AfCvr19XtwtpLeO9RtjwDdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFYGzz7Z1V7LqzpUgpHwpLT8lftal+8ae1kf95YOnITTr0kC6bolZY9t99tqXz6A6gQPEvsMWJkdU+ZHK1VlQTFb5YpYUJsiagQp75jXRReGudquzipD2J4ECKo+uyoHe+eWogYUktAC08wxlgh1+NFzPWDBY1K3gd/3OpOrvlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YG1reRop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YG1reRop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2252AC4CEC6;
	Tue, 15 Oct 2024 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992767;
	bh=BgEkzLQPoKz6w7/pDBe/AfCvr19XtwtpLeO9RtjwDdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YG1reRope+P7pDIfzrKDniNiEPzLy3/H2aKOq69HA0TwoZtCSLuR00KbZoG2kCHad
	 4MOFIwJg4xaFk8tgf0widEQrmx/GXI+5urB/FSzsrEl4xKnYhhN5PzBNqjFWJvPu5F
	 S7KI51eCqSPvMc0Kvev2DCNk5Ikx6SD9vTw6Orvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/691] drm/msm/a5xx: properly clear preemption records on resume
Date: Tue, 15 Oct 2024 13:22:09 +0200
Message-ID: <20241015112447.545322641@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e0eef47dae632..79b43803b6141 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -205,6 +205,8 @@ void a5xx_preempt_hw_init(struct msm_gpu *gpu)
 		return;
 
 	for (i = 0; i < gpu->nr_rings; i++) {
+		a5xx_gpu->preempt[i]->data = 0;
+		a5xx_gpu->preempt[i]->info = 0;
 		a5xx_gpu->preempt[i]->wptr = 0;
 		a5xx_gpu->preempt[i]->rptr = 0;
 		a5xx_gpu->preempt[i]->rbase = gpu->rb[i]->iova;
-- 
2.43.0



