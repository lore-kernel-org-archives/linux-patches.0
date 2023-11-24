Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E1435EE6;
	Fri, 24 Nov 2023 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HK+KdCGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889C3C433C7;
	Fri, 24 Nov 2023 19:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853226;
	bh=rFLuAJinI5QhcxIpJZ42avqIpILAn2hJB+HF2aIYmeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HK+KdCGHSA22p8Tf678jlS9FnyKxxSx5nhEqJjf4GLH1gV51orwD6FhoLxaibVqvb
	 JPy9TJmwVkY4oQRr31Yb7lpAdrTPq/E1c6G7/lnTcE2iffviQOh+AQUUtPcwhQEe4y
	 Ym9X4qUfY3lHH5QFXRkBWjadNAjDXIcEy1M1qu08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <hawking.zhang@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/297] drm/amdgpu: fix software pci_unplug on some chips
Date: Fri, 24 Nov 2023 17:52:02 +0000
Message-ID: <20231124172003.049514976@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit 4638e0c29a3f2294d5de0d052a4b8c9f33ccb957 ]

When software 'pci unplug' using IGT is executed we got a sysfs directory
entry is NULL for differant ras blocks like hdp, umc, etc.
Before call 'sysfs_remove_file_from_group' and 'sysfs_remove_group'
check that 'sd' is  not NULL.

[  +0.000001] RIP: 0010:sysfs_remove_group+0x83/0x90
[  +0.000002] Code: 31 c0 31 d2 31 f6 31 ff e9 9a a8 b4 00 4c 89 e7 e8 f2 a2 ff ff eb c2 49 8b 55 00 48 8b 33 48 c7 c7 80 65 94 82 e8 cd 82 bb ff <0f> 0b eb cc 66 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
[  +0.000001] RSP: 0018:ffffc90002067c90 EFLAGS: 00010246
[  +0.000002] RAX: 0000000000000000 RBX: ffffffff824ea180 RCX: 0000000000000000
[  +0.000001] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  +0.000001] RBP: ffffc90002067ca8 R08: 0000000000000000 R09: 0000000000000000
[  +0.000001] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  +0.000001] R13: ffff88810a395f48 R14: ffff888101aab0d0 R15: 0000000000000000
[  +0.000001] FS:  00007f5ddaa43a00(0000) GS:ffff88841e800000(0000) knlGS:0000000000000000
[  +0.000002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000001] CR2: 00007f8ffa61ba50 CR3: 0000000106432000 CR4: 0000000000350ef0
[  +0.000001] Call Trace:
[  +0.000001]  <TASK>
[  +0.000001]  ? show_regs+0x72/0x90
[  +0.000002]  ? sysfs_remove_group+0x83/0x90
[  +0.000002]  ? __warn+0x8d/0x160
[  +0.000001]  ? sysfs_remove_group+0x83/0x90
[  +0.000001]  ? report_bug+0x1bb/0x1d0
[  +0.000003]  ? handle_bug+0x46/0x90
[  +0.000001]  ? exc_invalid_op+0x19/0x80
[  +0.000002]  ? asm_exc_invalid_op+0x1b/0x20
[  +0.000003]  ? sysfs_remove_group+0x83/0x90
[  +0.000001]  dpm_sysfs_remove+0x61/0x70
[  +0.000002]  device_del+0xa3/0x3d0
[  +0.000002]  ? ktime_get_mono_fast_ns+0x46/0xb0
[  +0.000002]  device_unregister+0x18/0x70
[  +0.000001]  i2c_del_adapter+0x26d/0x330
[  +0.000002]  arcturus_i2c_control_fini+0x25/0x50 [amdgpu]
[  +0.000236]  smu_sw_fini+0x38/0x260 [amdgpu]
[  +0.000241]  amdgpu_device_fini_sw+0x116/0x670 [amdgpu]
[  +0.000186]  ? mutex_lock+0x13/0x50
[  +0.000003]  amdgpu_driver_release_kms+0x16/0x40 [amdgpu]
[  +0.000192]  drm_minor_release+0x4f/0x80 [drm]
[  +0.000025]  drm_release+0xfe/0x150 [drm]
[  +0.000027]  __fput+0x9f/0x290
[  +0.000002]  ____fput+0xe/0x20
[  +0.000002]  task_work_run+0x61/0xa0
[  +0.000002]  exit_to_user_mode_prepare+0x150/0x170
[  +0.000002]  syscall_exit_to_user_mode+0x2a/0x50

Cc: Hawking Zhang <hawking.zhang@amd.com>
Cc: Luben Tuikov <luben.tuikov@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 96a8fd0ca1df3..439ea256ed252 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1192,7 +1192,8 @@ static void amdgpu_ras_sysfs_remove_bad_page_node(struct amdgpu_device *adev)
 {
 	struct amdgpu_ras *con = amdgpu_ras_get_context(adev);
 
-	sysfs_remove_file_from_group(&adev->dev->kobj,
+	if (adev->dev->kobj.sd)
+		sysfs_remove_file_from_group(&adev->dev->kobj,
 				&con->badpages_attr.attr,
 				RAS_FS_NAME);
 }
@@ -1209,7 +1210,8 @@ static int amdgpu_ras_sysfs_remove_feature_node(struct amdgpu_device *adev)
 		.attrs = attrs,
 	};
 
-	sysfs_remove_group(&adev->dev->kobj, &group);
+	if (adev->dev->kobj.sd)
+		sysfs_remove_group(&adev->dev->kobj, &group);
 
 	return 0;
 }
@@ -1257,7 +1259,8 @@ int amdgpu_ras_sysfs_remove(struct amdgpu_device *adev,
 	if (!obj || !obj->attr_inuse)
 		return -EINVAL;
 
-	sysfs_remove_file_from_group(&adev->dev->kobj,
+	if (adev->dev->kobj.sd)
+		sysfs_remove_file_from_group(&adev->dev->kobj,
 				&obj->sysfs_attr.attr,
 				RAS_FS_NAME);
 	obj->attr_inuse = 0;
-- 
2.42.0



