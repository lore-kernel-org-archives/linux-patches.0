Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8789D528;
	Sun,  7 Sep 2025 20:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276667; cv=none; b=KC04HGbO68Me8pNo4u/KEuAhsisUwYP5df3diYLi0R4hgFcjAQ+4Iqo18NaBdwl3bgoIr3SwQnhumuAU07tuF+pTlSFZE/IFB5WbvZ/mgv1YPo+rod+eAy+yE1330oGBZ/KrPlpiGbHKUMcOk8dQl6iRWuukyKL+dAQo3M1zxeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276667; c=relaxed/simple;
	bh=ldqTci8YK70u1QLMCNNoLqAXdJ+hXK7rIWvQyM3Z358=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keW0cJyYbwWn0cpMYV/JjJGttyLGdNAzNT7Dj8f4CXAPe29wJgExAC1uohn0FH6+Z8oO8T6uAwEfaCdOI2YBL0t8T3lj1QuJD7hg7cDjlZBSnosNfq42cNPon41l6IKz7vFDSgr9LbVp7dqhJQCI22Gj+z/GPdl2LSJj+PnQgAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXiV0dxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXiV0dxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD5CC4CEF0;
	Sun,  7 Sep 2025 20:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276667;
	bh=ldqTci8YK70u1QLMCNNoLqAXdJ+hXK7rIWvQyM3Z358=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXiV0dxS87IKGuMJ5y3k4o0ca4b9302pZiPPvy0yTnNubwyNqUj3zWHKtYQeCiac1
	 fHJW+Hs+44eRIg4ug3jZsFvr+IINAg4wG/7luNDe4NVsSG601KHPptrdTv+tZ/KPc7
	 KPC5YhqKgjOuMn09DZO+dImG96pxYDOGeMnmuHYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/121] cpufreq: intel_pstate: Revise global turbo disable check
Date: Sun,  7 Sep 2025 21:58:28 +0200
Message-ID: <20250907195611.684928447@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -595,13 +595,9 @@ static void intel_pstate_hybrid_hwp_adju
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


