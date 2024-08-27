Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8D31BC9E3;
	Tue, 27 Aug 2024 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771464; cv=none; b=GnkDmAst9z9oZYqCGLavV/EKKS+mkRphz07QLPvakNmCKZ3l22o9rfdurpGOn3Au4Lwg0oVbso51jjDgpoTsPj6ZEmW65rlgXkzdH4lj9pRa/4a29eyAXFgVb8tX7uR+mj3cjkhTLcE3YyrXwgF7o0/nMhydETq4gf2ruXghIb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771464; c=relaxed/simple;
	bh=ky/2lQ0hfHuLBprqfAazAosGPl5/+PicMiUnXiMkg8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3zz6wkkgd+P6y40yPHd75XyBZULtsJQnvICaoDS0bnpGr22mnN2vauZw07+1loxA9iCsqf9DHLGoC6JRJhcKAfMGZEiP/NS0Fi6gEGS7Ru1+vSmJmMn85BlzBUGhN1/I4Z7Z+eCNHf5ubIxEDWCHHVpjDP9CC8Of8tt3ImhuYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSa52JX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSa52JX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04227C4DDE6;
	Tue, 27 Aug 2024 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771463;
	bh=ky/2lQ0hfHuLBprqfAazAosGPl5/+PicMiUnXiMkg8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSa52JX5+y85Ga28rifi3WJvhSx53RVLy746VA2WnRSnCbXL4LACT5YvW8RRpwOfI
	 pxMT0Cun1C9iZLMbuhnf3azWD/nCdlD7HnZZt/2chRjRBsVXnvFY3mlJWXeRVudXad
	 PG+OcRt+zz/Bztx7gmU9VP1DO0riCoXAeQPhx0mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 194/273] drm/msm/dpu: move dpu_encoders connector assignment to atomic_enable()
Date: Tue, 27 Aug 2024 16:38:38 +0200
Message-ID: <20240827143840.790306225@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit aedf02e46eb549dac8db4821a6b9f0c6bf6e3990 ]

For cases where the crtc's connectors_changed was set without enable/active
getting toggled , there is an atomic_enable() call followed by an
atomic_disable() but without an atomic_mode_set().

This results in a NULL ptr access for the dpu_encoder_get_drm_fmt() call in
the atomic_enable() as the dpu_encoder's connector was cleared in the
atomic_disable() but not re-assigned as there was no atomic_mode_set() call.

Fix the NULL ptr access by moving the assignment for atomic_enable() and also
use drm_atomic_get_new_connector_for_encoder() to get the connector from
the atomic_state.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/59
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> # SM8350-HDK
Patchwork: https://patchwork.freedesktop.org/patch/606729/
Link: https://lore.kernel.org/r/20240731191723.3050932-1-quic_abhinavk@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 697ad4a640516..a6c5e3bc9bf15 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1179,8 +1179,6 @@ static void dpu_encoder_virt_atomic_mode_set(struct drm_encoder *drm_enc,
 
 	cstate->num_mixers = num_lm;
 
-	dpu_enc->connector = conn_state->connector;
-
 	for (i = 0; i < dpu_enc->num_phys_encs; i++) {
 		struct dpu_encoder_phys *phys = dpu_enc->phys_encs[i];
 
@@ -1277,6 +1275,8 @@ static void dpu_encoder_virt_atomic_enable(struct drm_encoder *drm_enc,
 
 	dpu_enc->commit_done_timedout = false;
 
+	dpu_enc->connector = drm_atomic_get_new_connector_for_encoder(state, drm_enc);
+
 	cur_mode = &dpu_enc->base.crtc->state->adjusted_mode;
 
 	dpu_enc->wide_bus_en = dpu_encoder_is_widebus_enabled(drm_enc);
-- 
2.43.0



