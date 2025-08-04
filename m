Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2C87260B;
	Mon,  4 Aug 2025 00:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268168; cv=none; b=HqJ38OVLyTP74VnkFTeZL4PSdB5TSBy3l8ThHnGOjc0o8NB3ecp2n8QB1ZV/dXaMRkctKCJmcooNuxMJc2IiTlRxpvjsmN2OAcMhhAvTUcAlt3UHmT3CfhIH98qrUII310BiOFFJvS8SbCutMztn6fTQ3o/4s4fMMFvPJOtLS+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268168; c=relaxed/simple;
	bh=rTsx42W5SiwWDpG7IMWgRXoMjBrRNUczQMcOZD6svUc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MGS07mO1KI8rJcAvBrDWqSkx36Z0Lzl2mzKLUacrhF8ED17mINqBcfZIzKfKl+S4kuFrwr27Yh0A+Ejo2RKJZEMOcvl1u6jXMq4G54Nxl94Tl/EvJ36BN3Ph8cOitLPp/WUISAGXKrcH9s3tTWjAF1rVUlu/F3DXeGU06gqtF/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zsx/CnUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zsx/CnUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D0AC4CEF8;
	Mon,  4 Aug 2025 00:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268168;
	bh=rTsx42W5SiwWDpG7IMWgRXoMjBrRNUczQMcOZD6svUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zsx/CnUbtPwLxAkhPQzlURtkzd6GA9+ja62qfSHYOGBZFqVDx+s0NkOiDMjYBz7EC
	 ru2kAewf+KNvJSfocUowoNTcT5BWC3Wx9uYDwAX7ikefl8FVUV1LY8AW2CJbKGUtx3
	 Mc5cLmyiOIMocL+X+u/hBSOT47OmroLbZYk9XcKLY87Zg+Gcx09tzIHA7lmcH2ol2m
	 y4qfp/AMzTdMXkKFDJOSyyUTMdEAhN1XSaM4mctKtsya+/0eKrAGKsl8+OKT+EUjlL
	 LlMB1ogEG4B8IH8lHky7X0WV39pXSStGQyI9MkEKbBGJ0TsrGBuVXnBMAcoqR2ojZg
	 +zJaw98+2THgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Kochetkov <al.kochet@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 09/28] ARM: rockchip: fix kernel hang during smp initialization
Date: Sun,  3 Aug 2025 20:42:08 -0400
Message-Id: <20250804004227.3630243-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004227.3630243-1-sashal@kernel.org>
References: <20250804004227.3630243-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.296
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
index 649e0a54784c..246a525d1d26 100644
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

