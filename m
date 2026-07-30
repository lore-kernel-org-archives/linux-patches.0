Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790A43B6366;
	Thu, 30 Jul 2026 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423237; cv=none; b=WuuxkPKhC5JwtQpmMk839ts17JW+hwHPjYf0ZszmyA4qRxVSF/qMDrxdjTjJkJ3XkEH0H5ddbDq9NXMCgu+LgBc5bbGK0vBGJp6oy3KC+9w9lZWYErgGNsvq0jjP/xq5irAWufEgD7i56Pk2/MsZPYnPn9553dRLLXWvJ6fXdpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423237; c=relaxed/simple;
	bh=XlsYnNwwWD7sae8lQJGSXdLK+t5iA2ZYRi6MsJ8ZQVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn0z0kidcnhT+qZenWTTaxZxQPW3xvY/jdvtFQs0zEITC/d3Q0kaDzeVs4HPzSNtxbZ7+e1oW5I+6c+Z4+2utVgCFhhsvwE+QnskrEdv4X87yEKy3mFh9YockYf83ssaPfxrGXzkDMLoqLTJ6DCOYeYOzPR1d3EMAc847wj3uow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrti+p2n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrti+p2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35411F000E9;
	Thu, 30 Jul 2026 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423236;
	bh=/U4DtJJxJ3WXPL4dTtLHtGGV2o/mNk6GGA7tN7nNQCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrti+p2na/4kAgDZ+UTXTl2WD1BDZgjd2wjFUr+IBXw+dcIMImSj3i39kM5HNkTNw
	 bRV7ZPNnarirQenZzW2WrYffJ2q5qdE+kLcKrS1Vvpg6UhukKGtHx8pSfUE9w6bgKA
	 JpCG3/6ocjl0aEQOvO3VgUhJxBwW4lrswNpxrV7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 714/744] drm/amdgpu: invoke pm_genpd_remove() before freeing genpd
Date: Thu, 30 Jul 2026 16:16:27 +0200
Message-ID: <20260730141459.455480422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ce Sun <cesun102@amd.com>

commit 28c9b3c5dc35cc790d11e26ca3fc6e068be63998 upstream.

Call pm_genpd_remove() to unregister from global list prior to releasing
acp_genpd memory, and clear the pointer after free.

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cd8650d7a91ee8b768e202354672553faa5cc1f2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -560,7 +560,9 @@ out:
 
 	mfd_remove_devices(adev->acp.parent);
 	kfree(adev->acp.acp_res);
+	pm_genpd_remove(&adev->acp.acp_genpd->gpd);
 	kfree(adev->acp.acp_genpd);
+	adev->acp.acp_genpd = NULL;
 	kfree(adev->acp.acp_cell);
 
 	return ret;


