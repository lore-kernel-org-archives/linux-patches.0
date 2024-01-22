Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055764F204;
	Tue, 23 Jan 2024 00:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970329; cv=none; b=g+q4u/lBxMek9a63bXGmOzv6I0aBoqxiev//0ljbPAM5NLRURBrTveLmgu25E0JQnbKc/5tB8ktciK+8CsgYT/EiA+aKIO4z+Ry132lWpO55cwo6JzK19Jyatsdq2Kk2GMkfOxcP7pRfJwwRre5BHfoWCiMyyRbLhRAqtVH15YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970329; c=relaxed/simple;
	bh=yNj3eO+prH+xoJSIMmYUFtKEsLhWu6oCATHyqriDFhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHHfvEMsUrHzzMT604w91o7qeyHgji9GPsAPZbqGU/1zQOw8few7jb/JLFARb3o3PBIAJUlkQMJtyOEuXJwjOqWROqMJLc41m+MHBelqw7JCoGXKPiLnn22ndEf3xAZCulKkDh/AoOwXDCwbrw4lNyvsCN5ysUeSgtJ74eMj5EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkh+UIQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkh+UIQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3DEC433C7;
	Tue, 23 Jan 2024 00:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970328;
	bh=yNj3eO+prH+xoJSIMmYUFtKEsLhWu6oCATHyqriDFhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkh+UIQJJgBAk4++7MmI08FK6F2yZ2BqAE5yRDFbL6I4yGieyTssRUduuw9olCa8i
	 dBNbod+Jg6Sr7KYz4/eCdx5jlscrSa2sz7YnUBl844k48+CgJ5KNNXCVtSxLcGX6lu
	 k3O3a4fx5Cl3FtxS01Jh3EpXBWVoyOW/sto2c6W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Dafna Hirschfeld <dhirschfeld@habana.ai>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 610/641] drm/amdkfd: fixes for HMM mem allocation
Date: Mon, 22 Jan 2024 15:58:34 -0800
Message-ID: <20240122235837.321719710@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dafna Hirschfeld <dhirschfeld@habana.ai>

[ Upstream commit 02eed83abc1395a1207591aafad9bcfc5cb1abcb ]

Fix err return value and reset pgmap->type after checking it.

Fixes: c83dee9b6394 ("drm/amdkfd: add SPM support for SVM")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Dafna Hirschfeld <dhirschfeld@habana.ai>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 6c25dab051d5..b8680e0753ca 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -1021,7 +1021,7 @@ int kgd2kfd_init_zone_device(struct amdgpu_device *adev)
 	} else {
 		res = devm_request_free_mem_region(adev->dev, &iomem_resource, size);
 		if (IS_ERR(res))
-			return -ENOMEM;
+			return PTR_ERR(res);
 		pgmap->range.start = res->start;
 		pgmap->range.end = res->end;
 		pgmap->type = MEMORY_DEVICE_PRIVATE;
@@ -1037,10 +1037,10 @@ int kgd2kfd_init_zone_device(struct amdgpu_device *adev)
 	r = devm_memremap_pages(adev->dev, pgmap);
 	if (IS_ERR(r)) {
 		pr_err("failed to register HMM device memory\n");
-		/* Disable SVM support capability */
-		pgmap->type = 0;
 		if (pgmap->type == MEMORY_DEVICE_PRIVATE)
 			devm_release_mem_region(adev->dev, res->start, resource_size(res));
+		/* Disable SVM support capability */
+		pgmap->type = 0;
 		return PTR_ERR(r);
 	}
 
-- 
2.43.0



