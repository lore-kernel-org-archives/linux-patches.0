Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF181FBEB6;
	Wed,  4 Jun 2025 01:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998906; cv=none; b=sKhOFOk9C9fJKMts6e/k5qjFdg/6jqtSw9nNK9UcDtQTEatFKxvW0jTEsfU3eHPrjHly0dj8V5pdt/s4eUDSA0eY5mwvxlE+iPaQEIrIhkfSkFT0K4Thbnb/yKsdASGDvztqqTdDwLMic1es/LRvI41i5/uJ+cJGx30Qw5B1Baw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998906; c=relaxed/simple;
	bh=miHxNhMmz+z/B/SYmot+ioYTYMK/UdTNx2oVQJ8bz2w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L4mmp0c0YuLhHhIEpkuOl5iwTC9c9rrOYKnjFFoTvibpOhU5lGzVrBImP6SPti6rRQhdNtINlYHNdxI+s2J6bHDbfVcmsPza1MVosiaXE8iR38hJlV6ejjH3elzQQ03tgUF1yMUoHjUEoblzwv3IigE2ZML2pYXpLaL5CEJZ1RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8OGUPxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8OGUPxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64EFC4CEED;
	Wed,  4 Jun 2025 01:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998905;
	bh=miHxNhMmz+z/B/SYmot+ioYTYMK/UdTNx2oVQJ8bz2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8OGUPxtJW15rqR6tHMQsYgOmLlM1qG/gQMKHCwAg3sZyGl/gaiiBW++V/MZyx35j
	 zCOeYcxdlL9yDX01OIIbQrSsKjB5DdSZe8HXYsOJhtEZS9J1yuS1LjdvTl74V9gd1F
	 iMtzNv6oaMSnU+LNzd/+Fy7bupWABpcKk5f2gFkYwrMEQXpM8Cwfpj7IW5NeIseLqH
	 4ZguoSU/YSOy14kHuUH3voqo9X6U5F0DxgD6KyuhcxtzndsGiXMaAMJY8jlhR63/FI
	 VzxSbdJh2quUMAPrVf9SOgP7ZiKuFySqZYNFkBbnBfMq/HHRSg6eMcRTUqaoQ/KLxZ
	 8QODIVLatJ3LA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rand Deeb <rand.sec96@gmail.com>,
	Rinitha S <sx.rinitha@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	przemyslaw.kitszel@intel.com,
	intel-wired-lan@lists.osuosl.org
Subject: [PATCH AUTOSEL 6.12 81/93] ixgbe: Fix unreachable retry logic in combined and byte I2C write functions
Date: Tue,  3 Jun 2025 20:59:07 -0400
Message-Id: <20250604005919.4191884-81-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit cdcb3804eeda24d588348bbab6766cf14fddbeaa ]

The current implementation of `ixgbe_write_i2c_combined_generic_int` and
`ixgbe_write_i2c_byte_generic_int` sets `max_retry` to `1`, which makes
the condition `retry < max_retry` always evaluate to `false`. This renders
the retry mechanism ineffective, as the debug message and retry logic are
never executed.

This patch increases `max_retry` to `3` in both functions, aligning them
with the retry logic in `ixgbe_read_i2c_combined_generic_int`. This
ensures that the retry mechanism functions as intended, improving
robustness in case of I2C write failures.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Bug Analysis **Critical Logic Flaw:** The
commit fixes a fundamental bug where the retry logic in I2C write
functions was completely ineffective. With `max_retry = 1`, the
condition `retry < max_retry` would only allow `retry = 0`, meaning the
retry loop would never execute more than once, making the entire retry
mechanism useless. **Code Impact:** The change from `max_retry = 1` to
`max_retry = 3` in both: - `ixgbe_write_i2c_combined_generic_int()`
(line ~170) - `ixgbe_write_i2c_byte_generic_int()` (line ~2288) This
aligns with the existing `ixgbe_read_i2c_combined_generic_int()`
function which already uses `max_retry = 3`. ## Backport Suitability
Criteria **1. Fixes Important User-Affecting Bug:** ✓ - I2C write
failures directly impact SFP/QSFP module detection and configuration -
Affects `ethtool --identify` LED functionality - Can cause intermittent
network interface initialization failures - Users would experience
unreliable hardware detection and configuration **2. Small and Contained
Change:** ✓ - Only changes two integer values from 1 to 3 - No
architectural changes or new functionality - Minimal risk of introducing
regressions - Affects only the specific I2C write retry mechanism **3.
No Side Effects Beyond the Fix:** ✓ - Simply enables existing retry
logic to work as intended - Doesn't change the fundamental I2C
communication protocol - Maintains consistency with read operations - No
new code paths introduced **4. Critical Subsystem Impact:** ✓ - Network
driver functionality is critical for system operation - I2C
communication is essential for modern network hardware management -
Affects Intel ixgbe NICs which are widely deployed in enterprise
environments **5. Clear Bug Evidence:** ✓ - Linux Verification Center
found this with static analysis (SVACE) - Logic flaw is mathematically
provable (retry < 1 never allows retry) - Consistent with similar
commits in the pattern (Similar Commit #1 shows retry count adjustments
are appropriate for backporting) ## Comparison to Historical Patterns
This commit closely matches **Similar Commit #1** (Backport Status: YES)
which also modified I2C retry counts in ixgbe. That commit reduced retry
counts to avoid regressions, while this one increases retry counts to
fix broken logic - both are stability improvements worthy of
backporting. Unlike **Similar Commit #2** (Backport Status: NO) which
was architectural refactoring, this commit fixes a clear functional
defect without introducing new features or code reorganization. ## Risk
Assessment **Low Risk:** - Increasing retries from effectively 0 to 3
cannot make things worse - The retry mechanism already existed and was
intended to be used - 3 retries aligns with established patterns in the
same driver - Intel has tested this change (as indicated by the "Tested-
by" tag) **High Impact:** - Fixes complete failure of I2C write retry
mechanism - Improves reliability of critical network hardware
functionality - Addresses systematic logic flaw affecting all ixgbe
deployments This commit represents exactly the type of important, low-
risk bug fix that stable trees are designed to receive.

 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index 07eaa3c3f4d36..530e4319a2e89 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -167,7 +167,7 @@ int ixgbe_write_i2c_combined_generic_int(struct ixgbe_hw *hw, u8 addr,
 					 u16 reg, u16 val, bool lock)
 {
 	u32 swfw_mask = hw->phy.phy_semaphore_mask;
-	int max_retry = 1;
+	int max_retry = 3;
 	int retry = 0;
 	u8 reg_high;
 	u8 csum;
@@ -2284,7 +2284,7 @@ static int ixgbe_write_i2c_byte_generic_int(struct ixgbe_hw *hw, u8 byte_offset,
 					    u8 dev_addr, u8 data, bool lock)
 {
 	u32 swfw_mask = hw->phy.phy_semaphore_mask;
-	u32 max_retry = 1;
+	u32 max_retry = 3;
 	u32 retry = 0;
 	int status;
 
-- 
2.39.5

