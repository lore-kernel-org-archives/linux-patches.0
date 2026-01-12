Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08322E265A;
	Mon, 12 Jan 2026 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229949; cv=none; b=SDEKdVh1p+ZlpIAvSodeiAkQbpVUFuEHktWrjxU2nVOoumBkasrBlpFWUoQHegesyZShwrSohMM3cPqHXeMJHLWt2e12Vkn4VPPxZ3F3HBQH28dR5QIbT6flD6RtuwlVs3BBAPjPhkcJyU2Gz0XR3F641kqR47dzyoHEYH1J8gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229949; c=relaxed/simple;
	bh=YLQwjPY7945bpXWCQeKlXHc04GePXtcbUxNXw7vn4TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBtpcNtypVd2AewDb256sv7BuOQ41hvv7g/zBjxgImxfss76/7OtcawmpGuD7gcMa+zYOG/LHVWrVJkRnfkb2rrXpsa5TkcLQMARg97u7dAu/v092UOTpuKLDK/oAHNgLY17SlQNXzx3DksDg67sIdQbCIKPb/lO9jIAp5wjO+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oeNR2b72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oeNR2b72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77A2C16AAE;
	Mon, 12 Jan 2026 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229949;
	bh=YLQwjPY7945bpXWCQeKlXHc04GePXtcbUxNXw7vn4TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeNR2b72QCik30PRaEi26f+EYqQVJKTKXTjf8PCUJvt9S1PSay33P7sLaJeJykjtW
	 ohvclCUOTVS/qoQf9wT23sl3rfNB+il1Y3oCVCmL4P6Cvv6seeNnW+UOyUQzZ7XNke
	 TwANCGU3tBJq9TTSpxuBBQD/yguk+o7gwO3Msy7eauYhh5rMspjCnFwPOkhSLQiTcy
	 AXcCrWsdm/AjTW8ETAX9KU2O3wTvbT08qkTepj+4jsbKsjsBwguFZTtQWbkTijsYPm
	 wOLbTh6Oqz1v/Jbx6v6MIPI60J338R7TN8OOrrIihXPsVf+dLFtBFRoXuojfXzB6Mn
	 Ek/3NDSL+fujw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wupeng Ma <mawupeng1@huawei.com>,
	mathieu.desnoyers@efficios.com,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ring-buffer: Avoid softlockup in ring_buffer_resize() during memory free
Date: Mon, 12 Jan 2026 09:58:17 -0500
Message-ID: <20260112145840.724774-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Transfer-Encoding: 8bit

From: Wupeng Ma <mawupeng1@huawei.com>

[ Upstream commit 6435ffd6c7fcba330dfa91c58dc30aed2df3d0bf ]

When user resize all trace ring buffer through file 'buffer_size_kb',
then in ring_buffer_resize(), kernel allocates buffer pages for each
cpu in a loop.

If the kernel preemption model is PREEMPT_NONE and there are many cpus
and there are many buffer pages to be freed, it may not give up cpu
for a long time and finally cause a softlockup.

To avoid it, call cond_resched() after each cpu buffer free as Commit
f6bd2c92488c ("ring-buffer: Avoid softlockup in ring_buffer_resize()")
does.

Detailed call trace as follow:

  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu: 	24-....: (14837 ticks this GP) idle=521c/1/0x4000000000000000 softirq=230597/230597 fqs=5329
  rcu: 	(t=15004 jiffies g=26003221 q=211022 ncpus=96)
  CPU: 24 UID: 0 PID: 11253 Comm: bash Kdump: loaded Tainted: G            EL      6.18.2+ #278 NONE
  pc : arch_local_irq_restore+0x8/0x20
   arch_local_irq_restore+0x8/0x20 (P)
   free_frozen_page_commit+0x28c/0x3b0
   __free_frozen_pages+0x1c0/0x678
   ___free_pages+0xc0/0xe0
   free_pages+0x3c/0x50
   ring_buffer_resize.part.0+0x6a8/0x880
   ring_buffer_resize+0x3c/0x58
   __tracing_resize_ring_buffer.part.0+0x34/0xd8
   tracing_resize_ring_buffer+0x8c/0xd0
   tracing_entries_write+0x74/0xd8
   vfs_write+0xcc/0x288
   ksys_write+0x74/0x118
   __arm64_sys_write+0x24/0x38

Cc: <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20251228065008.2396573-1-mawupeng1@huawei.com
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: ring-buffer: Avoid softlockup in
ring_buffer_resize() during memory free

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes:
- **Problem**: When resizing trace ring buffers on systems with many
  CPUs and PREEMPT_NONE, the kernel can hold the CPU for too long while
  freeing buffer pages, causing a softlockup (RCU stall)
- **Evidence**: Includes a complete stack trace showing the issue on a
  96-CPU system with kernel 6.18.2+
- **Solution**: Add `cond_resched()` after each buffer page free,
  matching what was done in commit f6bd2c92488c for a different code
  path
- **Validation**: Acked by Masami Hiramatsu and signed off by Steven
  Rostedt (the ring buffer subsystem maintainer)

Keywords present: "softlockup", "self-detected stall", "rcu_sched" - all
indicate a real, user-visible bug.

### 2. CODE CHANGE ANALYSIS

The change is minimal and surgical:

```c
list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages, list) {
    list_del_init(&bpage->list);
    free_buffer_page(bpage);
+
+   cond_resched();
}
```

This is in the `out_err:` error handling path of `ring_buffer_resize()`.
The loop iterates over all buffer pages to free them on error cleanup.
On systems with many CPUs and many pages, this loop can run for a very
long time without yielding.

**Technical mechanism**:
- `cond_resched()` checks if the scheduler needs to preempt the current
  task
- On PREEMPT_NONE kernels, voluntary preemption points like this are the
  only way to yield
- This is a standard, well-established kernel pattern for long-running
  loops

### 3. CLASSIFICATION

- **Bug type**: Softlockup fix - prevents RCU stalls and potential
  watchdog timeouts
- **Not a feature**: Does not add new functionality, just prevents a
  hang
- **Not an exception category**: Standard bug fix, not device
  ID/quirk/DT

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Lines changed | 2 (1 blank + 1 cond_resched) |
| Files touched | 1 |
| Complexity | Trivial |
| Risk | Very Low |

**Risk is minimal because**:
- `cond_resched()` is designed to be safe to call anywhere
- It's a no-op when no rescheduling is needed
- The same pattern already exists in this function (per the referenced
  commit)
- Only affects the error path during cleanup

### 5. USER IMPACT

- **Affected users**: Systems with many CPUs, PREEMPT_NONE
  configuration, using tracing
- **Severity**: High - softlockups can trigger watchdog resets and
  system hangs
- **Trigger**: User-initiated action (writing to buffer_size_kb file)
- **Real-world**: Stack trace demonstrates this was hit on production
  hardware (96-CPU ARM64 system)

This is particularly relevant for enterprise servers and embedded
systems which commonly use PREEMPT_NONE for performance.

### 6. STABILITY INDICATORS

- **Reviewed by maintainer**: Steven Rostedt (ring buffer maintainer)
  signed off
- **Acked by**: Masami Hiramatsu (Google) - experienced kernel tracing
  developer
- **Follows established pattern**: References commit f6bd2c92488c which
  applied the same fix elsewhere

### 7. DEPENDENCY CHECK

- The `ring_buffer_resize()` function and its error path have existed
  for years
- `cond_resched()` is a fundamental kernel API available in all stable
  trees
- No dependencies on new code or recent changes
- The fix is self-contained and independent

### CONCLUSION

This commit is an **ideal stable backport candidate**:

1. **Obviously correct**: Adding `cond_resched()` to prevent softlockups
   is a textbook kernel pattern
2. **Fixes a real bug**: Softlockups are serious user-visible issues
   that can hang systems
3. **Small and contained**: 2-line change, single file, trivial
   complexity
4. **No new features**: Pure bug fix with no behavioral changes
5. **No API changes**: No userspace-visible modifications
6. **Very low risk**: `cond_resched()` is designed to be safe; worst
   case is slightly increased latency
7. **Maintainer approved**: Signed off by the subsystem maintainer
8. **Affects all stable trees**: The vulnerable code path exists in all
   supported stable kernels

The fix follows the exact pattern already applied in the same function
by a previous commit, demonstrating it's a proven solution. The risk-to-
benefit ratio is excellent: near-zero risk for fixing a potentially
system-hanging bug.

**YES**

 kernel/trace/ring_buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index afcd3747264d2..3ba08fc1b7d05 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3121,6 +3121,8 @@ int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
 					list) {
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);
+
+			cond_resched();
 		}
 	}
  out_err_unlock:
-- 
2.51.0

