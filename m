Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998492DB79C;
	Mon, 12 Jan 2026 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229940; cv=none; b=bdBCoU4pihZOVXLNIIfjfTXClp9nPnCpKhPf6Y/3lulgZQQ4lNHk/SWzqUzZT+o92OuxkUviRAenosOGGsTWBY+jLOSAzV/5XRazypZ8Lsyu6wUtXgJqRlnkhGa5z7T8rXs8fa/tYauIVjECcdi+0T+WX8JfP3IRLSdoazgm6fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229940; c=relaxed/simple;
	bh=yDuxJLWzF6kgfc2MCgc5E0fSNJNKC2uW57/u00KiBKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhdrlBiNAePhdrtnS7W+NDQQKxuvykm3u8qo+SGEnX54I0g4nV9NtIL5LEgee5J++rKf4cEA0FyScZp8S7axeO67gKolUV2CLmeQoH4nMgwd7QydLsgvBZpmgMox0iaT9W9X8hGdXCJG0Tg/7OoMMT8sKQjbq9dLQG83B0nw9OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SxobM8hO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SxobM8hO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804B3C16AAE;
	Mon, 12 Jan 2026 14:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229940;
	bh=yDuxJLWzF6kgfc2MCgc5E0fSNJNKC2uW57/u00KiBKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxobM8hOus9COszhWDayy0ubPfKikSUKL0DN6khSE6AixrAIRagIxCGxg6LuJ9zyU
	 WUGoKee/EmgAKj/yvhP7/+/k2yYQcCzacwa+WSEYwWDEh7EuSyY/XqMvk5GZOJLpsJ
	 hz4HncunV09itW37g7Nv+AWnEwH54z6OXk+7Dz+ALXIdTL8qgN/qORrgu5G9P35KQD
	 +4FfKWGg9Y4dsWk1bLdcQGd7Ov1rjvWxKcl+n7TLUbwIm1qaxH3tcANCwgmwNrUqaF
	 tA45OOZyYbk9AbuBEhB4DBFJdmTlHEieYXAHntS/FhJ3w+INOxZrjlB7KuzbmUrjSf
	 H0FjDXfaM5z5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Perry Yuan <perry.yuan@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	lijo.lazar@amd.com,
	christian.koenig@amd.com,
	Hawking.Zhang@amd.com,
	mario.limonciello@amd.com,
	cesun102@amd.com,
	superm1@kernel.org,
	kenneth.feng@amd.com,
	kevinyang.wang@amd.com,
	Yifan.Zha@amd.com,
	siqueira@igalia.com,
	ilya.zlobintsev@gmail.com,
	tomasz.pakula.oficjalny@gmail.com,
	Jesse.Zhang@amd.com
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amd/pm: Disable MMIO access during SMU Mode 1 reset
Date: Mon, 12 Jan 2026 09:58:12 -0500
Message-ID: <20260112145840.724774-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: drm/amd/pm: Disable MMIO access during SMU Mode 1
reset

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes a **serious stability problem**:
- During Mode 1 reset, the ASIC becomes temporarily inaccessible via
  PCIe
- Any MMIO access during this window (from interrupt handlers or other
  driver threads) results in **NMI panics or system hangs**
- Keywords: "NMI panics", "system hangs" - these are critical stability
  issues

The commit has proper attribution:
- Reviewed-by tag from Yifan Zhang
- Signed-off by AMD maintainer Alex Deucher
- Already cherry-picked, suggesting it's considered stable material

### 2. CODE CHANGE ANALYSIS

The fix is straightforward and surgical:

**smu_v13_0_0_ppt.c and smu_v14_0_2_ppt.c:**
```c
/* disable mmio access while doing mode 1 reset*/
smu->adev->no_hw_access = true;
/* ensure no_hw_access is globally visible before any MMIO */
smp_mb();
msleep(...);
```
Sets the existing `no_hw_access` flag to block MMIO from other driver
components during the reset sleep window. The `smp_mb()` ensures proper
cross-CPU memory ordering.

**amdgpu_device.c:**
```c
/* enable mmio access after mode 1 reset completed */
adev->no_hw_access = false;
```
Re-enables MMIO access after the reset completes successfully.

### 3. CLASSIFICATION

This is a **bug fix** - not a new feature. It uses an existing mechanism
(`no_hw_access` flag) that other driver components already check. The
fix simply sets this flag at the correct time during Mode 1 reset.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: ~15 lines of actual code across 3 files
- **Complexity**: Very low - just boolean flag setting and memory
  barriers
- **Risk**: LOW - uses existing infrastructure, pattern is well-
  understood
- **Subsystem**: AMD GPU power management (SMU v13.0.0 and v14.0.2)

The changes are minimal and isolated to the Mode 1 reset path.

### 5. USER IMPACT

- **Severity**: CRITICAL - NMI panics and system hangs affect system
  stability
- **Affected users**: AMD GPU users (Radeon RX 7000 series and newer)
  when GPU undergoes error recovery
- **Trigger likelihood**: Mode 1 resets happen during GPU error recovery
  - interrupt handlers racing with reset is a realistic scenario

### 6. STABILITY INDICATORS

- Has `Reviewed-by` tag
- Cherry-picked from mainline commit
  7edb503fe4b6d67f47d8bb0dfafb8e699bb0f8a4
- Comes from AMD engineers with domain expertise

### 7. DEPENDENCY CHECK

The `no_hw_access` field in `amdgpu_device` structure is existing
infrastructure used throughout the AMDGPU driver. This commit doesn't
introduce new fields or dependencies - it only sets an existing flag at
appropriate times.

**Potential concern**: SMU v14 code is relatively new (2024+), so very
old stable trees may not have this code path. However, if the code
exists in the stable tree, the fix applies cleanly.

### RISK VS BENEFIT ASSESSMENT

**Benefits:**
- Prevents NMI panics and system hangs - critical stability fix
- Protects against realistic race conditions during GPU reset

**Risks:**
- Minimal - uses existing flag mechanism
- Small, contained changes with proper memory barriers
- No architectural changes or new features

### CONCLUSION

This commit fixes a critical stability bug (NMI panics, system hangs)
that can occur during normal GPU error recovery scenarios. The fix is:
- Small and surgical (just flag setting + memory barrier)
- Uses existing infrastructure
- Properly reviewed
- Low regression risk
- Already cherry-picked indicating stable intent

The commit meets all stable kernel criteria: it's obviously correct,
fixes a real and serious bug, is small and contained, and introduces no
new features.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c           | 3 +++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 7 ++++++-
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c | 9 +++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 0cba31ec025c0..e9a14a62e73fc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5731,6 +5731,9 @@ int amdgpu_device_mode1_reset(struct amdgpu_device *adev)
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
index 086501cc5213b..2cb2d93f9989a 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2142,10 +2142,15 @@ static int smu_v14_0_2_mode1_reset(struct smu_context *smu)
 
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

