Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4B526CE33;
	Fri, 21 Nov 2025 13:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731173; cv=none; b=f7rp5IOMmsyiP+tGmDeCDwL4ZD4uHW5CaiQXW+81KqQEIQfIH943dCdqeSAB7WRvq7cdctJTDCDJm0L7vFxuWltIKVlX+o8MF6k2qJIvB9SX+v80NElbdmBfBuvfDReH9b2Lzw5CON3R3P4AIlXPolbPGx2TKoA2ZqBZrT59GT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731173; c=relaxed/simple;
	bh=nST0DxULIe3PgNbdgKaBFzXBF4O472J9TZDok5wIc2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH9Sfon+q5v7B3LFEJYjYB/5sA8uTzfVhbHAELIdEevPnIPiqfPtcCngmSzfVGvaLN2UXYRsnpU3ahk31KYOIfyiuYmbhi8nnqI8oYg7cY469HFBomMoLUEU8VKcuyAu7i9YXkwbdnNyDul0GQxKiruAZl2BbIk0HCBmXM9a0pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9lpFBm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9lpFBm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D164C4CEF1;
	Fri, 21 Nov 2025 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731172;
	bh=nST0DxULIe3PgNbdgKaBFzXBF4O472J9TZDok5wIc2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9lpFBm18oA1cAw8xzUN/vdyzsb5voRbZhwpElKCuJF9ZgU2zDnShRV+9DtaqRvDV
	 0CFAlLryacJdRqPRX4+Rvn+x/Z0hEELuQn+mDM0ZQQ7pNElrXQ0tA3vSw+naqz00pK
	 BDQjazyDlyrEH9of4fMaAJm/M/Nl1MEiibpkZ+r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Pratap Nirujogi <pratap.nirujogi@amd.com>,
	Sultan Alsawaf <sultan@kerneltoast.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 114/247] drm/amd/amdgpu: Ensure isp_kernel_buffer_alloc() creates a new BO
Date: Fri, 21 Nov 2025 14:11:01 +0100
Message-ID: <20251121130158.674031245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Sultan Alsawaf <sultan@kerneltoast.com>

[ Upstream commit 7132f7e025f9382157543dd86a62d161335b48b9 ]

When the BO pointer provided to amdgpu_bo_create_kernel() points to
non-NULL, amdgpu_bo_create_kernel() takes it as a hint to pin that address
rather than allocate a new BO.

This functionality is never desired for allocating ISP buffers. A new BO
should always be created when isp_kernel_buffer_alloc() is called, per the
description for isp_kernel_buffer_alloc().

Ensure this by zeroing *bo right before the amdgpu_bo_create_kernel() call.

Fixes: 55d42f616976 ("drm/amd/amdgpu: Add helper functions for isp buffers")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Pratap Nirujogi <pratap.nirujogi@amd.com>
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 73c8c29baac7f0c7e703d92eba009008cbb5228e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_isp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_isp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_isp.c
index 9cddbf50442a4..37270c4dab8dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_isp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_isp.c
@@ -280,6 +280,8 @@ int isp_kernel_buffer_alloc(struct device *dev, u64 size,
 	if (ret)
 		return ret;
 
+	/* Ensure *bo is NULL so a new BO will be created */
+	*bo = NULL;
 	ret = amdgpu_bo_create_kernel(adev,
 				      size,
 				      ISP_MC_ADDR_ALIGN,
-- 
2.51.0



