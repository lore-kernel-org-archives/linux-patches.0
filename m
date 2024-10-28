Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E17718EFD6;
	Mon, 28 Oct 2024 06:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097298; cv=none; b=PjEuKvmC93Euf+hMWGYViUIp3R6KNqBxdr5NhfEjPO7Y+YHuOQ/EDNEDKrWXp+eYzboxTKAv674nRDLMddaA+B++nNi1C69kEuNy3A3dDslk/h6fJjcpNIzu3GapLPPkBI6hdO9dcV68UbeoZVInAwhRKVQnva9W3y55z3On9sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097298; c=relaxed/simple;
	bh=O49dpKvS64nT1RBjfHt/N4EquhI1cwiLeclxc0w/jac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMlyhYRwEP5MpVrbIfXWSoMzYZ6k9eLTpZe+5QV1G987USEOPbFZ9yYwEpSB4jJu2+tHO5btvCgHpnthyAopGJvu+FYp0arsvJw8Qm3eXwz03zLl30fBYOanEdcxmKIVUERY7V9dJxHY3Pjg6rsJxZ6VV/ygvLt0M4aNvKnmCcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldeet0Vo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldeet0Vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02C2C4CEC3;
	Mon, 28 Oct 2024 06:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097298;
	bh=O49dpKvS64nT1RBjfHt/N4EquhI1cwiLeclxc0w/jac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldeet0Vo7kXS1Km2POklyfTEtOwHf120SgKvIFAyXXUMvRq7ComhG+VRJnIea2Ivc
	 NJOtexxyOuHP9PNPkJA0n8xqEKYGmKW5PpEKBHDUEcUJganhUbUo102x+vwjvSRd/K
	 os9DR3UVvKFfGIzfIH8OWQBePwEyWU8sDrU5RShE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/137] drm/msm/dpu: make sure phys resources are properly initialized
Date: Mon, 28 Oct 2024 07:24:20 +0100
Message-ID: <20241028062259.371035325@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1bf41a82cd0f9..ba8f2ba046298 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1106,21 +1106,20 @@ static void dpu_encoder_virt_atomic_mode_set(struct drm_encoder *drm_enc,
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



