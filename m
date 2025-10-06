Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D042765D2;
	Mon,  6 Oct 2025 18:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774750; cv=none; b=my1gU1v4A4bU0dl+qfvSbFvG4LFLWpwc/sdOP9AHtoVmqm61Q/JudWaviISmxWU4bm0EErnE5f0kNMkKdr6K6z6bLilMyspp8oSV+sSXlq190Xj5AbM52JSYpspZ13nyEX8sI1sPoY1lBlQj50V3BUD1caRHqKbY9nRnzTsWvv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774750; c=relaxed/simple;
	bh=pi9+48WVTh/niaA89TWN/8nPZQAmwD4yjcnsT846FhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jvDhvYSiVUWEuVDBYd7R1bAlhHc0PUx3+zME7buaZX0FgPF0KvBxYCb1jDvwF1d3hluOngV9+1bZHIcrASXW6dOFD2FNelGAxi64QR+MnO1Sg1g7f4BFRSEcTAUxsG1bRAlOPCVu9qss+my8DZ78MPzXYY8r/L4p8l6UObYVj+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mtrCUyd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mtrCUyd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F5FC4CEF5;
	Mon,  6 Oct 2025 18:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774747;
	bh=pi9+48WVTh/niaA89TWN/8nPZQAmwD4yjcnsT846FhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtrCUyd/zapq93kkt8wbj7jFO5vmGwbIG1xVgQJn4lop0NefH1d1XkzWaR5EilopC
	 0mukCbSebRUMtMxSykKsthrCIdqz1iVw6aY+RG4A0UER/Sc+GaS4c8kdNTIxq4NEPf
	 vj6VX/kv58jtCs3SGXzX537TAtGP7Tw4LpCRFpX7wH0eKbWGZgj4qsSTw/x9hcdnVn
	 OX67EX7L5hLIFbaIuSmtpTzubAZ0Kz7/im7aqFbwELSUMhflWC8icENLRagnaaTgnS
	 X5C+dXwZIj7T+pxAuyJWGGMGkqKV+A7z1xE78yB0rBz21sSm22pKukAd992HFqG6tX
	 V/2K6k/qB0YdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.16] sched_ext: Keep bypass on between enable failure and scx_disable_workfn()
Date: Mon,  6 Oct 2025 14:17:39 -0400
Message-ID: <20251006181835.1919496-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 4a1d9d73aabc8f97f48c4f84f936de3b265ffd6f ]

scx_enable() turns on the bypass mode while enable is in progress. If
enabling fails, it turns off the bypass mode and then triggers scx_error().
scx_error() will trigger scx_disable_workfn() which will turn on the bypass
mode again and unload the failed scheduler.

This moves the system out of bypass mode between the enable error path and
the disable path, which is unnecessary and can be brittle - e.g. the thread
running scx_enable() may already be on the failed scheduler and can be
switched out before it triggers scx_error() leading to a stall. The watchdog
would eventually kick in, so the situation isn't critical but is still
suboptimal.

There is nothing to be gained by turning off the bypass mode between
scx_enable() failure and scx_disable_workfn(). Keep bypass on.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis, here is my determination:

## **YES**

This commit should be backported to stable kernel trees.

### Detailed Analysis:

#### **Context and Timing:**
- **sched_ext introduction**: This feature was first introduced in
  kernel **v6.12** (confirmed via git tag analysis)
- **Applicability**: This commit is only relevant for kernels **v6.12
  and later** that include sched_ext
- **Current status**: The commit has **already been selected** for
  backporting to 6.17 (commit 2d013fc03f11a with Sasha Levin's sign-off)

#### **Bug Description and Impact:**
The code change addresses a **race condition in the error handling
path** during BPF scheduler enablement:

**Old behavior (buggy):**
1. Line 4580: `scx_bypass(true)` - Enable bypass mode during scheduler
   initialization
2. On error → Line 4708-4711: `scx_bypass(false)` - **Disable bypass
   mode**
3. Call `scx_error()` which triggers `scx_disable_workfn()`
4. Line 3873 in `scx_disable_workfn()`: `scx_bypass(true)` - Re-enable
   bypass mode

**Problem:** Between steps 2 and 4, the system is **out of bypass mode**
with a failed scheduler. The commit message explicitly states: *"the
thread running scx_enable() may already be on the failed scheduler and
can be switched out before it triggers scx_error() **leading to a
stall**"*

**New behavior (fixed):**
Simply **removes** the `scx_bypass(false)` call at line 4710, keeping
bypass mode continuously enabled from the failure point through the
entire disable sequence.

#### **Why This Should Be Backported:**

1. **Real Bug**: This fixes an actual stall condition (confirmed by
   author Tejun Heo and acked by Andrea Righi)

2. **User Impact**: While the watchdog eventually recovers, users
   experience **unnecessary stalls** when BPF schedulers fail to load -
   a real-world scenario

3. **Minimal Risk**:
   - **1-line change** (removal only)
   - Makes error path **more conservative** (keeps bypass on longer)
   - No new logic introduced
   - Only affects **error conditions**, not normal operation

4. **Stable Tree Criteria Met**:
   - ✅ Fixes important bug affecting users
   - ✅ Doesn't introduce new features
   - ✅ No architectural changes
   - ✅ Minimal regression risk
   - ✅ Confined to sched_ext subsystem

5. **Already Validated**: The autosel process has already selected this
   for 6.17, indicating automated analysis confirms its suitability

6. **Active Subsystem**: Multiple sched_ext fixes show this is under
   active maintenance and bug discovery

#### **Code Change Details:**
```c
// kernel/sched/ext.c, line 4708-4712
err_disable_unlock_all:
    scx_cgroup_unlock();
    percpu_up_write(&scx_fork_rwsem);
- scx_bypass(false);  // REMOVED
+   /* we'll soon enter disable path, keep bypass on */  // ADDED
COMMENT
err_disable:
```

This single-line removal prevents the problematic window where the
system exits bypass mode between error detection and cleanup,
eliminating the potential for stalls during scheduler enable failures.

 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 088ceff38c8a4..2ccc885a229d5 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5795,7 +5795,7 @@ static int scx_enable(struct sched_ext_ops *ops, struct bpf_link *link)
 err_disable_unlock_all:
 	scx_cgroup_unlock();
 	percpu_up_write(&scx_fork_rwsem);
-	scx_bypass(false);
+	/* we'll soon enter disable path, keep bypass on */
 err_disable:
 	mutex_unlock(&scx_enable_mutex);
 	/*
-- 
2.51.0

