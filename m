Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047470;
	b=RGfjJ1jqIxnVq4h3aN1gf1+39pM5DoSpzOV6Dh13VJ+CJjK3srs0mUB+4l/J+4TrmnzD
	 hMKJpramTWYwilRHE23Zxl4TPycnhpKoxiRPzHYeN+AeJpDeDVPgGtlfDXqfk2+PLT3pt
	 /gUvQJ3Dm6bZi7/roZFUrJpwlgcDKA4w1JgFJfBLGGrLbDE6RCWm8WDTELrAqPtoH4IVT
	 KTwV00qMEdqRdmFqatMmovDxdR9kCb1VzqCeaJHRKEHs0M+UIhf7tC1jfdmhh6hoSrg6K
	 dnO4QZWe/dTB8edRmmACzsJS7LlwSwo6rCr+FZfeWVHIgJBr8zpkwaeBwlOcTWuADcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=907rF09PjvHw3U/GMreMWbz2EqAIuEeSi7weDZ103bU=;
	b=gasx4ltERuJoCKisvI7b995jHBqkUw59aa32f0O+bpXQOICaTafCMZF7THGcFJCug/Ly
	 eh9AtSHZlve92/tJtCvVJMuKISZP9vLN1kB0Iif6ZcbD+/xVzgWjpN06HRX/kSc4m+t6U
	 WNkj6G/YaCYhoiaUV5EXKrGh91fzQeilcb90/wNTfD2wNUzKAoBnssTME4QZRZYXaPYyh
	 5pF0L06uVHTiPyRg65Sy6tNnsDX1SchrjyKfDBK9jIT35c+thlCTYm4h7CruOf/kuh4W7
	 iJ6LxeEx8/91iPzg1R9QaOyiS/gmKSPiqom00tTEGurwHUVIE17m6RIvIQgsuUCHEhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJYYYUCA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6DF606A320;
	Thu, 19 Nov 2026 00:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJYYYUCA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B001F000C4;
	Thu, 19 Nov 2026 00:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047470;
	bh=907rF09PjvHw3U/GMreMWbz2EqAIuEeSi7weDZ103bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJYYYUCAhMk+MNDFL/R/2i0DOIdWYHNHLGd9cKiVq8Rc7o2xDR3712PxZSiRoOa4t
	 dzqkNJq1YkiRnclPdXpspxw4jKJrXU7JthpVTnqYGV2pTkm8uzaK5Ny1eKhHR24/Z/
	 3mKUE997qLTi2OecKg6jENroWpYV1bqbmylxhAnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1651/2857] drm/amdgpu: cancel idle work in hw_init failure paths for vcn/uvd/vce/jpeg
Date: Wed, 18 Nov 2026 15:44:45 +0100
Message-ID: <20261118150300.779162228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced per-instance VCN cancellation loops with a single cancellation of the shared VCN idle worker. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c |  4 +++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c |  6 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c |  8 ++++----
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c |  6 +++++-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c  |  4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c  |  4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c  |  4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c  |  4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c  |  4 +++-
 drivers/gpu/drm/amd/amdgpu/vce_v2_0.c  |  6 +++++-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c  |  6 +++++-
 drivers/gpu/drm/amd/amdgpu/vce_v4_0.c  |  6 +++++-
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c  | 17 ++++++++++-------
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c  |  4 +++-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c  |  4 +++-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c  |  4 +++-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c  |  4 +++-
 17 files changed, 69 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
index af8f244e9c940..f54a3dc761fd4 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -135,7 +135,9 @@ static int jpeg_v2_0_hw_init(void *handle)
 		(adev->doorbell_index.vcn.vcn_ring0_1 << 1), 0);
 
 	r = amdgpu_ring_test_helper(ring);
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->jpeg.idle_work);
+	else
 		DRM_INFO("JPEG decode initialized successfully.\n");
 
 	return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
index a094dd138c0d5..6e617209c082b 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -184,12 +184,16 @@ static int jpeg_v2_5_hw_init(void *handle)
 
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
index 54cbf62a8deac..d003d8277c584 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -151,11 +151,11 @@ static int jpeg_v3_0_hw_init(void *handle)
 
 	r = amdgpu_ring_test_helper(ring);
 	if (r)
-		return r;
-
-	DRM_INFO("JPEG decode initialized successfully.\n");
+		cancel_delayed_work_sync(&adev->jpeg.idle_work);
+	else
+		DRM_INFO("JPEG decode initialized successfully.\n");
 
-	return 0;
+	return r;
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
index ae9e390c8bf6b..5ebe2d42cb396 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
@@ -143,11 +143,15 @@ static int jpeg_v4_0_hw_init(void *handle)
 
 	r = amdgpu_ring_test_helper(ring);
 	if (r)
-		return r;
+		goto error;
 
 	DRM_DEV_INFO(adev->dev, "JPEG decode initialized successfully.\n");
 
 	return 0;
+
+error:
+	cancel_delayed_work_sync(&adev->jpeg.idle_work);
+	return r;
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
index adb9f5cb95c23..13e50191d10ee 100644
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
index d7e31e48a2b8d..ae24b92e00d5b 100644
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
index 5fe872f4bea7e..cc1c1949fe2f5 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
@@ -513,7 +513,9 @@ static int uvd_v6_0_hw_init(void *handle)
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
index 91ef914b4cdc7..3f370883de568 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
@@ -581,7 +581,9 @@ static int uvd_v7_0_hw_init(void *handle)
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
index 479eb9382c77e..03e8543604dfd 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
@@ -469,12 +469,16 @@ static int vce_v2_0_hw_init(void *handle)
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
index 27b2c4c7c63ee..26a5744ac407d 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -479,12 +479,16 @@ static int vce_v3_0_hw_init(void *handle)
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
index 66cd3d11aa4b8..28de74c9bd4e8 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v4_0.c
@@ -532,12 +532,16 @@ static int vce_v4_0_hw_init(void *handle)
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
index f0fbcda76f5e3..094cdb16d566a 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -199,25 +199,28 @@ static int vcn_v1_0_hw_init(void *handle)
 
 	r = amdgpu_ring_test_helper(ring);
 	if (r)
-		goto done;
+		goto error_vcn;
 
 	for (i = 0; i < adev->vcn.num_enc_rings; ++i) {
 		ring = &adev->vcn.inst->ring_enc[i];
 		r = amdgpu_ring_test_helper(ring);
 		if (r)
-			goto done;
+			goto error_vcn;
 	}
 
 	ring = &adev->jpeg.inst->ring_dec;
 	r = amdgpu_ring_test_helper(ring);
 	if (r)
-		goto done;
+		goto error_both;
 
-done:
-	if (!r)
-		DRM_INFO("VCN decode and encode initialized successfully(under %s).\n",
-			(adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)?"DPG Mode":"SPG Mode");
+	DRM_INFO("VCN decode and encode initialized successfully(under %s).\n",
+		(adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)?"DPG Mode":"SPG Mode");
+	return 0;
 
+error_both:
+	cancel_delayed_work_sync(&adev->jpeg.idle_work);
+error_vcn:
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
 	return r;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
index c271f3f0c70a1..52d454126b9e6 100644
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
index f2a07794a2868..067df13a36b29 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c
@@ -309,7 +309,9 @@ static int vcn_v2_5_hw_init(void *handle)
 	}
 
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->vcn.idle_work);
+	else
 		DRM_INFO("VCN decode and encode initialized successfully(under %s).\n",
 			(adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)?"DPG Mode":"SPG Mode");
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index b73c642b7dc61..15e7ddce879dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -355,7 +355,9 @@ static int vcn_v3_0_hw_init(void *handle)
 	}
 
 done:
-	if (!r)
+	if (r)
+		cancel_delayed_work_sync(&adev->vcn.idle_work);
+	else
 		DRM_INFO("VCN decode and encode initialized successfully(under %s).\n",
 			(adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG)?"DPG Mode":"SPG Mode");
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index 608ee2a4d6275..83d997f8d500a 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -261,7 +261,9 @@ static int vcn_v4_0_hw_init(void *handle)
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



