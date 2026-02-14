Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D6928507B;
	Sat, 14 Feb 2026 21:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104442; cv=none; b=WJ2tbTgnI6FiyLtVGabdE3RO1RWwEFHW5ruZasHyJoPvVl99MnWdiTHcpkWBSQ1RdmrzQ1zWrr1ARrD2liRcG8KdVoJO61zNAia//h2cnDCKPGgvTMFAy/WHc4Ftg7EbXHQvi3QLNhJ3E9OpXc59ZY7icrwdfwvP+ELVIyO5Xj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104442; c=relaxed/simple;
	bh=zVyE5EpYRq9YZ/SKfSO2a8uHLflT7p8ze0wQ3zV77v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXDzAJrbZImz8lZNERBFEPtj6t25oZit7Lr1futSDXqIUlzMsOvFUye4RPlmhQRiAfYaJNSvhLWYuj0usKPKyxfegseyV0nI4hihqHQ+MvXfgoFXv4Os8Xv6/U9U9fSRuL0UcMBlEAWfUvO9ytedZoJx7VDwBP/c5/YT4pIeTTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tCbG/gJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tCbG/gJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCED4C16AAE;
	Sat, 14 Feb 2026 21:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104441;
	bh=zVyE5EpYRq9YZ/SKfSO2a8uHLflT7p8ze0wQ3zV77v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCbG/gJiIGW6k2pDxzNQOOiBor3If9PUTJdWYezdV2d5KXIwbwqSxh9iSjGor8g+F
	 hBRMKUe7Hz1DO+Pjd1CwffE3IkpwFKbE3kyxp4BKgedbiIUKoP3nRa2jAmHnykP/q4
	 SyS/H+HT0xwWEqkNA8xQyhoyOilk3fCyCgwwRfM2hbJdc3ZxvRenGZXMzST8oG7u4F
	 z+oOoKLaGru70ghmKpjVAdP2DXPzSbhn8E3PT8MqaEm94kM6J0fnYr+inXlrwPwYqn
	 j5xsNNzcUYGUArTGPORdkofyioD6Br7k/IwwTpHUIAOV8p9ZgR9Yol+1NpLcpUbWQJ
	 HH6wHSqZcJoeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
	syzbot+d24f940f770afda885cf@syzkaller.appspotmail.com,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] ipv4: fib: Annotate access to struct fib_alias.fa_state.
Date: Sat, 14 Feb 2026 16:23:51 -0500
Message-ID: <20260214212452.782265-86-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 6e84fc395e90465f1418f582a9f7d53c87ab010e ]

syzbot reported that struct fib_alias.fa_state can be
modified locklessly by RCU readers. [0]

Let's use READ_ONCE()/WRITE_ONCE() properly.

[0]:
BUG: KCSAN: data-race in fib_table_lookup / fib_table_lookup

write to 0xffff88811b06a7fa of 1 bytes by task 4167 on cpu 0:
 fib_alias_accessed net/ipv4/fib_lookup.h:32 [inline]
 fib_table_lookup+0x361/0xd60 net/ipv4/fib_trie.c:1565
 fib_lookup include/net/ip_fib.h:390 [inline]
 ip_route_output_key_hash_rcu+0x378/0x1380 net/ipv4/route.c:2814
 ip_route_output_key_hash net/ipv4/route.c:2705 [inline]
 __ip_route_output_key include/net/route.h:169 [inline]
 ip_route_output_flow+0x65/0x110 net/ipv4/route.c:2932
 udp_sendmsg+0x13c3/0x15d0 net/ipv4/udp.c:1450
 inet_sendmsg+0xac/0xd0 net/ipv4/af_inet.c:859
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x53a/0x600 net/socket.c:2592
 ___sys_sendmsg+0x195/0x1e0 net/socket.c:2646
 __sys_sendmmsg+0x185/0x320 net/socket.c:2735
 __do_sys_sendmmsg net/socket.c:2762 [inline]
 __se_sys_sendmmsg net/socket.c:2759 [inline]
 __x64_sys_sendmmsg+0x57/0x70 net/socket.c:2759
 x64_sys_call+0x1e28/0x3000 arch/x86/include/generated/asm/syscalls_64.h:308
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc0/0x2a0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff88811b06a7fa of 1 bytes by task 4168 on cpu 1:
 fib_alias_accessed net/ipv4/fib_lookup.h:31 [inline]
 fib_table_lookup+0x338/0xd60 net/ipv4/fib_trie.c:1565
 fib_lookup include/net/ip_fib.h:390 [inline]
 ip_route_output_key_hash_rcu+0x378/0x1380 net/ipv4/route.c:2814
 ip_route_output_key_hash net/ipv4/route.c:2705 [inline]
 __ip_route_output_key include/net/route.h:169 [inline]
 ip_route_output_flow+0x65/0x110 net/ipv4/route.c:2932
 udp_sendmsg+0x13c3/0x15d0 net/ipv4/udp.c:1450
 inet_sendmsg+0xac/0xd0 net/ipv4/af_inet.c:859
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x53a/0x600 net/socket.c:2592
 ___sys_sendmsg+0x195/0x1e0 net/socket.c:2646
 __sys_sendmmsg+0x185/0x320 net/socket.c:2735
 __do_sys_sendmmsg net/socket.c:2762 [inline]
 __se_sys_sendmmsg net/socket.c:2759 [inline]
 __x64_sys_sendmmsg+0x57/0x70 net/socket.c:2759
 x64_sys_call+0x1e28/0x3000 arch/x86/include/generated/asm/syscalls_64.h:308
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc0/0x2a0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x00 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 UID: 0 PID: 4168 Comm: syz.4.206 Not tainted syzkaller #0 PREEMPT(voluntary)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025

Reported-by: syzbot+d24f940f770afda885cf@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/69783ead.050a0220.c9109.0013.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260127043528.514160-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: ipv4: fib: Annotate access to struct
fib_alias.fa_state

### 1. Commit Message Analysis

The commit fixes a KCSAN-detected data race in `fib_table_lookup` on
`struct fib_alias.fa_state`. The race is between concurrent RCU readers
that both read and write `fa_state` without proper annotations. The
syzbot report clearly demonstrates two tasks on different CPUs
concurrently accessing the same memory location, with one writing and
one reading.

Key indicators:
- **Reported-by: syzbot** - fuzzer-found, reproducible bug
- **KCSAN data race** - detected by kernel sanitizer
- **Reviewed-by: Simon Horman** - reviewed by a respected networking
  maintainer
- **Signed-off-by: Jakub Kicinski** - accepted by the net maintainer

### 2. Code Change Analysis

The fix is extremely surgical - it adds `READ_ONCE()`/`WRITE_ONCE()`
annotations to accesses of `fa->fa_state`:

**In `fib_lookup.h` (`fib_alias_accessed()`):**
- The read of `fa->fa_state` is changed to `READ_ONCE(fa->fa_state)`
- The write is changed to `WRITE_ONCE(fa->fa_state, fa_state |
  FA_S_ACCESSED)`
- This is the hot path - called during every FIB lookup via
  `fib_table_lookup()`

**In `fib_trie.c` (`fib_table_insert()`):**
- `state = fa->fa_state` changed to `state = READ_ONCE(fa->fa_state)`
- This reads the state of an existing alias during route replacement,
  while RCU readers may be concurrently calling `fib_alias_accessed()`

**In `fib_trie.c` (`fib_table_delete()`):**
- `fa_to_delete->fa_state & FA_S_ACCESSED` changed to
  `READ_ONCE(fa_to_delete->fa_state) & FA_S_ACCESSED`
- This reads the state during route deletion while RCU readers may be
  concurrently modifying it

### 3. Bug Mechanism

The `fib_alias_accessed()` function is called under RCU read lock by
`fib_table_lookup()`. Multiple CPUs can execute this concurrently on the
same `fib_alias`. One CPU reads `fa_state`, checks if `FA_S_ACCESSED` is
set, and if not, sets it. Another CPU does the same thing
simultaneously. Without `READ_ONCE()`/`WRITE_ONCE()`, the compiler is
free to:
- Optimize away the read (use a cached value)
- Split the write into multiple stores
- Reorder the accesses

While the practical consequence here is relatively benign (the worst
case is a redundant cache flush or a missed `FA_S_ACCESSED` marking),
the data race is undefined behavior per the C standard and KCSAN
correctly flags it. These annotations are the standard Linux kernel
pattern for fixing such races.

### 4. Scope and Risk Assessment

- **Lines changed:** ~6 lines of actual code change across 2 files
- **Files touched:** 2 (both in the same subsystem: IPv4 FIB)
- **Risk:** Extremely low - `READ_ONCE()`/`WRITE_ONCE()` are transparent
  compiler barriers that don't change the logic
- **Subsystem:** Core IPv4 routing (FIB lookup) - very widely used
- **Could break something:** No. These annotations only prevent compiler
  optimizations that would be incorrect for concurrent access

### 5. User Impact

- **Who is affected:** Every system doing IPv4 routing (essentially all
  Linux systems)
- **Severity:** The data race itself is in a very hot path. While the
  practical consequence is low (it's a "set once" flag), undefined
  behavior in the kernel is always worth fixing
- **KCSAN noise:** Without this fix, KCSAN-enabled kernels will keep
  reporting this race, which affects kernel testing and development

### 6. Stable Kernel Criteria

- **Obviously correct:** Yes - textbook `READ_ONCE()`/`WRITE_ONCE()`
  annotation
- **Fixes a real bug:** Yes - KCSAN-detected data race, undefined
  behavior
- **Small and contained:** Yes - 6 lines across 2 files in one subsystem
- **No new features:** Correct - pure annotation fix
- **Tested:** Reviewed by Simon Horman, merged by Jakub Kicinski

### 7. Dependencies

No dependencies on other commits. `READ_ONCE()`/`WRITE_ONCE()` have been
available in the kernel for many years. The `fib_alias_accessed()`
function and `fa_state` field exist in all stable trees.

### Conclusion

This is a small, surgical fix for a KCSAN-detected data race in core
IPv4 FIB lookup code. It uses the standard `READ_ONCE()`/`WRITE_ONCE()`
pattern, has essentially zero risk of regression, and fixes undefined
behavior in one of the most heavily used kernel paths. It was reported
by syzbot, reviewed by a networking maintainer, and merged by the net
maintainer.

**YES**

 net/ipv4/fib_lookup.h | 6 ++++--
 net/ipv4/fib_trie.c   | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index f9b9e26c32c19..0b72796dd1ad3 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -28,8 +28,10 @@ struct fib_alias {
 /* Don't write on fa_state unless needed, to keep it shared on all cpus */
 static inline void fib_alias_accessed(struct fib_alias *fa)
 {
-	if (!(fa->fa_state & FA_S_ACCESSED))
-		fa->fa_state |= FA_S_ACCESSED;
+	u8 fa_state = READ_ONCE(fa->fa_state);
+
+	if (!(fa_state & FA_S_ACCESSED))
+		WRITE_ONCE(fa->fa_state, fa_state | FA_S_ACCESSED);
 }
 
 /* Exported by fib_semantics.c */
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 7e2c17fec3fc4..1308213791f19 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1280,7 +1280,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 			new_fa->fa_dscp = fa->fa_dscp;
 			new_fa->fa_info = fi;
 			new_fa->fa_type = cfg->fc_type;
-			state = fa->fa_state;
+			state = READ_ONCE(fa->fa_state);
 			new_fa->fa_state = state & ~FA_S_ACCESSED;
 			new_fa->fa_slen = fa->fa_slen;
 			new_fa->tb_id = tb->tb_id;
@@ -1745,7 +1745,7 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 
 	fib_remove_alias(t, tp, l, fa_to_delete);
 
-	if (fa_to_delete->fa_state & FA_S_ACCESSED)
+	if (READ_ONCE(fa_to_delete->fa_state) & FA_S_ACCESSED)
 		rt_cache_flush(cfg->fc_nlinfo.nl_net);
 
 	fib_release_info(fa_to_delete->fa_info);
-- 
2.51.0

