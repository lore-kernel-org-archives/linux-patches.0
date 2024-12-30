Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FB815E8B;
	Mon, 30 Dec 2024 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573878; cv=none; b=FX+jZKVbVfqewwAHqaTozwVvRNtsviQev7Pf+3Vpe4Dy5FGkCEE1CrtNOHgyuXWjt3yA7Uda8vkWW1tnBT2tvF2miRFGHve33RrOHXMxgt/Gik6/CAPVA6rEc2hinkw9CVf38L0G8mAAEi0VA70G3mUL1eLl0zyvCAvlw8uBaX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573878; c=relaxed/simple;
	bh=cR1Cu08x5fmidnx2ymX7qr1Xr0xxK3yx5ihNpFHkLu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E04ZKVTJ7f2tPsE5homA48rfOZyQplfJyhhNGhbhUVJfJqazc2DYlnNBDaRFUq7yBk3ITXCSd7RCHRfGdzkz9dLOCUgeMc7r0kkbRnpaVpmHJ9KiL5cFv+8o6LgFqxP6I6prGnvkBUeqwi4z7LoJqmds7iz0J14bOFSPfDIiNmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFnf/ESq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFnf/ESq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFBFC4CED0;
	Mon, 30 Dec 2024 15:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573878;
	bh=cR1Cu08x5fmidnx2ymX7qr1Xr0xxK3yx5ihNpFHkLu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFnf/ESqvIFOlSnpCfQrKtj5LJt3lGicWqWXUCgCRduwfmcT0/xlFxAfuRvFIF3gK
	 RHm2jxKPKB45XpULDMepgEEmT9cZRS1Ib6qxnk58Am514IJgKTQH18GmM5JZhJ/lgV
	 cST/Zzuw8HiaZHz+Nog8d68vGZPPhsr1ZDONrvdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 59/86] drm/amdgpu/hdp4.0: do a posting read when flushing HDP
Date: Mon, 30 Dec 2024 16:43:07 +0100
Message-ID: <20241230154213.964009022@linuxfoundation.org>
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

[ Upstream commit c9b8dcabb52afe88413ff135a0953e3cc4128483 ]

Need to read back to make sure the write goes through.

Cc: David Belanger <david.belanger@amd.com>
Reviewed-by: Frank Min <frank.min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c b/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c
index bbc6806d0f2b..30210613dc5c 100644
--- a/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c
@@ -40,10 +40,12 @@
 static void hdp_v4_0_flush_hdp(struct amdgpu_device *adev,
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
 
 static void hdp_v4_0_invalidate_hdp(struct amdgpu_device *adev,
@@ -53,11 +55,13 @@ static void hdp_v4_0_invalidate_hdp(struct amdgpu_device *adev,
 	    adev->ip_versions[HDP_HWIP][0] == IP_VERSION(4, 4, 2))
 		return;
 
-	if (!ring || !ring->funcs->emit_wreg)
+	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32_SOC15_NO_KIQ(HDP, 0, mmHDP_READ_CACHE_INVALIDATE, 1);
-	else
+		RREG32_SOC15_NO_KIQ(HDP, 0, mmHDP_READ_CACHE_INVALIDATE);
+	} else {
 		amdgpu_ring_emit_wreg(ring, SOC15_REG_OFFSET(
 			HDP, 0, mmHDP_READ_CACHE_INVALIDATE), 1);
+	}
 }
 
 static void hdp_v4_0_query_ras_error_count(struct amdgpu_device *adev,
-- 
2.39.5



