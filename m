Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23618235C52;
	Thu, 12 Dec 2024 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021294; cv=none; b=OAPzLn7ep3UUGdM3HM0JwuMB7+UKTdkHeUCA6I2+4KGCuBP0XzuCKnzW2dWwTRQCnY62GMQPzQQHH99js5bfdKxg3GgAElMiT8l09nZEm55I7uxCGSj11AZU+x62N0XZ5a+IEgb9KEuIimHj+RxBxoyIxpImv5CiMT+wPzyYcUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021294; c=relaxed/simple;
	bh=cL29mEB4wx1n2B7sqhnG+M8dKOQfRlfn+cwFHINN4/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQ4cdTeTU2UAwsjV77zxqHsTGOtGc4yxql8M5ww0SzlvdnQfu3Yzf/FeOKxjjtl8MYH/r7RfiHZb94fISsEOT9soGaISq241tUN5q+rw0qkTG8lQtBcKI+8SKxg5/lGXivQB3LzpSS32QdYC2hhefW4gMwA4dNmnn00EliTwOF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAC0H8Kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAC0H8Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE18C4CED3;
	Thu, 12 Dec 2024 16:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021294;
	bh=cL29mEB4wx1n2B7sqhnG+M8dKOQfRlfn+cwFHINN4/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAC0H8Kj4dzQCf7qIHArzMn+TVfGIhvwLzz/Q+h3cthvS2BXxuCgoCvqvOa2rAiTy
	 /YZ/EuHGrzK2cFvuoRC7VZfU/bwjlUvGSaaQbZi55haOYID4NPZ8lDCZ2cGHfqvinA
	 zdH/8ne/8Uh1/KmHbfg7zvl8SpWmkhGUFfR7P3hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <lang.yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 681/772] drm/amdgpu: refine error handling in amdgpu_ttm_tt_pin_userptr
Date: Thu, 12 Dec 2024 16:00:26 +0100
Message-ID: <20241212144418.056282197@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7afefaa374276..2b15d938c779f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -776,7 +776,7 @@ static int amdgpu_ttm_tt_pin_userptr(struct ttm_device *bdev,
 	/* Map SG to device */
 	r = dma_map_sgtable(adev->dev, ttm->sg, direction, 0);
 	if (r)
-		goto release_sg;
+		goto release_sg_table;
 
 	/* convert SG to linear array of pages and dma addresses */
 	drm_prime_sg_to_dma_addr_array(ttm->sg, gtt->ttm.dma_address,
@@ -784,6 +784,8 @@ static int amdgpu_ttm_tt_pin_userptr(struct ttm_device *bdev,
 
 	return 0;
 
+release_sg_table:
+	sg_free_table(ttm->sg);
 release_sg:
 	kfree(ttm->sg);
 	ttm->sg = NULL;
-- 
2.43.0



