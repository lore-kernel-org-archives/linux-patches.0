Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713BF13D896;
	Tue, 23 Jul 2024 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759638; cv=none; b=DbO0/EUPS5V+PSeum9Rbi9CkQIjtCweueKLd4TwR0iKRf9D489k+XKzeZ2PGYap+qrtfM/LgUFxndOlxxiI+hwlNifEROmp0wvEENTuEOHSKdLdQK8PH6Gaj2e8/7mi5Abx7A7geomC6nK3LHnzmJDFkgG8YuGBkpZOOJy+Dg38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759638; c=relaxed/simple;
	bh=wdV4zOYgAq2docihOx9RSLpHQh2bmWFdPOIFVpyd6rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViGk5T3obhPQWDLDyNpj8hZwty897TpJCtxRqBqx0j6bOEemMBp7uZJkFPbb8E5fp81WOV433xqZnM4y7hnI02jMyBifsaebPdTvNWYVoQbE+0wshtjpLkRKT9tFA60yGSyDZEugu3ZJo4wjffdS3stpUIEqsB52FStXG7e9lDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldgxreMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldgxreMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4E2C4AF0A;
	Tue, 23 Jul 2024 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759638;
	bh=wdV4zOYgAq2docihOx9RSLpHQh2bmWFdPOIFVpyd6rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldgxreMQ27mi9oC9eUmyBZwOlUsaINNzikmhL1hIPpE3qVbhXK9fgbe3Y3OVjf9Yv
	 VTfOWtBFO5j28XPWyRzn1s7y1aWEQUqdmrOo7aAUHzuKgtgKPOal8fa84hwYOOoXzF
	 b/9QLAs/FKZzPcGZX8CG3VqJtXdFYOOdSPRuE7IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/129] drm/amdgpu: Indicate CU havest info to CP
Date: Tue, 23 Jul 2024 20:23:28 +0200
Message-ID: <20240723180407.105484622@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit 49c9ffabde555c841392858d8b9e6cf58998a50c ]

To achieve full occupancy CP hardware needs to know if CUs in SE are
symmetrically or asymmetrically harvested

v2: Reset is_symmetric_cus for each loop

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index af46823e43367..caa04d897c2de 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -4290,9 +4290,10 @@ static u32 gfx_v9_4_3_get_cu_active_bitmap(struct amdgpu_device *adev, int xcc_i
 static int gfx_v9_4_3_get_cu_info(struct amdgpu_device *adev,
 				 struct amdgpu_cu_info *cu_info)
 {
-	int i, j, k, counter, xcc_id, active_cu_number = 0;
-	u32 mask, bitmap, ao_bitmap, ao_cu_mask = 0;
+	int i, j, k, prev_counter, counter, xcc_id, active_cu_number = 0;
+	u32 mask, bitmap, ao_bitmap, ao_cu_mask = 0, tmp;
 	unsigned disable_masks[4 * 4];
+	bool is_symmetric_cus;
 
 	if (!adev || !cu_info)
 		return -EINVAL;
@@ -4310,6 +4311,7 @@ static int gfx_v9_4_3_get_cu_info(struct amdgpu_device *adev,
 
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (xcc_id = 0; xcc_id < NUM_XCC(adev->gfx.xcc_mask); xcc_id++) {
+		is_symmetric_cus = true;
 		for (i = 0; i < adev->gfx.config.max_shader_engines; i++) {
 			for (j = 0; j < adev->gfx.config.max_sh_per_se; j++) {
 				mask = 1;
@@ -4337,6 +4339,15 @@ static int gfx_v9_4_3_get_cu_info(struct amdgpu_device *adev,
 					ao_cu_mask |= (ao_bitmap << (i * 16 + j * 8));
 				cu_info->ao_cu_bitmap[i][j] = ao_bitmap;
 			}
+			if (i && is_symmetric_cus && prev_counter != counter)
+				is_symmetric_cus = false;
+			prev_counter = counter;
+		}
+		if (is_symmetric_cus) {
+			tmp = RREG32_SOC15(GC, GET_INST(GC, xcc_id), regCP_CPC_DEBUG);
+			tmp = REG_SET_FIELD(tmp, CP_CPC_DEBUG, CPC_HARVESTING_RELAUNCH_DISABLE, 1);
+			tmp = REG_SET_FIELD(tmp, CP_CPC_DEBUG, CPC_HARVESTING_DISPATCH_DISABLE, 1);
+			WREG32_SOC15(GC, GET_INST(GC, xcc_id), regCP_CPC_DEBUG, tmp);
 		}
 		gfx_v9_4_3_xcc_select_se_sh(adev, 0xffffffff, 0xffffffff, 0xffffffff,
 					    xcc_id);
-- 
2.43.0



