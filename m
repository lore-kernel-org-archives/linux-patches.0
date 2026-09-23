Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3E35304D1;
	Wed, 23 Sep 2026 14:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173484; cv=none; b=pdyMpHrFo9aoRXCCjQUfaWGIT3D3zuuN3ZZqvyrh86KnbU28yhZj8kp/aZ1UH9iJM1abZ1E8nl0wsVPCodW1Wd3MSW8AHbcVaEORhM1OkN8HtcD/6YIoQh9Mj1ATvlV/R5/KhrRbMnWFdDEA6Mzu+m9sPNc0sZtRaecEwCqgpLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173484; c=relaxed/simple;
	bh=aOuFnOa1McVPYhPH7ZsMdYznZq5AY6uCx7DbLTUCJy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olZEDPAbN+VNFiWpE2v17S9H8r+sKwaDEf5KJ86OsRcrAiwSMkZ4bZBt6wp6X+TMFgE3qQ6pT2ZVk2ZaVplQNzaZPQj+nntAILj8yJDBfpO/VlUbVqN+N/2t4LDCoHxYoNizZ6lv0s2l6spCWXqCgLZ1tTGt/w4Wfc+ZORPOsbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpEylkvK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpEylkvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E781F000FF;
	Wed, 23 Sep 2026 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173482;
	bh=xL4dAfUzLJ0laoQTUYiwSMkuOdhfqSwo6cMWqLpUgW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpEylkvKi8uDEnVK8e2ngTQxWkUujdaFlfbiUAFTuMFytDY8GhUM9zLF0k36J07Ie
	 UNlXHo0uFgsEY8fCXoqMD2ZsfY/xix51LV0P7kxieChGt0f50LiEZ3tE65vHAJe3J/
	 mLuLPUTy+IkG8BA3caCu03vzig/CXU5AT7cz531c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 227/438] sched/core: Avoid false migration warning for proxy donors
Date: Wed, 23 Sep 2026 16:04:08 +0200
Message-ID: <20260923140650.653340480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit fe3c73d7bc769e7afc252f867a3421fe168b898d ]

Proxy execution can move a blocked donor's scheduling context to the
lock owner's CPU even when the donor is migration-disabled. The donor
does not execute there, and its original execution CPU remains recorded
in wake_cpu.

set_task_cpu() warns unconditionally for migration-disabled tasks, so a
subsequent proxy migration or the wakeup path returning the donor home
triggers a false positive: moving a blocked scheduling context does not
violate the migration-disabled execution context.

For example, creating a mutex owner on CPU1 and a migration-disabled
waiter on CPU0 can trigger the following warning:

  proxy_migrate_repro: donor blocking on CPU0 with migration disabled
  proxy_migrate_repro: donor moved from CPU0 to CPU1
  WARNING: kernel/sched/core.c:3389 at set_task_cpu+0x1d3/0x280
  ...
  Call Trace:
   try_to_wake_up+0x43f/0x780
   __mutex_unlock_slowpath+0x330/0x540
   owner_fn+0x9f/0xc0 [proxy_migrate_repro]
  ...
  proxy_migrate_repro: donor woke on CPU0, task_cpu=0
  proxy_migrate_repro: completed

Exclude blocked proxy donors from the warning. The proxy wakeup path
restores an executable placement before clearing the blocked state.

Fixes: b049b81bdff6 ("sched: Handle blocked-waiter migration (and return migration)")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/20260915184101.2621252-1-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 35d647c8c3683..3d6c55598726f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3352,6 +3352,8 @@ void relax_compatible_cpus_allowed_ptr(struct task_struct *p)
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 	unsigned int state = READ_ONCE(p->__state);
+	bool proxy_migrated = sched_proxy_exec() && p->is_blocked &&
+			      task_cpu(p) != p->wake_cpu;
 
 	/*
 	 * We should never call set_task_cpu() on a blocked task,
@@ -3387,7 +3389,12 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 */
 	WARN_ON_ONCE(!cpu_online(new_cpu));
 
-	WARN_ON_ONCE(is_migration_disabled(p));
+	/*
+	 * Proxy execution can move a blocked task's scheduling context to any
+	 * CPU without moving its migration-disabled execution context. The
+	 * wakeup path will return the task to a CPU where it can execute.
+	 */
+	WARN_ON_ONCE(is_migration_disabled(p) && !proxy_migrated);
 
 	trace_sched_migrate_task(p, new_cpu);
 
-- 
2.53.0



