Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6266A3AE5C
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EF7C433EF;
	Wed,  7 Jun 2023 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169750;
	bh=/ZQtRsJbOg2XX00OHxi8ngZFPwAIM6l/UIvEwv3Ew/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO4bIZpCVnySueD2e0TxqJdrveH/DexQktFeZvghoPgWW2uG2p2sVhAHVQCY3f71X
	 S2Pecv9m2b7Dp9ZI0FOGM0uAP+b9JDSOilufXPKmCnksXQZCcPBJuRaCpB6L6UhbIK
	 g/bH082Qaz1J6Cyyrex4ljnDeEOaFJdJm22zVKgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guchun Chen <guchun.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 170/286] drm/amdgpu: skip disabling fence driver src_irqs when device is unplugged
Date: Wed,  7 Jun 2023 22:14:29 +0200
Message-ID: <20230607200928.668722455@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit c1a322a7a4a96cd0a3dde32ce37af437a78bf8cd ]

When performing device unbind or halt, we have disabled all irqs at the
very begining like amdgpu_pci_remove or amdgpu_device_halt. So
amdgpu_irq_put for irqs stored in fence driver should not be called
any more, otherwise, below calltrace will arrive.

[  139.114088] WARNING: CPU: 2 PID: 1550 at drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c:616 amdgpu_irq_put+0xf6/0x110 [amdgpu]
[  139.114655] Call Trace:
[  139.114655]  <TASK>
[  139.114657]  amdgpu_fence_driver_hw_fini+0x93/0x130 [amdgpu]
[  139.114836]  amdgpu_device_fini_hw+0xb6/0x350 [amdgpu]
[  139.114955]  amdgpu_driver_unload_kms+0x51/0x70 [amdgpu]
[  139.115075]  amdgpu_pci_remove+0x63/0x160 [amdgpu]
[  139.115193]  ? __pm_runtime_resume+0x64/0x90
[  139.115195]  pci_device_remove+0x3a/0xb0
[  139.115197]  device_remove+0x43/0x70
[  139.115198]  device_release_driver_internal+0xbd/0x140

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index f52d0ba91a770..a7d250809da99 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -582,7 +582,8 @@ void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev)
 		if (r)
 			amdgpu_fence_driver_force_completion(ring);
 
-		if (ring->fence_drv.irq_src)
+		if (!drm_dev_is_unplugged(adev_to_drm(adev)) &&
+		    ring->fence_drv.irq_src)
 			amdgpu_irq_put(adev, ring->fence_drv.irq_src,
 				       ring->fence_drv.irq_type);
 
-- 
2.39.2



