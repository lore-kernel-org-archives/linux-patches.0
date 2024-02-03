Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE67171A4;
	Sat,  3 Feb 2024 04:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933904; cv=none; b=qx7uQEhv4LiRNyVvYw3MIkewjXTafa8lbM39m4L/4RACAtvgWiKfwIhhhn38yf06B6lLrPjzlVfL8cJKeC1gstAbLQIgkA/cdVpCOhlDBtWDVP1pnHq0XAbr6FMITPQJVANwLtQ8TC/R+RMW5qsFFMGK0+lTOnpuwhpQIi/0CxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933904; c=relaxed/simple;
	bh=lAwX/te4T7DI0QpDimUsmGuOYVvIIUE3E+byIMfRWJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4ZajqxZcqEiUbYiNNG/NcagMX01RehACjOZ3WlWHPN9ZEKbjZJ1B08EXFT8TkQarGQHqeKZhw40I9bEfFeqrQ1qIA6Oly0i8eTIqM5qCflUurGUNUgQegzmh1t88e95O/4fEPPr6lV9q3oEnRP5hhKyPHSL9/5Uuy5h/JRqjfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qprwu3+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qprwu3+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EA5C43394;
	Sat,  3 Feb 2024 04:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933904;
	bh=lAwX/te4T7DI0QpDimUsmGuOYVvIIUE3E+byIMfRWJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qprwu3+lj2U2PLs1YFeJbBrlFF3B+r9w9BGXn6JklZX1vRIdIQM51TzDRNtOhGgPT
	 QGMeguK/mGvGZ0mMAYNju8psEewszWjZ/+agiGY56Cawn6IuDchAb2UhEFRClsHEku
	 ERjz2OZQZo9wyYFAxAPWfgSeT2LbbjcTtjuLfTY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 226/353] drm/amdgpu: Fix ecc irq enable/disable unpaired
Date: Fri,  2 Feb 2024 20:05:44 -0800
Message-ID: <20240203035410.820392778@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley.Yang <Stanley.Yang@amd.com>

[ Upstream commit a32c6f7f5737cc7e31cd7ad5133f0d96fca12ea6 ]

The ecc_irq is disabled while GPU mode2 reset suspending process,
but not be enabled during GPU mode2 reset resume process.

Changed from V1:
	only do sdma/gfx ras_late_init in aldebaran_mode2_restore_ip
	delete amdgpu_ras_late_resume function

Changed from V2:
	check umc ras supported before put ecc_irq

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aldebaran.c | 26 +++++++++++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c |  4 ++++
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c |  5 +++++
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c  |  4 ++++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aldebaran.c b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
index 02f4c6f9d4f6..576067d66bb9 100644
--- a/drivers/gpu/drm/amd/amdgpu/aldebaran.c
+++ b/drivers/gpu/drm/amd/amdgpu/aldebaran.c
@@ -330,6 +330,7 @@ aldebaran_mode2_restore_hwcontext(struct amdgpu_reset_control *reset_ctl,
 {
 	struct list_head *reset_device_list = reset_context->reset_device_list;
 	struct amdgpu_device *tmp_adev = NULL;
+	struct amdgpu_ras *con;
 	int r;
 
 	if (reset_device_list == NULL)
@@ -355,7 +356,30 @@ aldebaran_mode2_restore_hwcontext(struct amdgpu_reset_control *reset_ctl,
 		 */
 		amdgpu_register_gpu_instance(tmp_adev);
 
-		/* Resume RAS */
+		/* Resume RAS, ecc_irq */
+		con = amdgpu_ras_get_context(tmp_adev);
+		if (!amdgpu_sriov_vf(tmp_adev) && con) {
+			if (tmp_adev->sdma.ras &&
+				tmp_adev->sdma.ras->ras_block.ras_late_init) {
+				r = tmp_adev->sdma.ras->ras_block.ras_late_init(tmp_adev,
+						&tmp_adev->sdma.ras->ras_block.ras_comm);
+				if (r) {
+					dev_err(tmp_adev->dev, "SDMA failed to execute ras_late_init! ret:%d\n", r);
+					goto end;
+				}
+			}
+
+			if (tmp_adev->gfx.ras &&
+				tmp_adev->gfx.ras->ras_block.ras_late_init) {
+				r = tmp_adev->gfx.ras->ras_block.ras_late_init(tmp_adev,
+						&tmp_adev->gfx.ras->ras_block.ras_comm);
+				if (r) {
+					dev_err(tmp_adev->dev, "GFX failed to execute ras_late_init! ret:%d\n", r);
+					goto end;
+				}
+			}
+		}
+
 		amdgpu_ras_resume(tmp_adev);
 
 		/* Update PSP FW topology after reset */
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
index a5a05c16c10d..6c5185608854 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -1041,6 +1041,10 @@ static int gmc_v10_0_hw_fini(void *handle)
 
 	amdgpu_irq_put(adev, &adev->gmc.vm_fault, 0);
 
+	if (adev->gmc.ecc_irq.funcs &&
+		amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__UMC))
+		amdgpu_irq_put(adev, &adev->gmc.ecc_irq, 0);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
index 23d7b548d13f..c9c653cfc765 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
@@ -941,6 +941,11 @@ static int gmc_v11_0_hw_fini(void *handle)
 	}
 
 	amdgpu_irq_put(adev, &adev->gmc.vm_fault, 0);
+
+	if (adev->gmc.ecc_irq.funcs &&
+		amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__UMC))
+		amdgpu_irq_put(adev, &adev->gmc.ecc_irq, 0);
+
 	gmc_v11_0_gart_disable(adev);
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 77e625f24cd0..776acdfc7209 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -2381,6 +2381,10 @@ static int gmc_v9_0_hw_fini(void *handle)
 
 	amdgpu_irq_put(adev, &adev->gmc.vm_fault, 0);
 
+	if (adev->gmc.ecc_irq.funcs &&
+		amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__UMC))
+		amdgpu_irq_put(adev, &adev->gmc.ecc_irq, 0);
+
 	return 0;
 }
 
-- 
2.43.0



