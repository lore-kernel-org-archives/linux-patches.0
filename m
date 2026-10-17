Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F8B3C061D;
	Sat, 17 Oct 2026 17:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259835; cv=none; b=qgvjxfbx8D5BSNfnjPa6GYPhw6Jy677EDfxjEQS5PFS+OxP0dl101jz59OyWOGzggD8pelqmRaqJ9olBcK3kpLJ1eLP8ZDyyDhr3vkpaWSmE36biJ3aydQqoj7ky4m/Opa1vm7U1IMFKMfyrsDFEcIvnZ9LCek99PXLrE19ko3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259835; c=relaxed/simple;
	bh=+yC7nbpGmISe9BwHVnjC1BiBbN7GZBtvqfaF4bFluzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xcjo67GclIv8YHqVs4wpq2uzbF8FcqfkwEWJyfMCpb6FUCkWMNFUldOeL4UOiRhcfDsJCPDyfrwZQ9rvhqI/PpIrJ2Fwo2ymzzoczkHzaREe1SNpgMGEQtZFZvATS4pyEYytmSP8bo/gY/gc1PZ3pSoyJ8WHDRymU7eAUyco5+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9177TSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9177TSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA9E1F000C4;
	Sat, 17 Oct 2026 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259834;
	bh=4gLw4cZVmKcTCLVvmcti/ZfWctOTLyRzCFXSSALGojw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r9177TSd4GZQlgeElOWHkR/BaRvF9n5rx77mYgKliqsK7rVVbvjw5hXBn/AoLRfRC
	 9orq54qHtwO9nugeS3dfHULAPuXuZkdV2bWmG3V6lnFMWOfUzbWr/OxZzJ3SH2Jgeb
	 hMmMS6EKc7zbO89gqaKnMCsZfz5d04YH2OjgUjjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bobzhou2@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Frank Min <Frank.Min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1346/1674] drm/amdgpu: avoid force-completing uninitialized UVD rings
Date: Sat, 17 Oct 2026 18:00:18 +0200
Message-ID: <20261017160505.708310834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Zhou <bobzhou2@amd.com>

[ Upstream commit 6760f5cb12d2366ddd58a2d8637f7583d73f596b ]

uvd_v7_0_sw_init() does not initialize the UVD decode ring for an
SR-IOV VF. However, amdgpu_uvd_resume() unconditionally force-completes
the decode ring when restoring its fence sequence.

Skip fence completion when the fence driver is not initialized.

Fixes: 0a33b11d26c6 ("drm/amdgpu: mark force completed fences with -ECANCELED")
Cc: stable@vger.kernel.org
Signed-off-by: Bob Zhou <bobzhou2@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Acked-by: Frank Min <Frank.Min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
index aab293ec3417e..52b5ddc923c82 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -511,7 +511,8 @@ int amdgpu_uvd_resume(struct amdgpu_device *adev)
 			}
 			memset_io(ptr, 0, size);
 			/* to restore uvd fence seq */
-			amdgpu_fence_driver_force_completion(&adev->uvd.inst[i].ring);
+			if (adev->uvd.inst[i].ring.fence_drv.initialized)
+				amdgpu_fence_driver_force_completion(&adev->uvd.inst[i].ring);
 		}
 	}
 	return 0;
-- 
2.53.0



