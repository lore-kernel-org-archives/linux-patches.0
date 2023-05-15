Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D722EFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDB6C433D2;
	Mon, 15 May 2023 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169874;
	bh=OcebkbZRy50ImBlQ5tANGP4fgofkc2XBtM8xhAigonQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcmQyOdSeVDX56ZNyjpT/SD6Rg3qpl4R+Ar8I1+Ysd+AypHIY5YgLLVv37VLADowP
	 BrJUvLcgRruqVQbyTWx5lHZ7ZvrzjyJfHcD2CfQk9gKewHgmCHdI9/nRuIc3LGLqoq
	 MJnUTDvZGxTgF75mDwZWD7TaIRalHjtnXOp8jibk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatio Zhang <Hongkun.Zhang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 199/246] drm/amdgpu: fix amdgpu_irq_put call trace in gmc_v11_0_hw_fini
Date: Mon, 15 May 2023 18:26:51 +0200
Message-Id: <20230515161728.581485103@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Horatio Zhang <Hongkun.Zhang@amd.com>

commit 13af556104fa93b1945c70bbf8a0a62cd2c92879 upstream.

The gmc.ecc_irq is enabled by firmware per IFWI setting,
and the host driver is not privileged to enable/disable
the interrupt. So, it is meaningless to use the amdgpu_irq_put
function in gmc_v11_0_hw_fini, which also leads to the call
trace.

[  102.980303] Call Trace:
[  102.980303]  <TASK>
[  102.980304]  gmc_v11_0_hw_fini+0x54/0x90 [amdgpu]
[  102.980357]  gmc_v11_0_suspend+0xe/0x20 [amdgpu]
[  102.980409]  amdgpu_device_ip_suspend_phase2+0x240/0x460 [amdgpu]
[  102.980459]  amdgpu_device_ip_suspend+0x3d/0x80 [amdgpu]
[  102.980520]  amdgpu_device_pre_asic_reset+0xd9/0x490 [amdgpu]
[  102.980573]  amdgpu_device_gpu_recover.cold+0x548/0xce6 [amdgpu]
[  102.980687]  amdgpu_debugfs_reset_work+0x4c/0x70 [amdgpu]
[  102.980740]  process_one_work+0x21f/0x3f0
[  102.980741]  worker_thread+0x200/0x3e0
[  102.980742]  ? process_one_work+0x3f0/0x3f0
[  102.980743]  kthread+0xfd/0x130
[  102.980743]  ? kthread_complete_and_exit+0x20/0x20
[  102.980744]  ret_from_fork+0x22/0x30

Signed-off-by: Horatio Zhang <Hongkun.Zhang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2522
Fixes: c8b5a95b5709 ("drm/amdgpu: Fix desktop freezed after gpu-reset")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
@@ -954,7 +954,6 @@ static int gmc_v11_0_hw_fini(void *handl
 		return 0;
 	}
 
-	amdgpu_irq_put(adev, &adev->gmc.ecc_irq, 0);
 	amdgpu_irq_put(adev, &adev->gmc.vm_fault, 0);
 	gmc_v11_0_gart_disable(adev);
 


