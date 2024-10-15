Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAFC1E5022;
	Tue, 15 Oct 2024 11:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992122; cv=none; b=udHbDvB48immTN34yq4tbJKVBrlc5EROt4+4JWvrZAX+4w+BcaicOUOhpQoWujVFlJoURqhbH5Q7EhlzgCzitxAlNUb1r+HSqRWejaETPm6OL+Kg2u6/XvJNnjcvIW+65YM30sadlVkLsv5xBxiDz4l56vMkL8Bvr4DjfDQHsm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992122; c=relaxed/simple;
	bh=BAktr6JXP4jJ+Dcf/srbaR+CltOexw1IAd/SZCeWKBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCbkXtz+R3W9HWmmWoj4Ls0SJfHSJgsRCxfMNNcRpsZqJUu6Of5RWofosTKH1j1Qu7luCExZOXRUU8jnn86MP7noPCfQ84+ryVi9IsSeXWU8GMqiLip4XtsIsqNsmv2TBQn5/pJFXXBxlnnTIIA/1mcIAGWo1tDJGpIGII3Z1KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfbItFfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfbItFfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40C1C4CEC6;
	Tue, 15 Oct 2024 11:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992122;
	bh=BAktr6JXP4jJ+Dcf/srbaR+CltOexw1IAd/SZCeWKBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfbItFfnXLzmkYmhUq8xAD7U1cbts9VC7bN7fyEwcJhF5tWzkRi3WvkSzcy+anwmO
	 jXojiuRO92eGIEEu4ue5V2EQPeW7hZEMCO2QoR0YxtFEQ72X4RMxfeqAk/W3SUUVND
	 uQ9ONBGyneXgDK1JWkryPBMLr7NtXk/kqOXkTAM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/691] drm/msm/adreno: Fix error return if missing firmware-name
Date: Tue, 15 Oct 2024 13:19:33 +0200
Message-ID: <20241015112441.333601186@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 624ab9cde26a9f150b4fd268b0f3dae3184dc40c ]

-ENODEV is used to signify that there is no zap shader for the platform,
and the CPU can directly take the GPU out of secure mode.  We want to
use this return code when there is no zap-shader node.  But not when
there is, but without a firmware-name property.  This case we want to
treat as-if the needed fw is not found.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/604564/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 47a260715a89..4c61f9906808 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -94,7 +94,7 @@ static int zap_shader_load_mdt(struct msm_gpu *gpu, const char *fwname,
 		 * was a bad idea, and is only provided for backwards
 		 * compatibility for older targets.
 		 */
-		return -ENODEV;
+		return -ENOENT;
 	}
 
 	if (IS_ERR(fw)) {
-- 
2.43.0



