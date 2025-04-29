Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B0F215F7C;
	Tue, 29 Apr 2025 17:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948173; cv=none; b=ILXQH4DrD4rTLXqlcobNULRB1eid0Fe8N6lipRSy/5itVay+Ze7XfuWbA/kBKvHcbVTbE+QWId9ugEq0yO3/2bKAVhkE6M/m6C4aDmDAKNzQM4aTXDl2QZ2cK4j7hzDbhF5ZA82SNCVGeT77wZ/mS1IcbNY1XNJjqKI34RCnOQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948173; c=relaxed/simple;
	bh=ylNYhxJ1LFyr4vNRyVAvxauB+gscZt9C+HNMBp99YuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ledALRMwaI2I5H42xbQyHAZV1oq6t0RZYtwT6EMglOSL5EY7YNBI2SYtdoS1nEj6kCJJY4mwMVIBl/of/+STL99sQlzaMkP4ATjIZmNljVPFC4wYb4Gk+Jnt2McACyZZw82UsmGY//8vaY6u85W4tPusDTsKjUCMPkQsgLR+kLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+ncl1kc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+ncl1kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D809C4CEE3;
	Tue, 29 Apr 2025 17:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948172;
	bh=ylNYhxJ1LFyr4vNRyVAvxauB+gscZt9C+HNMBp99YuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+ncl1kcTlUDAE5DHgC7kKqDRSs+y1wJs7ciR5agYPq3nMf/PRCICas1ZiMJc55Gp
	 LtnQ5xmth4hpcjG+FVL3cseO1IAAXHI2kt48fJkOYVBsboia88Iuy8bEB+XhdUuk0F
	 JtLBqe8XTmlrtmANtifRwUHJ6orXiJg+LAD90Hy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/280] drm/amdgpu: Increase KIQ invalidate_tlbs timeout
Date: Tue, 29 Apr 2025 18:42:31 +0200
Message-ID: <20250429161123.719790423@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Cornwall <jay.cornwall@amd.com>

[ Upstream commit 3666ed821832f42baaf25f362680dda603cde732 ]

KIQ invalidate_tlbs request has been seen to marginally exceed the
configured 100 ms timeout on systems under load.

All other KIQ requests in the driver use a 10 second timeout. Use a
similar timeout implementation on the invalidate_tlbs path.

v2: Poll once before msleep
v3: Fix return value

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Cc: Kent Russell <kent.russell@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h     |  1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 19 ++++++++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 9b1e0ede05a45..b7aad43d9ad07 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -350,7 +350,6 @@ enum amdgpu_kiq_irq {
 	AMDGPU_CP_KIQ_IRQ_DRIVER0 = 0,
 	AMDGPU_CP_KIQ_IRQ_LAST
 };
-#define SRIOV_USEC_TIMEOUT  1200000 /* wait 12 * 100ms for SRIOV */
 #define MAX_KIQ_REG_WAIT       5000 /* in usecs, 5ms */
 #define MAX_KIQ_REG_BAILOUT_INTERVAL   5 /* in msecs, 5ms */
 #define MAX_KIQ_REG_TRY 1000
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 17a19d49d30a5..9d130d3af0b39 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -678,12 +678,10 @@ int amdgpu_gmc_flush_gpu_tlb_pasid(struct amdgpu_device *adev, uint16_t pasid,
 				   uint32_t flush_type, bool all_hub,
 				   uint32_t inst)
 {
-	u32 usec_timeout = amdgpu_sriov_vf(adev) ? SRIOV_USEC_TIMEOUT :
-		adev->usec_timeout;
 	struct amdgpu_ring *ring = &adev->gfx.kiq[inst].ring;
 	struct amdgpu_kiq *kiq = &adev->gfx.kiq[inst];
 	unsigned int ndw;
-	int r;
+	int r, cnt = 0;
 	uint32_t seq;
 
 	/*
@@ -740,10 +738,21 @@ int amdgpu_gmc_flush_gpu_tlb_pasid(struct amdgpu_device *adev, uint16_t pasid,
 
 		amdgpu_ring_commit(ring);
 		spin_unlock(&adev->gfx.kiq[inst].ring_lock);
-		if (amdgpu_fence_wait_polling(ring, seq, usec_timeout) < 1) {
+
+		r = amdgpu_fence_wait_polling(ring, seq, MAX_KIQ_REG_WAIT);
+
+		might_sleep();
+		while (r < 1 && cnt++ < MAX_KIQ_REG_TRY &&
+		       !amdgpu_reset_pending(adev->reset_domain)) {
+			msleep(MAX_KIQ_REG_BAILOUT_INTERVAL);
+			r = amdgpu_fence_wait_polling(ring, seq, MAX_KIQ_REG_WAIT);
+		}
+
+		if (cnt > MAX_KIQ_REG_TRY) {
 			dev_err(adev->dev, "timeout waiting for kiq fence\n");
 			r = -ETIME;
-		}
+		} else
+			r = 0;
 	}
 
 error_unlock_reset:
-- 
2.39.5



