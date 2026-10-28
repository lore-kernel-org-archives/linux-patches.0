Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211231;
	b=c+MmcTo+9orq+axxCM+gvMgZIpC5whKVEJZrjyR4B/K8WAA/ENDJilGtKVxNEFpxfIc4
	 X4yLoTf863rtM/m0NhnVA32CUnOYIcMGX3WAAwewhRZ69uFtn3nX7mo3xc99ihfeY1Osh
	 Byh0EourCjPKtCa2jiSjy8e3igX22KyiUi19qkUXXpPJVB0ximtIXXyPcfpVNOC0PDM7i
	 QmzVRD10Godafd90Kq3sLd5nimctIuziom2I+cKcbw656r6HO0BobUzAezGKEGT8Nopgb
	 7y2qriPcTCnFCOP9VmcRrp2Foki+GmEn3lIGT7DxGDbhRHb3F9DkwxdgAsLHlafCLSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xt5aNjjBzz++b06dxa+zqW1BSSyBTlDY+RLYMngWklU=;
	b=F0irwUXSiX2waTQgQwWzoH5GdJJbWpz9nTRc4GZv6wIjlVH+t6g478+JAINACCK6OyyK
	 8SJYg36VXNdvgD1Wxh40XnBMscc9tZEnyVuY6zTzDkPAUHAbNXzed45BvZ3mC05ZGDzmL
	 6o6L7e5yrI+aWs2jwgEKmGI44w8E2Dj7matnFO8crLsqrRWGAUFGZU8aAA7EaOt0qcdEr
	 x1RNDY1530283BQ/2ORvV07eDbJz3QdRsnrsfO/BMScyrXRVwK5hkP6KyvpvPpIyobpe3
	 lkhaEo2VhxgYfhdRF8Th7rvJrrJ8g+oM777QdVvjNykakygTu9Kyz7JVTXp/9UF8nPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tSHgEgOw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9EA606B477;
	Wed, 28 Oct 2026 18:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tSHgEgOw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53D21F01828;
	Wed, 28 Oct 2026 18:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211231;
	bh=Xt5aNjjBzz++b06dxa+zqW1BSSyBTlDY+RLYMngWklU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tSHgEgOwUujXDaYkSd9PJHkaO7znbboCLmjNqGK0GIqdOkZROHHiryWMBcdkDm/Ts
	 l0CbGjZwopbeqmLMesoE5THgd5OPy0POZYYAQHzV8ebuBEV54s8JEVE1IlPgAfnQml
	 m/fHsGNzOBJfJ5DhuqUxezD6MyAsYXl99UvakoE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/571] drm/amdgpu: fix ACP MFD device leak on init failure
Date: Wed, 28 Oct 2026 17:57:31 +0100
Message-ID: <20261028170015.214289877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f0013046151b7467e62c471c1c83d63ea255799c ]

acp_hw_init() registers ACP child devices with mfd_add_devices() before
attaching them to the ACP power domain and initializing the hardware.

If attaching a child to the power domain fails, or if the ACP reset or
clock enable operation times out, the failure path frees only the
source cell, resource, and platform-data allocations. The child
platform devices already registered by mfd_add_devices() remain
registered and are never released.

Remove the children from the power domain and unregister the MFD
devices on failures that occur after mfd_add_devices() succeeds. Keep
mfd_add_devices() failures on the existing cleanup path since the MFD
core already rolls back partially registered children itself.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 25030321ba28 ("drm/amd: add pm domain for ACP IP sub blocks")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 63da68d6a2279ec945581c990c5a59a5ae8b5560)
Cc: stable@vger.kernel.org
[ sashal: Adjusted context for the single initialization path without Jadeite-specific code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
index 2b998d1245956..62ee3217842bf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -344,7 +344,7 @@ static int acp_hw_init(void *handle)
 	r = device_for_each_child(adev->acp.parent, &adev->acp.acp_genpd->gpd,
 				  acp_genpd_add_device);
 	if (r)
-		goto failure;
+		goto failure_remove_mfd;
 
 	/* Assert Soft reset of ACP */
 	val = cgs_read_register(adev->acp.cgs_device, mmACP_SOFT_RESET);
@@ -361,7 +361,7 @@ static int acp_hw_init(void *handle)
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -379,7 +379,7 @@ static int acp_hw_init(void *handle)
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -389,6 +389,11 @@ static int acp_hw_init(void *handle)
 	cgs_write_register(adev->acp.cgs_device, mmACP_SOFT_RESET, val);
 	return 0;
 
+failure_remove_mfd:
+	device_for_each_child(adev->acp.parent, NULL,
+			      acp_genpd_remove_device);
+	mfd_remove_devices(adev->acp.parent);
+
 failure:
 	kfree(i2s_pdata);
 	kfree(adev->acp.acp_res);
-- 
2.53.0



