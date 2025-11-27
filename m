Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01441334373;
	Thu, 27 Nov 2025 15:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255921; cv=none; b=t0Eb5ivGUmAinpyB+y8s3cu+zkc8eKF4rI4w6pHhJFk5Q9dcVhkdApRVnymJrNjvLfNmQtexrdhlop9B+DDVT4nnJpezlM01MVHbgdgyVnBTylPR5ZV6w75RnoAwGkZYeLRmfzVSHU0f7S/sr0b5XJdMxXKM6iPpd9rlOSdCpDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255921; c=relaxed/simple;
	bh=nc7h5IZAbmn1JM6v4rX68l8as2encXfWRd/14QlXIyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnBZBHFv3i37hodMPlZu9CgW5P2aU2yztBbXzG03ITDY/WoKd8xOhhfby0ld/Ml1SGPceGALxqxg5y930X9A4CFoQLrSPk2R2DYSaymt797azSHvZ4w+XVonWpQ0DvO6zMDsEvUVhwvhnb24Ol4x/wKCLtUJZP0Gc9SCMdxn5g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9bnn8kZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9bnn8kZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FB6C113D0;
	Thu, 27 Nov 2025 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255920;
	bh=nc7h5IZAbmn1JM6v4rX68l8as2encXfWRd/14QlXIyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9bnn8kZAOy2I7gCuKKYAQH4v7af++bsUMebr+sdKceXTM8MPtSWfyBKO3emLgF9L
	 Xir1s7wUdyttzJrK21L8BLz+yy4j8xlB+Lzw40dFkOt47O4bWfnPeyh6V3NrTSvjnA
	 ViC38hcJv/mk/HsAGvdrLJfJprJ3kzWYohFdE20U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Zhang <guoqing.zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 160/175] drm/amdgpu: fix gpu page fault after hibernation on PF passthrough
Date: Thu, 27 Nov 2025 15:46:53 +0100
Message-ID: <20251127144048.795863120@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Zhang <guoqing.zhang@amd.com>

[ Upstream commit eb6e7f520d6efa4d4ebf1671455abe4a681f7a05 ]

On PF passthrough environment, after hibernate and then resume, coralgemm
will cause gpu page fault.

Mode1 reset happens during hibernate, but partition mode is not restored
on resume, register mmCP_HYP_XCP_CTL and mmCP_PSP_XCP_CTL is not right
after resume. When CP access the MQD BO, wrong stride size is used,
this will cause out of bound access on the MQD BO, resulting page fault.

The fix is to ensure gfx_v9_4_3_switch_compute_partition() is called
when resume from a hibernation.
KFD resume is called separately during a reset recovery or resume from
suspend sequence. Hence it's not required to be called as part of
partition switch.

Signed-off-by: Samuel Zhang <guoqing.zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5d1b32cfe4a676fe552416cb5ae847b215463a1a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c | 3 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c    | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index 811124ff88a88..f9e2edf5260bc 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -407,7 +407,8 @@ static int aqua_vanjaram_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr,
 		return -EINVAL;
 	}
 
-	if (adev->kfd.init_complete && !amdgpu_in_reset(adev))
+	if (adev->kfd.init_complete && !amdgpu_in_reset(adev) &&
+		!adev->in_suspend)
 		flags |= AMDGPU_XCP_OPS_KFD;
 
 	if (flags & AMDGPU_XCP_OPS_KFD) {
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index f06bc94cf6e14..9ee7d25bb06cf 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -2292,7 +2292,9 @@ static int gfx_v9_4_3_cp_resume(struct amdgpu_device *adev)
 		r = amdgpu_xcp_init(adev->xcp_mgr, num_xcp, mode);
 
 	} else {
-		if (amdgpu_xcp_query_partition_mode(adev->xcp_mgr,
+		if (adev->in_suspend)
+			amdgpu_xcp_restore_partition_mode(adev->xcp_mgr);
+		else if (amdgpu_xcp_query_partition_mode(adev->xcp_mgr,
 						    AMDGPU_XCP_FL_NONE) ==
 		    AMDGPU_UNKNOWN_COMPUTE_PARTITION_MODE)
 			r = amdgpu_xcp_switch_partition_mode(
-- 
2.51.0



