Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E04B372228;
	Sat, 28 Feb 2026 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301485; cv=none; b=MSM3Qtxr+HR/cR7pACEVqkoK7Bcc+Bi7aKey/3teeTiaCOTOyD/OGWkzyAB3+CzEIwYzLZHiaANNDxt1sqy6GmdQdFA8kiJMvPQNlnhRdDaDmnIiAeF5TS+z8qnrfLMOPgkt9N3U1ZrGKDo+GGlV0mVWJLhD8vusI7/LQPeYKug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301485; c=relaxed/simple;
	bh=V2jJM/PItmpq3NyJsUteZEIeFcKhqtwlKWqStRva4n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6k643A1gv/P/DraiUe0r449ucfmUvi8VZdvEnscen8PQ7ZgC6a+cx1sxnaFIBccw50EtZr/oJ599gzKQfOptLCGPiWAhGPDJMAEaO9yI4zFcAOA6T7xRSYN5pZGkKa05kZHI8gparlSdCGb10szxAoVuASzs7vQ8OsmPfJIuAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDimz35z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDimz35z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47028C19425;
	Sat, 28 Feb 2026 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301484;
	bh=V2jJM/PItmpq3NyJsUteZEIeFcKhqtwlKWqStRva4n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDimz35zulhReJ6vWeQZwPxS8FMBkHCEYZ31wUrUFNg61BbC87u+rZuSLW/AfwIAf
	 KLhOj1dcWuYqeyqVsIgRrcbXiZmGdpDmfTc2209qqoNAeai1Xbb8eLYVJws8/2NKKd
	 3exfD6FVouwNk7KvlKxZHZc2mmrdMacUiQRyl0gOIuc6rnkOdhWNHL7pUjMRmTjBH+
	 3wbMOOQSt0FhGsx/IfenerkR85GitTS7f1pEOdtdaXWzC6nI52MHxiEwUGlOg/8RGe
	 fuLpw/TUr2WAE0MhZK3+RtBPbrl0xzd1R2/2oMazm9y08jjvaLxwiUormci2lfv7y4
	 Otlz2eB4XCITg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 670/752] drm/amdgpu: Protect GPU register accesses in powergated state in some paths
Date: Sat, 28 Feb 2026 12:46:21 -0500
Message-ID: <20260228174750.1542406-670-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 39fc2bc4da0082c226cbee331f0a5d44db3997da ]

Ungate GPU CG/PG in device_fini_hw and device_halt to protect GPU
register accesses, e.g. GC registers are accessed in amdgpu_irq_disable_all()
and amdgpu_fence_driver_hw_fini().

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c052da36aa9c2..b28ebb44c695d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3630,9 +3630,6 @@ static int amdgpu_device_ip_fini_early(struct amdgpu_device *adev)
 		}
 	}
 
-	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
-	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
-
 	amdgpu_amdkfd_suspend(adev, true);
 	amdgpu_userq_suspend(adev);
 
@@ -4961,6 +4958,9 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 		amdgpu_virt_fini_data_exchange(adev);
 	}
 
+	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
+	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
+
 	/* disable all interrupts */
 	amdgpu_irq_disable_all(adev);
 	if (adev->mode_info.mode_config_initialized) {
@@ -7354,6 +7354,9 @@ void amdgpu_device_halt(struct amdgpu_device *adev)
 	amdgpu_xcp_dev_unplug(adev);
 	drm_dev_unplug(ddev);
 
+	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
+	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
+
 	amdgpu_irq_disable_all(adev);
 
 	amdgpu_fence_driver_hw_fini(adev);
-- 
2.51.0

