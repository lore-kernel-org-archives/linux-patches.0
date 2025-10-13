Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09A423C4F3;
	Mon, 13 Oct 2025 15:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369530; cv=none; b=R+UQycuHIbTvWeBNZyMH2FSoTCJFBhgAku0kUB982yhj8qMWPBiY7K2aBra3pZ6xGVd99jaTNlyf3drZHW1KQelwdZi0tVezt1SxjoSHvLEFDufNmjls3sbHZXkkZ4/raWQofrbMIV+7rMqvJm5+n/pzvEajG07DR6mid/FjReI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369530; c=relaxed/simple;
	bh=BYH1/wkh6GiEctS72aOT1Oil2COr/L8Xhme6JHuIP+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZST3oR5qHTfB+WFJ9H9fJR99mMbX8e4WAyAzkveMn5XzoAsZXcdWlzZzGGRtxi6LhGvlE0L3Abn4oBG/oMBD44/mOI+/v692dRur/OpSNezzsDaxphhCs6ueAUCMMtYWBGOEXK/rexbwkBoijhIMIPhyKy3ICPYtOGUhu1uyv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/83aJEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/83aJEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2628C4CEE7;
	Mon, 13 Oct 2025 15:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369529;
	bh=BYH1/wkh6GiEctS72aOT1Oil2COr/L8Xhme6JHuIP+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/83aJEiCVPHOPr5RbMdTXzO3RpO3d6DkmpT5pEfLdM6ZPDz1OEvp9u5hviRZe5B/
	 1DwZcUWrQnHgPP23VaFwGkjYN8GJn7UK871x1YQbP1yEOw4iXUuFWriPoOG+C3DltM
	 qcVxuianskPlv+8S8c/fcQGfbYxHWPNJPuF7sffA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 279/563] drm/amdgpu/vcn: Add regdump helper functions
Date: Mon, 13 Oct 2025 16:42:20 +0200
Message-ID: <20251013144421.378646664@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

[ Upstream commit de55cbff5ce93c316b0113535752e43079761f2c ]

Add generic helper functions for vcn devcoredump support
which can be re-used for all vcn versions.

Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 9c0442286f84 ("drm/amdgpu: Check vcn state before profile switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c | 87 +++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h |  8 +++
 2 files changed, 95 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
index f1f67521c29ca..b497a67141384 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -92,6 +92,7 @@ MODULE_FIRMWARE(FIRMWARE_VCN5_0_0);
 MODULE_FIRMWARE(FIRMWARE_VCN5_0_1);
 
 static void amdgpu_vcn_idle_work_handler(struct work_struct *work);
+static void amdgpu_vcn_reg_dump_fini(struct amdgpu_device *adev);
 
 int amdgpu_vcn_early_init(struct amdgpu_device *adev, int i)
 {
@@ -285,6 +286,10 @@ int amdgpu_vcn_sw_fini(struct amdgpu_device *adev, int i)
 		amdgpu_ucode_release(&adev->vcn.inst[0].fw);
 		adev->vcn.inst[i].fw = NULL;
 	}
+
+	if (adev->vcn.reg_list)
+		amdgpu_vcn_reg_dump_fini(adev);
+
 	mutex_destroy(&adev->vcn.inst[i].vcn_pg_lock);
 	mutex_destroy(&adev->vcn.inst[i].vcn1_jpeg1_workaround);
 
@@ -1527,3 +1532,85 @@ int amdgpu_vcn_ring_reset(struct amdgpu_ring *ring,
 
 	return amdgpu_vcn_reset_engine(adev, ring->me);
 }
+
+int amdgpu_vcn_reg_dump_init(struct amdgpu_device *adev,
+			     const struct amdgpu_hwip_reg_entry *reg, u32 count)
+{
+	adev->vcn.ip_dump = kcalloc(adev->vcn.num_vcn_inst * count,
+				     sizeof(uint32_t), GFP_KERNEL);
+	if (!adev->vcn.ip_dump)
+		return -ENOMEM;
+	adev->vcn.reg_list = reg;
+	adev->vcn.reg_count = count;
+
+	return 0;
+}
+
+static void amdgpu_vcn_reg_dump_fini(struct amdgpu_device *adev)
+{
+	kfree(adev->vcn.ip_dump);
+	adev->vcn.reg_list = NULL;
+	adev->vcn.reg_count = 0;
+}
+
+void amdgpu_vcn_dump_ip_state(struct amdgpu_ip_block *ip_block)
+{
+	struct amdgpu_device *adev = ip_block->adev;
+	int i, j;
+	bool is_powered;
+	u32 inst_off;
+
+	if (!adev->vcn.ip_dump)
+		return;
+
+	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
+		if (adev->vcn.harvest_config & (1 << i))
+			continue;
+
+		inst_off = i * adev->vcn.reg_count;
+		/* mmUVD_POWER_STATUS is always readable and is the first in reg_list */
+		adev->vcn.ip_dump[inst_off] =
+			RREG32(SOC15_REG_ENTRY_OFFSET_INST(adev->vcn.reg_list[0], i));
+		is_powered = (adev->vcn.ip_dump[inst_off] &
+			      UVD_POWER_STATUS__UVD_POWER_STATUS_TILES_OFF) !=
+			      UVD_POWER_STATUS__UVD_POWER_STATUS_TILES_OFF;
+
+		if (is_powered)
+			for (j = 1; j < adev->vcn.reg_count; j++)
+				adev->vcn.ip_dump[inst_off + j] =
+				RREG32(SOC15_REG_ENTRY_OFFSET_INST(adev->vcn.reg_list[j], i));
+	}
+}
+
+void amdgpu_vcn_print_ip_state(struct amdgpu_ip_block *ip_block, struct drm_printer *p)
+{
+	struct amdgpu_device *adev = ip_block->adev;
+	int i, j;
+	bool is_powered;
+	u32 inst_off;
+
+	if (!adev->vcn.ip_dump)
+		return;
+
+	drm_printf(p, "num_instances:%d\n", adev->vcn.num_vcn_inst);
+	for (i = 0; i < adev->vcn.num_vcn_inst; i++) {
+		if (adev->vcn.harvest_config & (1 << i)) {
+			drm_printf(p, "\nHarvested Instance:VCN%d Skipping dump\n", i);
+			continue;
+		}
+
+		inst_off = i * adev->vcn.reg_count;
+		is_powered = (adev->vcn.ip_dump[inst_off] &
+			      UVD_POWER_STATUS__UVD_POWER_STATUS_TILES_OFF) !=
+			      UVD_POWER_STATUS__UVD_POWER_STATUS_TILES_OFF;
+
+		if (is_powered) {
+			drm_printf(p, "\nActive Instance:VCN%d\n", i);
+			for (j = 0; j < adev->vcn.reg_count; j++)
+				drm_printf(p, "%-50s \t 0x%08x\n", adev->vcn.reg_list[j].reg_name,
+					   adev->vcn.ip_dump[inst_off + j]);
+		} else {
+			drm_printf(p, "\nInactive Instance:VCN%d\n", i);
+		}
+	}
+}
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
index 0bc0a94d7cf0f..b3fb1d0e43fc9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -237,6 +237,8 @@
 
 #define AMDGPU_DRM_KEY_INJECT_WORKAROUND_VCNFW_ASD_HANDSHAKING 2
 
+struct amdgpu_hwip_reg_entry;
+
 enum amdgpu_vcn_caps {
 	AMDGPU_VCN_RRMT_ENABLED,
 };
@@ -362,6 +364,8 @@ struct amdgpu_vcn {
 
 	bool			workload_profile_active;
 	struct mutex            workload_profile_mutex;
+	u32 reg_count;
+	const struct amdgpu_hwip_reg_entry *reg_list;
 };
 
 struct amdgpu_fw_shared_rb_ptrs_struct {
@@ -557,4 +561,8 @@ int vcn_set_powergating_state(struct amdgpu_ip_block *ip_block,
 int amdgpu_vcn_ring_reset(struct amdgpu_ring *ring,
 			  unsigned int vmid,
 			  struct amdgpu_fence *guilty_fence);
+int amdgpu_vcn_reg_dump_init(struct amdgpu_device *adev,
+			     const struct amdgpu_hwip_reg_entry *reg, u32 count);
+void amdgpu_vcn_dump_ip_state(struct amdgpu_ip_block *ip_block);
+void amdgpu_vcn_print_ip_state(struct amdgpu_ip_block *ip_block, struct drm_printer *p);
 #endif
-- 
2.51.0



