Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284C321171A;
	Thu, 12 Dec 2024 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016366; cv=none; b=OOXz6SolzDS9Z4dXZaukYlgcoPbYxs2gnrdFQQwvePe7qE1ayLmE0EuFD7doOnbB+Kmsvd7qgSBTJjFxtIKv/YvLoMCDpc4RrRLnLYDfWimpzdsFgpPcuMpsxdWiiEP4q3eP5QiC1ERr23XWSZSJNqEChwBSZR7eWtp3c8ISwZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016366; c=relaxed/simple;
	bh=Xtxd1bIXzK6ieS/uUKO37k9jUd1FkbwKUsseI0MgBXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hf+ohMZLoltLM6mcXo8iZJTvOCeFNPNVB8A6cE2TwtLzlD+bxbPhBXVXHzHvAvY4TKFFCbPcMrAtNrwwqiWD9uH2h9zwc9fwLte7CGG2u3ZDQIe5WBiBHxUtPzodujhqv1qPzqLKjzstDBL6+JCZ8bW5mcagXVeck+hiu22jevA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Swls72Da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Swls72Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8FFC4CEDE;
	Thu, 12 Dec 2024 15:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016366;
	bh=Xtxd1bIXzK6ieS/uUKO37k9jUd1FkbwKUsseI0MgBXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Swls72DafuWC0uP86nnLTWRXneBvxJgoqQ5AFMqQPex78kuY6xzNMtNiNAcUZ1DvJ
	 DsN44MeuljQAxj8GD6FzIN0KS3q0DxtAqoXUVbhuQ1RSp6htjS26jJhdZXk5VG+n+r
	 EA2nv38WBxS7bI/WOm4FwO9w+zU6Rr4exDYxw8o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Frank Min <frank.min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 178/466] drm/amdgpu/hdp4.0: do a posting read when flushing HDP
Date: Thu, 12 Dec 2024 15:55:47 +0100
Message-ID: <20241212144313.825768840@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c9b8dcabb52afe88413ff135a0953e3cc4128483 upstream.

Need to read back to make sure the write goes through.

Cc: David Belanger <david.belanger@amd.com>
Reviewed-by: Frank Min <frank.min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

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
@@ -54,11 +56,13 @@ static void hdp_v4_0_invalidate_hdp(stru
 	    amdgpu_ip_version(adev, HDP_HWIP, 0) == IP_VERSION(4, 4, 5))
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


