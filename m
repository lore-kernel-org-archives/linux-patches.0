Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB77A188A38;
	Tue, 10 Sep 2024 09:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961605; cv=none; b=jZu4mPsWIbz+txzYNC2C6luK/QI/i2liUZo4sZSDStMujiBX+8ITTG1DIKaJlxcHTz6wI2JHbdynXdagakObzGRxmXLoUx4tOqINJzgDvTZYSmgesKGqgjFL+ZQPG4FhffDTQZwTWMS7kZCs2p6ile7s2UTjJjn9Ffii3flgXQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961605; c=relaxed/simple;
	bh=OI1OxHDJYxPcEjhH14mCT0vJPpNivGkDR01jUBQijao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G80psdudeRDCOBeaKCwOElGGOgplHsQKmYHfNNLsHkSLlK2p6jmdnBpsEPTXRaQwVDJz6IYGSpISMkdzxuOpmdl3PgREQ6vEeye4CU+Sc1KxLeSx4RV9jTG8aRnwkdu+FbjFJZxeGy/TlyLNrWqjMkGyRghcpO7lPElqAL7nAyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iT/ir9mA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iT/ir9mA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560ADC4CEC3;
	Tue, 10 Sep 2024 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961605;
	bh=OI1OxHDJYxPcEjhH14mCT0vJPpNivGkDR01jUBQijao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iT/ir9mAXut2kXUwb19ubXqioDZynIzrveUe1PXwctPEQMHQqukKHLxaAG8/LkRt+
	 gnt93bQfCT1Xm//h2ejrsQMDNv8tMyJTzOAd3EdjL8bkvFOW8CXiXGEKpNNENt86uA
	 5ZyIhfxP7uwy2UI4L2ZEj/2rQjPvQbW42YG+sqfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 126/375] drm/amdgpu: add missing error handling in function amdgpu_gmc_flush_gpu_tlb_pasid
Date: Tue, 10 Sep 2024 11:28:43 +0200
Message-ID: <20240910092626.669846190@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Zhou <bob.zhou@amd.com>

[ Upstream commit 9ff2e14cf013fa887e269bdc5ea3cffacada8635 ]

Fix the unchecked return value warning reported by Coverity,
so add error handling.

Signed-off-by: Bob Zhou <bob.zhou@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 86b096ad0319..f4478f2d5305 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -720,7 +720,11 @@ int amdgpu_gmc_flush_gpu_tlb_pasid(struct amdgpu_device *adev, uint16_t pasid,
 			ndw += kiq->pmf->invalidate_tlbs_size;
 
 		spin_lock(&adev->gfx.kiq[inst].ring_lock);
-		amdgpu_ring_alloc(ring, ndw);
+		r = amdgpu_ring_alloc(ring, ndw);
+		if (r) {
+			spin_unlock(&adev->gfx.kiq[inst].ring_lock);
+			goto error_unlock_reset;
+		}
 		if (adev->gmc.flush_tlb_needs_extra_type_2)
 			kiq->pmf->kiq_invalidate_tlbs(ring, pasid, 2, all_hub);
 
-- 
2.43.0



