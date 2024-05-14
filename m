Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC88C6D1D7;
	Tue, 14 May 2024 11:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685162; cv=none; b=YFEQUYF0jMjKLRS2h7wITBUIljHPBvUrj0m36zBkhfW6uWridcwycNsLPcgqe+4w5J25XuQhOr90qm9AusCYgwBxUWH5OCGln66HnqFLvQXtHeBUQKykNu6bXvnjIvW6br5s+OihRSTcyLwPALrKBlSkN2BKxYal4DRxzaN3vT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685162; c=relaxed/simple;
	bh=TreBqxrjcYiHA/N+i2Jy1gw0IL31XtLh5idxao63Cq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9eicpRkBMOwv9YaoQtKpmYLv7agvcyxxACGaSri1OzLtuSRNgPB72iqNMk3s1CHowiVZMIirSPCUBKnAnrG7Yxu6ULY0luyobDrYNLOhtPa/s3fOZJI3W+0nIRNZIZUMd2uChabctDJmSHEnxAcP/8SFoPVQ2PrrsOWMCIyRTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2G6Ajea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2G6Ajea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BEFC2BD10;
	Tue, 14 May 2024 11:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685161;
	bh=TreBqxrjcYiHA/N+i2Jy1gw0IL31XtLh5idxao63Cq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2G6Ajea6N1cNDXHHn03PjwLIyp4orlz4SNLcTSoy4vR1BeiDOVJa2Cw9IhaVPQX4
	 EVLQoOCDTkLIhegcHmvoWl2lH15BbjwKTOtUeChYfjBzl/AzSgaPt9kARAGMM4Cpr2
	 Ft4mGn0+bzk+yxlhH3TAQ0jFtOaf38XPdTqWHeE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/301] drm/amdgpu: implement IRQ_STATE_ENABLE for SDMA v4.4.2
Date: Tue, 14 May 2024 12:16:57 +0200
Message-ID: <20240514101037.766919418@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit f886b49feaae30acd599e37d4284836024b0f3ed ]

SDMA_CNTL is not set in some cases, driver configures it by itself.

v2: simplify code

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
index e76e7e7cb554e..4e8d5e6a65e41 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -1613,19 +1613,9 @@ static int sdma_v4_4_2_set_ecc_irq_state(struct amdgpu_device *adev,
 	u32 sdma_cntl;
 
 	sdma_cntl = RREG32_SDMA(type, regSDMA_CNTL);
-	switch (state) {
-	case AMDGPU_IRQ_STATE_DISABLE:
-		sdma_cntl = REG_SET_FIELD(sdma_cntl, SDMA_CNTL,
-					  DRAM_ECC_INT_ENABLE, 0);
-		WREG32_SDMA(type, regSDMA_CNTL, sdma_cntl);
-		break;
-	/* sdma ecc interrupt is enabled by default
-	 * driver doesn't need to do anything to
-	 * enable the interrupt */
-	case AMDGPU_IRQ_STATE_ENABLE:
-	default:
-		break;
-	}
+	sdma_cntl = REG_SET_FIELD(sdma_cntl, SDMA_CNTL, DRAM_ECC_INT_ENABLE,
+					state == AMDGPU_IRQ_STATE_ENABLE ? 1 : 0);
+	WREG32_SDMA(type, regSDMA_CNTL, sdma_cntl);
 
 	return 0;
 }
-- 
2.43.0



