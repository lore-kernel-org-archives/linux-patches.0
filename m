Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9216C27FB3D;
	Tue, 27 May 2025 16:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364579; cv=none; b=NZYnFlzxPkNzwpDZ6zUnUDyKc4suhLdvGMsUoiJt4wrzQQpoqRptikb/gc55wXKhTrD/vOceDht7WHzC5BOK9AlaN9iMWUty4uO/VPaFYKq0ljcDhBAWy7bapvXi05jJhCzbdwIgom0ONHe8FTI9JNKLgJnXnwEeLEqfpZ6PC5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364579; c=relaxed/simple;
	bh=X9jTfmzr6XIfsd2hkMFzSoKCgdqSzNdVSH0kKp0dVnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FncKZHHrhC7LPH9XzluUFTSJXpsMQkA6aLpafYjoDoilqDRZSQi+UDpbxuQzXbjGlo+dmx6CbOxdMBZogp2Nh+JNcUxxkbNiE2z509OsKsdeEDhq8gHIE5yyW9mBCEjo5DeyXHVlWUGM2Pk6jXz1g2tP4g+FqlXmJ9fWXvYyHPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9RfKPdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9RfKPdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FBDC4CEE9;
	Tue, 27 May 2025 16:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364579;
	bh=X9jTfmzr6XIfsd2hkMFzSoKCgdqSzNdVSH0kKp0dVnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9RfKPdh9rQb5s4lfb+9AJYoGKes3KyrZME1MQIVdfeqRGd4rmT+0B/+UVQxNIR1x
	 TK7Cpl3Q9cVzqWsSzGk6XHU1ZCmNn1B+vP5awp4Yf9vGuB6yjBmw3pb5uOH+QD52f4
	 OUxGrOWTF0/M0uHYKDcgDbGpRRJKeDHt0VdwDJKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Greg Thelen <gthelen@google.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/626] cgroup/rstat: avoid disabling irqs for O(num_cpu)
Date: Tue, 27 May 2025 18:19:54 +0200
Message-ID: <20250527162449.145618182@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0efc297a3c4974dbd609ee36fc6345720b6ca735 ]

cgroup_rstat_flush_locked() grabs the irq safe cgroup_rstat_lock while
iterating all possible cpus. It only drops the lock if there is
scheduler or spin lock contention. If neither, then interrupts can be
disabled for a long time. On large machines this can disable interrupts
for a long enough time to drop network packets. On 400+ CPU machines
I've seen interrupt disabled for over 40 msec.

Prevent rstat from disabling interrupts while processing all possible
cpus. Instead drop and reacquire cgroup_rstat_lock for each cpu. This
approach was previously discussed in
https://lore.kernel.org/lkml/ZBz%2FV5a7%2F6PZeM7S@slm.duckdns.org/,
though this was in the context of an non-irq rstat spin lock.

Benchmark this change with:
1) a single stat_reader process with 400 threads, each reading a test
   memcg's memory.stat repeatedly for 10 seconds.
2) 400 memory hog processes running in the test memcg and repeatedly
   charging memory until oom killed. Then they repeat charging and oom
   killing.

v6.14-rc6 with CONFIG_IRQSOFF_TRACER with stat_reader and hogs, finds
interrupts are disabled by rstat for 45341 usec:
  #  => started at: _raw_spin_lock_irq
  #  => ended at:   cgroup_rstat_flush
  #
  #
  #                    _------=> CPU#
  #                   / _-----=> irqs-off/BH-disabled
  #                  | / _----=> need-resched
  #                  || / _---=> hardirq/softirq
  #                  ||| / _--=> preempt-depth
  #                  |||| / _-=> migrate-disable
  #                  ||||| /     delay
  #  cmd     pid     |||||| time  |   caller
  #     \   /        ||||||  \    |    /
  stat_rea-96532    52d....    0us*: _raw_spin_lock_irq
  stat_rea-96532    52d.... 45342us : cgroup_rstat_flush
  stat_rea-96532    52d.... 45342us : tracer_hardirqs_on <-cgroup_rstat_flush
  stat_rea-96532    52d.... 45343us : <stack trace>
   => memcg1_stat_format
   => memory_stat_format
   => memory_stat_show
   => seq_read_iter
   => vfs_read
   => ksys_read
   => do_syscall_64
   => entry_SYSCALL_64_after_hwframe

With this patch the CONFIG_IRQSOFF_TRACER doesn't find rstat to be the
longest holder. The longest irqs-off holder has irqs disabled for
4142 usec, a huge reduction from previous 45341 usec rstat finding.

Running stat_reader memory.stat reader for 10 seconds:
- without memory hogs: 9.84M accesses => 12.7M accesses
-    with memory hogs: 9.46M accesses => 11.1M accesses
The throughput of memory.stat access improves.

The mode of memory.stat access latency after grouping by of 2 buckets:
- without memory hogs: 64 usec => 16 usec
-    with memory hogs: 64 usec =>  8 usec
The memory.stat latency improves.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Tested-by: Greg Thelen <gthelen@google.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/rstat.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 3e01781aeb7bd..c4ce2f5a9745f 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -323,13 +323,11 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp)
 			rcu_read_unlock();
 		}
 
-		/* play nice and yield if necessary */
-		if (need_resched() || spin_needbreak(&cgroup_rstat_lock)) {
-			__cgroup_rstat_unlock(cgrp, cpu);
-			if (!cond_resched())
-				cpu_relax();
-			__cgroup_rstat_lock(cgrp, cpu);
-		}
+		/* play nice and avoid disabling interrupts for a long time */
+		__cgroup_rstat_unlock(cgrp, cpu);
+		if (!cond_resched())
+			cpu_relax();
+		__cgroup_rstat_lock(cgrp, cpu);
 	}
 }
 
-- 
2.39.5



