Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9E82EF655;
	Wed,  1 Oct 2025 13:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759325829; cv=none; b=qBe62tUa8xtyH6t6ij8hrRxIFIiKWYxFvKWEOR1Yz7yhy/XHbJLdJwX4hy7NEI2km9QPSDGbAUNwWT7JyHHaR8RQQ/HmeG5BxsahLFdnuu6884wDEcz038FmfIDudL62LloCNpXfCoQqzsv2q/8ktVdcjNp1duwmno4pu+Wso18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759325829; c=relaxed/simple;
	bh=SuXU6LSNW4mlQG1jGN7uMe8ERQdFfP9Dr+aSHYK3MMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DE1vxfPDp3Z9VXKNC6jgHdjdii+4XKGOXlgrgdfx5MUioozqzf6eyWx0na2p2R7s4wETgf481EB1o6TGGPemySbbJb0eLVayTQduJjYejBikVd9ftAQUeeInc/f+Ani98Zx1RcC5d2jDCXuM1m4jLg1xry0aqeZH3upBav3ZBDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8mrI922; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8mrI922"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FA8C116C6;
	Wed,  1 Oct 2025 13:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759325828;
	bh=SuXU6LSNW4mlQG1jGN7uMe8ERQdFfP9Dr+aSHYK3MMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8mrI922iQCR0Cw37Vv/lpmRw37Q4mlJ0dGFbOi4Fe/cqUCGIMy9ipSU79hvF3kaD
	 DrP7Q50rEm9P6sPPVWTm0oHDD8BmfuN2aSf9cYT5gODEgbX4fQRz5CWyrYWdfpZsjc
	 f9b9anlTQr8/lSNjbRvzDZbWoXmvTCBRvMlEm2cjY7mULL49v0eb3/HgVkNl0dV8Kq
	 OeAjTZCU9/uGqEslZn73F29DPxXLirg7t3n+V+E0Dhmrddnsn02DsH1xifMwBd4qzK
	 s9yOlim5Rrp4H5SbEDsfD7hwmli5BF5o01AoBp5s8wAfh8/6kmBsa4x97o5Am1yUhF
	 tNO9onEzkuBwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: gaoxiang17 <gaoxiang17@xiaomi.com>,
	Baoquan He <bhe@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oleg@redhat.com,
	mjguzik@gmail.com,
	Liam.Howlett@Oracle.com,
	jack@suse.cz,
	joel.granados@kernel.org,
	viro@zeniv.linux.org.uk,
	lorenzo.stoakes@oracle.com
Subject: [PATCH AUTOSEL 6.17-5.4] pid: Add a judgment for ns null in pid_nr_ns
Date: Wed,  1 Oct 2025 09:36:42 -0400
Message-ID: <20251001133653.978885-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001133653.978885-1-sashal@kernel.org>
References: <20251001133653.978885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: gaoxiang17 <gaoxiang17@xiaomi.com>

[ Upstream commit 006568ab4c5ca2309ceb36fa553e390b4aa9c0c7 ]

__task_pid_nr_ns
        ns = task_active_pid_ns(current);
        pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
                if (pid && ns->level <= pid->level) {

Sometimes null is returned for task_active_pid_ns. Then it will trigger kernel panic in pid_nr_ns.

For example:
	Unable to handle kernel NULL pointer dereference at virtual address 0000000000000058
	Mem abort info:
	ESR = 0x0000000096000007
	EC = 0x25: DABT (current EL), IL = 32 bits
	SET = 0, FnV = 0
	EA = 0, S1PTW = 0
	FSC = 0x07: level 3 translation fault
	Data abort info:
	ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
	CM = 0, WnR = 0, TnD = 0, TagAccess = 0
	GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
	user pgtable: 4k pages, 39-bit VAs, pgdp=00000002175aa000
	[0000000000000058] pgd=08000002175ab003, p4d=08000002175ab003, pud=08000002175ab003, pmd=08000002175be003, pte=0000000000000000
	pstate: 834000c5 (Nzcv daIF +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
	pc : __task_pid_nr_ns+0x74/0xd0
	lr : __task_pid_nr_ns+0x24/0xd0
	sp : ffffffc08001bd10
	x29: ffffffc08001bd10 x28: ffffffd4422b2000 x27: 0000000000000001
	x26: ffffffd442821168 x25: ffffffd442821000 x24: 00000f89492eab31
	x23: 00000000000000c0 x22: ffffff806f5693c0 x21: ffffff806f5693c0
	x20: 0000000000000001 x19: 0000000000000000 x18: 0000000000000000
	x17: 00000000529c6ef0 x16: 00000000529c6ef0 x15: 00000000023a1adc
	x14: 0000000000000003 x13: 00000000007ef6d8 x12: 001167c391c78800
	x11: 00ffffffffffffff x10: 0000000000000000 x9 : 0000000000000001
	x8 : ffffff80816fa3c0 x7 : 0000000000000000 x6 : 49534d702d535449
	x5 : ffffffc080c4c2c0 x4 : ffffffd43ee128c8 x3 : ffffffd43ee124dc
	x2 : 0000000000000000 x1 : 0000000000000001 x0 : ffffff806f5693c0
	Call trace:
	__task_pid_nr_ns+0x74/0xd0
	...
	__handle_irq_event_percpu+0xd4/0x284
	handle_irq_event+0x48/0xb0
	handle_fasteoi_irq+0x160/0x2d8
	generic_handle_domain_irq+0x44/0x60
	gic_handle_irq+0x4c/0x114
	call_on_irq_stack+0x3c/0x74
	do_interrupt_handler+0x4c/0x84
	el1_interrupt+0x34/0x58
	el1h_64_irq_handler+0x18/0x24
	el1h_64_irq+0x68/0x6c
	account_kernel_stack+0x60/0x144
	exit_task_stack_account+0x1c/0x80
	do_exit+0x7e4/0xaf8
	...
	get_signal+0x7bc/0x8d8
	do_notify_resume+0x128/0x828
	el0_svc+0x6c/0x70
	el0t_64_sync_handler+0x68/0xbc
	el0t_64_sync+0x1a8/0x1ac
	Code: 35fffe54 911a02a8 f9400108 b4000128 (b9405a69)
	---[ end trace 0000000000000000 ]---
	Kernel panic - not syncing: Oops: Fatal exception in interrupt

Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
Link: https://lore.kernel.org/20250802022123.3536934-1-gxxa03070307@gmail.com
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis, I'll provide my backport
recommendation:

**Backport Status: YES**

## Analysis

### Code Change Review
The commit adds a single NULL check in `pid_nr_ns()` at
kernel/pid.c:494:
```c
- if (pid && ns->level <= pid->level) {
+       if (pid && ns && ns->level <= pid->level) {
```

This prevents dereferencing `ns` when it's NULL.

### Why This Fix Is Needed

1. **Real Production Crash**: The commit message includes a detailed
   crash dump showing a kernel panic at `__task_pid_nr_ns+0x74/0xd0`
   with NULL pointer dereference at address `0x0000000000000058` (offset
   of `level` field in `struct pid_namespace`).

2. **Race Condition During Task Exit**: `task_active_pid_ns()` can
   return NULL when called on a task that's being reaped. The call chain
   shows the crash occurred during interrupt handling while a task was
   exiting (`do_exit` → `exit_task_stack_account` → interrupt →
   `__task_pid_nr_ns`).

3. **Long-Standing Bug**: This isn't a regression - similar issues were
   fixed in 2015 (commit 81b1a832d7974) but this particular path was
   missed.

### Critical Context - Follow-Up Fix Required
My research found that Oleg Nesterov submitted a follow-up commit
(abdfd4948e45c) on Aug 10, 2025 titled "pid: make __task_pid_nr_ns(ns =>
NULL) safe for zombie callers" which adds an additional NULL check in
`__task_pid_nr_ns()` itself. Both commits address complementary aspects
of the same race condition and should be backported together.

### Backport Justification

✅ **Fixes important user-visible bug**: Kernel panic in production
systems
✅ **Minimal code change**: Single NULL check, no behavioral changes
✅ **Low regression risk**: Defensive check that only prevents crashes
✅ **Confined to subsystem**: Only affects PID namespace handling
✅ **Reviewed by maintainers**: Baoquan He (reviewed), Christian Brauner
(signed-off)
✅ **Stable tree criteria met**: Important bugfix, minimal risk, no
feature additions

### Recommendation
**Strongly recommend backporting to all active stable trees**,
preferably together with the follow-up commit abdfd4948e45c to ensure
complete protection against this race condition. The fix is critical for
containerized environments where PID namespaces are heavily used.

 kernel/pid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index c45a28c16cd25..14e908f2f0cbf 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -491,7 +491,7 @@ pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
 	struct upid *upid;
 	pid_t nr = 0;
 
-	if (pid && ns->level <= pid->level) {
+	if (pid && ns && ns->level <= pid->level) {
 		upid = &pid->numbers[ns->level];
 		if (upid->ns == ns)
 			nr = upid->nr;
-- 
2.51.0

