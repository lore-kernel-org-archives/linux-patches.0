Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10C31DE3A3;
	Tue,  8 Oct 2024 12:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391997; cv=none; b=WgdTkVQ7Gdy29pzlkSSiuOfjIZsHb1kpfGupUYn7cq4hDLSPRQqTtrNFEvv/nEXCqJ5jUgooiz8hSvIvim6iIB88kAsAqRHlWkMG1QkuISBzK13HqlmCIJojQDfbpZHY79ziCLO36PLmNnnotepMfuhsQDZlTo76/vOyO3G6X7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391997; c=relaxed/simple;
	bh=Q3LLSyuXM30Vm7bkolL7DyeKZJkNt15XKlxmTrfceAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot+JU3kxSuA0hxEpWnatsUPVcvzGeuhFgahE80dFFR2zQiYyOr+KFyqsxLAaom8RqIL1QmnbBybJCGFXWpp5obnirompWIkcAkOTWmncOvaptl1osUem+DH/ZCeZuMK32M3XCbQRrCPiuhprVNUot2tYtwzYQ4rT0SvPSNT8Ndw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHBv1qlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHBv1qlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EABC4CEC7;
	Tue,  8 Oct 2024 12:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391997;
	bh=Q3LLSyuXM30Vm7bkolL7DyeKZJkNt15XKlxmTrfceAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHBv1qlgsbDu0Tkcv5qc+I9CC1FsUCW2JI1rM9VoKgZ/aD8nFO49CG+tHWtAxb1yN
	 F6f9ltYLLinCVG2wrnRv1m47YmoqJbWfdHVoE0Oc/P5Q9EOpov1AGpm5T/D3mJLhxT
	 dbyZmvxFjMG+hNYnluXF5SNn7lU4fBWnQe8hPWJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 286/558] drm/amdgpu/gfx11: enter safe mode before touching CP_INT_CNTL
Date: Tue,  8 Oct 2024 14:05:16 +0200
Message-ID: <20241008115713.581032452@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit b5be054c585110b2c5c1b180136800e8c41c7bb4 ]

Need to enter safe mode before touching GC MMIO.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 61e62d846900c..228124b389541 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4707,6 +4707,8 @@ static int gfx_v11_0_soft_reset(void *handle)
 	int r, i, j, k;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	gfx_v11_0_set_safe_mode(adev, 0);
+
 	tmp = RREG32_SOC15(GC, 0, regCP_INT_CNTL);
 	tmp = REG_SET_FIELD(tmp, CP_INT_CNTL, CMP_BUSY_INT_ENABLE, 0);
 	tmp = REG_SET_FIELD(tmp, CP_INT_CNTL, CNTX_BUSY_INT_ENABLE, 0);
@@ -4714,8 +4716,6 @@ static int gfx_v11_0_soft_reset(void *handle)
 	tmp = REG_SET_FIELD(tmp, CP_INT_CNTL, GFX_IDLE_INT_ENABLE, 0);
 	WREG32_SOC15(GC, 0, regCP_INT_CNTL, tmp);
 
-	gfx_v11_0_set_safe_mode(adev, 0);
-
 	mutex_lock(&adev->srbm_mutex);
 	for (i = 0; i < adev->gfx.mec.num_mec; ++i) {
 		for (j = 0; j < adev->gfx.mec.num_queue_per_pipe; j++) {
-- 
2.43.0



