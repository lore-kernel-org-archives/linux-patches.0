Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DEA1E5718;
	Tue, 26 Aug 2025 13:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213804; cv=none; b=EjoS7Bkc4cXqTO8e3W7Tb27EhPXCPk99Mooop/VuWS7ooWdjRgkflIL8VafPOo0736SENwUbbsLYh8HN+beARXXOYkJwUM+JV561tiB/V9Br5ZQg8pT1GSJT8M70vZ9gM6wM04MzmhZnSRaNMPSRar0UXduu0mcOFQmIC5aVaj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213804; c=relaxed/simple;
	bh=Yyw6jstTcR2euOUcZDOWfY41NStOpLULp7B1OQtH9GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixtU8Zi2l3juTKw9UL7qbiunEJqApAhEnruhRBxHlcNizy3OZUkYrLq+09By+CeBaCEetWSg7oCza2bLHz7yVwO5roPV7IJAHMu6iRguSV/IJZDI2NO4m9QRLGEYzhcGT1mfDb2R65R6I1gor1bhV8xYcAj7rg01OG35078nQVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETiQZgyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETiQZgyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB191C4CEF1;
	Tue, 26 Aug 2025 13:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213804;
	bh=Yyw6jstTcR2euOUcZDOWfY41NStOpLULp7B1OQtH9GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETiQZgyCy1OzdOROpVE77yqCb8+Z3VtU/t5IQQooEWAwB6RlFwl+LSN/NVXNNkKvj
	 HKMABuVZtP0/hQdq8Wrfq4z3nX49YhVAvVea3uiZSkOEnN2G5vgdCrip6UcSStqehk
	 ktpFQEulj1TMMz2w/waEVRCQcQhs9l9W6ht6roNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wyes Karny <wkarny@gmail.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ingo Molnar <mingo@kernel.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.6 478/587] sched/fair: Fix frequency selection for non-invariant case
Date: Tue, 26 Aug 2025 13:10:27 +0200
Message-ID: <20250826111005.129492818@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Vincent Guittot <vincent.guittot@linaro.org>

commit e37617c8e53a1f7fcba6d5e1041f4fd8a2425c27 upstream.

Linus reported a ~50% performance regression on single-threaded
workloads on his AMD Ryzen system, and bisected it to:

  9c0b4bb7f630 ("sched/cpufreq: Rework schedutil governor performance estimation")

When frequency invariance is not enabled, get_capacity_ref_freq(policy)
is supposed to return the current frequency and the performance margin
applied by map_util_perf(), enabling the utilization to go above the
maximum compute capacity and to select a higher frequency than the current one.

After the changes in 9c0b4bb7f630, the performance margin was applied
earlier in the path to take into account utilization clampings and
we couldn't get a utilization higher than the maximum compute capacity,
and the CPU remained 'stuck' at lower frequencies.

To fix this, we must use a frequency above the current frequency to
get a chance to select a higher OPP when the current one becomes fully used.
Apply the same margin and return a frequency 25% higher than the current
one in order to switch to the next OPP before we fully use the CPU
at the current one.

[ mingo: Clarified the changelog. ]

Fixes: 9c0b4bb7f630 ("sched/cpufreq: Rework schedutil governor performance estimation")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Bisected-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Wyes Karny <wkarny@gmail.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Wyes Karny <wkarny@gmail.com>
Link: https://lore.kernel.org/r/20240114183600.135316-1-vincent.guittot@linaro.org
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpufreq_schedutil.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -156,7 +156,11 @@ unsigned long get_capacity_ref_freq(stru
 	if (arch_scale_freq_invariant())
 		return policy->cpuinfo.max_freq;
 
-	return policy->cur;
+	/*
+	 * Apply a 25% margin so that we select a higher frequency than
+	 * the current one before the CPU is fully busy:
+	 */
+	return policy->cur + (policy->cur >> 2);
 }
 
 /**


