Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E964FC0D
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC7BC4339B;
	Mon, 15 May 2023 17:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171828;
	bh=5CV/s2cN3keCeAICktc3VTc2f2iHM8e/JV38SFz4V5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9E4aEp13eKOUzFHKmgiOVVUZFrwQcy+QiwhqOUMTIc/g621fyRrMZ2pQ2FkGGoij
	 iFvLInQhv3QwuHyUCpbHijPCmqX7ARg6enfU+lYt9kmwIv9hlYh/7d0KNGnpM3Icsc
	 KTBhO5nHEV0Lnr1xFY4FkcNaWwGBVJyXzpaNiNTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Lin.Cao" <lincao12@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 092/134] drm/amdgpu: Fix vram recover doesnt work after whole GPU reset (v2)
Date: Mon, 15 May 2023 18:29:29 +0200
Message-Id: <20230515161706.228119353@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lin.Cao <lincao12@amd.com>

commit 6c032c37ac3ef3b7df30937c785ecc4da428edc0 upstream.

v1: Vmbo->shadow is used to back vram bo up when vram lost. So that we
should set shadow as vmbo->shadow to recover vmbo->bo
v2: Modify if(vmbo->shadow) shadow = vmbo->shadow as if(!vmbo->shadow)
continue;

Fixes: e18aaea733da ("drm/amdgpu: move shadow_list to amdgpu_bo_vm")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Lin.Cao <lincao12@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4368,7 +4368,11 @@ static int amdgpu_device_recover_vram(st
 	dev_info(adev->dev, "recover vram bo from shadow start\n");
 	mutex_lock(&adev->shadow_list_lock);
 	list_for_each_entry(vmbo, &adev->shadow_list, shadow_list) {
-		shadow = &vmbo->bo;
+		/* If vm is compute context or adev is APU, shadow will be NULL */
+		if (!vmbo->shadow)
+			continue;
+		shadow = vmbo->shadow;
+
 		/* No need to recover an evicted BO */
 		if (shadow->tbo.resource->mem_type != TTM_PL_TT ||
 		    shadow->tbo.resource->start == AMDGPU_BO_INVALID_OFFSET ||


