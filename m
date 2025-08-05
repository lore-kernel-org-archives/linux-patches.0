Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54BE2472B7;
	Tue,  5 Aug 2025 13:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399517; cv=none; b=GUrSxl6tMnkPcCN7yAeeAEe06/l/x14pzG6H9CKRsoqFbj9LDFb+7vkmjku31E9RMzejLcTyS5Ge0eKiYosZtjL41qQg3hZPf4voHClosAzm4/aMT4zI9ylxHdfeV6w5pw/ZnTJ76H4cU75fsNEHXgxJ+6N7M14bGs1bAi4iWqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399517; c=relaxed/simple;
	bh=uCGVy5vRCBk3vj4eapHNW2dgJlB7TzlfE0TWQs3S208=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SWgP48H6dwhNhptMlSUf6c0vUFvlRz1i92O9fwBPn65LyRxzGGifxtC44wwHBBC/JoYtZoWqCRM2g3mM0URtl+MPCpjegSegjkfetXN/AmvTJTG8P34mJgYSkBdR89f6PJ4bBwpZ8i1JgHFjQzAdVK4LAAM1B3zo4o19CvI+Br8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bf5sbeBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bf5sbeBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902A9C4CEF4;
	Tue,  5 Aug 2025 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399517;
	bh=uCGVy5vRCBk3vj4eapHNW2dgJlB7TzlfE0TWQs3S208=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf5sbeBO1OXNZkQsqRlq48Aex+3bDco8L19FGPMpID2n892K/DJXi2JfZv/A8a4pv
	 dPU/IVK9ILEyw3kd2ZXvzNqXWA3ptgYbsBPefun7vfATO1dnqq1aig6D8oXHECfZZ+
	 K0oeA/IGJGE668pnu8Vi0R8umbEKrJyn+KkshuRmv8NPpTfKT4ke1x1DDtdD3Eaxjq
	 BxgC3ST7yScQXBAVECepDJglv2BB+a/v2vvfvJmSBjdHBxIZJYg/mi6M2SmIw+NXl5
	 Zkvuwtu4hnfTtpvaLhPikOBLZtoWEQckdJ2/1iZ9J7ww07UW5V2sCwIZkoijhvTVWe
	 I8edkxv/KoCWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.12] soundwire: amd: cancel pending slave status handling workqueue during remove sequence
Date: Tue,  5 Aug 2025 09:09:33 -0400
Message-Id: <20250805130945.471732-58-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit f93b697ed98e3c85d1973ea170d4f4e7a6b2b45d ]

During remove sequence, cancel the pending slave status update workqueue.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250530054447.1645807-4-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Status: YES

This commit should be backported to stable kernel trees. Here's the
extensive analysis:

### 1. **Bug Fix Nature**
This commit fixes a potential **use-after-free (UAF)** vulnerability
during driver removal. The workqueue `amd_sdw_work` (initialized at line
1074 in `amd_sdw_manager_probe()`) can be scheduled by interrupts (line
946 in the interrupt handler). Without cancelling this work during
removal, the following race condition can occur:

- **CPU 0**: Driver removal begins, calls `amd_sdw_manager_remove()`
- **CPU 1**: Interrupt arrives, schedules `amd_sdw_work`
- **CPU 0**: Continues removal, frees the `amd_sdw_manager` structure
  via `sdw_bus_master_delete()`
- **CPU 1**: Work handler executes, accesses freed memory → **UAF**

### 2. **Small and Contained Fix**
The fix is minimal - just one line adding
`cancel_work_sync(&amd_manager->amd_sdw_work)` at the right place in the
removal sequence. This is placed:
- After `pm_runtime_disable()` (ensures no new runtime PM operations)
- Before `amd_disable_sdw_interrupts()` (ensures work can complete if
  running)
- Before any cleanup/freeing operations

### 3. **Common Pattern in Driver Code**
This follows an established pattern seen across the kernel. The recent
commit 984836621aad ("spi: mpc52xx: Add cancel_work_sync before module
remove") fixed an identical issue. The soundwire cadence driver also
uses `cancel_work_sync()` in similar contexts (line 1259 in
cadence_master.c).

### 4. **Part of a Broader Fix Series**
This commit is part of a series addressing multiple issues in the AMD
soundwire driver:
- Commit 86a4371b7697 fixed slave alert handling after link down
  (already includes `cancel_work_sync()` in suspend paths)
- This commit extends the fix to the removal path, ensuring complete
  coverage

### 5. **Real-World Impact**
The commit message from the related fix (86a4371b7697) shows actual
error logs from systems experiencing issues:
```
soundwire sdw-master-0-0: trf on Slave 1 failed:-110 read addr 0 count 1
rt722-sdca sdw:0:0:025d:0722:01: SDW_DP0_INT recheck read failed:-110
```
These errors occur when the workqueue tries to access hardware after
it's been disabled/freed.

### 6. **No Architectural Changes**
This is a pure bug fix with no feature additions or architectural
changes. It simply ensures proper cleanup ordering during driver
removal.

### 7. **Minimal Risk**
The `cancel_work_sync()` call is safe and standard practice. It waits
for any pending work to complete and prevents new work from being
scheduled. There's no risk of introducing new bugs or changing behavior
- it only prevents a race condition.

### 8. **Critical for System Stability**
Use-after-free bugs can lead to:
- Kernel crashes/panics
- Security vulnerabilities (potential for exploitation)
- System instability during module unload/reload
- Issues during system shutdown/reboot

The fix prevents these issues in production systems using AMD soundwire
hardware, particularly important for laptops and systems with audio
peripherals that may be dynamically loaded/unloaded.

 drivers/soundwire/amd_manager.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index 3b335d6eaa94..7ed9c8c0b4c8 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1074,6 +1074,7 @@ static void amd_sdw_manager_remove(struct platform_device *pdev)
 	int ret;
 
 	pm_runtime_disable(&pdev->dev);
+	cancel_work_sync(&amd_manager->amd_sdw_work);
 	amd_disable_sdw_interrupts(amd_manager);
 	sdw_bus_master_delete(&amd_manager->bus);
 	ret = amd_disable_sdw_manager(amd_manager);
-- 
2.39.5

