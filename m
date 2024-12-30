Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DCB15E8B;
	Mon, 30 Dec 2024 15:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573993; cv=none; b=cj0NRfYM6cJgNQ064dZWj7OWB/CAvWA5d1cGwNkuERpYBsBk2qiMlfA4v2rDeVJ+hJr3YvjTtLWs7fTzDCizVirDTTeLpR3aoCmh7dX24HCBi4zJCKet3YjXeRhoT3rt5OTmrUK7fwGa0x6vy9J6zKsw+5qTMLVKwoC190H7SOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573993; c=relaxed/simple;
	bh=P+MemgDaT1nbVI3U9l+ljanGgdjkg3E8nGC3LnjmeXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHufEYRv82Nphlv5+WmOnAD03laj5dqvz8wk8lmTH8MRfGxVABPC1d/cKE5CmPuG1CcIfp0ztzd02ed51X8FAVzDmMf5Lg6oW7vKQ3AzfutWuxIkCQt1weItkThA0fBBw9rw3Kwtk+56yf00E4j3ol7ISl0NOsO/Hn+/3Io4uQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gggt/QZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gggt/QZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3E3C4CED0;
	Mon, 30 Dec 2024 15:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573992;
	bh=P+MemgDaT1nbVI3U9l+ljanGgdjkg3E8nGC3LnjmeXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gggt/QZS+eiwMAqhri7DyzicwbAZ4GpqxuZIeOMmVuHdEqcw76opZu4/4baIKeK6H
	 e8xOuEN7rsjDMctlnOPXsosIOMCSX/MEWS2UlQ3AM01mzAfJk9F+zGXjyrkY0MSByN
	 0gDKYrXGalU9Y3RJP5tJQMFPu9oIMVpEFAd7Yig8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 60/86] drm/amdgpu/hdp5.0: do a posting read when flushing HDP
Date: Mon, 30 Dec 2024 16:43:08 +0100
Message-ID: <20241230154214.001029960@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit cf424020e040be35df05b682b546b255e74a420f ]

Need to read back to make sure the write goes through.

Cc: David Belanger <david.belanger@amd.com>
Reviewed-by: Frank Min <frank.min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c b/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
index ed7facacf2fe..d3962d469088 100644
--- a/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
@@ -31,10 +31,12 @@
 static void hdp_v5_0_flush_hdp(struct amdgpu_device *adev,
 				struct amdgpu_ring *ring)
 {
-	if (!ring || !ring->funcs->emit_wreg)
+	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
-	else
+		RREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2);
+	} else {
 		amdgpu_ring_emit_wreg(ring, (adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
+	}
 }
 
 static void hdp_v5_0_invalidate_hdp(struct amdgpu_device *adev,
@@ -42,6 +44,7 @@ static void hdp_v5_0_invalidate_hdp(struct amdgpu_device *adev,
 {
 	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32_SOC15_NO_KIQ(HDP, 0, mmHDP_READ_CACHE_INVALIDATE, 1);
+		RREG32_SOC15_NO_KIQ(HDP, 0, mmHDP_READ_CACHE_INVALIDATE);
 	} else {
 		amdgpu_ring_emit_wreg(ring, SOC15_REG_OFFSET(
 					HDP, 0, mmHDP_READ_CACHE_INVALIDATE), 1);
-- 
2.39.5



