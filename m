Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6111E6AA0;
	Tue,  5 Dec 2023 03:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTB3eSII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAED1C433C7;
	Tue,  5 Dec 2023 03:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746516;
	bh=Gvg7rFOfJsBjaJpFhK7sMYJPYT5R6VCjlKDoeZmgM+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTB3eSII2U2jEOKkSYb+3m1mIh3aK/Jqp+HPhBYlgYu6cp1t2avDBLYgCZysR1Cu0
	 CSBZipkiYv7LBGv9F5i08l6ATKJyjmQmNzz87VlIHJsTNIGg7wYWaCKXZDvAfdcCUD
	 V/+zayFBoD1IC6oUgsKz2dEWQ6eXhrU2npjxsp00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 029/134] drm/amdgpu: fix memory overflow in the IB test
Date: Tue,  5 Dec 2023 12:15:01 +0900
Message-ID: <20231205031537.282009771@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

commit 6b0b7789a7a5f3e69185449f891beea58e563f9b upstream.

Fix a memory overflow issue in the gfx IB test
for some ASICs. At least 20 bytes are needed for
the IB test packet.

v2: correct code indentation errors. (Christian)

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c  |    2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c   |    4 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c   |    4 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -398,7 +398,7 @@ static int gfx_v11_0_ring_test_ib(struct
 		adev->wb.wb[index] = cpu_to_le32(0xCAFEDEAD);
 		cpu_ptr = &adev->wb.wb[index];
 
-		r = amdgpu_ib_get(adev, NULL, 16, AMDGPU_IB_POOL_DIRECT, &ib);
+		r = amdgpu_ib_get(adev, NULL, 20, AMDGPU_IB_POOL_DIRECT, &ib);
 		if (r) {
 			DRM_ERROR("amdgpu: failed to get ib (%ld).\n", r);
 			goto err1;
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -883,8 +883,8 @@ static int gfx_v8_0_ring_test_ib(struct
 	gpu_addr = adev->wb.gpu_addr + (index * 4);
 	adev->wb.wb[index] = cpu_to_le32(0xCAFEDEAD);
 	memset(&ib, 0, sizeof(ib));
-	r = amdgpu_ib_get(adev, NULL, 16,
-					AMDGPU_IB_POOL_DIRECT, &ib);
+
+	r = amdgpu_ib_get(adev, NULL, 20, AMDGPU_IB_POOL_DIRECT, &ib);
 	if (r)
 		goto err1;
 
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1039,8 +1039,8 @@ static int gfx_v9_0_ring_test_ib(struct
 	gpu_addr = adev->wb.gpu_addr + (index * 4);
 	adev->wb.wb[index] = cpu_to_le32(0xCAFEDEAD);
 	memset(&ib, 0, sizeof(ib));
-	r = amdgpu_ib_get(adev, NULL, 16,
-					AMDGPU_IB_POOL_DIRECT, &ib);
+
+	r = amdgpu_ib_get(adev, NULL, 20, AMDGPU_IB_POOL_DIRECT, &ib);
 	if (r)
 		goto err1;
 
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -296,8 +296,8 @@ static int gfx_v9_4_3_ring_test_ib(struc
 	gpu_addr = adev->wb.gpu_addr + (index * 4);
 	adev->wb.wb[index] = cpu_to_le32(0xCAFEDEAD);
 	memset(&ib, 0, sizeof(ib));
-	r = amdgpu_ib_get(adev, NULL, 16,
-			  AMDGPU_IB_POOL_DIRECT, &ib);
+
+	r = amdgpu_ib_get(adev, NULL, 20, AMDGPU_IB_POOL_DIRECT, &ib);
 	if (r)
 		goto err1;
 


