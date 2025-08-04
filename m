Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD3A1A5B8D;
	Mon,  4 Aug 2025 00:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267338; cv=none; b=uUbnmo2o15hdqnDS6/HQ6gH4Oqr7dgBEFpy4n/zjoCrBxvTX4rY10hJdXf82ufS1m3SuX2g5wPZ/gSYD486cCh5gA4Z8Dbc7mthAne5W+PSdoaaEDLUX99RLbt+cyBOQ33txvmbB9CrJ6oSUV2zlkn8x3ATvw3JPPxWH3tOtjr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267338; c=relaxed/simple;
	bh=xfIDBkosaUm8UJ4nUT5Fdx0QMC4jhRR/FYER00pacDk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BEzFNNAy9fkHV/h/ur1UWYjyGcAKCEUJrG2wPrfIpBXZg4xhLCG7AWSUI5RFIUS7BvsLv8R1BxXLHv4RlpzDKVT0EQHu2+8C3/4ScegpSX6fgQuvPXLOsmpXqzCsqDrin0UxVHPMbAR6pIuch+CTSAsr3z1AaBXg2fv+4Ip62zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSXtuc9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSXtuc9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7BEC4CEF0;
	Mon,  4 Aug 2025 00:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267338;
	bh=xfIDBkosaUm8UJ4nUT5Fdx0QMC4jhRR/FYER00pacDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSXtuc9rmevHxaf29/i45Kl535asGIg7V4Nuq+1WsSH1Rxu+FSw5TekUzNkK6oVwc
	 oaXuHcFBDy4tUDHMFyhh06QEBit5jigLL1YDM+WNFe2cHfiVG6//9CmWUN6cDicwYn
	 nf4lm4dP3HEhacvFh7Jp2dN7aIR6VYjw3QWZ9re/AYa7niywzzO/WwOw+L0lT3//0D
	 Ddzr+D37L2Krwur0tEH0MQcL1f/iyl1vhljNhGYCgGkP9LYQdQ+0VVs9RuTXK/B7+K
	 sObPJ9FVP1rxybUkQkstGS/h3Jd6CnPl5ByC8F5C0763Q2Jku3Bj+hD997jdKCN+Zh
	 DWGwnfoHlYjJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Kochetkov <al.kochet@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.15 25/80] ARM: rockchip: fix kernel hang during smp initialization
Date: Sun,  3 Aug 2025 20:26:52 -0400
Message-Id: <20250804002747.3617039-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: Alexander Kochetkov <al.kochet@gmail.com>

[ Upstream commit 7cdb433bb44cdc87dc5260cdf15bf03cc1cd1814 ]

In order to bring up secondary CPUs main CPU write trampoline
code to SRAM. The trampoline code is written while secondary
CPUs are powered on (at least that true for RK3188 CPU).
Sometimes that leads to kernel hang. Probably because secondary
CPU execute trampoline code while kernel doesn't expect.

The patch moves SRAM initialization step to the point where all
secondary CPUs are powered down.

That fixes rarely hangs on RK3188:
[    0.091568] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.091996] rockchip_smp_prepare_cpus: ncores 4

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Link: https://lore.kernel.org/r/20250703140453.1273027-1-al.kochet@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the code context, here's my
determination:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real bug affecting users**: The commit explicitly mentions
   that it "fixes rarely hangs on RK3188" during SMP initialization.
   This is a critical boot-time issue that prevents the system from
   functioning properly.

2. **Small and contained fix**: The change is minimal - it only moves
   the SRAM initialization code (`rockchip_smp_prepare_sram()`) to
   execute after all secondary CPUs are powered down. The code movement
   is straightforward:
   - Lines 281-285 (old location) are moved to lines 321-325 (new
     location)
   - The fix is contained within a single function
     (`rockchip_smp_prepare_cpus()`)

3. **Clear root cause**: The commit message explains the race condition
   clearly - secondary CPUs may execute trampoline code while it's being
   written to SRAM, causing unpredictable behavior and hangs.

4. **No architectural changes**: This is purely a timing/ordering fix
   that doesn't introduce new features or change the architecture of the
   code.

5. **Critical subsystem**: SMP initialization is a critical kernel
   subsystem. A hang during boot makes the system unusable, which is a
   severe issue for affected users.

6. **Platform-specific fix**: The change only affects Rockchip ARM
   platforms (specifically those with Cortex-A9 CPUs like RK3188),
   limiting the scope of potential regressions.

7. **Follows stable tree rules**: The fix addresses an important bug
   (boot hang), is small and self-contained, has minimal risk of
   regression, and doesn't introduce new features.

The key insight from the code analysis is that the original code had a
clear race condition where:
1. Secondary CPUs were powered on (lines 287-288 in the original)
2. Trampoline code was written to SRAM (line 282 in the original)
3. Secondary CPUs could potentially execute incomplete/corrupted
   trampoline code

The fix ensures all secondary CPUs are powered down (lines 321-323)
before writing the trampoline code to SRAM (lines 321-325 in the new
version), eliminating the race condition.

 arch/arm/mach-rockchip/platsmp.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
index 36915a073c23..f432d22bfed8 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -279,11 +279,6 @@ static void __init rockchip_smp_prepare_cpus(unsigned int max_cpus)
 	}
 
 	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
-		if (rockchip_smp_prepare_sram(node)) {
-			of_node_put(node);
-			return;
-		}
-
 		/* enable the SCU power domain */
 		pmu_set_power_domain(PMU_PWRDN_SCU, true);
 
@@ -316,11 +311,19 @@ static void __init rockchip_smp_prepare_cpus(unsigned int max_cpus)
 		asm ("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
 		ncores = ((l2ctlr >> 24) & 0x3) + 1;
 	}
-	of_node_put(node);
 
 	/* Make sure that all cores except the first are really off */
 	for (i = 1; i < ncores; i++)
 		pmu_set_power_domain(0 + i, false);
+
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
+		if (rockchip_smp_prepare_sram(node)) {
+			of_node_put(node);
+			return;
+		}
+	}
+
+	of_node_put(node);
 }
 
 static void __init rk3036_smp_prepare_cpus(unsigned int max_cpus)
-- 
2.39.5

