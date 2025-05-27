Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9102110E;
	Tue, 27 May 2025 17:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365498; cv=none; b=WPkL7rxZ20M1PcOaode7UQ6F8/v9jl/mzzHlmR/2Yrc9LhA4zsUdx3Z04Sr57uIcjAjxIeRJ+NLjT5wW4qnWyfksdn9oxrgz0yb4Ap4C5hQhqvUS/bly+0SBGaNNSS5YRGOVpNOYLzt9tGvM4ysw/vrfr1A1OLt+gRaX43/O1QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365498; c=relaxed/simple;
	bh=HSdHHfQeUEDfTye2B6p+1ImI1mggpJM3/Vzwp3QnuXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjdS5ulmOykVnoFtJmWGUqcgm/YNX/FHhq6IxwcsPRtJhnz7FIp73WHxUOnXPV7cSoqzLNI8kknFNedpHlJGbaSxUq7J20bpCdOgAYpW4ga1u5oRVMw9/hp2Nr0Ix+9uvJbv4QxDocN5mln0z4HMvqC+1y4rq7J7qzoU3VngITM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idHCpGLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idHCpGLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DF7C4CEE9;
	Tue, 27 May 2025 17:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365498;
	bh=HSdHHfQeUEDfTye2B6p+1ImI1mggpJM3/Vzwp3QnuXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idHCpGLezGZbct2Dr4ToICX6gHt6GCvAJu/5Hyo4SNF1hXaXv6s5DfQWp/b6alaAd
	 kPB1Np6cG2ACsibgk5tOa3BxFHwpEY/tBRtsZdmmX8ACtV8GtcJQbi5zazCVGf1aGQ
	 8Fhjp4BQ2+3YROgKb06q6l/2WR4qlLw/w3caqlyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zihan zhou <15645113830zzh@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 378/626] sched: Reduce the default slice to avoid tasks getting an extra tick
Date: Tue, 27 May 2025 18:24:31 +0200
Message-ID: <20250527162500.375899078@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zihan zhou <15645113830zzh@gmail.com>

[ Upstream commit 2ae891b826958b60919ea21c727f77bcd6ffcc2c ]

The old default value for slice is 0.75 msec * (1 + ilog(ncpus)) which
means that we have a default slice of:

  0.75 for 1 cpu
  1.50 up to 3 cpus
  2.25 up to 7 cpus
  3.00 for 8 cpus and above.

For HZ=250 and HZ=100, because of the tick accuracy, the runtime of
tasks is far higher than their slice.

For HZ=1000 with 8 cpus or more, the accuracy of tick is already
satisfactory, but there is still an issue that tasks will get an extra
tick because the tick often arrives a little faster than expected. In
this case, the task can only wait until the next tick to consider that it
has reached its deadline, and will run 1ms longer.

vruntime + sysctl_sched_base_slice =     deadline
        |-----------|-----------|-----------|-----------|
             1ms          1ms         1ms         1ms
                   ^           ^           ^           ^
                 tick1       tick2       tick3       tick4(nearly 4ms)

There are two reasons for tick error: clockevent precision and the
CONFIG_IRQ_TIME_ACCOUNTING/CONFIG_PARAVIRT_TIME_ACCOUNTING. with
CONFIG_IRQ_TIME_ACCOUNTING every tick will be less than 1ms, but even
without it, because of clockevent precision, tick still often less than
1ms.

In order to make scheduling more precise, we changed 0.75 to 0.70,
Using 0.70 instead of 0.75 should not change much for other configs
and would fix this issue:

  0.70 for 1 cpu
  1.40 up to 3 cpus
  2.10 up to 7 cpus
  2.8 for 8 cpus and above.

This does not guarantee that tasks can run the slice time accurately
every time, but occasionally running an extra tick has little impact.

Signed-off-by: zihan zhou <15645113830zzh@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20250208075322.13139-1-15645113830zzh@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 990d0828bf2a9..443f6a9ef3f8f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -71,10 +71,10 @@ unsigned int sysctl_sched_tunable_scaling = SCHED_TUNABLESCALING_LOG;
 /*
  * Minimal preemption granularity for CPU-bound tasks:
  *
- * (default: 0.75 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 0.70 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_base_slice			= 750000ULL;
-static unsigned int normalized_sysctl_sched_base_slice	= 750000ULL;
+unsigned int sysctl_sched_base_slice			= 700000ULL;
+static unsigned int normalized_sysctl_sched_base_slice	= 700000ULL;
 
 const_debug unsigned int sysctl_sched_migration_cost	= 500000UL;
 
-- 
2.39.5



