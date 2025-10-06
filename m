Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8B02DF15D;
	Mon,  6 Oct 2025 18:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774762; cv=none; b=pmxbk9cQ7bMarxFBJASCXxu5rYg6gbkPrfy2O7BHUvkyW59PqN+hrL0GabRMzvZyDNqyR56CU/S5n3N6j70hF/TrnzlYG6f463zQZuJQH1+R8MoTKnKsPc7Yv2kpG6iBCJfbaONOb43RRWVkjosdGGn67VkxN985c2atzlHq2yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774762; c=relaxed/simple;
	bh=4QHmMm0HnvC1UzoVVe0fnLdsw+rEJP3mgwGZEQk65qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUdO4f5d1k8QAgxo2sIZfY5kG+SqgqHyl1QI2Fd0dTgycb8zPndoh4lIpWXgzze/+nSOZwiluB8gAFct0zxBatG/q0HEvP8obmHotNmQWJr2228lp15DU79ig1/hBApbOLxknQvUXpXfY8ApEyJGBqLGj4u7HUSObeWOqvDoz74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ux6Zgv8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ux6Zgv8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52C4C113D0;
	Mon,  6 Oct 2025 18:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774761;
	bh=4QHmMm0HnvC1UzoVVe0fnLdsw+rEJP3mgwGZEQk65qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux6Zgv8ydcoo9QTJ/xd0HBf6AklVTsjk0mteTN3kFC8WqurQS8iSqKD6R90sVLJhq
	 qHZDofc4lU99HRehhx5/MGvCZYNBTQ2BUfpCDwqlmKqvCHRTQBFuTkT/0G8MlFHtco
	 qFkxpx/kuoENYj3XlFe6AHdsu+UNTLK91KCukxAcJIWFHqo5Fq0+bG0Nglf+IGtUrp
	 blOBC6RahIjMD9jtFsjmQdFvrEJJvbjlXmZfU8p2n4POzrIfoNbMjOd2gPPqOvEaWr
	 39+Q52gircHn08HgbQbWvw8mKP2p/a5tBmGYh/DNEvwAVHXBj2HMQe+xct1PfwOqQj
	 k2QK//ZdPqo3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] perf: Use current->flags & PF_KTHREAD|PF_USER_WORKER instead of current->mm == NULL
Date: Mon,  6 Oct 2025 14:17:48 -0400
Message-ID: <20251006181835.1919496-16-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 90942f9fac05702065ff82ed0bade0d08168d4ea ]

To determine if a task is a kernel thread or not, it is more reliable to
use (current->flags & (PF_KTHREAD|PF_USER_WORKERi)) than to rely on
current->mm being NULL.  That is because some kernel tasks (io_uring
helpers) may have a mm field.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250820180428.592367294@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis, here is my determination:

## **Backport Status: YES**

### Extensive Analysis:

#### **Context and Problem Being Fixed:**

This commit addresses a **correctness bug** in how the perf subsystem
identifies kernel threads. The issue is that the code was using
`current->mm == NULL` to determine if a task is a kernel thread, but
this assumption is incorrect for **io_uring helper threads and other
PF_USER_WORKER threads**, which have a non-NULL mm field despite being
kernel-side workers.

#### **Evidence from Code Investigation:**

1. **This is part of a fix series**: I found three related commits in
   upstream:
   - `16ed389227651`: "perf: Skip user unwind if the task is a kernel
     thread" (already being backported to stable as `823d7b9ec8616`)
   - `d77e3319e3109`: "perf: Simplify get_perf_callchain() user logic"
     (already in stable as `96681d3b99282`)
   - `90942f9fac057`: **This commit** - completes the fix by updating
     remaining locations

2. **Historical context**: PF_USER_WORKER was introduced in commit
   `54e6842d0775b` (March 2023) to handle io_uring and vhost workers
   that behave differently from regular kernel threads. These threads
   have mm contexts but shouldn't be treated as user threads for
   operations like register sampling.

3. **Real-world impact**: PowerPC already experienced crashes (commit
   `01849382373b8`) when trying to access pt_regs for PF_IO_WORKER tasks
   during coredump generation, demonstrating this class of bugs is real.

#### **Specific Code Changes Analysis:**

1. **kernel/events/callchain.c:247-250** (currently at line 245 in
   autosel-6.17):
   - **OLD**: `if (current->mm)` then use `task_pt_regs(current)`
   - **NEW**: `if (current->flags & (PF_KTHREAD | PF_USER_WORKER))` then
     skip user unwinding
   - **Impact**: Prevents perf from attempting to unwind user stack for
     io_uring helpers

2. **kernel/events/core.c:7455** (currently at line 7443 in
   autosel-6.17):
   - **OLD**: `!(current->flags & PF_KTHREAD)`
   - **NEW**: `!(current->flags & (PF_KTHREAD | PF_USER_WORKER))`
   - **Impact**: Correctly excludes user worker threads from user
     register sampling

3. **kernel/events/core.c:8095** (currently at line 8083 in
   autosel-6.17):
   - **OLD**: `if (current->mm != NULL)`
   - **NEW**: `if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER)))`
   - **Impact**: Prevents incorrect page table walks for user worker
     threads in `perf_virt_to_phys()`

#### **Why This Qualifies for Backporting:**

1. **Fixes a real bug**: Perf incorrectly handles io_uring helper
   threads, leading to:
   - Incorrect callchain collection
   - Wrong register samples
   - Potential crashes or data corruption when walking page tables

2. **Affects widely-used functionality**: io_uring is heavily used in
   modern applications (databases, proxies, async I/O workloads), and
   perf profiling of these workloads would hit this bug

3. **Small and contained**: Only 3 conditional checks changed across 2
   files - minimal risk

4. **Part of an upstream series already being backported**: The first
   commit in the series (`16ed389227651`) is already marked for stable
   backport, making this a natural follow-up

5. **No architectural changes**: Pure bug fix with no API changes or
   feature additions

6. **Low regression risk**: The new flag-based check is more correct
   than the mm-based check; any behavioral changes would be fixing
   incorrect behavior

#### **Verification in Current Tree:**

I confirmed that linux-autosel-6.17 still has the old buggy code:
- Line 7443: Missing PF_USER_WORKER in the check
- Line 8083: Still uses `current->mm != NULL`
- callchain.c:245: Still uses `if (current->mm)`

This confirms the fix is needed and not yet applied.

#### **Conclusion:**

This is a **clear YES for backporting**. It's a well-understood
correctness fix for a real bug affecting perf profiling of io_uring
workloads, with minimal risk and part of an ongoing stable backport
series.

 kernel/events/callchain.c | 6 +++---
 kernel/events/core.c      | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 6c83ad674d010..decff7266cfbd 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -242,10 +242,10 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 
 	if (user) {
 		if (!user_mode(regs)) {
-			if  (current->mm)
-				regs = task_pt_regs(current);
-			else
+			if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
 				regs = NULL;
+			else
+				regs = task_pt_regs(current);
 		}
 
 		if (regs) {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 820127536e62b..ea9ff856770be 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7440,7 +7440,7 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
 	if (user_mode(regs)) {
 		regs_user->abi = perf_reg_abi(current);
 		regs_user->regs = regs;
-	} else if (!(current->flags & PF_KTHREAD)) {
+	} else if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
 		perf_get_regs_user(regs_user, regs);
 	} else {
 		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
@@ -8080,7 +8080,7 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * Try IRQ-safe get_user_page_fast_only first.
 		 * If failed, leave phys_addr as 0.
 		 */
-		if (current->mm != NULL) {
+		if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
 			struct page *p;
 
 			pagefault_disable();
-- 
2.51.0

