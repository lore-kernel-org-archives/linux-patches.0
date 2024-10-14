Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937FA19E7ED;
	Mon, 14 Oct 2024 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919168; cv=none; b=WXsHlXf44bhSfoCLTeD9PVXJH/4h+AIk41FFHiP9cY8ypyyDLHdvu0kOg1u+7ee1WtYD85hB+RP5bLeYc63w5V52W5F3ooWbSctMkNrnrzdE97AChv9XVHCpnVVNC/9Su4TQM7OMKdy7dM0iAvvwBV6MkTnZLu/6xUqNaEAbcmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919168; c=relaxed/simple;
	bh=u+IrxSwwa9HrTPccAoeVHwmjtVqmhHPkKTEoZwT59UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNxzuPw7yz17b6x2c3uqM/KLQ005vSSsQ9XziKAEaIVRD23a0/uAuay4ec8rBbxS0Q2tXlgHl7+PI33FzhLwTGavChsLcjVJ0PMODJDW97hmGVDTPi3U1pT99Ns3GsC+4HJXdwZeHFJib8sATG06DxBcZjmuIWpU1XNQJCt7cc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xtcm/KjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xtcm/KjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC67C4CECF;
	Mon, 14 Oct 2024 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919168;
	bh=u+IrxSwwa9HrTPccAoeVHwmjtVqmhHPkKTEoZwT59UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xtcm/KjDiP67MTlEHktoxLZZYkdNj4irDxXSEjTUU1WrFVoBChQ9tyTfSZGM1X8oc
	 xnxM+7b8sDroxNzRzh+ikLvoSHwhkobmSDG58+Dr1PZMLbXRbXvZRgQNksNJOoSSID
	 s5h8BZUsWHLdfmCyzGGszraZsOAzEuMC6IrFTek8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 500/798] drm/amdgpu: fix unchecked return value warning for amdgpu_gfx
Date: Mon, 14 Oct 2024 16:17:34 +0200
Message-ID: <20241014141237.620377546@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e9e0e7328c4e1..6b818c6c9a4c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -676,8 +676,11 @@ int amdgpu_gfx_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *r
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
@@ -758,7 +761,10 @@ uint32_t amdgpu_kiq_rreg(struct amdgpu_device *adev, uint32_t reg)
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
@@ -824,7 +830,10 @@ void amdgpu_kiq_wreg(struct amdgpu_device *adev, uint32_t reg, uint32_t v)
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
@@ -860,6 +869,7 @@ void amdgpu_kiq_wreg(struct amdgpu_device *adev, uint32_t reg, uint32_t v)
 
 failed_undo:
 	amdgpu_ring_undo(ring);
+failed_unlock:
 	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 failed_kiq_write:
 	dev_err(adev->dev, "failed to write reg:%x\n", reg);
-- 
2.43.0



