Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671E0442C;
	Wed, 30 Jul 2025 09:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869285; cv=none; b=Uw1fLUzsYRR5KtPlDWb8pE+C8yAnmHvnYNV+aAKorpu7D5UIkfGM1qq4QhiM0uEDpJ8shZNR3fjM65VBbOEHf1SpKakyPrah17jdt+J6knywusf2+ZQc1Gs6j35k/f4k/bQwTKlct4yqX3R9/hlf2/yRlJRyfhqvB5VG99IXRnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869285; c=relaxed/simple;
	bh=79udYCoDzqb8xtIbWNoAstsEcs6SNDaBlhEYIw7WF18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldfKbj0cVZdRy7cDdh9shR/5LZQZUXIXguKl1F3VO8rcjPrO9nGLGT9Ef+LMR8MefVODQeAAfDnkEhZF+KV/U8l5E6C+oguN6R6HpwHx3LHmlGw2apYXtpG67qlX/wmjwXqk5Wo3QZhMYQ/D2QkH8cNJRPWPugcZeH+yNYIRLwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYWjPmDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYWjPmDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36237C4CEF5;
	Wed, 30 Jul 2025 09:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869284;
	bh=79udYCoDzqb8xtIbWNoAstsEcs6SNDaBlhEYIw7WF18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYWjPmDayUOk+/iYsVNfn3tMDa0qZ2u2Xv85YJnASemiKW3M5NFIRRSpWXawENRnT
	 gkw7cd3HAijO3xkZ4CU8JMYuSGe8T2ApEz9IBhpufltYiEt10k6i+snS35ns4tTgEZ
	 m+CwY4XScqSdOG/pDnJQx+pC6HNMbAljBlPlXyJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 83/92] drm/amdgpu: Implement SDMA soft reset directly for v5.x
Date: Wed, 30 Jul 2025 11:36:31 +0200
Message-ID: <20250730093233.959823573@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.zhang@amd.com <Jesse.zhang@amd.com>

commit 5c3e7c49538e2ddad10296a318c225bbb3d37d20 upstream.

This patch introduces a new function `amdgpu_sdma_soft_reset` to handle SDMA soft resets directly,
rather than relying on the DPM interface.

1. **New `amdgpu_sdma_soft_reset` Function**:
   - Implements a soft reset for SDMA engines by directly writing to the hardware registers.
   - Handles SDMA versions 4.x and 5.x separately:
     - For SDMA 4.x, the existing `amdgpu_dpm_reset_sdma` function is used for backward compatibility.
     - For SDMA 5.x, the driver directly manipulates the `GRBM_SOFT_RESET` register to reset the specified SDMA instance.

2. **Integration into `amdgpu_sdma_reset_engine`**:
   - The `amdgpu_sdma_soft_reset` function is called during the SDMA reset process, replacing the previous call to `amdgpu_dpm_reset_sdma`.

v2: r should default to an error (Alex)

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 09b585592fa4 ("drm/amdgpu: Fix SDMA engine reset with logical instance ID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c |   38 ++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c
@@ -26,6 +26,8 @@
 #include "amdgpu_sdma.h"
 #include "amdgpu_ras.h"
 #include "amdgpu_reset.h"
+#include "gc/gc_10_1_0_offset.h"
+#include "gc/gc_10_3_0_sh_mask.h"
 
 #define AMDGPU_CSA_SDMA_SIZE 64
 /* SDMA CSA reside in the 3rd page of CSA */
@@ -561,6 +563,40 @@ void amdgpu_sdma_register_on_reset_callb
 	list_add_tail(&funcs->list, &adev->sdma.reset_callback_list);
 }
 
+static int amdgpu_sdma_soft_reset(struct amdgpu_device *adev, u32 instance_id)
+{
+	struct amdgpu_sdma_instance *sdma_instance = &adev->sdma.instance[instance_id];
+	int r = -EOPNOTSUPP;
+
+	switch (amdgpu_ip_version(adev, SDMA0_HWIP, 0)) {
+	case IP_VERSION(4, 4, 2):
+	case IP_VERSION(4, 4, 4):
+	case IP_VERSION(4, 4, 5):
+		/* For SDMA 4.x, use the existing DPM interface for backward compatibility */
+		r = amdgpu_dpm_reset_sdma(adev, 1 << instance_id);
+		break;
+	case IP_VERSION(5, 0, 0):
+	case IP_VERSION(5, 0, 1):
+	case IP_VERSION(5, 0, 2):
+	case IP_VERSION(5, 0, 5):
+	case IP_VERSION(5, 2, 0):
+	case IP_VERSION(5, 2, 2):
+	case IP_VERSION(5, 2, 4):
+	case IP_VERSION(5, 2, 5):
+	case IP_VERSION(5, 2, 6):
+	case IP_VERSION(5, 2, 3):
+	case IP_VERSION(5, 2, 1):
+	case IP_VERSION(5, 2, 7):
+		if (sdma_instance->funcs->soft_reset_kernel_queue)
+			r = sdma_instance->funcs->soft_reset_kernel_queue(adev, instance_id);
+		break;
+	default:
+		break;
+	}
+
+	return r;
+}
+
 /**
  * amdgpu_sdma_reset_engine - Reset a specific SDMA engine
  * @adev: Pointer to the AMDGPU device
@@ -611,7 +647,7 @@ int amdgpu_sdma_reset_engine(struct amdg
 	}
 
 	/* Perform the SDMA reset for the specified instance */
-	ret = amdgpu_dpm_reset_sdma(adev, 1 << instance_id);
+	ret = amdgpu_sdma_soft_reset(adev, instance_id);
 	if (ret) {
 		dev_err(adev->dev, "Failed to reset SDMA instance %u\n", instance_id);
 		goto exit;


