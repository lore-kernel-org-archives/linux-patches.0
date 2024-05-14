Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DC613A250;
	Tue, 14 May 2024 10:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683074; cv=none; b=UQJKvVQqoy0ymdwL2h0XKxV0XomfF8S6Use36RH+3GK/S7dOVj/XUVydQ4Y7+MH5WMJ7rt2c9GOJZIbtHiBSeicce4FT0qYXqmrdAG1il9ZpFRB4h2LRwQOPSfT7XPkf+gVOpIi2lBNfjO6zUCkauQZ0wnv/G0Px656CFTRx4YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683074; c=relaxed/simple;
	bh=2aZC8sxl58Qw2inf9toONBfst5bMoWOmH1TCwmXqqJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvnFdtOW0W0LwXvptJJVsmPz76M0Dx89u/LCkCiU6I3B86rAndHVNgJUa7kfbCyS14AFWbMhsgT5elcnZTaHibQmlzzHPTGa0t8jXcLgKumhKPG7ymfcQwHGGKqpJT5xjXa3DrLw/v8jrggAo9ifjD0W7n80HSw7NTcDYnijA60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW6C7fKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW6C7fKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2144CC2BD10;
	Tue, 14 May 2024 10:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683073;
	bh=2aZC8sxl58Qw2inf9toONBfst5bMoWOmH1TCwmXqqJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PW6C7fKLRnWJCVdybb87KnnXn0OZoTdnV7A6wwBJeXRsHHRWS5n0gFIkqFvc6ndQy
	 dm/eCadki6CUA2ScxeASCGqmCqPhqaFB8kkGmjwPCpb4npX6PZllg4FBRdYuBqkEbh
	 B/NvoHd1XCotAWr1lYtCGfQecYeczZWxrkHsNyOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 162/336] drm/amdgpu: implement IRQ_STATE_ENABLE for SDMA v4.4.2
Date: Tue, 14 May 2024 12:16:06 +0200
Message-ID: <20240514101044.721029503@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 1caed0163b53d..328682cbb7e22 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -1601,19 +1601,9 @@ static int sdma_v4_4_2_set_ecc_irq_state(struct amdgpu_device *adev,
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



