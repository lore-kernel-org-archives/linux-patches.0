Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD512BF3E2;
	Tue, 10 Mar 2026 11:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141097; cv=none; b=k8MRUlLxQZc1eqm6mYq9rHQYzuDS37pBxsj6jH9MfxV7cGvBgw825T8cLeysWID+c5rkmN8QRpiQ3IzN6ol/DlVmU8zFLQha3e6VcjFOMkbIvnq8DOc5d2Zn+u1ziN5NAljYP1iUVIFtsxW5TvEY1uCDFin1geBeF7Mo7iRp+R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141097; c=relaxed/simple;
	bh=lJQdq2iaaHSa9q7Xv/z4g9O2ReS/644I+1V3+c23Fuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6PGl7qxMdaaToOSVUxsc9uJT48FoZFXyMW70kHpsJylZP5s2Go7aC9lf63ukvIT/p9dFx3NoL2kYS+p14vukljQcRmkL+Bu7nu09n4avIDxQ7BdnuDMwbiy6GfysqgZw7OvFsI5F0DU9sdZMxSaz1obPA8MWLtF51QFn7ORcCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuaytctF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuaytctF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D514EC2BC9E;
	Tue, 10 Mar 2026 11:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141097;
	bh=lJQdq2iaaHSa9q7Xv/z4g9O2ReS/644I+1V3+c23Fuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuaytctF03CfdEeg78YqlMwqSptEnzrFTblkM0D9ROlPPycpWWoyDsvSHeGoxDvor
	 glCqRxAkFtpEcU49CwLmJjdAsbXmvmzgqdUsh2nw3RUXrCySaeYesducBNFpwOOzj5
	 6U/OAFg1eszCknJePSIs3DLaChlmrRQuJ0C1sHO7HpsjqSqup9tQhPChSRv+FQY0I7
	 9IEDWt3VhE6wRB/y8ToEmRLcvvcxJZ4THP5yLNM7fRGIU8gBwVsrlZwxepKRYUdOro
	 WJTsfX9IOJQ2jbvwdpNmEjYJ+O15uaZ0WaJeEi7wltqlMO3oX2FHX0BpDwMFsHuSQi
	 rgk5MxKOqPVRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Quentin Schulz <quentin.schulz@cherry.de>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 098/311] accel/rocket: fix unwinding in error path in rocket_probe
Date: Tue, 10 Mar 2026 07:02:25 -0400
Message-ID: <ebf2f86537ec70c933674ef4123979834188cd49.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Quentin Schulz <quentin.schulz@cherry.de>

[ Upstream commit 34f4495a7f72895776b81969639f527c99eb12b9 ]

When rocket_core_init() fails (as could be the case with EPROBE_DEFER),
we need to properly unwind by decrementing the counter we just
incremented and if this is the first core we failed to probe, remove the
rocket DRM device with rocket_device_fini() as well. This matches the
logic in rocket_remove(). Failing to properly unwind results in
out-of-bounds accesses.

Fixes: 0810d5ad88a1 ("accel/rocket: Add job submission IOCTL")
Cc: stable@vger.kernel.org
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Signed-off-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Link: https://patch.msgid.link/20251215-rocket-error-path-v1-2-eec3bf29dc3b@cherry.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/rocket/rocket_drv.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/rocket/rocket_drv.c b/drivers/accel/rocket/rocket_drv.c
index 5c0b63f0a8f00..f6ef4c7aeef11 100644
--- a/drivers/accel/rocket/rocket_drv.c
+++ b/drivers/accel/rocket/rocket_drv.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
+#include "rocket_device.h"
 #include "rocket_drv.h"
 #include "rocket_gem.h"
 #include "rocket_job.h"
@@ -158,6 +159,8 @@ static const struct drm_driver rocket_drm_driver = {
 
 static int rocket_probe(struct platform_device *pdev)
 {
+	int ret;
+
 	if (rdev == NULL) {
 		/* First core probing, initialize DRM device. */
 		rdev = rocket_device_init(drm_dev, &rocket_drm_driver);
@@ -177,7 +180,17 @@ static int rocket_probe(struct platform_device *pdev)
 
 	rdev->num_cores++;
 
-	return rocket_core_init(&rdev->cores[core]);
+	ret = rocket_core_init(&rdev->cores[core]);
+	if (ret) {
+		rdev->num_cores--;
+
+		if (rdev->num_cores == 0) {
+			rocket_device_fini(rdev);
+			rdev = NULL;
+		}
+	}
+
+	return ret;
 }
 
 static void rocket_remove(struct platform_device *pdev)
-- 
2.51.0

