Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931946FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BE7C433EF;
	Mon, 16 Jan 2023 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888147;
	bh=3egT90OQ9sgJi2rEEaM6f+kWpSgPMquYfgPPoGx3TvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1F9TcyF5VCAVxZGKlQQ86rWvDjh6sXAopVLIMoW4zlkjCZefVSlmxi80tTYMm4S1B
	 zkn33eK9zPBms4FwsBFvoK+0uidK0E2i74dpoZ0vOEkZuhXBU6bybnjp3V4Y1RAeUU
	 v07pOKQIo9EoQWXWsG2MpIRQTjKMQ3ErhV98Eq+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luben Tuikov <luben.tuikov@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 418/521] drm/amdgpu: make display pinning more flexible (v2)
Date: Mon, 16 Jan 2023 16:51:20 +0100
Message-Id: <20230116154905.818150796@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit 81d0bcf9900932633d270d5bc4a54ff599c6ebdb upstream.

Only apply the static threshold for Stoney and Carrizo.
This hardware has certain requirements that don't allow
mixing of GTT and VRAM.  Newer asics do not have these
requirements so we should be able to be more flexible
with where buffers end up.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2270
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2291
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2255
Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1387,7 +1387,8 @@ u64 amdgpu_bo_gpu_offset(struct amdgpu_b
 uint32_t amdgpu_bo_get_preferred_pin_domain(struct amdgpu_device *adev,
 					    uint32_t domain)
 {
-	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
+	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
+	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
 		domain = AMDGPU_GEM_DOMAIN_VRAM;
 		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
 			domain = AMDGPU_GEM_DOMAIN_GTT;


