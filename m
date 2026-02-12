Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027C71E7C18;
	Thu, 12 Feb 2026 01:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858608; cv=none; b=SZxR3AG9ud24UbfmnWFu2EdsrXRfKVRn5A6wZ8e6kud7N/m7MnRVRnbGF2mArlVNHVBHvlt4QeMF+PWd9sACN6NlUpxRt9TqY/BQl5jvaE543L8Kv4ZQFeTd1bfLoJrtv7PFTujHhqb/9tH4KRBA/D644Hft05EhUt6KLOBkQaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858608; c=relaxed/simple;
	bh=LiAFQBbBbVwfWHEZSuJDuYjNsJmlyuTyALUVfkxJEqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=il465RUEZll4z0taM47bcn95Mb2gj7wIXWBrhWcHHrv49cWTQGr5VswMMl45ZpzqMMBISI4sJkfw5WuVgeHUEUuReVNfF+COtieWfo4/O7tFFmd49Ay7ldbLPTF+zeHGQYDaA8CcMSrrsQwJi9uYwEc3UKVoN1UUYjk2/eg//MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5KQGLPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5KQGLPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884CFC4CEF7;
	Thu, 12 Feb 2026 01:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858607;
	bh=LiAFQBbBbVwfWHEZSuJDuYjNsJmlyuTyALUVfkxJEqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5KQGLPuKak7OuznoFh5fVyWYAFkztT1eOj8burpXK5nNMEgCmrXvA17T9HhBwDAg
	 z6wBxhrSULHXdWA3VEX4RAhyzaIBRjBw8loQiFWvhJ9PqTWraLtZW8q+CLvG6JwUpX
	 +O2BjdEcokLb4Xxj0o8NpIFDbAFMYkH2a67n7BDadWh4C8swwa1HhGC9lIt361XJmp
	 jPh8uZ30JoDAJEz3YsIUCohqIm1cN9l5kQyIkrYlpUKolMlK5u+7ckdJVbQDVOnFYk
	 qiCew6kqjLDjqvf+uqlfcT9zKprIsJVGRSm30BObxY7l6y3J09qtcWdfB6cKsIZ7ew
	 nIwWtlLDCfJRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Imran Khan <imran.f.khan@oracle.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] genirq/cpuhotplug: Notify about affinity changes breaking the affinity mask
Date: Wed, 11 Feb 2026 20:09:29 -0500
Message-ID: <20260212010955.3480391-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Imran Khan <imran.f.khan@oracle.com>

[ Upstream commit dd9f6d30c64001ca4dde973ac04d8d155e856743 ]

During CPU offlining the interrupts affined to that CPU are moved to other
online CPUs, which might break the original affinity mask if the outgoing
CPU was the last online CPU in that mask. This change is not propagated to
irq_desc::affinity_notify(), which leaves users of the affinity notifier
mechanism with stale information.

Avoid this by scheduling affinity change notification work for interrupts
that were affined to the CPU being offlined, if the new target CPU is not
part of the original affinity mask.

Since irq_set_affinity_locked() uses the same logic to schedule affinity
change notification work, split out this logic into a dedicated function
and use that at both places.

[ tglx: Removed the EXPORT(), removed the !SMP stub, moved the prototype,
  	added a lockdep assert instead of a comment, fixed up coding style
  	and name space. Polished and clarified the change log ]

Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260113143727.1041265-1-imran.f.khan@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile my findings.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit subject and body describe a clear, concrete bug: during CPU
offlining, interrupts are migrated away from the offlined CPU. When the
new target CPU is **not** part of the original affinity mask (i.e., the
affinity was "broken"), the `irq_desc::affinity_notify` mechanism is NOT
triggered. This leaves users of the affinity notifier (network drivers,
RFS/RPS, IB HFI1, etc.) with **stale CPU affinity information**.

Key details:
- Author: Imran Khan (Oracle), a recognized contributor
- Signed-off-by and edited by Thomas Gleixner (IRQ subsystem
  maintainer), who personally polished the changelog and code
- The `[tglx: ...]` notes show significant maintainer review and
  modification

### 2. CODE CHANGE ANALYSIS

The patch makes three changes across three files:

**a) `kernel/irq/manage.c` - Refactoring + bug fix enablement**

The inline notification logic in `irq_set_affinity_locked()`:

```350:381:kernel/irq/manage.c
int irq_set_affinity_locked(struct irq_data *data, const struct cpumask
*mask,
                            bool force)
{
        // ... elided ...
        if (desc->affinity_notify) {
                kref_get(&desc->affinity_notify->kref);
                if (!schedule_work(&desc->affinity_notify->work)) {
                        /* Work was already scheduled, drop our extra
ref */
                        kref_put(&desc->affinity_notify->kref,
                                 desc->affinity_notify->release);
                }
        }
```

is extracted into a new function `irq_affinity_schedule_notify_work()`,
and the original site is replaced by a call to this new function. This
is a pure refactoring at this call site -- no behavioral change.

The new function:

```python
void irq_affinity_schedule_notify_work(struct irq_desc *desc)
{
    lockdep_assert_held(&desc->lock);
    kref_get(&desc->affinity_notify->kref);
    if (!schedule_work(&desc->affinity_notify->work)) {
        kref_put(&desc->affinity_notify->kref,
desc->affinity_notify->release);
    }
}
```

This is identical logic to what was inline, plus a
`lockdep_assert_held()` for safety.

**b) `kernel/irq/cpuhotplug.c` - The actual bug fix**

In `irq_migrate_all_off_this_cpu()`, the patch adds:

```python
scoped_guard(raw_spinlock, &desc->lock) {
    affinity_broken = migrate_one_irq(desc);
    if (affinity_broken && desc->affinity_notify)
        irq_affinity_schedule_notify_work(desc);
}
```

This is the core fix: when `migrate_one_irq()` returns `true` (affinity
was broken), and the descriptor has an affinity notifier registered,
**schedule the notification work**. This is done inside the lock scope,
which is correct since `irq_affinity_schedule_notify_work` asserts
`desc->lock` is held.

**c) `kernel/irq/internals.h` - Declaration**

Adds `extern void irq_affinity_schedule_notify_work(struct irq_desc
*desc);` to the internal header.

### 3. BUG MECHANISM AND IMPACT

**Root cause:** The CPU hotplug IRQ migration path
(`irq_migrate_all_off_this_cpu` -> `migrate_one_irq` ->
`irq_do_set_affinity`) bypasses `irq_set_affinity_locked()` and calls
the lower-level `irq_do_set_affinity()` directly. The notification logic
was only in `irq_set_affinity_locked()`, so CPU hotplug IRQ migrations
**never** triggered affinity notifications.

**Who is affected:**

1. **`irq_cpu_rmap` (lib/cpu_rmap.c)** - Used by major network drivers
   (bnxt, sfc, mlx5, mlx4, hns3, i40e, qede, enic) for Receive Flow
   Steering (RFS). When CPU hotplug migrates IRQs, the rmap becomes
   stale, causing incorrect RFS steering decisions. This has existed
   since `cpuhotplug.c` was created in 2015.

2. **NAPI affinity tracking** (net/core/dev.c `netif_napi_irq_notify`) -
   Newer mechanism (v6.15+) where NAPI tracks IRQ CPU affinity. Stale
   data here means incorrect CPU affinity tracking after CPU offlining.

3. **InfiniBand HFI1 driver** (drivers/infiniband/hw/hfi1/affinity.c) -
   Uses affinity notifiers for SDMA engine management.

4. **Various other network drivers** (ionic, i40e, funeth, bnxt,
   qla2xxx, qedf) that directly use `irq_set_affinity_notifier()`.

**Real-world impact:** On systems doing CPU hotplug (common in cloud/VM
environments, power management, CPU isolation), network performance
degrades because RFS steering becomes incorrect. The CPU rmap points to
offline CPUs or wrong CPUs, causing suboptimal packet delivery.

### 4. CLASSIFICATION

This is a **real bug fix** -- not a feature, not cleanup. It fixes a
missing notification that causes stale data in multiple critical
subsystems (networking RFS, NAPI, InfiniBand).

### 5. SCOPE AND RISK ASSESSMENT

- **Lines changed:** ~30 lines (very small)
- **Files touched:** 3, all in `kernel/irq/` (contained)
- **Complexity:** Low. The new function is a direct extraction of
  existing inline code. The new call site is a straightforward
  conditional.
- **Risk of regression:** Very low. The notification work was already
  being scheduled from `irq_set_affinity_locked()` using the identical
  logic. Adding it to the CPU hotplug path uses the same proven
  mechanism.
- **Subsystem:** `kernel/irq/` - core infrastructure, but the change is
  very surgical

### 6. DEPENDENCY ANALYSIS

**Critical concern:** The patch as written uses
`scoped_guard(raw_spinlock, &desc->lock)` syntax, which was introduced
by commit `88a4df117ad66` ("genirq/cpuhotplug: Convert to lock guards")
merged in v6.16. Older stable trees (6.15 and below) use
`raw_spin_lock()`/`raw_spin_unlock()` directly, so **this patch would
not apply cleanly to those trees**.

For stable trees <= 6.15, a backport would need adaptation to use the
old locking style:

```c
raw_spin_lock(&desc->lock);
affinity_broken = migrate_one_irq(desc);
if (affinity_broken && desc->affinity_notify)
    irq_affinity_schedule_notify_work(desc);
raw_spin_unlock(&desc->lock);
```

This adaptation is trivial and mechanically straightforward.

### 7. STABILITY AND TESTING

- Thomas Gleixner (IRQ subsystem maintainer) personally reviewed,
  edited, and applied this patch
- The logic reuses proven existing code (the kref_get + schedule_work +
  kref_put pattern)
- The `lockdep_assert_held()` adds runtime verification in debug builds

### 8. CONCLUSION

This fixes a **real, longstanding bug** (since 2015) that causes stale
IRQ affinity information in the CPU hotplug path, affecting network
drivers using RFS (bnxt, sfc, mlx5, mlx4, hns3, i40e, qede, enic), NAPI
affinity tracking, and InfiniBand HFI1. The impact is concrete:
incorrect receive flow steering and CPU affinity tracking when CPUs go
offline, which is common in cloud, VM, and power-managed environments.

The fix is:
- Small and surgical (~30 lines)
- Obviously correct (reuses existing proven notification logic)
- Well-reviewed (Thomas Gleixner personally edited it)
- Low risk of regression
- Self-contained (no part of a series)
- Fixes a real user-visible issue (stale CPU affinity data)

The only concern is that it requires a trivial backport adaptation for
stable trees <= 6.15 due to the lock guard conversion. This is a
mechanical change.

**YES**

 kernel/irq/cpuhotplug.c |  6 ++++--
 kernel/irq/internals.h  |  2 +-
 kernel/irq/manage.c     | 26 ++++++++++++++++++--------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/kernel/irq/cpuhotplug.c b/kernel/irq/cpuhotplug.c
index 755346ea98196..cd5689e383b00 100644
--- a/kernel/irq/cpuhotplug.c
+++ b/kernel/irq/cpuhotplug.c
@@ -177,9 +177,11 @@ void irq_migrate_all_off_this_cpu(void)
 		bool affinity_broken;
 
 		desc = irq_to_desc(irq);
-		scoped_guard(raw_spinlock, &desc->lock)
+		scoped_guard(raw_spinlock, &desc->lock) {
 			affinity_broken = migrate_one_irq(desc);
-
+			if (affinity_broken && desc->affinity_notify)
+				irq_affinity_schedule_notify_work(desc);
+		}
 		if (affinity_broken) {
 			pr_debug_ratelimited("IRQ %u: no longer affine to CPU%u\n",
 					    irq, smp_processor_id());
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 0164ca48da59e..5568ed3a8b852 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -135,6 +135,7 @@ extern bool irq_can_set_affinity_usr(unsigned int irq);
 
 extern int irq_do_set_affinity(struct irq_data *data,
 			       const struct cpumask *dest, bool force);
+extern void irq_affinity_schedule_notify_work(struct irq_desc *desc);
 
 #ifdef CONFIG_SMP
 extern int irq_setup_affinity(struct irq_desc *desc);
@@ -142,7 +143,6 @@ extern int irq_setup_affinity(struct irq_desc *desc);
 static inline int irq_setup_affinity(struct irq_desc *desc) { return 0; }
 #endif
 
-
 #define for_each_action_of_desc(desc, act)			\
 	for (act = desc->action; act; act = act->next)
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 349ae7979da0e..4873b0f73df96 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -347,6 +347,21 @@ static bool irq_set_affinity_deactivated(struct irq_data *data,
 	return true;
 }
 
+/**
+ * irq_affinity_schedule_notify_work - Schedule work to notify about affinity change
+ * @desc:  Interrupt descriptor whose affinity changed
+ */
+void irq_affinity_schedule_notify_work(struct irq_desc *desc)
+{
+	lockdep_assert_held(&desc->lock);
+
+	kref_get(&desc->affinity_notify->kref);
+	if (!schedule_work(&desc->affinity_notify->work)) {
+		/* Work was already scheduled, drop our extra ref */
+		kref_put(&desc->affinity_notify->kref, desc->affinity_notify->release);
+	}
+}
+
 int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 			    bool force)
 {
@@ -367,14 +382,9 @@ int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 		irq_copy_pending(desc, mask);
 	}
 
-	if (desc->affinity_notify) {
-		kref_get(&desc->affinity_notify->kref);
-		if (!schedule_work(&desc->affinity_notify->work)) {
-			/* Work was already scheduled, drop our extra ref */
-			kref_put(&desc->affinity_notify->kref,
-				 desc->affinity_notify->release);
-		}
-	}
+	if (desc->affinity_notify)
+		irq_affinity_schedule_notify_work(desc);
+
 	irqd_set(data, IRQD_AFFINITY_SET);
 
 	return ret;
-- 
2.51.0

