Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2C71E9B3D;
	Thu,  3 Jul 2025 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555292; cv=none; b=mO1qaGXkOQwFGmoH5DDLnbmRzpq4NnX5/h7D/eKyEJnBRodciEFEhdl+PUC6CwKKBxIcTu37KQ/XGCEradhW1pQxWeezXEl2YrKbh+eVWFX8kjRmIHmE5sFbyNF70mKK1ruzOmTaD6OnmrVPHQW2sQ8mdteLrryKubnT6pjT0ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555292; c=relaxed/simple;
	bh=iEMyHPLh4u9tWyADiEPq2nFEVgEMyvKMIUl6MssXU00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fi2K87/pk99d5JOKRL4eAAlYHXlajPQ2sp4hahbhnAUEyGdZm6zWSaT6CsUvfte09SX/XKFL8nAZNNsSD2i/OYY0NNEHTHXZIJW69EzSjKDfKUwxGw0XqAdRjlQWP0DLvMwOVHY67/ODG7I44ygWiFr6gElUChb9f+9epjv/qPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCrKkoHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCrKkoHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE1FC4CEE3;
	Thu,  3 Jul 2025 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555292;
	bh=iEMyHPLh4u9tWyADiEPq2nFEVgEMyvKMIUl6MssXU00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCrKkoHbzE9nxF1HcD/JBChe0gtP6TwFeEH56OAWc9NnMVJQ7zXQWHTIhfysb+296
	 a0BoHDTQcbCAiBjh7RcCbe1M3M+gpHNcQL6nJGP2GV5He/Dof+C0wkKvpQreRj1vx0
	 riYhGkNqn8pZEdtdW996BtVk7/UtGriyycfSuf8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 234/263] drm/amdgpu: Fix SDMA UTC_L1 handling during start/stop sequences
Date: Thu,  3 Jul 2025 16:42:34 +0200
Message-ID: <20250703144013.786096041@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Jesse Zhang <jesse.zhang@amd.com>

commit 7f3b16f3f229e37cc3e02e9e4e7106c523b119e9 upstream.

This commit makes two key fixes to SDMA v4.4.2 handling:

1. disable UTC_L1 in sdma_cntl register when stopping SDMA engines
   by reading the current value before modifying UTC_L1_ENABLE bit.

2. Ensure UTC_L1_ENABLE is consistently managed by:
   - Adding the missing register write when enabling UTC_L1 during start
   - Keeping UTC_L1 enabled by default as per hardware requirements

v2: Correct SDMA_CNTL setting (Philip)

Suggested-by: Jonathan Kim <jonathan.kim@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 375bf564654e85a7b1b0657b191645b3edca1bda)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -489,7 +489,7 @@ static void sdma_v4_4_2_inst_gfx_stop(st
 {
 	struct amdgpu_ring *sdma[AMDGPU_MAX_SDMA_INSTANCES];
 	u32 doorbell_offset, doorbell;
-	u32 rb_cntl, ib_cntl;
+	u32 rb_cntl, ib_cntl, sdma_cntl;
 	int i;
 
 	for_each_inst(i, inst_mask) {
@@ -501,6 +501,9 @@ static void sdma_v4_4_2_inst_gfx_stop(st
 		ib_cntl = RREG32_SDMA(i, regSDMA_GFX_IB_CNTL);
 		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA_GFX_IB_CNTL, IB_ENABLE, 0);
 		WREG32_SDMA(i, regSDMA_GFX_IB_CNTL, ib_cntl);
+		sdma_cntl = RREG32_SDMA(i, regSDMA_CNTL);
+		sdma_cntl = REG_SET_FIELD(sdma_cntl, SDMA_CNTL, UTC_L1_ENABLE, 0);
+		WREG32_SDMA(i, regSDMA_CNTL, sdma_cntl);
 
 		if (sdma[i]->use_doorbell) {
 			doorbell = RREG32_SDMA(i, regSDMA_GFX_DOORBELL);
@@ -994,6 +997,7 @@ static int sdma_v4_4_2_inst_start(struct
 		/* set utc l1 enable flag always to 1 */
 		temp = RREG32_SDMA(i, regSDMA_CNTL);
 		temp = REG_SET_FIELD(temp, SDMA_CNTL, UTC_L1_ENABLE, 1);
+		WREG32_SDMA(i, regSDMA_CNTL, temp);
 
 		if (amdgpu_ip_version(adev, SDMA0_HWIP, 0) < IP_VERSION(4, 4, 5)) {
 			/* enable context empty interrupt during initialization */


