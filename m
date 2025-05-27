Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0208E1DC998;
	Tue, 27 May 2025 17:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367770; cv=none; b=em5nTQX+aDkfLuqw/JeQS3QZzuYiok2EQobZYMM4NvT3WzI6ffAERG6/sayk/10eA2N2aO3fRay0uo+iO//iTy3E1OK8rTifogAYimPlrj9br5Jmx4dpRnma3LpV+jaAyqd9vkvYLOs1CkK7PsyfpAPa2wkQ3GK/wCUS8ad2C2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367770; c=relaxed/simple;
	bh=KYsIAqcXBOhKklbRZWfPDZYhw8wRZ9gJwYkd4wvfhso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdrSApEExnlz1coSVm3LM/OjhcyMOACCL1i8fjqICmGS5Fjza7jFYN03Jf+k1jUSnycU3Tn/opWLXpvlswevEek/soF2Ap2mPo6qc33Qd5xQxpAP7Ci/K3alZFLx+RyHyt9mJQlWCO2tzbI4EfOsmK/FkY//7YpuaXlDPpQsi+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QobPtiCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QobPtiCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008A1C4CEE9;
	Tue, 27 May 2025 17:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367769;
	bh=KYsIAqcXBOhKklbRZWfPDZYhw8wRZ9gJwYkd4wvfhso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QobPtiCVtf4KDmAwk7VXwpVq0+QKJu55ghkFGCDwdd9aphHW0ALdLTBSanTahS10t
	 ATt+wme9/Vn+foA0YcJdhho4qMUkV7nA9s6RfvU2nSdBhVhwxrRfzfjxO9pOCEPSUQ
	 06LU1wehOdgG533dKDYrYLxmNpY7w9qr+nBwS7ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Skvortsov <victor.skvortsov@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 494/783] drm/amdgpu: Skip err_count sysfs creation on VF unsupported RAS blocks
Date: Tue, 27 May 2025 18:24:51 +0200
Message-ID: <20250527162533.242910734@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Skvortsov <victor.skvortsov@amd.com>

[ Upstream commit 04893397766a2b2f1bc7fe5c6414e4c0846ed171 ]

VFs are not able to query error counts for all RAS blocks. Rather than
returning error for queries on these blocks, skip sysfs the creation
all together.

Signed-off-by: Victor Skvortsov <victor.skvortsov@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c  |  3 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 17 ++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h |  2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index f0924aa3f4e48..0c338dcdde48a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1864,6 +1864,9 @@ int amdgpu_ras_sysfs_create(struct amdgpu_device *adev,
 	if (!obj || obj->attr_inuse)
 		return -EINVAL;
 
+	if (amdgpu_sriov_vf(adev) && !amdgpu_virt_ras_telemetry_block_en(adev, head->block))
+		return 0;
+
 	get_obj(obj);
 
 	snprintf(obj->fs_data.sysfs_name, sizeof(obj->fs_data.sysfs_name),
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 13e5709ea1caa..e6f0152e5b087 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -1247,7 +1247,8 @@ amdgpu_ras_block_to_sriov(struct amdgpu_device *adev, enum amdgpu_ras_block bloc
 	case AMDGPU_RAS_BLOCK__MPIO:
 		return RAS_TELEMETRY_GPU_BLOCK_MPIO;
 	default:
-		dev_err(adev->dev, "Unsupported SRIOV RAS telemetry block 0x%x\n", block);
+		DRM_WARN_ONCE("Unsupported SRIOV RAS telemetry block 0x%x\n",
+			      block);
 		return RAS_TELEMETRY_GPU_BLOCK_COUNT;
 	}
 }
@@ -1332,3 +1333,17 @@ int amdgpu_virt_ras_telemetry_post_reset(struct amdgpu_device *adev)
 
 	return 0;
 }
+
+bool amdgpu_virt_ras_telemetry_block_en(struct amdgpu_device *adev,
+					enum amdgpu_ras_block block)
+{
+	enum amd_sriov_ras_telemetry_gpu_block sriov_block;
+
+	sriov_block = amdgpu_ras_block_to_sriov(adev, block);
+
+	if (sriov_block >= RAS_TELEMETRY_GPU_BLOCK_COUNT ||
+	    !amdgpu_sriov_ras_telemetry_block_en(adev, sriov_block))
+		return false;
+
+	return true;
+}
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index 0ca73343a7689..0f3ccae5c1ab3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -407,4 +407,6 @@ bool amdgpu_virt_get_ras_capability(struct amdgpu_device *adev);
 int amdgpu_virt_req_ras_err_count(struct amdgpu_device *adev, enum amdgpu_ras_block block,
 				  struct ras_err_data *err_data);
 int amdgpu_virt_ras_telemetry_post_reset(struct amdgpu_device *adev);
+bool amdgpu_virt_ras_telemetry_block_en(struct amdgpu_device *adev,
+					enum amdgpu_ras_block block);
 #endif
-- 
2.39.5



