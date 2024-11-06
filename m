Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80871EC011;
	Wed,  6 Nov 2024 12:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897964; cv=none; b=fGaYDawiZ45Ls6Fl6UzP59Bo2uC2yY/HW7tscMY4YOOE9ICllSiiGmbnelXeTLEo1HW6iOAWJRdMDGiqmhIKb2IvOSkazIQ3fOi2bFN2DUuFf+sYSOd3pMQd7h6vyfZjl4bVSDM7owuK5auFn8OxfelQCli/hXAtTbNKpu1zQFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897964; c=relaxed/simple;
	bh=v9T27XD8tLJF1DOI33ai2lU6rnhQSkMFsGBYBH5ehZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LX1vz1cGsiw3PoUOP+siMfjFNYVvmXxsetVTKhQHUtREi1Ss/seGlR9fSgmgjUhPqMy6gxkgpR4v71vlMbXPfk/wwiOw/DL74vQ0aU8WV9p23qz/sX49TfesJyfBK0M7UJSTqG1mALcEU29Jfk+xXqYw/nSm4HoA6L8iA2Mqvsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XupPjAWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XupPjAWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B857C4CECD;
	Wed,  6 Nov 2024 12:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897964;
	bh=v9T27XD8tLJF1DOI33ai2lU6rnhQSkMFsGBYBH5ehZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XupPjAWwBoXjRoU7Mn82yop85gRg9LwXxtvh2JmGz4ciT7UMRaSHMrnBsVMS9sEB1
	 1/ajOV/WUf0sQdXgyM8R/DcN5G1lotyZXsHHlcJvS9wYb5QxIrP/STeUNM/onmW4f1
	 gNNtIbgqfRqlyhu6vHlCyYsScZdmbMVtyI7HU5fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/462] drm/msm/a5xx: disable preemption in submits by default
Date: Wed,  6 Nov 2024 12:59:32 +0100
Message-ID: <20241106120333.457991262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Lypak <vladimir.lypak@gmail.com>

[ Upstream commit db9dec2db76146d65e1cfbb6afb2e2bd5dab67f8 ]

Fine grain preemption (switching from/to points within submits)
requires extra handling in command stream of those submits, especially
when rendering with tiling (using GMEM). However this handling is
missing at this point in mesa (and always was). For this reason we get
random GPU faults and hangs if more than one priority level is used
because local preemption is enabled prior to executing command stream
from submit.
With that said it was ahead of time to enable local preemption by
default considering the fact that even on downstream kernel it is only
enabled if requested via UAPI.

Fixes: a7a4c19c36de ("drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register")
Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/612041/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 65c2c5361e5fc..c3f35bee9b8d8 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -134,9 +134,13 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit,
 	OUT_PKT7(ring, CP_SET_PROTECTED_MODE, 1);
 	OUT_RING(ring, 1);
 
-	/* Enable local preemption for finegrain preemption */
+	/*
+	 * Disable local preemption by default because it requires
+	 * user-space to be aware of it and provide additional handling
+	 * to restore rendering state or do various flushes on switch.
+	 */
 	OUT_PKT7(ring, CP_PREEMPT_ENABLE_LOCAL, 1);
-	OUT_RING(ring, 0x1);
+	OUT_RING(ring, 0x0);
 
 	/* Allow CP_CONTEXT_SWITCH_YIELD packets in the IB2 */
 	OUT_PKT7(ring, CP_YIELD_ENABLE, 1);
-- 
2.43.0



