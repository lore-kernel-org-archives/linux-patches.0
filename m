Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77C61D26F3;
	Wed,  2 Oct 2024 14:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877907; cv=none; b=WDiwER/rtVGmwlvsIoDbtHE0b2iHJtwwMiATe2uEza6HJ43srn6ge7/NrFBwBb8NgCgxVK20I2dmAipN2Crp9nzR3cdDHxrqsDFWaam+PSo5lRN0VuZAWgQvAcyin9E4dpMd0loF0BVs8PPJ4cI/4P9gP13Q0bIxlesmX0jPyS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877907; c=relaxed/simple;
	bh=BgA4oxFulte7abMbnYJdCtXTeRj80p2vNo+Q/+Ylg4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=engCRSINhEvlDMLSh0gZQ06WSuamqogvBngCeLjvE8GodVRDWf3osnpIjjLoUi1+TDm7EShRXTPdDgHhzIjYnEVECiHOjCJN7oQyMTkiuZgX5CGshFH6d5Ij7Uzv8ZgMDhqzfVqxLeWM8oopSquon5oLB9+JtB0sCM0J7L7X9fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNZ5yk3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNZ5yk3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54A1C4CEC2;
	Wed,  2 Oct 2024 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877907;
	bh=BgA4oxFulte7abMbnYJdCtXTeRj80p2vNo+Q/+Ylg4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNZ5yk3E6E7uWCCnLhEhfOuDQpF2iNB15UVVNJ4uIZP7uV/eHHE7ibFshG6nKgdSE
	 9WBnI71Pdq+wojv4tRlLv9jACseeFqHgW5IhkjTrRANoGlwBCYDTW74I2Oc+x92SZB
	 8ovtpFJgIDEKJ8fKNyb3zB211Tu8s8PGyhC29R80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 204/634] drm/msm/a5xx: properly clear preemption records on resume
Date: Wed,  2 Oct 2024 14:55:04 +0200
Message-ID: <20241002125819.158597168@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



