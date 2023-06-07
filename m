Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9902E34CD3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7BAC433D2;
	Wed,  7 Jun 2023 20:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170386;
	bh=nZUplXiiIU6VxfNuZZPVbRGQyDLiDfLgwOKHV5Tdrvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5VMvujkJtR4ZSaF3Pt5BVv9L0Ikqs1SvxNbw7gNtW7kUwJcyI83R9WerQDpYMG2L
	 bfcM5iJHpzNEVzM8Bh4Ub71ILlzB/1lOXbtJdbSTURwpXSESYUMzrzpWxJ6FR8MdgF
	 U3DekRuXdaUXXZ/D0NQnrGHr2yYD3q5z0zfB5D50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lyndonli <Lyndon.Li@amd.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/225] drm/amdgpu: Use the default reset when loading or reloading the driver
Date: Wed,  7 Jun 2023 22:14:18 +0200
Message-ID: <20230607200916.487679150@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: lyndonli <Lyndon.Li@amd.com>

[ Upstream commit 4eea7fb980dc44545a32eec92e2662053b34cd9d ]

Below call trace and errors are observed when reloading
amdgpu driver with the module parameter reset_method=3.

It should do a default reset when loading or reloading the
driver, regardless of the module parameter reset_method.

v2: add comments inside and modify commit messages.

[  +2.180243] [drm] psp gfx command ID_LOAD_TOC(0x20) failed
and response status is (0x0)
[  +0.000011] [drm:psp_hw_start [amdgpu]] *ERROR* Failed to load toc
[  +0.000890] [drm:psp_hw_start [amdgpu]] *ERROR* PSP tmr init failed!
[  +0.020683] [drm:amdgpu_fill_buffer [amdgpu]] *ERROR* Trying to
clear memory with ring turned off.
[  +0.000003] RIP: 0010:amdgpu_bo_release_notify+0x1ef/0x210 [amdgpu]
[  +0.000004] Call Trace:
[  +0.000003]  <TASK>
[  +0.000008]  ttm_bo_release+0x2c4/0x330 [amdttm]
[  +0.000026]  amdttm_bo_put+0x3c/0x70 [amdttm]
[  +0.000020]  amdgpu_bo_free_kernel+0xe6/0x140 [amdgpu]
[  +0.000728]  psp_v11_0_ring_destroy+0x34/0x60 [amdgpu]
[  +0.000826]  psp_hw_init+0xe7/0x2f0 [amdgpu]
[  +0.000813]  amdgpu_device_fw_loading+0x1ad/0x2d0 [amdgpu]
[  +0.000731]  amdgpu_device_init.cold+0x108e/0x2002 [amdgpu]
[  +0.001071]  ? do_pci_enable_device+0xe1/0x110
[  +0.000011]  amdgpu_driver_load_kms+0x1a/0x160 [amdgpu]
[  +0.000729]  amdgpu_pci_probe+0x179/0x3a0 [amdgpu]

Signed-off-by: lyndonli <Lyndon.Li@amd.com>
Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c83df8b78b7de..9556df0dfefad 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3555,6 +3555,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	int r, i;
 	bool px = false;
 	u32 max_MBps;
+	int tmp;
 
 	adev->shutdown = false;
 	adev->flags = flags;
@@ -3776,7 +3777,13 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 				}
 			}
 		} else {
+			tmp = amdgpu_reset_method;
+			/* It should do a default reset when loading or reloading the driver,
+			 * regardless of the module parameter reset_method.
+			 */
+			amdgpu_reset_method = AMD_RESET_METHOD_NONE;
 			r = amdgpu_asic_reset(adev);
+			amdgpu_reset_method = tmp;
 			if (r) {
 				dev_err(adev->dev, "asic reset on init failed\n");
 				goto failed;
-- 
2.39.2



