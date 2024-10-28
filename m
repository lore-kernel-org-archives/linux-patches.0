Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE8518E77D;
	Mon, 28 Oct 2024 06:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098040; cv=none; b=JtOa6eI4TrT9jNpQygGJz/Nd/DARb8ludBCQYfKPydltSVDEZIYVjUUzcLxgM0wVc5jy5Zz2xotkYpGolKMEPiWVrn/1ulvLiLR7eshMjM9cj8DeTRpR0VvLbMnBToyB4jIhtmR1ICgW0rwldiUBThFK/sIpyg9UQTP6Rbs0kkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098040; c=relaxed/simple;
	bh=vDbA123yZ1DJ9wig9O22ciSqFXkWcAzudC0u/exRlYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ujc+AZFXPn+gS7TjZoozYps4TzUHa4mnoWMyt3WsL2v7qU9SdbhD6QXIz/Lx/Gb8B/yAYQHpfDmrk0fnl8cRhAYNCsoE1dcET3o+uCpl4Oia7VO1lcsXn8C08IH7X6hhyTkz/wnt41xegpceS/CgCzciDewaOwtdaQZS3lZM4G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfYlVzo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfYlVzo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718F1C4CEC3;
	Mon, 28 Oct 2024 06:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098040;
	bh=vDbA123yZ1DJ9wig9O22ciSqFXkWcAzudC0u/exRlYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfYlVzo08bp+eQfC0tBIhS1fXoxicjBXgHTKWM79PH3ngkdtJAqH907Q9qt0wiD5y
	 BneSqlao9zhuoDS7pBfxV3zMCHvxPgdNn0Jr1HJHd9jCL+MtT3n1MRFwDmOwijJ2qP
	 TaTLs92ADN8gwBoKUrOWlHvWYW0v3JaBWjE8XrNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 050/261] drm/msm/dpu: make sure phys resources are properly initialized
Date: Mon, 28 Oct 2024 07:23:12 +0100
Message-ID: <20241028062313.269096941@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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
index 3b171bf227d16..949ebda2fa829 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1174,21 +1174,20 @@ static void dpu_encoder_virt_atomic_mode_set(struct drm_encoder *drm_enc,
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



