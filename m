Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF04134C2;
	Tue, 23 Jan 2024 00:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969508; cv=none; b=EIS0T3xn0B3RLeUUjiswd4hOn+h+l4QqdZtfDgi8NeNpvLXreYiEn9FbGyHvI851tk8SO5+knbwNKnro06gdOKYd4Jhl0M7pMCWNaWcVrpFNzhAxrgjoogO8nhpwx/FU9DLM5XgZqq8Ny23ZzY7JaP4V7nDknvSejTfCN0QBcQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969508; c=relaxed/simple;
	bh=NdIODz7VJOMt9w0wJy64BL25ZMNX9fM13kCG2o6yaJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRrpwCUnYUIJoPdtUfQWt14FLLRvovfPGXMrQlRh+0Xs+V8UR/aBLPqSRRxuAh2S2ctMV90QP0/00PBCTzsioA2hPbw9zAUXJE17pW91Yx+HamAEAWtwjmA97w8yWApugpNiXUIiNfmDOjVSp+ksuJ/AOGGoSbzYd+pOmoqLrys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3C1jyfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3C1jyfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE99C433A6;
	Tue, 23 Jan 2024 00:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969508;
	bh=NdIODz7VJOMt9w0wJy64BL25ZMNX9fM13kCG2o6yaJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3C1jyfMp0d0POaqvEkV2i+Dhaz0iLJ9HOcQTdyujiF9OuspfVNUiSZmjRKPOQMCs
	 oJMzL8h94v1DYQ56qo5LI98gXVAjy+yx3zZkfLc7ScUGu9PNFdP2vY+YLgrM3ofjcQ
	 el9e2vLnvByWhpC5o8HtpBzogOOAnr8OMXsaSuRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 269/641] drm/radeon: check return value of radeon_ring_lock()
Date: Mon, 22 Jan 2024 15:52:53 -0800
Message-ID: <20240122235826.338110754@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 71225e1c930942cb1e042fc08c5cc0c4ef30e95e ]

In the unlikely event of radeon_ring_lock() failing, its errno return
value should be processed. This patch checks said return value and
prints a debug message in case of an error.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 48c0c902e2e6 ("drm/radeon/kms: add support for CP setup on SI")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/si.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index a91012447b56..85e9cba49cec 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3611,6 +3611,10 @@ static int si_cp_start(struct radeon_device *rdev)
 	for (i = RADEON_RING_TYPE_GFX_INDEX; i <= CAYMAN_RING_TYPE_CP2_INDEX; ++i) {
 		ring = &rdev->ring[i];
 		r = radeon_ring_lock(rdev, ring, 2);
+		if (r) {
+			DRM_ERROR("radeon: cp failed to lock ring (%d).\n", r);
+			return r;
+		}
 
 		/* clear the compute context state */
 		radeon_ring_write(ring, PACKET3_COMPUTE(PACKET3_CLEAR_STATE, 0));
-- 
2.43.0



