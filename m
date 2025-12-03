Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A212FFF98;
	Wed,  3 Dec 2025 20:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764793782; cv=none; b=B/jQgssww0gjb7NZHVW8voaAHmrXXWtm4RjyXaLIlT86AAjopTKKvhVCtQdsqyebBM8JM/Z7E8mcwt0aJZSqPVgIF8D+OabyuDa1rzx2CK6AdIpBx6TWcsdY57Yee3gM32HRq7S2fYHZmLl1qwJoOppi/C84ablhZwI2GhBqyQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764793782; c=relaxed/simple;
	bh=h8B0Zjix0+jmOtI6eBS4vfgWeG0zQjRVR6cYNlU89PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KYukWEGyFOM+rQsuWSvS0nlta/udrgTMXq9IBJYVKEhShRkM4426upUuGbmGkMW2kbWcndc+O9wuXgVC/RAtBoKcIjJCzuN3ovNsHYeeBKXSHdhNVMjPkOSO/VNGo9sXeReoT2n1iSQNriEpxqcaP/WkgwhVrCTxZUwNhcAYUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dixTMhdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dixTMhdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44ECC4CEFB;
	Wed,  3 Dec 2025 20:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764793782;
	bh=h8B0Zjix0+jmOtI6eBS4vfgWeG0zQjRVR6cYNlU89PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dixTMhdPcgUkynepIlEj8qQB0tf3IwuIztNGcc/M7QhmAhfhDU+wHxyeMGZOE47mF
	 7hBKt792PBPGsdCynsy7/fJKRsH5s6GlhHzgAv31FQ7vjEeNAqwrs9Yeu3rAHk+9xx
	 Y3Nu4HbG0CV3CfqoePh1zlR8FNOudksZH8fXjGsYsi+mHnBLNi8D6MGNE7Fm1VNkJj
	 oaVJDSOCV6KH9Qu5RLTp/JCkuMjdlE232rx2I2muM+Ze1cpzxGJukJdNkbrr6pcxwl
	 cXA7pWZy4sD7RE6879aSsC5mZEm7+lbOlJCcTswNaQR7hHhWwr4hG1muD4YxiNYU1K
	 FXS0zewxirgCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	Adam Li <adamli@os.amperecomputing.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
	Chris Mason <clm@meta.com>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] sched/fair: Revert max_newidle_lb_cost bump
Date: Wed,  3 Dec 2025 15:29:29 -0500
Message-ID: <20251203202933.826777-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251203202933.826777-1-sashal@kernel.org>
References: <20251203202933.826777-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d206fbad9328ddb68ebabd7cf7413392acd38081 ]

Many people reported regressions on their database workloads due to:

  155213a2aed4 ("sched/fair: Bump sd->max_newidle_lb_cost when newidle balance fails")

For instance Adam Li reported a 6% regression on SpecJBB.

Conversely this will regress schbench again; on my machine from 2.22
Mrps/s down to 2.04 Mrps/s.

Reported-by: Joseph Salisbury <joseph.salisbury@oracle.com>
Reported-by: Adam Li <adamli@os.amperecomputing.com>
Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reported-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://lkml.kernel.org/r/20250626144017.1510594-2-clm@fb.com
Link: https://lkml.kernel.org/r/006c9df2-b691-47f1-82e6-e233c3f91faf@oracle.com
Link: https://patch.msgid.link/20251107161739.406147760@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile my findings.

---

## COMPREHENSIVE BACKPORT ANALYSIS

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** `sched/fair: Revert max_newidle_lb_cost bump`

**Key signals:**
- **"Revert"** - This is undoing a previous change that caused problems
- **Multiple "Reported-by:" tags** from major organizations:
  - Joseph Salisbury (Oracle)
  - Adam Li (Ampere Computing)
  - Dietmar Eggemann (ARM)
  - Hazem Mohamed Abuelfotoh (Amazon)
- **"Tested-by:" and "Reviewed-by:"** tags showing validation
- **Explicit regression** mentioned: "6% regression on SpecJBB"
- **No "Cc: stable" tag** explicitly, but this is fixing a regression in
  code that WAS backported

**Missing Fixes: tag:** There's no explicit `Fixes:` tag, but the commit
message clearly states it reverts `155213a2aed4`.

### 2. CODE CHANGE ANALYSIS

The revert removes two related changes from the original commit:

**Change 1 - `update_newidle_cost()` function:**
```c
// BEFORE (problematic - being reverted):
sd->max_newidle_lb_cost = min(cost, sysctl_sched_migration_cost + 200);

// AFTER (restored original):
sd->max_newidle_lb_cost = cost;
```

**Change 2 - `sched_balance_newidle()` function:**
```c
// BEFORE (problematic - being reverted):
domain_cost = t1 - t0;
curr_cost += domain_cost;
t0 = t1;

if (!pulled_task)
    domain_cost = (3 * sd->max_newidle_lb_cost) / 2;

update_newidle_cost(sd, domain_cost);

// AFTER (restored original):
domain_cost = t1 - t0;
update_newidle_cost(sd, domain_cost);

curr_cost += domain_cost;
t0 = t1;
```

**Technical explanation:**
The original commit 155213a2aed4 tried to fix a schbench regression by:
1. Capping `max_newidle_lb_cost` to `sysctl_sched_migration_cost + 200`
2. Artificially bumping the cost by 50% when newidle balance fails to
   find work

The intent was to make the scheduler stop doing expensive newidle
balancing operations that weren't productive. However, this approach was
too aggressive and caused database workloads to suffer because they rely
on the scheduler's ability to quickly migrate tasks to idle CPUs.

### 3. CLASSIFICATION

| Category | Assessment |
|----------|------------|
| Bug fix | **YES** - Fixing a performance regression |
| Security fix | NO |
| Feature addition | NO - This removes code |
| Cleanup/refactoring | NO |
| Device ID/quirk | NO |

This is a **clear regression fix** - the original commit caused
measurable performance degradation in real-world workloads.

### 4. SCOPE AND RISK ASSESSMENT

**Size:** 1 file, 19 lines changed (-16 lines removed, +3 lines added)

**Complexity:** LOW - This is a straight revert removing problematic
logic

**Subsystem:** Scheduler (kernel/sched/fair.c) - Core but well-tested
area

**Risk factors:**
- ✅ Simple revert to known-good state
- ✅ Tested by multiple parties
- ✅ Well-understood change
- ⚠️ Will cause schbench regression (~8%), but this is a synthetic
  benchmark

### 5. USER IMPACT

**Who is affected:**
- **Database workloads** (SpecJBB) - MAJOR, 6% regression fixed
- **Production systems** running Oracle, Amazon, ARM platforms
- Any workload relying on fast task migration to idle CPUs

**Severity:** HIGH - This affects real production database workloads
with measurable performance impact

### 6. STABILITY INDICATORS

| Tag | Present |
|-----|---------|
| Reviewed-by | ✅ Dietmar Eggemann (ARM) |
| Tested-by | ✅ Dietmar Eggemann (ARM), Chris Mason (Meta) |
| Signed-off-by | ✅ Peter Zijlstra (Intel) - scheduler maintainer |

**Maturity:** The revert was authored by Peter Zijlstra, the primary
Linux scheduler maintainer, demonstrating careful consideration.

### 7. DEPENDENCY CHECK

I verified the commits between the original and the revert:

```
d206fbad9328d sched/fair: Revert max_newidle_lb_cost bump
522fb20fbdbe4 sched/fair: Have SD_SERIALIZE affect newidle balancing
...
```

The `SD_SERIALIZE` commit (522fb20fbdbe4) touches `sched_balance_rq()`,
not the areas modified by the revert. **No dependencies or conflicts
detected.**

### 8. STABLE TREE STATUS - CRITICAL FINDING

**The original problematic commit WAS backported to multiple stable
branches:**

| Stable Branch | Original Commit Hash | Revert Status |
|--------------|---------------------|---------------|
| 6.12.y (LTS) | fc4289233e4b7 | ❌ NOT REVERTED |
| 6.15.y | a4946f4b01421 | ❌ NOT REVERTED |
| 6.16.y | c6e88242c06d4 | ❌ NOT REVERTED |
| 6.17.y | 155213a2aed4 | ❌ NOT REVERTED |
| 6.18.y | 155213a2aed4 | ❌ NOT REVERTED |

**This means all these stable branches currently have the regression-
causing code!**

I verified the code in these branches - they all have:
1. The capped `min(cost, sysctl_sched_migration_cost + 200)`
2. The bump logic `(3 * sd->max_newidle_lb_cost) / 2`

The revert applies cleanly because the code structure is identical.

### 9. TRADE-OFF ANALYSIS

| Workload | Impact |
|----------|--------|
| SpecJBB (database) | **+6% restored** |
| schbench (synthetic) | -8% regression |

The maintainers deliberately chose to prioritize real-world database
workloads over a synthetic microbenchmark. This is the correct decision
for stable trees.

---

## FINAL ASSESSMENT

**This commit SHOULD be backported to stable trees because:**

1. **Fixes a real performance regression** - 6% on database workloads is
   significant
2. **Multiple independent reporters** from Oracle, Ampere, ARM, and
   Amazon confirms real-world impact
3. **The problematic commit was already backported** to 6.12.y, 6.15.y,
   6.16.y, 6.17.y, and 6.18.y - users of these stable trees are
   currently affected
4. **Simple, low-risk change** - It's a revert returning to previous
   stable behavior
5. **Small and contained** - 19 lines in one file, no architectural
   changes
6. **Well-tested** - Has Tested-by and Reviewed-by tags from ARM and
   Meta engineers
7. **Authored by maintainer** - Peter Zijlstra (scheduler maintainer)
   made this decision deliberately
8. **Clean backport** - Code matches exactly in stable trees, will apply
   without conflicts

**This is exactly the type of fix stable trees need:** fixing
regressions introduced by prior backports, with minimal risk and maximum
user benefit.

**YES**

 kernel/sched/fair.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5b752324270b0..9492a1de2501a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12159,14 +12159,8 @@ static inline bool update_newidle_cost(struct sched_domain *sd, u64 cost)
 		/*
 		 * Track max cost of a domain to make sure to not delay the
 		 * next wakeup on the CPU.
-		 *
-		 * sched_balance_newidle() bumps the cost whenever newidle
-		 * balance fails, and we don't want things to grow out of
-		 * control.  Use the sysctl_sched_migration_cost as the upper
-		 * limit, plus a litle extra to avoid off by ones.
 		 */
-		sd->max_newidle_lb_cost =
-			min(cost, sysctl_sched_migration_cost + 200);
+		sd->max_newidle_lb_cost = cost;
 		sd->last_decay_max_lb_cost = jiffies;
 	} else if (time_after(jiffies, sd->last_decay_max_lb_cost + HZ)) {
 		/*
@@ -12858,17 +12852,10 @@ static int sched_balance_newidle(struct rq *this_rq, struct rq_flags *rf)
 
 			t1 = sched_clock_cpu(this_cpu);
 			domain_cost = t1 - t0;
+			update_newidle_cost(sd, domain_cost);
+
 			curr_cost += domain_cost;
 			t0 = t1;
-
-			/*
-			 * Failing newidle means it is not effective;
-			 * bump the cost so we end up doing less of it.
-			 */
-			if (!pulled_task)
-				domain_cost = (3 * sd->max_newidle_lb_cost) / 2;
-
-			update_newidle_cost(sd, domain_cost);
 		}
 
 		/*
-- 
2.51.0

