Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CE222A81D;
	Tue, 29 Apr 2025 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946476; cv=none; b=EqoPEZXXBj+Ye/504JjB5awOWkH2O1wvKMN8PMcme5G70Vhb3gO+ckJJgA8oyH46QbApp+JG5bMmlCPo5sTRFm6lH4JPU5pwDEE6Dc3zXr/OUJwhFYMKFYxWh4uOgrM79sFuCdRxNbAXcaJmJHKsgN5gk4rY+/rYb63o5q3zDRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946476; c=relaxed/simple;
	bh=pFbXAMN6Lih6wtjr5FYSLa234hn3n5w4yKeEpp6H4Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTx0gXlpZ42orO6G8HFxcQsbRI68abM72DP5drhRRwjLZeJezcbO+/WRJ3jJGM2EXHnp0eHJGHJhDvWVJbgz3ZorIZdtDTFrrRXHENahfR4QP7CBd5sqE1ompbIWYjDfyNSwMgUkguzHMIyrc+ma4ddu0oB+UwGSg9JaBsSN//k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laacbVJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laacbVJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CDDC4CEE3;
	Tue, 29 Apr 2025 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946476;
	bh=pFbXAMN6Lih6wtjr5FYSLa234hn3n5w4yKeEpp6H4Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laacbVJMGsgNFnCmlwWjL3JuEix9rFUzKF4iWF6i7Z2s7llweXQOp8x6GQekLpGCn
	 8if3K5v8qz9U6OpRv2+0bIw88hdDiy4JNuuabTzXroH5b3k6sM7cDVL+9EfugRb2SX
	 ZF0LZlP5VSE7ZFarWLnik5Q6DgXJmj3bdUNLwa1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 250/311] drm/amdkfd: sriov doesnt support per queue reset
Date: Tue, 29 Apr 2025 18:41:27 +0200
Message-ID: <20250429161131.266775693@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emily Deng <Emily.Deng@amd.com>

[ Upstream commit ba6d8f878d6180d4d0ed0574479fc1e232928184 ]

Disable per queue reset for sriov.

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Jonathan Kim <jonathan.kim@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index ceb9fb475ef13..62a9a9ccf9bb6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -2000,7 +2000,8 @@ static void kfd_topology_set_capabilities(struct kfd_topology_device *dev)
 			dev->node_props.capability |=
 				HSA_CAP_TRAP_DEBUG_PRECISE_MEMORY_OPERATIONS_SUPPORTED;
 
-		dev->node_props.capability |= HSA_CAP_PER_QUEUE_RESET_SUPPORTED;
+		if (!amdgpu_sriov_vf(dev->gpu->adev))
+			dev->node_props.capability |= HSA_CAP_PER_QUEUE_RESET_SUPPORTED;
 	} else {
 		dev->node_props.debug_prop |= HSA_DBG_WATCH_ADDR_MASK_LO_BIT_GFX10 |
 					HSA_DBG_WATCH_ADDR_MASK_HI_BIT;
-- 
2.39.5



