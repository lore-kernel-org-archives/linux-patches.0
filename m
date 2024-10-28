Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC53018E04F;
	Mon, 28 Oct 2024 06:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097548; cv=none; b=AkVQODoFLCwcs+K2n0LsnEUpTBPNslYpS8yv0EMFyG3quEY1CZ4bx4kBLxKibM6oOM9z1hZS0GdvFhKH/zBjYw7tXt4VWBopQhD0pJgJ7Fv/762JMU7OiQoq529HJZgRbSS7W+2FQwrxmTXdwtc1gSXd2BwVDzR9XUxHIPyW1Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097548; c=relaxed/simple;
	bh=6e3IBE7cGQ8wQYgJBFcsNJauE8sGSwFvSg4rsmzuvgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFlWg8Uk5DThnf/NjBOYbaB6Mc14YXdyNJuUdbwLqO5pLK//yzLeV84DjaG5aRTV3fc0gH/NNxhRBuzrC51Yp4B4cYWp+EkEGusM/vEYSQBtMyr8gTFE2gj7FLPUyNtBL/+0OJJ4dfS5V1S+6BkVkdEieUETnG3dDK6fInTZifI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7E9j8WB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7E9j8WB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435C7C4CEC3;
	Mon, 28 Oct 2024 06:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097548;
	bh=6e3IBE7cGQ8wQYgJBFcsNJauE8sGSwFvSg4rsmzuvgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7E9j8WBvUUnEww2oMk7j5cbOunWzh8LHdxKTWrY/IJtkwd10N3I76DUb1/XONPm8
	 0342BLukXbqOb9IJ1wDs6ETCyNrZ5AOxhDwFnZz5v0wMyCB3k//963n3enPbZegZxE
	 kRs0qUhmd3Io+qP9hfC+sG0UoB8RCIOmhgEJ6tF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/208] drm/msm/dpu: make sure phys resources are properly initialized
Date: Mon, 28 Oct 2024 07:23:41 +0100
Message-ID: <20241028062307.667352166@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit bfecbc2cfba9b06d67d9d249c33d92e570e2fa70 ]

The commit b954fa6baaca ("drm/msm/dpu: Refactor rm iterator") removed
zero-init of the hw_ctl array, but didn't change the error condition,
that checked for hw_ctl[i] being NULL. At the same time because of the
early returns in case of an error dpu_encoder_phys might be left with
the resources assigned in the previous state. Rework assigning of hw_pp
/ hw_ctl to the dpu_encoder_phys in order to make sure they are always
set correctly.

Fixes: b954fa6baaca ("drm/msm/dpu: Refactor rm iterator")
Suggested-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/612233/
Link: https://lore.kernel.org/r/20240903-dpu-mode-config-width-v6-1-617e1ecc4b7a@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 6262ec5e40204..10c68de1bf22c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1122,21 +1122,20 @@ static void dpu_encoder_virt_atomic_mode_set(struct drm_encoder *drm_enc,
 	for (i = 0; i < dpu_enc->num_phys_encs; i++) {
 		struct dpu_encoder_phys *phys = dpu_enc->phys_encs[i];
 
-		if (!dpu_enc->hw_pp[i]) {
+		phys->hw_pp = dpu_enc->hw_pp[i];
+		if (!phys->hw_pp) {
 			DPU_ERROR_ENC(dpu_enc,
 				"no pp block assigned at idx: %d\n", i);
 			return;
 		}
 
-		if (!hw_ctl[i]) {
+		phys->hw_ctl = i < num_ctl ? to_dpu_hw_ctl(hw_ctl[i]) : NULL;
+		if (!phys->hw_ctl) {
 			DPU_ERROR_ENC(dpu_enc,
 				"no ctl block assigned at idx: %d\n", i);
 			return;
 		}
 
-		phys->hw_pp = dpu_enc->hw_pp[i];
-		phys->hw_ctl = to_dpu_hw_ctl(hw_ctl[i]);
-
 		phys->cached_mode = crtc_state->adjusted_mode;
 		if (phys->ops.atomic_mode_set)
 			phys->ops.atomic_mode_set(phys, crtc_state, conn_state);
-- 
2.43.0



