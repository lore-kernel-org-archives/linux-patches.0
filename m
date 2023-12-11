Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835F65102A;
	Mon, 11 Dec 2023 18:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1U5GOH1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AB0C433C8;
	Mon, 11 Dec 2023 18:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320684;
	bh=n8KWG4ToQwMdY5zPQwM4iRBXobbHpfA2awrwaGZKHVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1U5GOH1uoQkbteMEKVmcdS8kxyEgBpdeBG+HvwzmDpcbbAblJ+j1Z9Qxk0JuuMTjI
	 D9iaswh7vBRPXFF+4Rf7c1U4QDR7DN76vKVaXKikq7Z3Euvl7r9dS12vq4dZhLjhGY
	 sHgLEyYvooSlEvZMEGbu+Zc6O/jqBuZTV/lM+S/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/194] drm/amdgpu: fix memory overflow in the IB test
Date: Mon, 11 Dec 2023 19:22:23 +0100
Message-ID: <20231211182043.481747623@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 6b0b7789a7a5f3e69185449f891beea58e563f9b ]

Fix a memory overflow issue in the gfx IB test
for some ASICs. At least 20 bytes are needed for
the IB test packet.

v2: correct code indentation errors. (Christian)

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c  | 4 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c  | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 23e7e5126eae6..66a6f7a37ebcf 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -397,7 +397,7 @@ static int gfx_v11_0_ring_test_ib(struct amdgpu_ring *ring, long timeout)
 		adev->wb.wb[index] = cpu_to_le32(0xCAFEDEAD);
 		cpu_ptr = &adev->wb.wb[index];
 
-		r = amdgpu_ib_get(adev, NULL, 16, AMDGPU_IB_POOL_DIRECT, &ib);
+		r = amdgpu_ib_get(adev, NULL, 20, AMDGPU_IB_POOL_DIRECT, &ib);
 		if (r) {
 			DRM_ERROR("amdgpu: failed to get ib (%ld).\n", r);
 			goto err1;
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index 7f0b18b0d4c48..71ef25425c7f6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -883,8 +883,8 @@ static int gfx_v8_0_ring_test_ib(struct amdgpu_ring *ring, long timeout)
 	gpu_addr = adev->wb.gpu_addr + (index * 4);
 	adev->wb.wb[index] = cpu_to_le32(0xCAFEDEAD);
 	memset(&ib, 0, sizeof(ib));
-	r = amdgpu_ib_get(adev, NULL, 16,
-					AMDGPU_IB_POOL_DIRECT, &ib);
+
+	r = amdgpu_ib_get(adev, NULL, 20, AMDGPU_IB_POOL_DIRECT, &ib);
 	if (r)
 		goto err1;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index fe371022e5104..84ca601f7d5f3 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1034,8 +1034,8 @@ static int gfx_v9_0_ring_test_ib(struct amdgpu_ring *ring, long timeout)
 	gpu_addr = adev->wb.gpu_addr + (index * 4);
 	adev->wb.wb[index] = cpu_to_le32(0xCAFEDEAD);
 	memset(&ib, 0, sizeof(ib));
-	r = amdgpu_ib_get(adev, NULL, 16,
-					AMDGPU_IB_POOL_DIRECT, &ib);
+
+	r = amdgpu_ib_get(adev, NULL, 20, AMDGPU_IB_POOL_DIRECT, &ib);
 	if (r)
 		goto err1;
 
-- 
2.42.0



