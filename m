Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3108930ACE8;
	Sat, 25 Oct 2025 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409026; cv=none; b=EFNCmRmNmGhGMSOLB4eAQ8h/MPQ9nraWkJ+58hvJ7/8Wz/2QPynkw1l3Tx6UZ8guYG9XNmpOmDq7uXRck5jty56bDzZfBylbIuX7ZdI7e8wOSRt99S/l47GnHV+kQeUuAFXeOlt6VYXOkcq7+6RA9RANYj0v1l1tPEBJDHezP/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409026; c=relaxed/simple;
	bh=4YwdClfFl8clTWtetgAnqdWoVkEyNgqQ8FVXlCG38b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KQ7Cgr9/9LbSKYsfdvP4QL5muiQMwkRlSt3cXmkrWHRoAPpNKYd2sWckfXvV38hCcEvkkQDknuL3z/FdZhHklDTfDqO6VMhMjyboAfQ1boreEt5GjU9+xxLvJ8PP8ktEXohbBzf2ojKc93b5/IlGLFKCrXERz95NEMUZvKeTd/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5yQ0B0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5yQ0B0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F62BC4CEF5;
	Sat, 25 Oct 2025 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409022;
	bh=4YwdClfFl8clTWtetgAnqdWoVkEyNgqQ8FVXlCG38b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5yQ0B0QX094pL1gdAV3UaMHyddG+9PW0sPj5ZTxVLU+crbd+rYGnkdkrQR1FfkrE
	 0yA3C6gkvZm2mjkCnxywDmeJM6mxDGQzoPuoQl54bxr74YQWT3tdODZq+NVIWfAsui
	 WYV+oolT4REAAG4Edy9JOZRFyX9+QtPjuVGezxyQVg+UO+k3++i8g0GwuSFHBGLlcR
	 e1+UskMmbq6ruSfuJF94+WKEzHMojQ4ksYrA/dDljo2mU5+nAIMZqQVzn/fl6pWbfy
	 Bet4KE3P+yKZ1vAUjuEUDMH7kBj8W4HTfUJIuFjxmCzbH9Vuso1HbZB80NlyYdO9ie
	 82gl8bxIhCh7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	lijo.lazar@amd.com,
	christian.koenig@amd.com,
	Hawking.Zhang@amd.com,
	mario.limonciello@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Effective health check before reset
Date: Sat, 25 Oct 2025 11:56:44 -0400
Message-ID: <20251025160905.3857885-173-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ce Sun <cesun102@amd.com>

[ Upstream commit da467352296f8e50c7ab7057ead44a1df1c81496 ]

Move amdgpu_device_health_check into amdgpu_device_gpu_recover to
ensure that if the device is present can be checked before reset

The reason is:
1.During the dpc event, the device where the dpc event occurs is not
present on the bus
2.When both dpc event and ATHUB event occur simultaneously,the dpc thread
holds the reset domain lock when detecting error,and the gpu recover thread
acquires the hive lock.The device is simultaneously in the states of
amdgpu_ras_in_recovery and occurs_dpc,so gpu recover thread will not go to
amdgpu_device_health_check.It waits for the reset domain lock held by the
dpc thread, but dpc thread has not released the reset domain lock.In the dpc
callback slot_reset,to obtain the hive lock, the hive lock is held by the
gpu recover thread at this time.So a deadlock occurred

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents a real-world deadlock between the GPU recovery path and
    PCIe DPC error handling when an ATHUB error and a DPC event occur
    concurrently in an XGMI hive. Today, the GPU recovery thread takes
    the hive lock first and then waits for the reset-domain lock, while
    the DPC path already holds the reset-domain lock and later needs the
    hive lock, leading to a lock inversion and a hang.
  - The deadlock arises because the health check is currently skipped
    during DPC (gated by `occurs_dpc`), so the GPU recovery path
    proceeds far enough to try to take the reset lock rather than
    bailing out early when the device is no longer present on the bus.

- Current behavior in this tree
  - Health check implementation:
    `drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:6123` (uses
    `amdgpu_device_bus_status_check`, which reads PCI config via
    `amdgpu_device_bus_status_check` in
    `drivers/gpu/drm/amd/amdgpu/amdgpu.h:1774`).
  - Health check is called from `amdgpu_device_recovery_prepare()` and
    is skipped during DPC: see call at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:6162` guarded by `if
    (!adev->pcie_reset_ctx.occurs_dpc)`.
  - GPU recovery lock order: hive lock is taken before attempting reset
    lock; reset lock acquired here:
    `drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:6464`.
  - DPC path takes the reset lock early (in error_detected) and later
    needs the hive lock: reset lock taken in error_detected at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:6911`, and hive lock is
    taken again in `amdgpu_pci_slot_reset()`.

- What this commit changes
  - Moves the health check out of `amdgpu_device_recovery_prepare()`
    (and drops its return value) so `amdgpu_device_recovery_prepare()`
    only builds the reset device list. This eliminates the `occurs_dpc`
    gate there.
  - Calls `amdgpu_device_health_check()` in
    `amdgpu_device_gpu_recover()` immediately after building the device
    list and before attempting to take the reset-domain lock. This
    ensures that when DPC has occurred (device lost from the bus), the
    check returns `-ENODEV` and the recovery path bails out early,
    releasing the hive lock and avoiding the lock inversion with the DPC
    thread.
  - Net effect: on DPC, GPU recovery no longer tries to contend for the
    reset-domain lock; it exits cleanly because the health check fails,
    allowing the DPC thread to proceed.

- Why this prevents the deadlock
  - Before: GPU recovery holds hive lock, skips health check due to
    `occurs_dpc`, then blocks on reset-domain lock; DPC holds reset-
    domain lock and later blocks on hive lock → deadlock.
  - After: GPU recovery holds hive lock, runs health check
    unconditionally for non-VF, sees device lost (DPC), returns early
    and releases hive lock; DPC can then obtain hive lock and complete.

- Risk and scope
  - Scope: Single file change; no architectural refactor. The change
    restores the earlier, safer placement/semantics (health check before
    lock acquisition) and removes the special-case gating for DPC.
  - Callers: `amdgpu_device_recovery_prepare()`’s signature change is
    localized within the same file; its only callers are updated
    accordingly. No interfaces exposed outside the driver are changed.
  - Behavior under SR-IOV VF remains unchanged (health check is still
    skipped for VFs).
  - Note: The diff also shows removal of the “skip slot reset during RAS
    recovery” early-return in `amdgpu_pci_slot_reset`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:6969). That widens when
    slot reset proceeds during RAS. While unrelated to the deadlock fix,
    it keeps error handling consistent and avoids suppressing the DPC
    recovery path; the main deadlock is eliminated by the earlier
    health-check bail-out. This is the only part that slightly increases
    behavioral surface area, but it remains confined to AMDGPU’s AER
    recovery.

- Stable backport fit
  - Fixes an important deadlock affecting users under real error
    conditions (DPC + ATHUB).
  - Small, contained, revert of a fragile conditional (the `occurs_dpc`
    gate) and call placement tweak.
  - No new features, minimal regression risk, limited to the AMDGPU
    reset/AER code paths.

Given the bug severity (deadlock/hang) and contained nature of the fix,
this is a good candidate for stable backport.

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 26 +++++++---------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c8459337fcb89..dfa68cb411966 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6132,12 +6132,11 @@ static int amdgpu_device_health_check(struct list_head *device_list_handle)
 	return ret;
 }
 
-static int amdgpu_device_recovery_prepare(struct amdgpu_device *adev,
+static void amdgpu_device_recovery_prepare(struct amdgpu_device *adev,
 					  struct list_head *device_list,
 					  struct amdgpu_hive_info *hive)
 {
 	struct amdgpu_device *tmp_adev = NULL;
-	int r;
 
 	/*
 	 * Build list of devices to reset.
@@ -6157,14 +6156,6 @@ static int amdgpu_device_recovery_prepare(struct amdgpu_device *adev,
 	} else {
 		list_add_tail(&adev->reset_list, device_list);
 	}
-
-	if (!amdgpu_sriov_vf(adev) && (!adev->pcie_reset_ctx.occurs_dpc)) {
-		r = amdgpu_device_health_check(device_list);
-		if (r)
-			return r;
-	}
-
-	return 0;
 }
 
 static void amdgpu_device_recovery_get_reset_lock(struct amdgpu_device *adev,
@@ -6457,8 +6448,13 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	reset_context->hive = hive;
 	INIT_LIST_HEAD(&device_list);
 
-	if (amdgpu_device_recovery_prepare(adev, &device_list, hive))
-		goto end_reset;
+	amdgpu_device_recovery_prepare(adev, &device_list, hive);
+
+	if (!amdgpu_sriov_vf(adev)) {
+		r = amdgpu_device_health_check(&device_list);
+		if (r)
+			goto end_reset;
+	}
 
 	/* We need to lock reset domain only once both for XGMI and single device */
 	amdgpu_device_recovery_get_reset_lock(adev, &device_list);
@@ -6965,12 +6961,6 @@ pci_ers_result_t amdgpu_pci_slot_reset(struct pci_dev *pdev)
 	int r = 0, i;
 	u32 memsize;
 
-	/* PCI error slot reset should be skipped During RAS recovery */
-	if ((amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 3) ||
-	    amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 4)) &&
-	    amdgpu_ras_in_recovery(adev))
-		return PCI_ERS_RESULT_RECOVERED;
-
 	dev_info(adev->dev, "PCI error: slot reset callback!!\n");
 
 	memset(&reset_context, 0, sizeof(reset_context));
-- 
2.51.0

