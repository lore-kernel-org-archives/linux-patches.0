Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F354B14BFA2;
	Sun,  7 Sep 2025 20:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276453; cv=none; b=gYKaXuwQm/8BKYOTv7Tt868U2TmlY6UNOzoHhohu0zWwj4CiQnmZytbdEslNHm0yT0ZF1AW/Zu4zcpDImTq8vBjGxTQ0YtOmmQXowBW4Q2ySmbcPwC5URRRZTgx0+uSNdTFK7veqXgbpgFOr0kvVPHIn9G/kp1FGepjftRqa2Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276453; c=relaxed/simple;
	bh=JDcHFHwQ+zk92n0MrhE02tSS74CaETD4vw98tQMZcS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/Czc9bItcv3R5/9hEySBoZSrpuFoIVtmzWUWWiCKKt1P6xx42vtI2HHqSg0w7Fqd/siIW/C76p+SKHTCL2zhkVLA/fTHEECc+RAkuXT0faG76IY3/TmB8mlaNRs6Z3NWyKXXIx/Uhzw74tMJEf4Zs+GzexiRFX/PWWrLeIsD3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y06nVsQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y06nVsQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B26EC4CEF0;
	Sun,  7 Sep 2025 20:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276452;
	bh=JDcHFHwQ+zk92n0MrhE02tSS74CaETD4vw98tQMZcS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y06nVsQtj6yMbNAYKGdOfdg/41Hp7g7J72UAX6fYHS1PmTwfpXReIxipX8ns2a4ht
	 J0z3QNvuD9/HELST6r6xmZfuFKOO3iNISJdQ+FxgbkW4tLrJd47DeuLAvc7xU4HPJ1
	 18dbIyS4YCXkYMlDHx2750Ittc/ntulLm7efX84M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/104] cpufreq: intel_pstate: Revise global turbo disable check
Date: Sun,  7 Sep 2025 21:58:26 +0200
Message-ID: <20250907195609.468573735@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 37b6ddba967c601479bea418a7ac6ff16b6232b7 ]

Setting global turbo flag based on CPU 0 P-state limits is problematic
as it limits max P-state request on every CPU on the system just based
on its P-state limits.

There are two cases in which global.turbo_disabled flag is set:
- When the MSR_IA32_MISC_ENABLE_TURBO_DISABLE bit is set to 1
in the MSR MSR_IA32_MISC_ENABLE. This bit can be only changed by
the system BIOS before power up.
- When the max non turbo P-state is same as max turbo P-state for CPU 0.

The second check is not a valid to decide global turbo state based on
the CPU 0. CPU 0 max turbo P-state can be same as max non turbo P-state,
but for other CPUs this may not be true.

There is no guarantee that max P-state limits are same for every CPU. This
is possible that during fusing max P-state for a CPU is constrained. Also
with the Intel Speed Select performance profile, CPU 0 may not be present
in all profiles. In this case the max non turbo and turbo P-state can be
set to the lowest possible P-state by the hardware when switched to
such profile. Since max non turbo and turbo P-state is same,
global.turbo_disabled flag will be set.

Once global.turbo_disabled is set, any scaling max and min frequency
update for any CPU will result in its max P-state constrained to the max
non turbo P-state.

Hence remove the check of max non turbo P-state equal to max turbo P-state
of CPU 0 to set global turbo disabled flag.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: ac4e04d9e378 ("cpufreq: intel_pstate: Unchecked MSR aceess in legacy mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -562,13 +562,9 @@ static void intel_pstate_hybrid_hwp_adju
 static inline void update_turbo_state(void)
 {
 	u64 misc_en;
-	struct cpudata *cpu;
 
-	cpu = all_cpu_data[0];
 	rdmsrl(MSR_IA32_MISC_ENABLE, misc_en);
-	global.turbo_disabled =
-		(misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE ||
-		 cpu->pstate.max_pstate == cpu->pstate.turbo_pstate);
+	global.turbo_disabled = misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE;
 }
 
 static int min_perf_pct_min(void)


