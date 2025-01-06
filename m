Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893A6157E82;
	Mon,  6 Jan 2025 15:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177983; cv=none; b=d7ta4sfvgDfjotW9a6pxmCCdhPrj2D8gY3WDb80oniZtGfMG9FYRyLPHljnJtuWMboQkS29S69gLLajcaXVyReQ+fSFbYunxSampBnPKptK1yz4yEdXh3Y4PjZr8RypO5BA768tAXC9BVakjC7zN+aKj1iXGrhltKtKdKs1ufJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177983; c=relaxed/simple;
	bh=tB7W+zvbqIl4mwhTkXOy3jE+0ASKOzIzz2Dt7ksueVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKJBDANKiU8nR6lKygpWTVKuxy6C9xvqVlHCxtpq/FfRg3K6to0aIr7BO6giESmNrJOXYScgRTVlYz4RjpFiduF4LAUitqodg8TxfiOteBYwRAmGZFSxV+/cwXhFJcjUzLAUsHJbEJmOeBDwC3PmiYfCes9XIXEeLRoEe9Ro5VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rs0fiyOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rs0fiyOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0130AC4CED2;
	Mon,  6 Jan 2025 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177983;
	bh=tB7W+zvbqIl4mwhTkXOy3jE+0ASKOzIzz2Dt7ksueVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rs0fiyOTQPlgKm8ljRvRnUkYkySElEjIpkzSXycVR8ep6bd/4fh+99IbJgvzI5e82
	 Od8S5oww+/SauLw5n0C8OJaqGrjXWq1mT7nM7mHaM8PkO8J2J+daYWesHbKVNCffHY
	 WLKFH6NqaXtBppQFq14k2hpYqeLvVHZUxWRcYXFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Zhao <Victor.Zhao@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/156] drm/amdgpu: use sjt mec fw on gfx943 for sriov
Date: Mon,  6 Jan 2025 16:16:07 +0100
Message-ID: <20250106151144.784175388@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Zhao <Victor.Zhao@amd.com>

[ Upstream commit 9a4ab400f1fad0e6e8686b8f5fc5376383860ce8 ]

Use second jump table in sriov for live migration or mulitple VF
support so different VF can load different version of MEC as long
as they support sjt

Signed-off-by: Victor Zhao <Victor.Zhao@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index c100845409f7..ffdb966c4127 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -45,6 +45,8 @@ MODULE_FIRMWARE("amdgpu/gc_9_4_3_mec.bin");
 MODULE_FIRMWARE("amdgpu/gc_9_4_4_mec.bin");
 MODULE_FIRMWARE("amdgpu/gc_9_4_3_rlc.bin");
 MODULE_FIRMWARE("amdgpu/gc_9_4_4_rlc.bin");
+MODULE_FIRMWARE("amdgpu/gc_9_4_3_sjt_mec.bin");
+MODULE_FIRMWARE("amdgpu/gc_9_4_4_sjt_mec.bin");
 
 #define GFX9_MEC_HPD_SIZE 4096
 #define RLCG_UCODE_LOADING_START_ADDRESS 0x00002000L
@@ -574,8 +576,12 @@ static int gfx_v9_4_3_init_cp_compute_microcode(struct amdgpu_device *adev,
 {
 	int err;
 
-	err = amdgpu_ucode_request(adev, &adev->gfx.mec_fw,
-				   "amdgpu/%s_mec.bin", chip_name);
+	if (amdgpu_sriov_vf(adev))
+		err = amdgpu_ucode_request(adev, &adev->gfx.mec_fw,
+				"amdgpu/%s_sjt_mec.bin", chip_name);
+	else
+		err = amdgpu_ucode_request(adev, &adev->gfx.mec_fw,
+				"amdgpu/%s_mec.bin", chip_name);
 	if (err)
 		goto out;
 	amdgpu_gfx_cp_init_microcode(adev, AMDGPU_UCODE_ID_CP_MEC1);
-- 
2.39.5



