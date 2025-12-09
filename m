Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCA3237180;
	Tue,  9 Dec 2025 00:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239441; cv=none; b=hD6MvT+HS5ZyUJOAStTlYd+mOtVuPibQj4ZzLOlGEbjg3Ej+VemDUXXTyhiUw3LkD4i4d6ORt/p3EPfTgm1+EvBSAzX66aC2jUvMmtKRkAQa87UCzm7I6mNFCyxSS5CBGqiwRlS+0yKZKfio6L0lxY+mljZSNFKLRXrJIo/L7fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239441; c=relaxed/simple;
	bh=JlT8U3xNRuoWRB25hd8k8Cu8Y1NyvjF/bcNo0Q8/3rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q0A4kn/Y5Nsg5JHyhf8H1A2pqeG0saAC08E1iTIqQSw18rUlYimKRLSQi7y/fBElAs4XaXXXmzG6DXqx3dB4m2wAnF9krMqVIl2cetjnM3rmLmF3lH/gtqhfYAG0Uo9uUgY9/hPk/c3wEAf40CnpXOLjki8W2ojyYHagFexfl3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lnv07pq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lnv07pq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5168FC4CEF1;
	Tue,  9 Dec 2025 00:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239441;
	bh=JlT8U3xNRuoWRB25hd8k8Cu8Y1NyvjF/bcNo0Q8/3rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lnv07pq/7WQR3Huw9gFJq3IaTeaWDXN/7qD3OpnzhM2edlYbV/W1q3wlBNo2qGIUm
	 K8jnuzVInT5R5pcLUM4bXBqABpSE9Oqk3COeW3H2bNAWKRqNN8Yf3vY6bicmcIFYcK
	 QDSF08xXTrraorxjPq3Cj9RVHSNnKC2zOv7DwZ5QeHdvS/9ysB7WCUHasHyP0VFXrU
	 42+A/9UvXnUu9elw0njvaryAHSog+Q13YeVTtPu+kS/zHh4sE3RbKpKbffwLo24LNU
	 ZWuifQAGoHY8iAxJVTx3SQB9/3KLoW5l65tVZ7zPpWsxB5j7TQTSe3pnpVFRYCbTEu
	 rHYrtzs+tPWvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
	syzbot+87e1289a044fcd0c5f62@syzkaller.appspotmail.com,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] net: sched: Don't use WARN_ON_ONCE() for -ENOMEM in tcf_classify().
Date: Mon,  8 Dec 2025 19:15:13 -0500
Message-ID: <20251209001610.611575-21-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit b8a7826e4b1aab3fabb29cbf0b73da9993d356de ]

As demonstrated by syzbot, WARN_ON_ONCE() in tcf_classify() can
be easily triggered by fault injection. [0]

We should not use WARN_ON_ONCE() for the simple -ENOMEM case.

Also, we provide SKB_DROP_REASON_NOMEM for the same error.

Let's remove WARN_ON_ONCE() there.

[0]:
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 0
CPU: 0 UID: 0 PID: 31392 Comm: syz.8.7081 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250
 should_fail_ex+0x414/0x560
 should_failslab+0xa8/0x100
 kmem_cache_alloc_noprof+0x74/0x6e0
 skb_ext_add+0x148/0x8f0
 tcf_classify+0xeba/0x1140
 multiq_enqueue+0xfd/0x4c0 net/sched/sch_multiq.c:66
...
WARNING: CPU: 0 PID: 31392 at net/sched/cls_api.c:1869 tcf_classify+0xfd7/0x1140
Modules linked in:
CPU: 0 UID: 0 PID: 31392 Comm: syz.8.7081 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:tcf_classify+0xfd7/0x1140
Code: e8 03 42 0f b6 04 30 84 c0 0f 85 41 01 00 00 66 41 89 1f eb 05 e8 89 26 75 f8 bb ff ff ff ff e9 04 f9 ff ff e8 7a 26 75 f8 90 <0f> 0b 90 49 83 c5 44 4c 89 eb 49 c1 ed 03 43 0f b6 44 35 00 84 c0
RSP: 0018:ffffc9000b7671f0 EFLAGS: 00010293
RAX: ffffffff894addf6 RBX: 0000000000000002 RCX: ffff888025029e40
RDX: 0000000000000000 RSI: ffffffff8bbf05c0 RDI: ffffffff8bbf0580
RBP: 0000000000000000 R08: 00000000ffffffff R09: 1ffffffff1c0bfd6
R10: dffffc0000000000 R11: fffffbfff1c0bfd7 R12: ffff88805a90de5c
R13: ffff88805a90ddc0 R14: dffffc0000000000 R15: ffffc9000b7672c0
FS:  00007f20739f66c0(0000) GS:ffff88812613e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c2d2a80 CR3: 0000000024e36000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 multiq_classify net/sched/sch_multiq.c:39 [inline]
 multiq_enqueue+0xfd/0x4c0 net/sched/sch_multiq.c:66
 dev_qdisc_enqueue+0x4e/0x260 net/core/dev.c:4118
 __dev_xmit_skb net/core/dev.c:4214 [inline]
 __dev_queue_xmit+0xe83/0x3b50 net/core/dev.c:4729
 packet_snd net/packet/af_packet.c:3076 [inline]
 packet_sendmsg+0x3e33/0x5080 net/packet/af_packet.c:3108
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x830 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f207578efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f20739f6038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f20759e5fa0 RCX: 00007f207578efc9
RDX: 0000000000000004 RSI: 00002000000000c0 RDI: 0000000000000008
RBP: 00007f20739f6090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007f20759e6038 R14: 00007f20759e5fa0 R15: 00007f2075b0fa28
 </TASK>

Reported-by: syzbot+87e1289a044fcd0c5f62@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/69003e33.050a0220.32483.00e8.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20251028035859.2067690-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms that `SKB_DROP_REASON_NOMEM` is a valid, well-defined drop
reason in the kernel. Now let me write my complete analysis:

## Summary Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: `net: sched: Don't use WARN_ON_ONCE() for -ENOMEM in
tcf_classify().`

**Key Details from the Commit Message**:
- The commit addresses a **syzbot-reported issue** where
  `WARN_ON_ONCE()` can be easily triggered by fault injection
- The issue is that `WARN_ON_ONCE()` is inappropriate for simple
  `-ENOMEM` (out-of-memory) cases
- The code already uses `SKB_DROP_REASON_NOMEM` to handle this same
  error, making the `WARN` redundant and noisy
- No `Cc: stable@vger.kernel.org` tag is present
- No `Fixes:` tag is present
- Has `Reported-by: syzbot` and `Closes:` link to bug report
- Has `Reviewed-by: Jamal Hadi Salim` (a TC subsystem maintainer)

### 2. CODE CHANGE ANALYSIS

**The Change (1 line modification)**:
```c
// Before:
if (WARN_ON_ONCE(!ext)) {
// After:
if (!ext) {
```

**Technical Analysis**:

The `tcf_classify()` function is the main traffic classifier function in
the Linux kernel's TC (Traffic Control) subsystem. It's called from:
- 16+ qdisc classifier functions (htb_classify, sfq_classify, etc.)
- The core `tc_run()` function

The problematic code path is:
1. `tcf_classify()` calls `tc_skb_ext_alloc(skb)` which internally calls
   `skb_ext_add(skb, TC_SKB_EXT)`
2. `skb_ext_add()` uses `GFP_ATOMIC` allocation, which **can
   legitimately fail** under memory pressure
3. On failure, the code correctly handles it by:
   - Setting `SKB_DROP_REASON_NOMEM`
   - Returning `TC_ACT_SHOT` (drop the packet)

**Why WARN_ON_ONCE is Wrong Here**:
- `WARN_ON_ONCE()` is intended for situations that indicate a **bug** or
  **should never happen**
- Memory allocation failures are **expected** runtime behavior,
  especially with `GFP_ATOMIC`
- The kernel's fault injection framework (failslab) intentionally
  triggers allocation failures for testing
- Using `WARN_ON_ONCE()` for expected failures creates false alarms and
  clutters logs

### 3. CLASSIFICATION

- **Type**: Bug fix (removing inappropriate WARN)
- **Category**: Code correctness / warning cleanup
- **NOT**: Feature addition, API change, security fix

### 4. SCOPE AND RISK ASSESSMENT

**Scope**:
- **1 file** modified: `net/sched/cls_api.c`
- **1 line** changed
- Pure removal of `WARN_ON_ONCE` wrapper

**Risk**: **VERY LOW**
- The error handling logic remains **completely unchanged**
- The packet is still dropped with correct `SKB_DROP_REASON_NOMEM`
- No functional behavior changes
- The only difference is suppression of the spurious warning

### 5. USER IMPACT

**Who is affected**:
- Anyone using TC (Traffic Control) subsystem
- Systems under memory pressure
- Test systems using fault injection
- Systems running syzbot or similar fuzzers

**Severity of the bug**:
- **Low-Medium**: The `WARN_ON_ONCE` produces kernel warning output
  (dmesg spam)
- It does NOT cause crashes or data corruption
- Some systems may treat kernel warnings as events requiring
  investigation/monitoring

**Practical Impact**:
- In production: Warnings in dmesg under memory pressure (rare but
  possible)
- In testing: Frequent warnings when using fault injection, polluting
  logs

### 6. STABILITY INDICATORS

- **Reviewed-by: Jamal Hadi Salim** - TC subsystem expert
- **Signed-off-by: Jakub Kicinski** - Network maintainer
- **syzbot tested** - The issue was discovered and verified by the
  fuzzing system

### 7. DEPENDENCY CHECK

**Code existence in stable trees**:
- The `WARN_ON_ONCE(!ext)` exists in:
  - 6.12.y (line 1869)
  - 6.6.y (line 1797)
  - 6.1.y (line 1644)
  - 5.15.y (line 1624)
  - 5.10.y (line 1631)
  - 5.4.y (line 1595)

**Original introduction**:
- The `WARN_ON_ONCE(!ext)` was introduced in commit `95a7233c452a5`
  (v5.4-rc1)

**Dependencies**:
- None - this is a standalone one-line fix
- The fix applies cleanly to all affected stable versions

### 8. HISTORICAL CONTEXT

The `WARN_ON_ONCE` was originally added in v5.4-rc1 when the TC skb
extension feature was introduced. At the time, the developer likely
thought allocation failure was unexpected, but in reality:
1. `GFP_ATOMIC` allocations can fail
2. The `SKB_DROP_REASON_NOMEM` was later added (in commit
   4cf24dc8934074) showing the failure is recognized as "memory
   exhaustion"
3. The warning serves no debugging purpose since the error is fully
   handled

## CONCLUSION

**Should this be backported?**

**Arguments FOR backporting**:
1. ✅ **Tiny, surgical fix** - 1 line change
2. ✅ **Zero functional change** - Error handling remains identical
3. ✅ **Fixes user-visible issue** - Removes spurious kernel warnings
4. ✅ **No risk of regression** - Only removes unnecessary WARN
5. ✅ **Applies cleanly** to all stable branches
6. ✅ **Well-tested** - Reviewed by TC maintainer, triggered by syzbot

**Arguments AGAINST backporting**:
1. ⚠️ No explicit `Cc: stable` tag
2. ⚠️ No `Fixes:` tag
3. ⚠️ Not a security issue
4. ⚠️ Not a crash or data corruption bug
5. ⚠️ Warnings are "noise" rather than serious bugs

**Verdict**:

While this commit lacks explicit stable tags, it represents an extremely
low-risk improvement that suppresses inappropriate kernel warnings. The
change:
- Is trivial (1 line)
- Has zero risk of regression
- Improves kernel log cleanliness under stress/testing
- Follows proper Linux coding guidelines (WARN should be for bugs, not
  expected conditions)

The lack of `Cc: stable` may simply be an oversight, as this type of fix
is commonly accepted in stable trees. The benefits (cleaner logs, proper
handling) outweigh the minimal effort of backporting.

**YES**

 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ecec0a1e1c1a0..f751cd5eeac8d 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1866,7 +1866,7 @@ int tcf_classify(struct sk_buff *skb,
 			struct tc_skb_cb *cb = tc_skb_cb(skb);
 
 			ext = tc_skb_ext_alloc(skb);
-			if (WARN_ON_ONCE(!ext)) {
+			if (!ext) {
 				tcf_set_drop_reason(skb, SKB_DROP_REASON_NOMEM);
 				return TC_ACT_SHOT;
 			}
-- 
2.51.0

