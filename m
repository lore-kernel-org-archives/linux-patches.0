Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054492;
	b=jFtZw83Fptlt3z+B6lMJazM9ih7qdeMs/2h7daUa4G7b/78f/I+lAq317LsNT12oUKev
	 cHCZhkMuzVsbzsryGrtbCtgz3zZkzIJtP6fSzocvM0uBO7j809sZuY1dK4Ka3ykK82Yiu
	 jbi6QWhN8SsfddCSJJzG5r5EdAktGfuBJkkGPrI3L0zFVQIemoAwOLjCusm4s1oF65FxB
	 VSSqA+jAC5x9c1hs3pXyAfRHzb32kdoDjNMBIsAvF1gjoLEzk8kXbZCptRK8GPLtX8RAq
	 0CCOVe3QtacvXddws1KsSc2FCsoLKtAdabdK407vLb4Wckum+wp/GC8Pvtqh18YoHTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4KLfsXPrfjEY3MLx/vMMLWHNkfUA/BpkaIXve0z8zIw=;
	b=AE7MWAsAtA9Po0AaOw3dYtjVLKMo94xz7O9k1ZuLmg+Jl/TBx3XhzHU0jniQYC0PDK74
	 bFAx3ODHbahC+QwwDUBCN16VoUgm/jp9ZDNAI037I8O4NgLLUBOVMCEb3Josv7XT6p3Sv
	 owVKwEmOftXDFXBuACSm8YaFdO1/AZrq7VgTQoinhH8SiE8d/Ib2Crd1svjJfAtyjJEuX
	 11uwDNhPUyYGTkN9rKiGa+rbYTHGJCUo+bTBVPSRiM/jGOY2R/6mGvo1zfL6Z8fiwdinA
	 5/pMBBpao7hNcUMvcNpk4e7+YNFaYhPfZ7y4Q8smbcgwzw9Y8HwbeNy4c/jJDC42ZnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02qiEt2k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11588606A320;
	Thu, 19 Nov 2026 02:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02qiEt2k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF511F000C4;
	Thu, 19 Nov 2026 02:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054491;
	bh=4KLfsXPrfjEY3MLx/vMMLWHNkfUA/BpkaIXve0z8zIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02qiEt2k+0y9OiC/gzz7r9T0ALOYcdUB9H7T24SZjDhu7MEVxVh/lHgo7yuAUWKwc
	 pqu5WTicynwQHILrlmX9P3lWjwyWPYfmtIHX6b68e2e7Snvz2cVSBxREfcJS9BkOBU
	 eG/qj3U8lIdh0j7CDtiYaOWNCVWUWAWSpaG3kCyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1253/2214] drm/amdgpu: cancel idle work in hw_init failure paths for vcn/uvd/vce/jpeg
Date: Wed, 18 Nov 2026 15:48:49 +0100
Message-ID: <20261118150101.799138679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Leo Liu <leo.liu@amd.com>

[ Upstream commit a56c2536c399d57a9bb1c02fd411e0c25859af3b ]

When hw_init() fails, amdgpu_device_ip_fini_early() skips hw_fini()
because status.hw was never set.  For VCN, UVD (including UVD ENC), VCE,
and JPEG, hw_fini() is where cancel_delayed_work_sync() is called.  Any
idle work queued during the partial hw_init() is therefore left pending
after sw_fini() frees the adev state the handler touches.

Cancel the idle work in each hw_init() error path, immediately before
returning the error, so that hw_fini() remains the sole cancel site on
the normal teardown path with no duplication.

Link: https://github.com/ROCm/amdgpu/issues/234
Fixes: 416e1fab4752 ("drm/amdgpu: drop redundant cancel_delayed_work_sync call")
Assisted-by: Claude:Claude-Sonnet-4.6
Signed-off-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7ff2327fde029e97d0050fcb94e3f4063c318547)
Cc: stable@vger.kernel.org
[ sashal: Replaced per-instance VCN idle-work cancellations with a single cancellation of the shared worker, which also covers integrated JPEG. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c | 4 +++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c | 6 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c | 4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c  | 4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c  | 4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c  | 4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c  | 4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c  | 4 +++-
 drivers/gpu/drm/amd/amdgpu/vce_v2_0.c  | 6 +++++-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c  | 6 +++++-
 drivers/gpu/drm/amd/amdgpu/vce_v4_0.c  | 6 +++++-
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c  | 4 +++-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c  | 4 +++-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c  | 4 +++-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c  | 4 +++-
 15 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
index 8e20ae3f0f117..25f034d5bafb3 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -155,7 +155,9 @@ static int jpeg_v2_0_hw_init(void *handle)
 		(adev->doorbell_index.vcn.vcn_ring0_1 << 1), 0);
 
 	r = amdgpu_ring_test_helper(ring);
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->jpeg.idle_work);
+	else
 		DRM_INFO("JPEG decode initialized successfully.\n");
 
 	return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
index c682d1fab7f0d..db7a24c509779 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -169,12 +169,16 @@ static int jpeg_v2_5_hw_init(void *handle)
 
 		r = amdgpu_ring_test_helper(ring);
 		if (r)
-			return r;
+			goto error;
 	}
 
 	DRM_INFO("JPEG decode initialized successfully.\n");
 
 	return 0;
+
+error:
+	cancel_delayed_work_sync(&adev->jpeg.idle_work);
+	return r;
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
index 8c49a67bf0408..62b517699180e 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -144,8 +144,10 @@ static int jpeg_v3_0_hw_init(void *handle)
 		(adev->doorbell_index.vcn.vcn_ring0_1 << 1), 0);
 
 	r = amdgpu_ring_test_helper(ring);
-	if (r)
+	if (r) {
+		cancel_delayed_work_sync(&adev->jpeg.idle_work);
 		return r;
+	}
 
 	DRM_INFO("JPEG decode initialized successfully.\n");
 
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
index 3a27bed57b4ff..482007346fe14 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
@@ -712,7 +712,9 @@ static int uvd_v3_1_hw_init(void *handle)
 	amdgpu_ring_commit(ring);
 
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->uvd.idle_work);
+	else
 		DRM_INFO("UVD initialized successfully.\n");
 
 	return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c b/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c
index 01d8e7d2caf97..abcdf37f0cb15 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c
@@ -195,7 +195,9 @@ static int uvd_v4_2_hw_init(void *handle)
 	amdgpu_ring_commit(ring);
 
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->uvd.idle_work);
+	else
 		DRM_INFO("UVD initialized successfully.\n");
 
 	return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c b/drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c
index 563493d1f8306..ddc44841f3722 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c
@@ -192,7 +192,9 @@ static int uvd_v5_0_hw_init(void *handle)
 	amdgpu_ring_commit(ring);
 
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->uvd.idle_work);
+	else
 		DRM_INFO("UVD initialized successfully.\n");
 
 	return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
index 72f8762907681..0d8cd2e1ddb34 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
@@ -522,7 +522,9 @@ static int uvd_v6_0_hw_init(void *handle)
 	}
 
 done:
-	if (!r) {
+	if (r) {
+		cancel_delayed_work_sync(&adev->uvd.idle_work);
+	} else {
 		if (uvd_v6_0_enc_support(adev))
 			DRM_INFO("UVD and UVD ENC initialized successfully.\n");
 		else
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
index 1fd9ca21a091b..79cf2746aea16 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
@@ -589,7 +589,9 @@ static int uvd_v7_0_hw_init(void *handle)
 		}
 	}
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->uvd.idle_work);
+	else
 		DRM_INFO("UVD and UVD ENC initialized successfully.\n");
 
 	return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
index ddbcfcc70df5c..d9e690e5ff4a2 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
@@ -467,12 +467,16 @@ static int vce_v2_0_hw_init(void *handle)
 	for (i = 0; i < adev->vce.num_rings; i++) {
 		r = amdgpu_ring_test_helper(&adev->vce.ring[i]);
 		if (r)
-			return r;
+			goto error;
 	}
 
 	DRM_INFO("VCE initialized successfully.\n");
 
 	return 0;
+
+error:
+	cancel_delayed_work_sync(&adev->vce.idle_work);
+	return r;
 }
 
 static int vce_v2_0_hw_fini(void *handle)
diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
index 6095ddf1d7b79..fcf7ebad605c5 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -477,12 +477,16 @@ static int vce_v3_0_hw_init(void *handle)
 	for (i = 0; i < adev->vce.num_rings; i++) {
 		r = amdgpu_ring_test_helper(&adev->vce.ring[i]);
 		if (r)
-			return r;
+			goto error;
 	}
 
 	DRM_INFO("VCE initialized successfully.\n");
 
 	return 0;
+
+error:
+	cancel_delayed_work_sync(&adev->vce.idle_work);
+	return r;
 }
 
 static int vce_v3_0_hw_fini(void *handle)
diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v4_0.c
index 70b8c88d30513..2050b890bb4a3 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v4_0.c
@@ -530,12 +530,16 @@ static int vce_v4_0_hw_init(void *handle)
 	for (i = 0; i < adev->vce.num_rings; i++) {
 		r = amdgpu_ring_test_helper(&adev->vce.ring[i]);
 		if (r)
-			return r;
+			goto error;
 	}
 
 	DRM_INFO("VCE initialized successfully.\n");
 
 	return 0;
+
+error:
+	cancel_delayed_work_sync(&adev->vce.idle_work);
+	return r;
 }
 
 static int vce_v4_0_hw_fini(void *handle)
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
index 462008d506904..923a71350962c 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -213,7 +213,9 @@ static int vcn_v1_0_hw_init(void *handle)
 		goto done;
 
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->vcn.idle_work);
+	else
 		DRM_INFO("VCN decode and encode initialized successfully(under %s).\n",
 			(adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)?"DPG Mode":"SPG Mode");
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
index 02ae3e7a8a552..5eaf3e13d0efc 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -248,7 +248,9 @@ static int vcn_v2_0_hw_init(void *handle)
 	}
 
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->vcn.idle_work);
+	else
 		DRM_INFO("VCN decode and encode initialized successfully(under %s).\n",
 			(adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)?"DPG Mode":"SPG Mode");
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
index a0956d8623770..063d732869de5 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -307,7 +307,9 @@ static int vcn_v2_5_hw_init(void *handle)
 	}
 
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->vcn.idle_work);
+	else
 		DRM_INFO("VCN decode and encode initialized successfully(under %s).\n",
 			(adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)?"DPG Mode":"SPG Mode");
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 7085c1f45cf74..f1ad7fdd035fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -372,7 +372,9 @@ static int vcn_v3_0_hw_init(void *handle)
 	}
 
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->vcn.idle_work);
+	else
 		DRM_INFO("VCN decode and encode initialized successfully(under %s).\n",
 			(adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)?"DPG Mode":"SPG Mode");
 
-- 
2.53.0



