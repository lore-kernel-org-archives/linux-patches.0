Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AB11487CD;
	Thu, 12 Dec 2024 15:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016847; cv=none; b=JcFBL+ud2dUVBZ+CS+skNKcgYWbgRFT1e2iFVUx7H8AsFy+N2JEAy8AMLWyUNgP/2H5ZzmfibhR2R7WzszboSoqoIOxMBIBN0hrAhQs/7Q8FMfbz06UKycpjr7N4eFDYdTI4mkakXZjOck+VKU+9ziBiMgMal2bvpUCMWtimjt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016847; c=relaxed/simple;
	bh=GXFl2thFBj0amLQd2tyX9rjpTJYQG9uZp1OoNg3ZA/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcaIiuDmmRZj0PyMBbTJECLVs1sAumH2znOiGmvLlWGYNY2lTWS3Z3FT3FldQjmckfdJEe6kqnoDqohysGBmzfucBFhI/D3f7TnqGOMDx2Vo1nz8M4MhxzAR2BK/BRvSBgoNdnysmSU/e1S9y8W+PqGgY80risQN2kszKYCzYq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiX1TrXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiX1TrXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C43C4CED7;
	Thu, 12 Dec 2024 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016847;
	bh=GXFl2thFBj0amLQd2tyX9rjpTJYQG9uZp1OoNg3ZA/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiX1TrXFtaUM6Eh02mvndLEyiJtouC3To496zahC+ACYDlC/m2sd8QrYI5HTXauHc
	 NcgHPw5BlPc5BOQ5vZ3VwnD0PCO9f6utVMAB/q0nlnQo3U2z+KL9mhxwsNwpvliomh
	 pVldGIw7CvC4G6VoKqAYoi5PMvzPMZS152YbAni4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <lang.yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 313/466] drm/amdgpu: refine error handling in amdgpu_ttm_tt_pin_userptr
Date: Thu, 12 Dec 2024 15:58:02 +0100
Message-ID: <20241212144319.144587921@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Yu <lang.yu@amd.com>

[ Upstream commit 46186667f98fb7158c98f4ff5da62c427761ffcd ]

Free sg table when dma_map_sgtable() failed to avoid memory leak.

Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 74adb983ab03e..0637414fc70e0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -812,7 +812,7 @@ static int amdgpu_ttm_tt_pin_userptr(struct ttm_device *bdev,
 	/* Map SG to device */
 	r = dma_map_sgtable(adev->dev, ttm->sg, direction, 0);
 	if (r)
-		goto release_sg;
+		goto release_sg_table;
 
 	/* convert SG to linear array of pages and dma addresses */
 	drm_prime_sg_to_dma_addr_array(ttm->sg, gtt->ttm.dma_address,
@@ -820,6 +820,8 @@ static int amdgpu_ttm_tt_pin_userptr(struct ttm_device *bdev,
 
 	return 0;
 
+release_sg_table:
+	sg_free_table(ttm->sg);
 release_sg:
 	kfree(ttm->sg);
 	ttm->sg = NULL;
-- 
2.43.0



