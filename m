Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1903315E8B;
	Mon, 30 Dec 2024 15:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573875; cv=none; b=e3kGrZQTHykKPfC2J9ryCZL185dsDMq+k/VI9pj7w3F0Zuz08aqM+1F5qcFg9OktZtcpsm7AQcSHgFCPpUzymyfzsMQoxpFMUXlPXKMKHulsaQQ5lAsFjrK7zen0yVb7c2ZuNOH++gTniYI/e3K5YaRDhgkgGpLv5b4M3UVdCBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573875; c=relaxed/simple;
	bh=Fbfd0eWkQqA+1tCfRdKCkff3a20LT46FnAZxqmp7ofU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tnmt3H2y8s0+CWLn0N/GIVdqGoA5lTz+9KqTKu8SLtkWUxN31lzYLlJZNv813HsoysGnLbV3gzl6Wabz+dJa1K6naSMoFHQmy84prqjYqd/HRKCBjiK7BuJUcdkxfznKFtqv8RcodLfLE1WoL6eQOW7h4TPrwNw/urUW1RzEqbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/E/4S72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/E/4S72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94787C4CED0;
	Mon, 30 Dec 2024 15:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573875;
	bh=Fbfd0eWkQqA+1tCfRdKCkff3a20LT46FnAZxqmp7ofU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/E/4S72bEPhAmcAzt2diM8bd+jMWidJ37UvTzXRA+e74Pi0idqsOi4G+j4xe/dTc
	 PIs2E3CyNj/H8fXNwb6AJZsW2lXx6Fu2izDi/YVsTBnKTfAlwSNK2ZsDjeGeK8+Dca
	 zJvGr8uJgCcyUjqT607dc9c8hkucwA/mJhWYb6K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Zhao <Victor.Zhao@amd.com>,
	Emily Deng <Emily.Deng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 58/86] drm/amd/amdgpu: allow use kiq to do hdp flush under sriov
Date: Mon, 30 Dec 2024 16:43:06 +0100
Message-ID: <20241230154213.923002562@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Zhao <Victor.Zhao@amd.com>

[ Upstream commit bf2bc61638033d118c9ef4ab1204295ba6694401 ]

when use cpu to do page table update under sriov runtime, since mmio
access is blocked, kiq has to be used to flush hdp.

change WREG32_NO_KIQ to WREG32 to allow kiq.

Signed-off-by: Victor Zhao <Victor.Zhao@amd.com>
Reviewed-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c9b8dcabb52a ("drm/amdgpu/hdp4.0: do a posting read when flushing HDP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c b/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c
index 71d1a2e3bac9..bbc6806d0f2b 100644
--- a/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c
@@ -41,7 +41,7 @@ static void hdp_v4_0_flush_hdp(struct amdgpu_device *adev,
 				struct amdgpu_ring *ring)
 {
 	if (!ring || !ring->funcs->emit_wreg)
-		WREG32_NO_KIQ((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
+		WREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
 	else
 		amdgpu_ring_emit_wreg(ring, (adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c b/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
index a9ea23fa0def..ed7facacf2fe 100644
--- a/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
@@ -32,7 +32,7 @@ static void hdp_v5_0_flush_hdp(struct amdgpu_device *adev,
 				struct amdgpu_ring *ring)
 {
 	if (!ring || !ring->funcs->emit_wreg)
-		WREG32_NO_KIQ((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
+		WREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
 	else
 		amdgpu_ring_emit_wreg(ring, (adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c b/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
index 063eba619f2f..53ad93f96cd9 100644
--- a/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
@@ -32,7 +32,7 @@ static void hdp_v6_0_flush_hdp(struct amdgpu_device *adev,
 				struct amdgpu_ring *ring)
 {
 	if (!ring || !ring->funcs->emit_wreg)
-		WREG32_NO_KIQ((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
+		WREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
 	else
 		amdgpu_ring_emit_wreg(ring, (adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
 }
-- 
2.39.5



