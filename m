Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111AF298CC0;
	Sun,  1 Jun 2025 23:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820819; cv=none; b=ICPKAcd6IJed/UxGJ+Yr2/8wBb2iMU+ilhH01jhAMQ2UtxdNLMbpV1WR9P9NmPM90J4LBExUU0D9iYf7dHjbLltnogwFzB+UIFS6p9gR5bTaj6Irpi7nYInYQObqj2GUN2jF1uzMvsTlHIvgSv9EH2zhUIteajNQn4C1SRrEsiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820819; c=relaxed/simple;
	bh=6OM4IMogy0OSr2SprMVEd2TTySzn2Va76nSMWcYbnYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bj8DQnzuu5L/Qgpksn9IdoYC6FuTBPBV2bOjku+rH7+1cAzinrVX6sivc5LJZUf0ABZy2oz7w8s+Krn2leIMyUkrJ9P9tFYB1qzpY7HnrFZ0fJYXFVbsrjGsUyCL9TmgefTLRqkRqf5zJYwtKyb7Gx4CXf23BjlnxgTs3jWBAE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdUEMaku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdUEMaku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5C5C4CEE7;
	Sun,  1 Jun 2025 23:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820818;
	bh=6OM4IMogy0OSr2SprMVEd2TTySzn2Va76nSMWcYbnYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdUEMakusGe2QqazNAifzwqHzaRRhYQYIGUWJzUIgLONIn5twZUQLc0iCLuZRus4w
	 ZfV7Mi+EfbbBcJGn7+i6Cf4JfWMpXDmFFy7Acennf3jXJkCqXWD5zeRlLkoebqJQnJ
	 PjpwIooxuREXCqHWb+ldc63dDhZEyaRZniZEFoEt5Yi/S/Qg82A1bPYeh1AhlzQyLD
	 0AiFLQUKM/Xuh/2/8icq0RhNC3KHCsNfLGaR+c+46G73KLe6wgaGDPPd7MStajfpQi
	 OQzTzuHCprL3qCx9ycHCkXtiHU/gztFiazIo/s7IVbwXG5MzUovAflM3yhK6+GWdIo
	 lX5kj+MJF1jtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jstultz@google.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 090/102] clocksource: Fix the CPUs' choice in the watchdog per CPU verification
Date: Sun,  1 Jun 2025 19:29:22 -0400
Message-Id: <20250601232937.3510379-90-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>

[ Upstream commit 08d7becc1a6b8c936e25d827becabfe3bff72a36 ]

Right now, if the clocksource watchdog detects a clocksource skew, it might
perform a per CPU check, for example in the TSC case on x86.  In other
words: supposing TSC is detected as unstable by the clocksource watchdog
running at CPU1, as part of marking TSC unstable the kernel will also run a
check of TSC readings on some CPUs to be sure it is synced between them
all.

But that check happens only on some CPUs, not all of them; this choice is
based on the parameter "verify_n_cpus" and in some random cpumask
calculation. So, the watchdog runs such per CPU checks on up to
"verify_n_cpus" random CPUs among all online CPUs, with the risk of
repeating CPUs (that aren't double checked) in the cpumask random
calculation.

But if "verify_n_cpus" > num_online_cpus(), it should skip the random
calculation and just go ahead and check the clocksource sync between
all online CPUs, without the risk of skipping some CPUs due to
duplicity in the random cpumask calculation.

Tests in a 4 CPU laptop with TSC skew detected led to some cases of the per
CPU verification skipping some CPU even with verify_n_cpus=8, due to the
duplicity on random cpumask generation. Skipping the randomization when the
number of online CPUs is smaller than verify_n_cpus, solves that.

Suggested-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/all/20250323173857.372390-1-gpiccoli@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: **Bug Fix Analysis:** The commit fixes a logical
flaw in the clocksource watchdog's per-CPU verification mechanism. The
issue occurs in the `clocksource_verify_choose_cpus()` function at
`/kernel/time/clocksource.c:313`. **The Problem:** The original
condition `if (n < 0)` only checked for negative values of
`verify_n_cpus`, but when `verify_n_cpus` (default 8) is greater than
the number of online CPUs, the code would still proceed with random CPU
selection. This could lead to: 1. **CPU duplication**: Random selection
could pick the same CPU multiple times 2. **Incomplete coverage**: Some
CPUs might never be tested due to duplicates 3. **Inefficient
verification**: Testing fewer unique CPUs than intended **The Fix:** The
change from: ```c if (n < 0) { ``` to: ```c if (n < 0 || n >=
num_online_cpus()) { ``` Now correctly handles the case where
`verify_n_cpus >= num_online_cpus()` by bypassing random selection and
testing ALL online CPUs instead. **Backport Suitability Criteria:** 1.
**Important Bug Fix**: ✅ Fixes incorrect CPU verification that could
miss clocksource synchronization issues 2. **Small and Contained**: ✅
Single line change with clear, minimal scope 3. **No Side Effects**: ✅
Only affects the CPU selection logic, doesn't change fundamental
behavior 4. **No Architectural Changes**: ✅ Simple conditional logic fix
5. **Critical Subsystem**: ✅ Clocksource watchdog is crucial for system
timing reliability 6. **Minimal Regression Risk**: ✅ The fix makes the
verification more thorough, not less **Similar Commit Patterns:** This
matches the pattern of similar commits marked "YES" like commit #2 and
#3, which were small, focused fixes to clocksource verification logic
that improved reliability without introducing risks. **Real-World
Impact:** The commit message specifically mentions testing on a 4-CPU
laptop where the bug caused CPU verification to skip CPUs even with
`verify_n_cpus=8`, demonstrating this is a real issue affecting actual
systems. This is exactly the type of targeted bug fix that stable trees
are designed to include - it fixes incorrect behavior, has minimal risk,
and improves system reliability.

 kernel/time/clocksource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 2a7802ec480cc..7831827d5af52 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -310,7 +310,7 @@ static void clocksource_verify_choose_cpus(void)
 {
 	int cpu, i, n = verify_n_cpus;
 
-	if (n < 0) {
+	if (n < 0 || n >= num_online_cpus()) {
 		/* Check all of the CPUs. */
 		cpumask_copy(&cpus_chosen, cpu_online_mask);
 		cpumask_clear_cpu(smp_processor_id(), &cpus_chosen);
-- 
2.39.5

