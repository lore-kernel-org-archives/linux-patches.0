Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AC71CF297;
	Tue,  8 Oct 2024 12:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390334; cv=none; b=lfbCslPXxYiPSAo7GGpQQNwXbbbKtJyaPglSsmruf5j/aAcfF91fUj/xfIFugBSNYvWGu9873TvsW5iHVx0O6s6LuVLTpNbcXcYwqv9HAD2RAU3+VcwimTPDzFSxw27PkvdWx6ySVkcPcNguYfh7sTz931X9EHTFvj+5LApQ3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390334; c=relaxed/simple;
	bh=AdKSgxKTJJqnJOYqyI5XyFMecYL5EWjcqotqD+U16EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgM5Mqf50bvwMNBRHyosl/MV9bDqNLf2dV8d2uVuQJdBSzf2/rPypCNGjwDHTfakq4EJJ4HXAKEHzBvAFZm3ehqBUVuKjAKYjuI93rSXvGEAXEQJm36tFv89kgSkd/I2jywUgmnOEG+fV8HfR/J3/PwIEZ8wEo1zIS0K/UF1WL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mw8sPoPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mw8sPoPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49C0C4CEC7;
	Tue,  8 Oct 2024 12:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390333;
	bh=AdKSgxKTJJqnJOYqyI5XyFMecYL5EWjcqotqD+U16EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mw8sPoPSG/n3CWZM0Lj1+mFgd/+yZfaMHsERehb6szuqes+YEBbSc6luCQhaLClKh
	 DPmilkMiIYZi2zHpUwLBupsOUMzxxwRnKyaNEbUdoj+TUSNYDiXn1IKelNd0w61BuH
	 fv2q+LwjV+1e3ehq1GxtMV6NJT22xwadn5kt9Vdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 226/482] drm/amdgpu: fix unchecked return value warning for amdgpu_gfx
Date: Tue,  8 Oct 2024 14:04:49 +0200
Message-ID: <20241008115657.200419994@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Tim Huang <tim.huang@amd.com>

[ Upstream commit c0277b9d7c2ee9ee5dbc948548984f0fbb861301 ]

This resolves the unchecded return value warning reported by Coverity.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index e92bdc9a39d35..1935b211b527d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -816,8 +816,11 @@ int amdgpu_gfx_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *r
 	int r;
 
 	if (amdgpu_ras_is_supported(adev, ras_block->block)) {
-		if (!amdgpu_persistent_edc_harvesting_supported(adev))
-			amdgpu_ras_reset_error_status(adev, AMDGPU_RAS_BLOCK__GFX);
+		if (!amdgpu_persistent_edc_harvesting_supported(adev)) {
+			r = amdgpu_ras_reset_error_status(adev, AMDGPU_RAS_BLOCK__GFX);
+			if (r)
+				return r;
+		}
 
 		r = amdgpu_ras_block_late_init(adev, ras_block);
 		if (r)
@@ -961,7 +964,10 @@ uint32_t amdgpu_kiq_rreg(struct amdgpu_device *adev, uint32_t reg, uint32_t xcc_
 		pr_err("critical bug! too many kiq readers\n");
 		goto failed_unlock;
 	}
-	amdgpu_ring_alloc(ring, 32);
+	r = amdgpu_ring_alloc(ring, 32);
+	if (r)
+		goto failed_unlock;
+
 	amdgpu_ring_emit_rreg(ring, reg, reg_val_offs);
 	r = amdgpu_fence_emit_polling(ring, &seq, MAX_KIQ_REG_WAIT);
 	if (r)
@@ -1027,7 +1033,10 @@ void amdgpu_kiq_wreg(struct amdgpu_device *adev, uint32_t reg, uint32_t v, uint3
 	}
 
 	spin_lock_irqsave(&kiq->ring_lock, flags);
-	amdgpu_ring_alloc(ring, 32);
+	r = amdgpu_ring_alloc(ring, 32);
+	if (r)
+		goto failed_unlock;
+
 	amdgpu_ring_emit_wreg(ring, reg, v);
 	r = amdgpu_fence_emit_polling(ring, &seq, MAX_KIQ_REG_WAIT);
 	if (r)
@@ -1063,6 +1072,7 @@ void amdgpu_kiq_wreg(struct amdgpu_device *adev, uint32_t reg, uint32_t v, uint3
 
 failed_undo:
 	amdgpu_ring_undo(ring);
+failed_unlock:
 	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 failed_kiq_write:
 	dev_err(adev->dev, "failed to write reg:%x\n", reg);
-- 
2.43.0



