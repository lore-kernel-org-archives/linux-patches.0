Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469A01AF0A7;
	Tue, 15 Oct 2024 12:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996831; cv=none; b=h0XKsAUxcWzKg9FtzDnpYPABcspTeXRC3BZGVYt+255MxyOPFzJGPMIJQUXTkR+prhqJ703qYF86QGEERd6/Kt5I3uEJlH2rFeBA50e7W3wHTY/C47em8Ze7+QhJhouvZOzYGDLj0Mk1PRUMOXhIFOXaDl7TVDeRhf1znty6jWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996831; c=relaxed/simple;
	bh=uIuQzjUgeG23mDvvv79jGKjJWKn8q8GdgdP0Nt6jUn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIZicJufx3WtEm+VFIOOqDF3V02Bvj8Cex2MYUWn3HCwf/mQ/O5VEkYqBxeHF51XoMhE85SJI3SQ+UzVQk+UyI1n3C+/cY+NkC6iVzfbDZrCWVu7JPN/hmp7jYkMjnMhvjnXcwBETjZVHPGJ6PharPWuTFPDQbgBScfcHlnFzHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDtHYjB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDtHYjB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F726C4CECF;
	Tue, 15 Oct 2024 12:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996830;
	bh=uIuQzjUgeG23mDvvv79jGKjJWKn8q8GdgdP0Nt6jUn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDtHYjB1UuaL/jnl7iWsIj4jcjsGmNyL9JcwhOeEZ3tMqXJH3izp4qf0rjneQolT9
	 YPgei84CMPBEA2IOxeI7i75BjL7Al0fd2qt7ULBhjWnB55ncPT4pWcKQdund8AKyEF
	 r2KR8+7pWtSrUlyS5ZSNLIMHCy4WqqcjGD1RZwp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/518] drm/msm/adreno: Fix error return if missing firmware-name
Date: Tue, 15 Oct 2024 14:38:36 +0200
Message-ID: <20241015123917.309001928@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 11a6a41b4910..a5f95801adfe 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -93,7 +93,7 @@ static int zap_shader_load_mdt(struct msm_gpu *gpu, const char *fwname,
 		 * was a bad idea, and is only provided for backwards
 		 * compatibility for older targets.
 		 */
-		return -ENODEV;
+		return -ENOENT;
 	}
 
 	if (IS_ERR(fw)) {
-- 
2.43.0



