Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767D624A06A;
	Mon, 13 Oct 2025 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367138; cv=none; b=dtXd7d/QRBEfyhec7a9YKvDwvWZbCHe9X2GL26O5hhnyaI4yLu9XUTEl4NnlaZ59FiTgRX55R7GkvZwg/5S5iMhzRHcBsbiaVO6x9siRAQOfP8616TzbFA5uQOduwrdo3XLuQOobauRAAJQL9d7l4/0hOi0+RfQALib8hGSQmUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367138; c=relaxed/simple;
	bh=YNMwc4w6vZCZzCDxuT9tvkj0juF0JJeCib41m/g5HFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YnOAc19w7Khfmw4o0hQBF4UabpN1I5khWj5Pz083hQs/O2qrkRW81pLjg5QIUnYt2TcewW9L+Oe48vZJOCtT39qTXllva7hj7fRMGzTwPkAFeo6fjSxZtQRKxByMivQOI2jTb2CM2c9PGoonw0kWPowprRGwDfUQADRBtqVUlG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guktIolN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guktIolN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF439C4CEE7;
	Mon, 13 Oct 2025 14:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367138;
	bh=YNMwc4w6vZCZzCDxuT9tvkj0juF0JJeCib41m/g5HFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guktIolNkzizAGwTzxs0goyXWX4yyCLD2qPK/oFiX93E/mpxZV9FqsX4Z0tVcAAVS
	 XfwG8qo1mph7Szs3xcofVgO+F4K8MG2yqs9IRui+1/lT6FIi5oTcaQQPO0zEqg+pzG
	 w9mhqQ1JcBakEe6+FprBk9fpLjYbTaZu6XwQV5rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/196] drm/amd/pm: Fix si_upload_smc_data (v3)
Date: Mon, 13 Oct 2025 16:44:38 +0200
Message-ID: <20251013144318.498627209@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit a43b2cec04b02743338aa78f837ee0bdf066a6d5 ]

The si_upload_smc_data function uses si_write_smc_soft_register
to set some register values in the SMC, and expects the result
to be PPSMC_Result_OK which is 1.

The PPSMC_Result_OK / PPSMC_Result_Failed values are used for
checking the result of a command sent to the SMC.
However, the si_write_smc_soft_register actually doesn't send
any commands to the SMC and returns zero on success,
so this check was incorrect.

Fix that by not checking the return value, just like other
calls to si_write_smc_soft_register.

v3:
Additionally, when no display is plugged in, there is no need
to restrict MCLK switching, so program the registers to zero.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 43 ++++++++++++----------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index c17d567cf8bc5..85ab0d87eb337 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -5793,9 +5793,9 @@ static int si_upload_smc_data(struct amdgpu_device *adev)
 {
 	struct amdgpu_crtc *amdgpu_crtc = NULL;
 	int i;
-
-	if (adev->pm.dpm.new_active_crtc_count == 0)
-		return 0;
+	u32 crtc_index = 0;
+	u32 mclk_change_block_cp_min = 0;
+	u32 mclk_change_block_cp_max = 0;
 
 	for (i = 0; i < adev->mode_info.num_crtc; i++) {
 		if (adev->pm.dpm.new_active_crtcs & (1 << i)) {
@@ -5804,26 +5804,31 @@ static int si_upload_smc_data(struct amdgpu_device *adev)
 		}
 	}
 
-	if (amdgpu_crtc == NULL)
-		return 0;
+	/* When a display is plugged in, program these so that the SMC
+	 * performs MCLK switching when it doesn't cause flickering.
+	 * When no display is plugged in, there is no need to restrict
+	 * MCLK switching, so program them to zero.
+	 */
+	if (adev->pm.dpm.new_active_crtc_count && amdgpu_crtc) {
+		crtc_index = amdgpu_crtc->crtc_id;
 
-	if (amdgpu_crtc->line_time <= 0)
-		return 0;
+		if (amdgpu_crtc->line_time) {
+			mclk_change_block_cp_min = amdgpu_crtc->wm_high / amdgpu_crtc->line_time;
+			mclk_change_block_cp_max = amdgpu_crtc->wm_low / amdgpu_crtc->line_time;
+		}
+	}
 
-	if (si_write_smc_soft_register(adev,
-				       SI_SMC_SOFT_REGISTER_crtc_index,
-				       amdgpu_crtc->crtc_id) != PPSMC_Result_OK)
-		return 0;
+	si_write_smc_soft_register(adev,
+		SI_SMC_SOFT_REGISTER_crtc_index,
+		crtc_index);
 
-	if (si_write_smc_soft_register(adev,
-				       SI_SMC_SOFT_REGISTER_mclk_change_block_cp_min,
-				       amdgpu_crtc->wm_high / amdgpu_crtc->line_time) != PPSMC_Result_OK)
-		return 0;
+	si_write_smc_soft_register(adev,
+		SI_SMC_SOFT_REGISTER_mclk_change_block_cp_min,
+		mclk_change_block_cp_min);
 
-	if (si_write_smc_soft_register(adev,
-				       SI_SMC_SOFT_REGISTER_mclk_change_block_cp_max,
-				       amdgpu_crtc->wm_low / amdgpu_crtc->line_time) != PPSMC_Result_OK)
-		return 0;
+	si_write_smc_soft_register(adev,
+		SI_SMC_SOFT_REGISTER_mclk_change_block_cp_max,
+		mclk_change_block_cp_max);
 
 	return 0;
 }
-- 
2.51.0



