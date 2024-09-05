Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B03195FCE;
	Thu,  5 Sep 2024 09:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529940; cv=none; b=fpipdqIN+DMqeBCV8gsyzgPyUPmEZMgOe2xFX/OqhkQL8xDrlo5Q88Uo2qFtaPX4erK6BUXDfG5u9lk+LHJE5SUyBO7L1Z+im09lvymRAYj4Nit1K2m/IxCuxdvG3OPzUhldIBYxN4GRNPhiIhOIlMLsSrF2qHawpzRHDJdVGpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529940; c=relaxed/simple;
	bh=UExJEgV3amwCAlHikPUbABjkkgVJEyqwk4+pzXNE084=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lor1oZ+DbweZ6JrcBWblprTxvtmrPxKMfpd1r6DGhH6YtkRH88CAY7F1q8UoxDJp2NcxTTUBpmIczQqEPWbLPkmK1sq4+eiL1rcFUmmLo9Q6XJhR0BEa5TxtCxdN03BEgWyP0ur0ZLj+wKyFYzs49dhUCL8nVN3E4NjdGl4jDSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxGMUBPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxGMUBPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D22C4CEC4;
	Thu,  5 Sep 2024 09:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529940;
	bh=UExJEgV3amwCAlHikPUbABjkkgVJEyqwk4+pzXNE084=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxGMUBPglGArN5OQfFlDb1YOJqHIO1NS3hzjnjTQv/HbNGdQpKMsSss9ovhdbtjtz
	 H5uRvEmGuAWU9RmVd3EKOHYZ90o7T0GkPNiirseMz8L5Xp3PrlyKqqHRuthZ+hjYk/
	 48Ph8eIYR7T7Xs99yVpAgW+v6//AtZIaRrSSuYeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 163/184] drm/amdgpu: add skip_hw_access checks for sriov
Date: Thu,  5 Sep 2024 11:41:16 +0200
Message-ID: <20240905093738.704423526@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunxiang Li <Yunxiang.Li@amd.com>

[ Upstream commit b3948ad1ac582f560e1f3aeaecf384619921c48d ]

Accessing registers via host is missing the check for skip_hw_access and
the lockdep check that comes with it.

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 923d51f16ec8..2359d1d60275 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -977,6 +977,9 @@ u32 amdgpu_virt_rlcg_reg_rw(struct amdgpu_device *adev, u32 offset, u32 v, u32 f
 		return 0;
 	}
 
+	if (amdgpu_device_skip_hw_access(adev))
+		return 0;
+
 	reg_access_ctrl = &adev->gfx.rlc.reg_access_ctrl[xcc_id];
 	scratch_reg0 = (void __iomem *)adev->rmmio + 4 * reg_access_ctrl->scratch_reg0;
 	scratch_reg1 = (void __iomem *)adev->rmmio + 4 * reg_access_ctrl->scratch_reg1;
@@ -1053,6 +1056,9 @@ void amdgpu_sriov_wreg(struct amdgpu_device *adev,
 {
 	u32 rlcg_flag;
 
+	if (amdgpu_device_skip_hw_access(adev))
+		return;
+
 	if (!amdgpu_sriov_runtime(adev) &&
 		amdgpu_virt_get_rlcg_reg_access_flag(adev, acc_flags, hwip, true, &rlcg_flag)) {
 		amdgpu_virt_rlcg_reg_rw(adev, offset, value, rlcg_flag, xcc_id);
@@ -1070,6 +1076,9 @@ u32 amdgpu_sriov_rreg(struct amdgpu_device *adev,
 {
 	u32 rlcg_flag;
 
+	if (amdgpu_device_skip_hw_access(adev))
+		return 0;
+
 	if (!amdgpu_sriov_runtime(adev) &&
 		amdgpu_virt_get_rlcg_reg_access_flag(adev, acc_flags, hwip, false, &rlcg_flag))
 		return amdgpu_virt_rlcg_reg_rw(adev, offset, 0, rlcg_flag, xcc_id);
-- 
2.43.0



