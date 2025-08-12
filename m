Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424A32FA0DB;
	Tue, 12 Aug 2025 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021309; cv=none; b=M0A8z7J2WrILHE3m567VSd3rRNobQ4ijRGtyd60WcidDWXvh7QbZfCBmXc+scbg4JZfSk5eRhw81+w509HvN0PDYxcOoamAEh6VRdYYzdA4C8ZQ7H9RQsO7JXlLVedT6Kx086J7lw56E4tKFmxIYzNkB+yxrzlwBc5tggoAf0OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021309; c=relaxed/simple;
	bh=LeCHp5AyjDupErHELHkx2Vw7FZLlHrXPMMj8+K0JTN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBGcHkXQIDcfawvEYzcJB8zoP94pTlGZCgW+sLzjqnIvXMTSAK6p4Nk56SV/PSZ6EK1qjs5KehnAiJYrH+/XFe6LK2qK14FuV+mhoZTWi+A4PyJK8WsJVfJGJaFxKEKT/YjI3WY5EE8o/cZrGbKcQUmKHjHlRdsUu0WDTHPAfXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knnrXZ11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knnrXZ11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E02C4CEF0;
	Tue, 12 Aug 2025 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021308;
	bh=LeCHp5AyjDupErHELHkx2Vw7FZLlHrXPMMj8+K0JTN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knnrXZ11eHfKySRe8TRLN1yec/zBWhP3+moF6ZMJd9ApeAs+uEtD2sCsSP4Mc0S3C
	 gRMVOLDmuQS/D09ugzfIbGpYr0pGdZxssuVLMYOxRMnCFcSxsc6/PoeY4xOBhaMzHY
	 8yuScFS2OSGpoCyrqaBdlQZBJIjsChWXifnm7/+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+40f772d37250b6d10efc@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/262] bpf: Disable migration in nf_hook_run_bpf().
Date: Tue, 12 Aug 2025 19:28:01 +0200
Message-ID: <20250812172957.028347131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 17ce3e5949bc37557305ad46316f41c7875d6366 ]

syzbot reported that the netfilter bpf prog can be called without
migration disabled in xmit path.

Then the assertion in __bpf_prog_run() fails, triggering the splat
below. [0]

Let's use bpf_prog_run_pin_on_cpu() in nf_hook_run_bpf().

[0]:
BUG: assuming non migratable context at ./include/linux/filter.h:703
in_atomic(): 0, irqs_disabled(): 0, migration_disabled() 0 pid: 5829, name: sshd-session
3 locks held by sshd-session/5829:
 #0: ffff88807b4e4218 (sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1667 [inline]
 #0: ffff88807b4e4218 (sk_lock-AF_INET){+.+.}-{0:0}, at: tcp_sendmsg+0x20/0x50 net/ipv4/tcp.c:1395
 #1: ffffffff8e5c4e00 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #1: ffffffff8e5c4e00 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #1: ffffffff8e5c4e00 (rcu_read_lock){....}-{1:3}, at: __ip_queue_xmit+0x69/0x26c0 net/ipv4/ip_output.c:470
 #2: ffffffff8e5c4e00 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #2: ffffffff8e5c4e00 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #2: ffffffff8e5c4e00 (rcu_read_lock){....}-{1:3}, at: nf_hook+0xb2/0x680 include/linux/netfilter.h:241
CPU: 0 UID: 0 PID: 5829 Comm: sshd-session Not tainted 6.16.0-rc6-syzkaller-00002-g155a3c003e55 #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x16c/0x1f0 lib/dump_stack.c:120
 __cant_migrate kernel/sched/core.c:8860 [inline]
 __cant_migrate+0x1c7/0x250 kernel/sched/core.c:8834
 __bpf_prog_run include/linux/filter.h:703 [inline]
 bpf_prog_run include/linux/filter.h:725 [inline]
 nf_hook_run_bpf+0x83/0x1e0 net/netfilter/nf_bpf_link.c:20
 nf_hook_entry_hookfn include/linux/netfilter.h:157 [inline]
 nf_hook_slow+0xbb/0x200 net/netfilter/core.c:623
 nf_hook+0x370/0x680 include/linux/netfilter.h:272
 NF_HOOK_COND include/linux/netfilter.h:305 [inline]
 ip_output+0x1bc/0x2a0 net/ipv4/ip_output.c:433
 dst_output include/net/dst.h:459 [inline]
 ip_local_out net/ipv4/ip_output.c:129 [inline]
 __ip_queue_xmit+0x1d7d/0x26c0 net/ipv4/ip_output.c:527
 __tcp_transmit_skb+0x2686/0x3e90 net/ipv4/tcp_output.c:1479
 tcp_transmit_skb net/ipv4/tcp_output.c:1497 [inline]
 tcp_write_xmit+0x1274/0x84e0 net/ipv4/tcp_output.c:2838
 __tcp_push_pending_frames+0xaf/0x390 net/ipv4/tcp_output.c:3021
 tcp_push+0x225/0x700 net/ipv4/tcp.c:759
 tcp_sendmsg_locked+0x1870/0x42b0 net/ipv4/tcp.c:1359
 tcp_sendmsg+0x2e/0x50 net/ipv4/tcp.c:1396
 inet_sendmsg+0xb9/0x140 net/ipv4/af_inet.c:851
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg net/socket.c:727 [inline]
 sock_write_iter+0x4aa/0x5b0 net/socket.c:1131
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x6c7/0x1150 fs/read_write.c:686
 ksys_write+0x1f8/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7d365d407
Code: 48 89 fa 4c 89 df e8 38 aa 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP:

Fixes: fd9c663b9ad67 ("bpf: minimal support for programs hooked into netfilter framework")
Reported-by: syzbot+40f772d37250b6d10efc@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6879466d.a00a0220.3af5df.0022.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Tested-by: syzbot+40f772d37250b6d10efc@syzkaller.appspotmail.com
Acked-by: Florian Westphal <fw@strlen.de>
Link: https://patch.msgid.link/20250722224041.112292-1-kuniyu@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_bpf_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 2aad0562a413..a851553fbbb0 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -17,7 +17,7 @@ static unsigned int nf_hook_run_bpf(void *bpf_prog, struct sk_buff *skb,
 		.skb = skb,
 	};
 
-	return bpf_prog_run(prog, &ctx);
+	return bpf_prog_run_pin_on_cpu(prog, &ctx);
 }
 
 struct bpf_nf_link {
-- 
2.39.5



