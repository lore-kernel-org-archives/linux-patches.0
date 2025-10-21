Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66BF26E6F5;
	Tue, 21 Oct 2025 20:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077434; cv=none; b=lf916MdjwkPIsayBxwyPB9WLZADn8/DCimzQgTVY4oolLy+srJPgP8pZaBRuajfXwkUEbmehTa+eA0rkOMGN3+lTZQbL6yf0bFHUknFG1O1ftJLMwlxtLdv0tqW8BCYhS81z+Crr5V284wbYP3YHqYoeBJ3PGo3yPfv3tFdDlE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077434; c=relaxed/simple;
	bh=4p+VQtd6js3WcfhYbhn4S/e2OHJcfsT2YMmtS0oMwjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMUl0hTrO7xNaz90yh45YUYo7QyLclxXuQHg4a+SXsXku+v2e6zfR2bIRXDiJkgxWQwIwxTzf/eMYRzHzdODsehC2Sg7CgQiICT4+sp+3xDf/GtBS4i2bvWjwz6uc5firFyS/nZ7D2RRruWhcVkLTs46Zw+ZH84ClgQyDrHqMjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYxILfUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYxILfUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A20C4CEF1;
	Tue, 21 Oct 2025 20:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077434;
	bh=4p+VQtd6js3WcfhYbhn4S/e2OHJcfsT2YMmtS0oMwjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYxILfUpXEwzIwPTUbYf69DdKdUeK3WGAg8CC82bvmIw9Judv2novXbVbHV/GULzC
	 +Lod8vnlq1ECqV7h5nQq8BxvUkMhcURSUAuYBAjr2KuqFYpCgOAwuGrdFu5GVjyqxB
	 KXQwiKIARlS1TdWA7CQ0CXc4i2wb/sZ22qWygDnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 105/159] drm/amdgpu: add ip offset support for cyan skillfish
Date: Tue, 21 Oct 2025 21:51:22 +0200
Message-ID: <20251021195045.704161275@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit e8529dbc75cab56fc3c57830d0fd48cbd8911e6c ]

For chips that don't have IP discovery tables.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 357d90be2c7a ("drm/amdgpu: fix handling of harvesting for ip_discovery firmware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/Makefile           |  3 +-
 .../drm/amd/amdgpu/cyan_skillfish_reg_init.c  | 56 +++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/nv.h               |  1 +
 3 files changed, 59 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/amd/amdgpu/cyan_skillfish_reg_init.c

diff --git a/drivers/gpu/drm/amd/amdgpu/Makefile b/drivers/gpu/drm/amd/amdgpu/Makefile
index 930de203d533c..2d0fea87af79f 100644
--- a/drivers/gpu/drm/amd/amdgpu/Makefile
+++ b/drivers/gpu/drm/amd/amdgpu/Makefile
@@ -84,7 +84,8 @@ amdgpu-y += \
 	vega20_reg_init.o nbio_v7_4.o nbio_v2_3.o nv.o arct_reg_init.o mxgpu_nv.o \
 	nbio_v7_2.o hdp_v4_0.o hdp_v5_0.o aldebaran_reg_init.o aldebaran.o soc21.o soc24.o \
 	sienna_cichlid.o smu_v13_0_10.o nbio_v4_3.o hdp_v6_0.o nbio_v7_7.o hdp_v5_2.o lsdma_v6_0.o \
-	nbio_v7_9.o aqua_vanjaram.o nbio_v7_11.o lsdma_v7_0.o hdp_v7_0.o nbif_v6_3_1.o
+	nbio_v7_9.o aqua_vanjaram.o nbio_v7_11.o lsdma_v7_0.o hdp_v7_0.o nbif_v6_3_1.o \
+	cyan_skillfish_reg_init.o
 
 # add DF block
 amdgpu-y += \
diff --git a/drivers/gpu/drm/amd/amdgpu/cyan_skillfish_reg_init.c b/drivers/gpu/drm/amd/amdgpu/cyan_skillfish_reg_init.c
new file mode 100644
index 0000000000000..96616a865aac7
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdgpu/cyan_skillfish_reg_init.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2018 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ */
+#include "amdgpu.h"
+#include "nv.h"
+
+#include "soc15_common.h"
+#include "soc15_hw_ip.h"
+#include "cyan_skillfish_ip_offset.h"
+
+int cyan_skillfish_reg_base_init(struct amdgpu_device *adev)
+{
+	/* HW has more IP blocks,  only initialized the blocke needed by driver */
+	uint32_t i;
+
+	adev->gfx.xcc_mask = 1;
+	for (i = 0 ; i < MAX_INSTANCE ; ++i) {
+		adev->reg_offset[GC_HWIP][i] = (uint32_t *)(&(GC_BASE.instance[i]));
+		adev->reg_offset[HDP_HWIP][i] = (uint32_t *)(&(HDP_BASE.instance[i]));
+		adev->reg_offset[MMHUB_HWIP][i] = (uint32_t *)(&(MMHUB_BASE.instance[i]));
+		adev->reg_offset[ATHUB_HWIP][i] = (uint32_t *)(&(ATHUB_BASE.instance[i]));
+		adev->reg_offset[NBIO_HWIP][i] = (uint32_t *)(&(NBIO_BASE.instance[i]));
+		adev->reg_offset[MP0_HWIP][i] = (uint32_t *)(&(MP0_BASE.instance[i]));
+		adev->reg_offset[MP1_HWIP][i] = (uint32_t *)(&(MP1_BASE.instance[i]));
+		adev->reg_offset[VCN_HWIP][i] = (uint32_t *)(&(UVD0_BASE.instance[i]));
+		adev->reg_offset[DF_HWIP][i] = (uint32_t *)(&(DF_BASE.instance[i]));
+		adev->reg_offset[DCE_HWIP][i] = (uint32_t *)(&(DMU_BASE.instance[i]));
+		adev->reg_offset[OSSSYS_HWIP][i] = (uint32_t *)(&(OSSSYS_BASE.instance[i]));
+		adev->reg_offset[SDMA0_HWIP][i] = (uint32_t *)(&(GC_BASE.instance[i]));
+		adev->reg_offset[SDMA1_HWIP][i] = (uint32_t *)(&(GC_BASE.instance[i]));
+		adev->reg_offset[SMUIO_HWIP][i] = (uint32_t *)(&(SMUIO_BASE.instance[i]));
+		adev->reg_offset[THM_HWIP][i] = (uint32_t *)(&(THM_BASE.instance[i]));
+		adev->reg_offset[CLK_HWIP][i] = (uint32_t *)(&(CLK_BASE.instance[i]));
+	}
+	return 0;
+}
diff --git a/drivers/gpu/drm/amd/amdgpu/nv.h b/drivers/gpu/drm/amd/amdgpu/nv.h
index 83e9782aef39d..8f4817404f10d 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.h
+++ b/drivers/gpu/drm/amd/amdgpu/nv.h
@@ -31,5 +31,6 @@ extern const struct amdgpu_ip_block_version nv_common_ip_block;
 void nv_grbm_select(struct amdgpu_device *adev,
 		    u32 me, u32 pipe, u32 queue, u32 vmid);
 void nv_set_virt_ops(struct amdgpu_device *adev);
+int cyan_skillfish_reg_base_init(struct amdgpu_device *adev);
 
 #endif
-- 
2.51.0



