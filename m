Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8BD13D600;
	Tue, 23 Jul 2024 18:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760027; cv=none; b=dEIly2oEBGfXE1FDICiCPhAHR6cVTyKEtU/hE5qGc6Cq4C9/z/ZDwek9tz8mab8pbiVHxFPoRuwQWBbYypZGferKax74P8KTNkleZpum1kAk+Kn77ISWCESCEZdzTB8VE08hiLhvT7oFwp9yqRGMxx8SW9JcFbwZN1ogQ6kad2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760027; c=relaxed/simple;
	bh=B6JnSwNzz621YxYX+UyugdL4VeRe7E4CiHZCKCfznKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2YeTPiYpVXSdpHIvtceF+J7fqx5ry8Eitb9CPzysMPmU8LeuYXQxqaP+ikhKX8X7K7Ap6SonZ95j+8fKW7LIfR9g6UZ5NMr3HrW8vRG3JOiGtewuDl5FslSSNZ+Az6mhs9B26QAJokr2vP6yRP/uc++4OKzQG80TK+ApkvYa6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTkeip5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTkeip5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA497C4AF0A;
	Tue, 23 Jul 2024 18:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760027;
	bh=B6JnSwNzz621YxYX+UyugdL4VeRe7E4CiHZCKCfznKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTkeip5MwKtEYvursMfAStzeM4cdXzYPuyVWsF4gyXXi/Z1CFf+jdZz2MXnVcDEUW
	 PLbaJ3PBcmXZC3s9VIZ3h5zZrUbYXxstnQJX5S50atM9IEc6stNIle64eh9v3spZH7
	 bF6+/96KyJrSqU4LXnGZmT9i1fkgJHMLvwdBVnd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 079/163] drm/amdgpu: Indicate CU havest info to CP
Date: Tue, 23 Jul 2024 20:23:28 +0200
Message-ID: <20240723180146.522407517@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index d89d6829f1df4..b10fdd8b54144 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -4187,9 +4187,10 @@ static u32 gfx_v9_4_3_get_cu_active_bitmap(struct amdgpu_device *adev, int xcc_i
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
@@ -4207,6 +4208,7 @@ static int gfx_v9_4_3_get_cu_info(struct amdgpu_device *adev,
 
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (xcc_id = 0; xcc_id < NUM_XCC(adev->gfx.xcc_mask); xcc_id++) {
+		is_symmetric_cus = true;
 		for (i = 0; i < adev->gfx.config.max_shader_engines; i++) {
 			for (j = 0; j < adev->gfx.config.max_sh_per_se; j++) {
 				mask = 1;
@@ -4234,6 +4236,15 @@ static int gfx_v9_4_3_get_cu_info(struct amdgpu_device *adev,
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



