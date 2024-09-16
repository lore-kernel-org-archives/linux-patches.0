Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FC8149C57;
	Mon, 16 Sep 2024 12:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488547; cv=none; b=syLj2UUdhnows4DaikTCinjtUTHW33BiraWemXrJHnLYa/whg4y9LNf273qnuuV5XyuvmLOqIHET0UnPIz/QX52vUlmj7Y9cxgTiAwGzbNvzI/3sKGt/sqoVrqMGIjrRUnYg3sIf8mEqerOiH/r8VD8EFiclqIMbXNKpXEQjc1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488547; c=relaxed/simple;
	bh=ySQbGZHtrFPTP3vIfV1m8S/g8js1x1qQr6KgcmK3LNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KK86cIgmdXys02TTH7OT949xnvtl5RJKjM61pUlMY5yOVjrY20qlPXpjhaK2gc9wL62sqRIw5z77qibJ+DINXYbxAQm3YXLPGK3I9ymEVYeMKQjKpNkDTvbX+oZ4dXJinRDMSVvfJ2IWP8yHfXxF9LqesOJT2mCa7djw8QMYZAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBrQyhpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBrQyhpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20826C4CEC4;
	Mon, 16 Sep 2024 12:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488547;
	bh=ySQbGZHtrFPTP3vIfV1m8S/g8js1x1qQr6KgcmK3LNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBrQyhpVx6k8IHx9cldyhJ8EVeJNre2CxdRhm76uRGmSd/wPfs8uKencfZYoETCGU
	 WRfezWG8MDrHiYaGRY1VjLiXbwL4Fn8YcG+qmNwAFfqs79jCLS4m7rpEPl3e/lhpSy
	 NuK48Ev7p5mBPt2gNgAm57QjVCZhnxzxYaBz6KDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 30/91] drm/msm/adreno: Fix error return if missing firmware-name
Date: Mon, 16 Sep 2024 13:44:06 +0200
Message-ID: <20240916114225.502595359@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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
index 8090dde03280..96deaf85c0cd 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -99,7 +99,7 @@ static int zap_shader_load_mdt(struct msm_gpu *gpu, const char *fwname,
 		 * was a bad idea, and is only provided for backwards
 		 * compatibility for older targets.
 		 */
-		return -ENODEV;
+		return -ENOENT;
 	}
 
 	if (IS_ERR(fw)) {
-- 
2.43.0



