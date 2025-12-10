Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6685B226CF1;
	Wed, 10 Dec 2025 03:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338589; cv=none; b=lqIeW0EqDWTUgIp7BIAnbAS0DeIJezbWwR/mPKn/vaR4LFxPrknUE8fTcRsTVQ05Jg61tuUsIpHJ/6LExu2gLxIK/b0PS2AitgiBDsLV1v+TEzpNwU+8bvNBsGlr5SRVFqBegru7WOz0rn5mt6aIROge8EaYPmB4d0VQ42HVEtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338589; c=relaxed/simple;
	bh=26AMDGw3CTHSl9i+ijQwfW3FKagYLiKq4TVjFXs4w+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLzp5pm4hu3qJx2zudJ4n3sfVPn561CT7skcjkgs9akbFLYIgqviaDx+o4HZtENMpP/HWNJEjrIr5oWdTfuaResOYrwvSSxB+6E6Z8aZ7aEVSvMBwGihNMvzVBJFSoj5DIxcpC4p3JiE2/UFL5JOUV4nNWWiNzQZ0XwTXw5VV4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dickmjH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dickmjH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08A2C4CEF1;
	Wed, 10 Dec 2025 03:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338588;
	bh=26AMDGw3CTHSl9i+ijQwfW3FKagYLiKq4TVjFXs4w+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dickmjH0jr60i2oD3Po0u8zuC7MeQ4S/xqdj6Y48veTZdVaQlUKK+h0dMQFQjWsAi
	 BLQv6Re/vR4MBrQIuZ/ZT5Du//CywSf8r8q+8fn2OdOblQxViaC//hNCZdJHE7KCb1
	 V9J9i4J6Hr1BWb3wrwzDzW9is3OWaGNO0dkWDBkGiZ2e1gtpsQ3E/w2eCNmWoaNaCe
	 3FF38zowZaAZoTx5aQQkFJ+ZM5MzOmMSB2I9V0wJijHnoG0KgZ3/VhHPqNr20LXsYX
	 nVp06ALqk4Uue+FxudJA0QEX43G5xARWYooaUEg0P8dFs5KPP6U/Y3YzB/QnQYKSeY
	 x8Id4djh1pOzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	tiwei.btw@antgroup.com,
	andreas@gaisler.com,
	richard@nod.at,
	schuster.simon@siemens-energy.com,
	thomas.weissschuh@linutronix.de,
	benjamin.berg@intel.com,
	rppt@kernel.org,
	dave.hansen@linux.intel.com,
	akpm@linux-foundation.org,
	ethan@ethancedwards.com,
	mingo@kernel.org
Subject: [PATCH AUTOSEL 6.18-6.17] um: init cpu_tasks[] earlier
Date: Tue,  9 Dec 2025 22:48:54 -0500
Message-ID: <20251210034915.2268617-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210034915.2268617-1-sashal@kernel.org>
References: <20251210034915.2268617-1-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7b5d4416964c07c902163822a30a622111172b01 ]

This is currently done in uml_finishsetup(), but e.g. with
KCOV enabled we'll crash because some init code can call
into e.g. memparse(), which has coverage annotations, and
then the checks in check_kcov_mode() crash because current
is NULL.

Simply initialize the cpu_tasks[] array statically, which
fixes the crash. For the later SMP work, it seems to have
not really caused any problems yet, but initialize all of
the entries anyway.

Link: https://patch.msgid.link/20250924113214.c76cd74d0583.I974f691ebb1a2b47915bd2b04cc38e5263b9447f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### Bug Mechanism

This commit fixes a **boot crash** in User Mode Linux (UML) when KCOV
(kernel code coverage) is enabled:

1. **Root cause**: In UML, `current` is defined as `cpu_tasks[0]` (see
   `arch/um/include/asm/current.h:15`)
2. **Problem**: `cpu_tasks[]` was uninitialized (NULL) until
   `uml_finishsetup()` was called late in boot
3. **Trigger**: With KCOV enabled, early init code calls coverage-
   annotated functions like `memparse()`
4. **Crash path**: KCOV's `__sanitizer_cov_trace_pc` →
   `check_kcov_mode(current)` → dereferences NULL `current` → crash

### The Fix

The fix is elegantly simple:
- **Before**: `struct task_struct *cpu_tasks[NR_CPUS];` (zero-
  initialized, i.e., NULL)
- **After**: `struct task_struct *cpu_tasks[NR_CPUS] = { [0 ... NR_CPUS
  - 1] = &init_task };`

This ensures `current` is valid (`&init_task`) from the very start of
kernel execution. The runtime initialization in `uml_finishsetup()` is
removed since it's now redundant.

### Stable Criteria Assessment

| Criteria | Assessment |
|----------|------------|
| Fixes a real bug? | **YES** - Boot crash with KCOV enabled |
| Obviously correct? | **YES** - Same value (`&init_task`), just
initialized earlier |
| Small and contained? | **YES** - 2 files, +3/-3 lines, net -1 |
| No new features? | **YES** - Pure bug fix |
| Low regression risk? | **YES** - Identical initialization, just at
compile time |
| Self-contained? | **YES** - No dependencies on other patches |

### Risk Assessment

- **Risk**: Very low. The initialization value is exactly what was done
  before in `uml_finishsetup()`, just done statically at compile time
  instead of at runtime.
- **Scope**: Limited to UML architecture only
- **Impact**: Fixes complete boot failure for UML+KCOV users

### Concerns

- No explicit `Cc: stable@vger.kernel.org` tag
- No `Fixes:` tag to identify when bug was introduced
- Affects only UML users (niche architecture, but important for kernel
  testing/development)

### Conclusion

This is a textbook stable backport candidate:
- Fixes a real, reproducible crash (not theoretical)
- The fix is minimal, surgical, and obviously correct
- Zero risk of introducing regressions since the same value is used,
  just initialized earlier
- The infrastructure (`init_task`, `cpu_tasks[]`) has existed in stable
  trees for years

The lack of explicit stable tags appears to be an oversight. The fix is
appropriate for any stable tree that has both UML support and KCOV
support.

**YES**

 arch/um/kernel/process.c | 4 +++-
 arch/um/kernel/um_arch.c | 2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 9c9c66dc45f05..13d461712c997 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -43,7 +43,9 @@
  * cares about its entry, so it's OK if another processor is modifying its
  * entry.
  */
-struct task_struct *cpu_tasks[NR_CPUS];
+struct task_struct *cpu_tasks[NR_CPUS] = {
+	[0 ... NR_CPUS - 1] = &init_task,
+};
 EXPORT_SYMBOL(cpu_tasks);
 
 void free_stack(unsigned long stack, int order)
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index cfbbbf8500c34..ed2f67848a50e 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -239,8 +239,6 @@ static struct notifier_block panic_exit_notifier = {
 
 void uml_finishsetup(void)
 {
-	cpu_tasks[0] = &init_task;
-
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &panic_exit_notifier);
 
-- 
2.51.0

