Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A4137AA9E;
	Mon,  9 Feb 2026 14:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647371; cv=none; b=dmm9VFAZnihABeKKY+qtuRsLoIImDc26XNC3GwFAunPs5a1JtLX2aVbHlBlpSVyvF21r83yHY+3jHca5w3ZQKULbOosq3B+/JwTW3gZiGF2QoVqRqd5zCK6Bvzt/jgtWgae4Sc4YITyHJvmcK0dh+yVzykrGfPRwqdrnDYau9fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647371; c=relaxed/simple;
	bh=R6Q19zLV1ugv2sqlB8VtbkDUfPtYITxD/QL9qoFtP7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUfFLgHX91gOOdyxCKDMU4ARnItd045mx91lVG/PctRpBDIJV3yRNEJ2A8IID8bYg15Yh+Inz1XVMUqs+GfOMnJs/71h799ygs77JVFyW5Jw3nllS4tACZyshdmGwhp9JKbCFQ6N0sDCL5r4sXpD882Qc/1Xu5v0pXkHmsbgzfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0F0rVzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0F0rVzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19657C116C6;
	Mon,  9 Feb 2026 14:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647371;
	bh=R6Q19zLV1ugv2sqlB8VtbkDUfPtYITxD/QL9qoFtP7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0F0rVzFdgwNoe/3cw8smVomsv1+P66flYN6woWUkVeH7eDBbSPVIDefDtUDrrBVo
	 1mit1nmcJai3iK9LuF4UaejhXer3/G1uBtM0LfC56Rb1bABlBZbk9pOyRu4jq1CamK
	 d72EwAH3bQkmAmWGy9MgJZWhZficQVc/AuE1Iin4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/175] drm/amd/pm: Disable MMIO access during SMU Mode 1 reset
Date: Mon,  9 Feb 2026 15:22:32 +0100
Message-ID: <20260209142323.285461750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit 0de604d0357d0d22cbf03af1077d174b641707b6 ]

During Mode 1 reset, the ASIC undergoes a reset cycle and becomes
temporarily inaccessible via PCIe. Any attempt to access MMIO registers
during this window (e.g., from interrupt handlers or other driver threads)
can result in uncompleted PCIe transactions, leading to NMI panics or
system hangs.

To prevent this, set the `no_hw_access` flag to true immediately after
triggering the reset. This signals other driver components to skip
register accesses while the device is offline.

A memory barrier `smp_mb()` is added to ensure the flag update is
globally visible to all cores before the driver enters the sleep/wait
state.

Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7edb503fe4b6d67f47d8bb0dfafb8e699bb0f8a4)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c           | 3 +++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 7 ++++++-
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c | 9 +++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 49107475af619..53b33a636971a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5739,6 +5739,9 @@ int amdgpu_device_mode1_reset(struct amdgpu_device *adev)
 	if (ret)
 		goto mode1_reset_failed;
 
+	/* enable mmio access after mode 1 reset completed */
+	adev->no_hw_access = false;
+
 	amdgpu_device_load_pci_state(adev->pdev);
 	ret = amdgpu_psp_wait_for_bootloader(adev);
 	if (ret)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index c1062e5f03936..8d070a9ea2c10 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2922,8 +2922,13 @@ static int smu_v13_0_0_mode1_reset(struct smu_context *smu)
 		break;
 	}
 
-	if (!ret)
+	if (!ret) {
+		/* disable mmio access while doing mode 1 reset*/
+		smu->adev->no_hw_access = true;
+		/* ensure no_hw_access is globally visible before any MMIO */
+		smp_mb();
 		msleep(SMU13_MODE1_RESET_WAIT_TIME_IN_MS);
+	}
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
index e735da7ab6126..bad8dd786bff2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2143,10 +2143,15 @@ static int smu_v14_0_2_mode1_reset(struct smu_context *smu)
 
 	ret = smu_cmn_send_debug_smc_msg(smu, DEBUGSMC_MSG_Mode1Reset);
 	if (!ret) {
-		if (amdgpu_emu_mode == 1)
+		if (amdgpu_emu_mode == 1) {
 			msleep(50000);
-		else
+		} else {
+			/* disable mmio access while doing mode 1 reset*/
+			smu->adev->no_hw_access = true;
+			/* ensure no_hw_access is globally visible before any MMIO */
+			smp_mb();
 			msleep(1000);
+		}
 	}
 
 	return ret;
-- 
2.51.0



