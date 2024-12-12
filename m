Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A74E222D62;
	Thu, 12 Dec 2024 17:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023323; cv=none; b=EgImP/2n8lQw+yTl2BX+ZOiouuC1eECh46yMj5TU/bqxwmNREdwhbI519VeOaQwR/du9a0zpkE52YYZasjHLA3mmtpMspm8YZ5Um+nsqtVd+1Z+aPwk18rPh8CK24WOk6ekazNPzDIz9JXtavKhy6p0UfB/Ay/yAghhyfoOBPwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023323; c=relaxed/simple;
	bh=5Lz6BXWHVULL91ddyhYThyMssHDf/LBVYwrnqmWV4NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKHYr1OcB5UNf/vlzVAfANhwzKiWRIYpi60XAM5l+0l8IeQ5PkjjlCmqwkxqCr+BUFUSjtQjUYoV7/AlPgFtd3N5Jg/VAMatNqL0SgEf15v9yiyH7mg9cnBXPU5W++/DTZZQfmHQzRCkrnE2qt7IDSw2cUzw7UVVf7RJXHy0lcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfEkYPz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfEkYPz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD45C4CECE;
	Thu, 12 Dec 2024 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023322;
	bh=5Lz6BXWHVULL91ddyhYThyMssHDf/LBVYwrnqmWV4NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfEkYPz1SePR3Rw2ym6+TsATjLxjAEZnZ2QIXkFKctGxk0uK25yYiMMFyIgCeLuNI
	 3YImSFQIVcii1fsUpO90rMmFd+711734OO9xlNXZ/oRksXDbSDL/9b94I27eIyEOzN
	 TH4PMPi25rvnbR8I682ClQO8Alv4Dh+kxEU74Sl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <lang.yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 497/565] drm/amdgpu: refine error handling in amdgpu_ttm_tt_pin_userptr
Date: Thu, 12 Dec 2024 16:01:32 +0100
Message-ID: <20241212144331.413554394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9a1b19e3d4378..ca00a2d5e38b5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -775,7 +775,7 @@ static int amdgpu_ttm_tt_pin_userptr(struct ttm_device *bdev,
 	/* Map SG to device */
 	r = dma_map_sgtable(adev->dev, ttm->sg, direction, 0);
 	if (r)
-		goto release_sg;
+		goto release_sg_table;
 
 	/* convert SG to linear array of pages and dma addresses */
 	drm_prime_sg_to_dma_addr_array(ttm->sg, gtt->ttm.dma_address,
@@ -783,6 +783,8 @@ static int amdgpu_ttm_tt_pin_userptr(struct ttm_device *bdev,
 
 	return 0;
 
+release_sg_table:
+	sg_free_table(ttm->sg);
 release_sg:
 	kfree(ttm->sg);
 	ttm->sg = NULL;
-- 
2.43.0



