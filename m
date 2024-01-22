Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E066281D;
	Tue, 23 Jan 2024 00:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971457; cv=none; b=j+FR6xJ5X+rzAXCwFLDYkYbpBcYGjS8aPhMyo9wTDASDJRj/DKV8vcQ+IR1zMmdb5w8bIhBcw27c1sulTMQJxfKFYpWVflYEH7F1jEl82dATcM6x5WUR6B4sV67nEN0ojgE2ITiuRXdfazG4sHaC38+khHO/RYKN/Zmrm4Se8ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971457; c=relaxed/simple;
	bh=wRvii5VxOUWZi3kf6/WVCHqI+pAgsQmyPKx2C2dfRaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7YWiLd106YL4LaOUn5r/3ef4GEPh+06uWVrIZlNIR0+HdD9onjXtuLotMRqg2o2FGHpm0GQdnekcEgFG9CpVr3DfRsUZICrJkbfzVARRzrihSfMcSrKPCQi19tZFLKXDdotOalxMx3jBTOwigm7wx54N+voeMKtVO9rAa39RMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQyIdzLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQyIdzLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B242C43390;
	Tue, 23 Jan 2024 00:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971457;
	bh=wRvii5VxOUWZi3kf6/WVCHqI+pAgsQmyPKx2C2dfRaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQyIdzLuMWodIsq+anrGfW3hEPU0Kgv6iG9x+3io4N+Z6+JcY//LaJaQrmDKMVCE8
	 0twf3bfJc0jpjCUecVLIOmxojKXQ54ptSYMxSr16Mvc16MEqrXgraUakprHhuZp0Md
	 NHLeaK8KVRtAdmiQvxo2suDukXLMD1d7h2TSgIgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/286] drm/radeon: check return value of radeon_ring_lock()
Date: Mon, 22 Jan 2024 15:57:40 -0800
Message-ID: <20240122235738.096041385@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 31e2c1083b08..e2eac766666e 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -3616,6 +3616,10 @@ static int si_cp_start(struct radeon_device *rdev)
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



