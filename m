Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F1B125B2;
	Mon,  9 Feb 2026 14:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647874; cv=none; b=QPk3uLS4RT5wXkc4fd2tdQPhCcop8utc9jgsaVqHGXS50khRvdWzOnNrF0T4xA4QBr+fGXvWkSQhn6FfGbvjcgHk1iQJCZglYdcqmr4r3CWQWz0+9h95HmlgxzU5AYpjrfbjPbzMGyLdZzpVhe0NsczOLLXp4jAzzuIiMTmnloQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647874; c=relaxed/simple;
	bh=CccUSdBbNzAZQUhgcHCeppmOCrUNTRr1RXXviYbuRh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOwSeJe02GTK46t9KccYS4/TYhT1QUS5HoOkb148+uX2I7FlKa5CgPml42RupPiMjuDj6IX3iDe3n4P9rkXXJoMhiUiN7t7q69BS6OypWdeGhfMigseez/XSy+MqwRYNrga4hC0J7HkL37w+UD/rxRtYJa0C13NOXjyDYvQ2Emw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxNzN0lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxNzN0lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3A4C116C6;
	Mon,  9 Feb 2026 14:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647874;
	bh=CccUSdBbNzAZQUhgcHCeppmOCrUNTRr1RXXviYbuRh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxNzN0lcTI0R8/55NhW8/YLFVU/6UMUUG0SUL1LbRUZKIWjAcsNAqK0Y75GC30bzv
	 dHjAGnkzTGQddv9KWro9AtnYyw2l7jwETuHfPMYoVBVq8V1lk83bbJzWkA8eqGuxSL
	 srAhBS5uG6OVvF+DpyGP4WSqs69dwSxxfflXNQ4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/113] drm/amd/pm: Disable MMIO access during SMU Mode 1 reset
Date: Mon,  9 Feb 2026 15:23:22 +0100
Message-ID: <20260209142312.108179491@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fb5d2de035df0..1cf90557b310b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5325,6 +5325,9 @@ int amdgpu_device_mode1_reset(struct amdgpu_device *adev)
 	if (ret)
 		goto mode1_reset_failed;
 
+	/* enable mmio access after mode 1 reset completed */
+	adev->no_hw_access = false;
+
 	amdgpu_device_load_pci_state(adev->pdev);
 	ret = amdgpu_psp_wait_for_bootloader(adev);
 	if (ret)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 5a0a10144a73f..d83f04b282534 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2853,8 +2853,13 @@ static int smu_v13_0_0_mode1_reset(struct smu_context *smu)
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
index f34cef26b382c..3bab8269a46aa 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2129,10 +2129,15 @@ static int smu_v14_0_2_mode1_reset(struct smu_context *smu)
 
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



