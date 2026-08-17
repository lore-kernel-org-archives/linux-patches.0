Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AE7424D6D;
	Mon, 17 Aug 2026 15:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979606; cv=none; b=Fbko4nJT5JpRbAk0wmFTH6Wn4RwwKYDAfN1I+GenikiAbNTOHg575kBL783RLSRm/Hc7Dnu0Nf+OsMUkUHbTx/IDphuAKLE8vHUUW2QjnUe1eniOZl5WNkCB2kJwXex0r78+JATec87x4dT+Ks2szOdHedDx8GxgPPK0JcKFrk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979606; c=relaxed/simple;
	bh=TPa7Rye+Z9tr/dFI2RUnF687xzbaxzSGriv2ryI7qFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEkYK0WYbR+sAeuS9t8hul+AKXK2lYRF5bxnXkAsfZIagulbHhN4u21ZNbAMLGmKC3pRujILxBXVDTU6AvEJjSBqJJU3zWHjpMWguxvUveB0M4/AVQ7iP/KAltXUOaGm/HYZvSWw8UJpX3+RgZbyK9qnIo2MoeOZt58z7Mdm04M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzPCisff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzPCisff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D631F000E9;
	Mon, 17 Aug 2026 15:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979605;
	bh=12TlQk1pcgT673d5kel2l+Mgz4t1tkQPGcByNfTXB1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzPCisffmOyNLi3hjiA30IC41R8AApwm9bpbQoVWxTQpFMfomjqWsFlmvXoGRFPDh
	 VF5APe2WTUaZyrxIEN+5LLSydPxEbd/U/eG7NpjgZ4x9V7Ag82O5oyB0d/sRQ5Eome
	 8H1+0DR5ZDcX8OurscdkHhRBQzB+wdbWZlRjZ9Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 285/609] drm/amdgpu: invoke pm_genpd_remove() before freeing genpd
Date: Mon, 17 Aug 2026 15:29:41 +0200
Message-ID: <20260817132553.715517517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -559,7 +559,9 @@ static int acp_hw_fini(void *handle)
 
 	mfd_remove_devices(adev->acp.parent);
 	kfree(adev->acp.acp_res);
+	pm_genpd_remove(&adev->acp.acp_genpd->gpd);
 	kfree(adev->acp.acp_genpd);
+	adev->acp.acp_genpd = NULL;
 	kfree(adev->acp.acp_cell);
 
 	return 0;


