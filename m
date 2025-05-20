Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C774C24501D;
	Tue, 20 May 2025 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749679; cv=none; b=n1BQRoZnKEQYNH84bENioicu72uTThKp/g+I7LxBbI18smpcpU+Y72GyhUYOaVds/8bX2+Auan/soe9+1v4ThGsQHQ7iN8BHP+9wp7VX/rMb5owyzu6STKxd3fT/oL5wz4mKiBsDi4hgP1PP9gJz3CA3TEtcGvWBcP0PjZUqvyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749679; c=relaxed/simple;
	bh=geeSJupQ98p3Jm9R1aPa2wWIrpge5ut0JmorjO1I5h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDO+7ozTT0Wb6MHfB5O4kPJShe+DWhtrtzHm+m+DsSCUtOyCac/qcxW6l8OjG9r16Ey24sH45GBVwUu3iNTQf9nxL9G0O/zPfeUbQxrlIGhRPkpRqVgbp1ZofTztmI8Mi7M4NgVZCP4KZf/PpiGJaPt4LWu79GwKsYiOTBut0ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djby4Wek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djby4Wek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59197C4CEEB;
	Tue, 20 May 2025 14:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749679;
	bh=geeSJupQ98p3Jm9R1aPa2wWIrpge5ut0JmorjO1I5h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djby4WekSLhIK7AlufV4FWZHJzuff58M9tcs9QDOEoHhuGP7V1oHKPTcHnDot0/42
	 o8K2b/kM4AfPWc8wqY5zaFvOj3EUGOul3YIWtq0+xrhY/I4om0N0BO8iZU2BAoOc0+
	 b4ZMESyLWS356x9umMbj5zY4JWQ6jTX76lXSIpQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhigang Luo <Zhigang.Luo@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/117] drm/amdgpu: trigger flr_work if reading pf2vf data failed
Date: Tue, 20 May 2025 15:49:50 +0200
Message-ID: <20250520125804.977034647@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

From: Zhigang Luo <Zhigang.Luo@amd.com>

[ Upstream commit ab66c832847fcdffc97d4591ba5547e3990d9d33 ]

if reading pf2vf data failed 30 times continuously, it means something is
wrong. Need to trigger flr_work to recover the issue.

also use dev_err to print the error message to get which device has
issue and add warning message if waiting IDH_FLR_NOTIFICATION_CMPL
timeout.

Signed-off-by: Zhigang Luo <Zhigang.Luo@amd.com>
Acked-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: d0ce1aaa8531 ("Revert "drm/amd: Stop evicting resources on APUs in suspend"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 15 +++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c   | 29 ++++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h   |  3 +++
 drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c      |  2 ++
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c      |  2 ++
 5 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index b2056228e8699..e22e2a1df730c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -141,6 +141,8 @@ const char *amdgpu_asic_name[] = {
 	"LAST",
 };
 
+static inline void amdgpu_device_stop_pending_resets(struct amdgpu_device *adev);
+
 /**
  * DOC: pcie_replay_count
  *
@@ -4558,6 +4560,8 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 retry:
 	amdgpu_amdkfd_pre_reset(adev);
 
+	amdgpu_device_stop_pending_resets(adev);
+
 	if (from_hypervisor)
 		r = amdgpu_virt_request_full_gpu(adev, true);
 	else
@@ -5354,11 +5358,12 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 			tmp_adev->asic_reset_res = r;
 		}
 
-		/*
-		 * Drop all pending non scheduler resets. Scheduler resets
-		 * were already dropped during drm_sched_stop
-		 */
-		amdgpu_device_stop_pending_resets(tmp_adev);
+		if (!amdgpu_sriov_vf(tmp_adev))
+			/*
+			* Drop all pending non scheduler resets. Scheduler resets
+			* were already dropped during drm_sched_stop
+			*/
+			amdgpu_device_stop_pending_resets(tmp_adev);
 	}
 
 	/* Actual ASIC resets if needed.*/
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 22575422ca7ec..7cb4b4118335a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -32,6 +32,7 @@
 
 #include "amdgpu.h"
 #include "amdgpu_ras.h"
+#include "amdgpu_reset.h"
 #include "vi.h"
 #include "soc15.h"
 #include "nv.h"
@@ -468,7 +469,7 @@ static int amdgpu_virt_read_pf2vf_data(struct amdgpu_device *adev)
 		return -EINVAL;
 
 	if (pf2vf_info->size > 1024) {
-		DRM_ERROR("invalid pf2vf message size\n");
+		dev_err(adev->dev, "invalid pf2vf message size: 0x%x\n", pf2vf_info->size);
 		return -EINVAL;
 	}
 
@@ -479,7 +480,9 @@ static int amdgpu_virt_read_pf2vf_data(struct amdgpu_device *adev)
 			adev->virt.fw_reserve.p_pf2vf, pf2vf_info->size,
 			adev->virt.fw_reserve.checksum_key, checksum);
 		if (checksum != checkval) {
-			DRM_ERROR("invalid pf2vf message\n");
+			dev_err(adev->dev,
+				"invalid pf2vf message: header checksum=0x%x calculated checksum=0x%x\n",
+				checksum, checkval);
 			return -EINVAL;
 		}
 
@@ -493,7 +496,9 @@ static int amdgpu_virt_read_pf2vf_data(struct amdgpu_device *adev)
 			adev->virt.fw_reserve.p_pf2vf, pf2vf_info->size,
 			0, checksum);
 		if (checksum != checkval) {
-			DRM_ERROR("invalid pf2vf message\n");
+			dev_err(adev->dev,
+				"invalid pf2vf message: header checksum=0x%x calculated checksum=0x%x\n",
+				checksum, checkval);
 			return -EINVAL;
 		}
 
@@ -529,7 +534,7 @@ static int amdgpu_virt_read_pf2vf_data(struct amdgpu_device *adev)
 			((struct amd_sriov_msg_pf2vf_info *)pf2vf_info)->uuid;
 		break;
 	default:
-		DRM_ERROR("invalid pf2vf version\n");
+		dev_err(adev->dev, "invalid pf2vf version: 0x%x\n", pf2vf_info->version);
 		return -EINVAL;
 	}
 
@@ -628,8 +633,21 @@ static void amdgpu_virt_update_vf2pf_work_item(struct work_struct *work)
 	int ret;
 
 	ret = amdgpu_virt_read_pf2vf_data(adev);
-	if (ret)
+	if (ret) {
+		adev->virt.vf2pf_update_retry_cnt++;
+		if ((adev->virt.vf2pf_update_retry_cnt >= AMDGPU_VF2PF_UPDATE_MAX_RETRY_LIMIT) &&
+		    amdgpu_sriov_runtime(adev) && !amdgpu_in_reset(adev)) {
+			if (amdgpu_reset_domain_schedule(adev->reset_domain,
+							  &adev->virt.flr_work))
+				return;
+			else
+				dev_err(adev->dev, "Failed to queue work! at %s", __func__);
+		}
+
 		goto out;
+	}
+
+	adev->virt.vf2pf_update_retry_cnt = 0;
 	amdgpu_virt_write_vf2pf_data(adev);
 
 out:
@@ -650,6 +668,7 @@ void amdgpu_virt_init_data_exchange(struct amdgpu_device *adev)
 	adev->virt.fw_reserve.p_pf2vf = NULL;
 	adev->virt.fw_reserve.p_vf2pf = NULL;
 	adev->virt.vf2pf_update_interval_ms = 0;
+	adev->virt.vf2pf_update_retry_cnt = 0;
 
 	if (adev->mman.fw_vram_usage_va && adev->mman.drv_vram_usage_va) {
 		DRM_WARN("Currently fw_vram and drv_vram should not have values at the same time!");
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 23b6efa9d25df..891713757a8f5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -51,6 +51,8 @@
 /* tonga/fiji use this offset */
 #define mmBIF_IOV_FUNC_IDENTIFIER 0x1503
 
+#define AMDGPU_VF2PF_UPDATE_MAX_RETRY_LIMIT 30
+
 enum amdgpu_sriov_vf_mode {
 	SRIOV_VF_MODE_BARE_METAL = 0,
 	SRIOV_VF_MODE_ONE_VF,
@@ -253,6 +255,7 @@ struct amdgpu_virt {
 	/* vf2pf message */
 	struct delayed_work vf2pf_work;
 	uint32_t vf2pf_update_interval_ms;
+	int vf2pf_update_retry_cnt;
 
 	/* multimedia bandwidth config */
 	bool     is_mm_bw_enabled;
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
index 63725b2ebc037..37ac6d8ff8136 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c
@@ -276,6 +276,8 @@ static void xgpu_ai_mailbox_flr_work(struct work_struct *work)
 		timeout -= 10;
 	} while (timeout > 1);
 
+	dev_warn(adev->dev, "waiting IDH_FLR_NOTIFICATION_CMPL timeout\n");
+
 flr_done:
 	atomic_set(&adev->reset_domain->in_gpu_reset, 0);
 	up_write(&adev->reset_domain->sem);
diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
index 6a68ee946f1cc..96edd5d11326d 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
@@ -298,6 +298,8 @@ static void xgpu_nv_mailbox_flr_work(struct work_struct *work)
 		timeout -= 10;
 	} while (timeout > 1);
 
+	dev_warn(adev->dev, "waiting IDH_FLR_NOTIFICATION_CMPL timeout\n");
+
 flr_done:
 	atomic_set(&adev->reset_domain->in_gpu_reset, 0);
 	up_write(&adev->reset_domain->sem);
-- 
2.39.5



