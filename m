Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3999F340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301116; cv=none; b=QYGBPglJX5E6hU4mt+yQYc73mdVzZyY9zpS7XxLVvE1gFpM1gPrKr9G4MidUBw8JwRhAofay6x/DkcKWW9+zTkRP9UeFnqmXV+HBp050D19ZybzgoIfqr+ayvrBkz6tUOwT/e4cxM5KSqUP1RtKHRZGT1BWkJ4jpWh/A7QjB9OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301116; c=relaxed/simple;
	bh=8SNhOOm44b/ACAd188vKHovcDjXTTfUaUnS/ehVfOZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgyHMfCOjht8iQ7sTNnb8moBuPjJ0Us0FOTDHzIkM+GexHTANA/3P+NHQM7MGYGeob3YyIk1Jf5vrez2vWnLIgpq0tUO3YwrYnKGKbIDhLCJ3G3Tm/OXfcGvPND+BoeoYWgzgXJrh0BWWLqeTatnOX3Z+NxZEu+BA9wAwn/c+c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q3UB0zMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q3UB0zMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725F5C116D0;
	Sat, 28 Feb 2026 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301116;
	bh=8SNhOOm44b/ACAd188vKHovcDjXTTfUaUnS/ehVfOZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3UB0zMDUmILv9wnQc/Tld/G8Ku1DCSHL4xb6U/MOORz5X6Fy29js85yRwb8cj/7u
	 gnEeFJCoHnxQt5FISVmWDF9/MPTzcm6H7cYqkaixAe2Mr3y9S55M6Yi4W7Uw2r9gnv
	 4kmlP+sZQm7DzfvskbElLekHFfvvuh7UT40NVNRdIDOWAdxHYIA93O5NcKM7ACUWIr
	 ZyihRsHX0xRzq9nFHg7qR2bROvP9MNnU6L+wkK6jJecrhDTGRqDrtXa9Ild4S8YyQA
	 ufGQq0LDpSx9WQSF8PZCbd8zUJ8MNs+McByTU5QMS641t10nPbQG0FUyGhPffqh37T
	 JvNQYL+7fOi/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
	syzbot+d24f940f770afda885cf@syzkaller.appspotmail.com,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 272/752] ipv4: fib: Annotate access to struct fib_alias.fa_state.
Date: Sat, 28 Feb 2026 12:39:43 -0500
Message-ID: <20260228174750.1542406-272-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

