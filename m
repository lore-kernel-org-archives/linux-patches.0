Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1739B15667B;
	Mon, 16 Sep 2024 11:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487977; cv=none; b=FmTDwqC++kSBbyk/oxkp6KrJvrUm0A2Rcmv+lVs2K2IC662hv8Dvn+6i4j4p2rwkfXVsUx+W3ZiLxbo8r9uSXJdCB9EX3XuRCLG2hhig7tsvkUKFarMdvhF6gMCUSgTzBHX6eYVE90Akiu0M4KA7p491916Z2fdBJx8HDrpQ9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487977; c=relaxed/simple;
	bh=D4b12ri3fL92PS4sU914RT1bwqZLE1GPnqCtDsn1/sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbbtCrJtpCE2sc4USWFVpTLUOuy4Cou1oTpaHMPCNVjwcAhVd5JXkqyi/A0SxIEnifPVf9xaUQg963O8RqROG/GHZDMldT1ILc4UFBqjlTcYWSsGhpJZRoGhR/TeiTA9Dz4PttZIgj+GwvWdrsG5dPj6k84WVjI2/8dgMJIgEr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tt59O5Tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tt59O5Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7124BC4CECE;
	Mon, 16 Sep 2024 11:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726487976;
	bh=D4b12ri3fL92PS4sU914RT1bwqZLE1GPnqCtDsn1/sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tt59O5TkTePh2F98z2fqZGUZ1xVTEC+kax3rsH1dAAbr9U1BbOY95cD+GWOXYzlFg
	 dTMycptPT0WMIVRT+OWGoRqpzJT3OLj4h1BWGe9YoxCIiHFZJhfUu2lkKXD7bxJ6rb
	 oRF2D/yeeIEHeOhhZAcgGck+vMqWlEVExuldK7vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/63] drm/msm/adreno: Fix error return if missing firmware-name
Date: Mon, 16 Sep 2024 13:43:55 +0200
Message-ID: <20240916114221.633148975@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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
index dfd4eec21785..c4ad70eb1d92 100644
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



