Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492BC299943;
	Sat, 12 Sep 2026 07:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198895; cv=none; b=URk6nQsbOO2xwgXnfLXcqoVrSRWyaQvONd778xZz9LWPmHtZSnD//zVPOOsB4pV0+qngTpnWx7Y5FT8Y+QHnzmau6DQDqSq+j5xgB4Twp2Afc5JbfGRkBa1e/Gigakv4u7kHKuB2l0XB79bdSF4YfVKjhG1UM+A3iA4FE63OJAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198895; c=relaxed/simple;
	bh=xkl8iapRsRiof513Ssf/YkWqvZt8CDaYNcas0XYjgW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZnBrSFNq/RznscXLhuKGKnQk3e7TVl5M6vRyzsc1kPM608/jhRkYAIdpZbf6gXwy7Vig8oBKmISr7fNSh7/Dj6M56VGiFySWwB03tRtylMvv4IgDfm+R/OPeHYYPdewk9W1ZHgly8p3powRB434amHz8Q717C8Y4uM2s9iqlsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXSYV5f0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXSYV5f0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13FE1F000FF;
	Sat, 12 Sep 2026 07:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198893;
	bh=i99RlqYm0as7/akGNInbj4szDT07oFqttz2wICSF0fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXSYV5f0djbnIjWp3wByjvnOo1jh+31rMo3DR4R3/FBQJlDW0z3EvDR4wLJVz+/IX
	 bEZ0oJ1cSgNw9x5f5HDYI5I+MJCAbK6ihmMMKN/wSlCCsa3Jdm7uGRZf2GkV8Ap/Hx
	 dZLPRcs4yZnyDFLLO3jks9SU9M8cLWR5L2ytzm88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Zhang <jie.zhang@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0474/1815] drm/msm: Recover HW before retire hung submit
Date: Sat, 12 Sep 2026 08:37:04 +0200
Message-ID: <20260912065700.014518241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Zhang <jie.zhang@oss.qualcomm.com>

[ Upstream commit b303e1d52811de7d1bcf793560754d4df68d4a1c ]

During recovery, it is not safe to retire the hung submit before we
recover the GPU. Retiring the submit triggers BO free and that can
result in GPU pagefaults since the GPU may be actively accessing those
BOs.

To fix this, retire the submits after gpu recovery is complete in
recover_worker().

Fixes: 1a370be9ac51 ("drm/msm: restart queued submits after hang")
Signed-off-by: Jie Zhang <jie.zhang@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/730655/
Message-ID: <20260605-assorted-fixes-june-v1-2-2caa04f7287c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 18ed00e5f143b..9ac7740a87f01 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -552,11 +552,11 @@ static void recover_worker(struct kthread_work *work)
 		msm_update_fence(ring->fctx, fence);
 	}
 
+	gpu->funcs->recover(gpu);
+
 	/* retire completed submits, plus the one that hung: */
 	retire_submits(gpu);
 
-	gpu->funcs->recover(gpu);
-
 	/*
 	 * Replay all remaining submits starting with highest priority
 	 * ring
-- 
2.53.0



