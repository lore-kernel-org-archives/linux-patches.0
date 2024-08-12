Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234CD186E36;
	Mon, 12 Aug 2024 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478790; cv=none; b=HI53njx5DV2OVFs2uLEpMvlogKQYe1xhe/TV6KNzl16nJtBO+BwbsqUGJJcaRrRMkBY8xwNr69ki73t6bDyNVCJIACxlDOYRMv814YzqxO0Q6SJ7rCIvO75XgTmAwQ8yn5+ZJfM2pt6F6p7JdtZfiEcqnZpbmCM6VlwGrxrQIio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478790; c=relaxed/simple;
	bh=Qujtxlic1nY9rQUCMErFE3IRl90sdj3hQu6WQuFCf7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiDPREdQ8XpRZt91VKTs44hG/Xg5Iyf+KFFUd4seoU79ngJSb8dyQEUOejkFRS3D3S1FNQeQzA8IUw9T2jtYC7gSmxphzu+darHvipJp40U4T6TY2GQ65YULVmFDdMgmt+Kwjw5BBWGwthD3ZM3FKoxdwma620ISUw6V3sxXxdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgf4F6x7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgf4F6x7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F2DC32782;
	Mon, 12 Aug 2024 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478789;
	bh=Qujtxlic1nY9rQUCMErFE3IRl90sdj3hQu6WQuFCf7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgf4F6x783GNhDio0427otcLjaiCSK/f+ddSy6/J9dg5elc6lMr3IX+3UjyF6arDb
	 D3ymmg2ypXBE+J+Nr6PEIPjOaoiS/NiE0J7efXNhJg+mx1KIfra+D/tJWxQl6sPsam
	 Zuc/ewfe9XzRFzeeC1ERxq137oSVHE0kd93MMhAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Skvortsov <victor.skvortsov@amd.com>,
	Zhigang Luo <zhigang.luo@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/150] drm/amdgpu: Add lock around VF RLCG interface
Date: Mon, 12 Aug 2024 18:01:59 +0200
Message-ID: <20240812160126.634974127@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Victor Skvortsov <victor.skvortsov@amd.com>

[ Upstream commit e864180ee49b4d30e640fd1e1d852b86411420c9 ]

flush_gpu_tlb may be called from another thread while
device_gpu_recover is running.

Both of these threads access registers through the VF
RLCG interface during VF Full Access. Add a lock around this interface
to prevent race conditions between these threads.

Signed-off-by: Victor Skvortsov <victor.skvortsov@amd.com>
Reviewed-by: Zhigang Luo <zhigang.luo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c   | 6 ++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h   | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d4faa489bd5fa..4d1c2eb63090f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3631,6 +3631,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	mutex_init(&adev->grbm_idx_mutex);
 	mutex_init(&adev->mn_lock);
 	mutex_init(&adev->virt.vf_errors.lock);
+	mutex_init(&adev->virt.rlcg_reg_lock);
 	hash_init(adev->mn_hash);
 	mutex_init(&adev->psp.mutex);
 	mutex_init(&adev->notifier_lock);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 81549f1edfe01..5ee9211c503c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -956,6 +956,9 @@ static u32 amdgpu_virt_rlcg_reg_rw(struct amdgpu_device *adev, u32 offset, u32 v
 	scratch_reg1 = (void __iomem *)adev->rmmio + 4 * reg_access_ctrl->scratch_reg1;
 	scratch_reg2 = (void __iomem *)adev->rmmio + 4 * reg_access_ctrl->scratch_reg2;
 	scratch_reg3 = (void __iomem *)adev->rmmio + 4 * reg_access_ctrl->scratch_reg3;
+
+	mutex_lock(&adev->virt.rlcg_reg_lock);
+
 	if (reg_access_ctrl->spare_int)
 		spare_int = (void __iomem *)adev->rmmio + 4 * reg_access_ctrl->spare_int;
 
@@ -1009,6 +1012,9 @@ static u32 amdgpu_virt_rlcg_reg_rw(struct amdgpu_device *adev, u32 offset, u32 v
 	}
 
 	ret = readl(scratch_reg0);
+
+	mutex_unlock(&adev->virt.rlcg_reg_lock);
+
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 2b9d806e23afb..dc6aaa4d67be7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -260,6 +260,8 @@ struct amdgpu_virt {
 
 	/* the ucode id to signal the autoload */
 	uint32_t autoload_ucode_id;
+
+	struct mutex rlcg_reg_lock;
 };
 
 struct amdgpu_video_codec_info;
-- 
2.43.0



