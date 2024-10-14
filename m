Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B2519E802;
	Mon, 14 Oct 2024 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918746; cv=none; b=Sgjy+epYtzASQTgscXVbMlcZQJ3JXtTl56VVXxAGlnb9YPv2cbHKrSK9CTiZEMJQuutO2UK1wskQOqVWeqoNlkext64nk+17vIspqV/W3hYJWwAilQnoQAjy1RpTepwhJ27Pet8xOzJ9ZIC0ykDBCM0W8EN3rDKM/VBHJxsXtaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918746; c=relaxed/simple;
	bh=IMK0f197QuhCHE0HqKJdRBBJ098wy01A+8fkHl4885g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tghZSDJOKagGFXmL8Q/TMgic80Y3GI2vhSpjXAesGWuElGwDIQBUkMuhIx9m9Idy4TFOoYhRS1Mp//oYw9eR6A/WpHJCdYUybuEmA15rwltbjzr5VszsSd5zmcMThQu2v3X9HvescG9vdWr2XdGtFIJM1ALR7QiFr8/kyoF+9qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iy+8NHG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iy+8NHG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C791DC4CEC3;
	Mon, 14 Oct 2024 15:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918746;
	bh=IMK0f197QuhCHE0HqKJdRBBJ098wy01A+8fkHl4885g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iy+8NHG5PyMtB+pldYvSqgh+EpiCpiRBpArZ1+iSbqkKeEjmfCrjWFPU+JmPlosVK
	 5FDnKVK6ZgkJVmWS15nqbJ5uCbbRQyd9G8Iww7OxoNlrF/F/m5rBPHIRbZQswX/fvn
	 VadfROzpMbpkjUlNu/+GRgXMh81pOttl9pXv6pvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 394/798] netfilter: nf_tables: prevent nf_skb_duplicated corruption
Date: Mon, 14 Oct 2024 16:15:48 +0200
Message-ID: <20241014141233.422873634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 92ceba94de6fb4cee2bf40b485979c342f44a492 ]

syzbot found that nf_dup_ipv4() or nf_dup_ipv6() could write
per-cpu variable nf_skb_duplicated in an unsafe way [1].

Disabling preemption as hinted by the splat is not enough,
we have to disable soft interrupts as well.

[1]
BUG: using __this_cpu_write() in preemptible [00000000] code: syz.4.282/6316
 caller is nf_dup_ipv4+0x651/0x8f0 net/ipv4/netfilter/nf_dup_ipv4.c:87
CPU: 0 UID: 0 PID: 6316 Comm: syz.4.282 Not tainted 6.11.0-rc7-syzkaller-00104-g7052622fccb1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:93 [inline]
  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
  check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
  nf_dup_ipv4+0x651/0x8f0 net/ipv4/netfilter/nf_dup_ipv4.c:87
  nft_dup_ipv4_eval+0x1db/0x300 net/ipv4/netfilter/nft_dup_ipv4.c:30
  expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
  nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
  nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
  nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
  NF_HOOK_COND include/linux/netfilter.h:302 [inline]
  ip_output+0x185/0x230 net/ipv4/ip_output.c:433
  ip_local_out net/ipv4/ip_output.c:129 [inline]
  ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1495
  udp_send_skb+0xacf/0x1650 net/ipv4/udp.c:981
  udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1269
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x1a6/0x270 net/socket.c:745
  ____sys_sendmsg+0x525/0x7d0 net/socket.c:2597
  ___sys_sendmsg net/socket.c:2651 [inline]
  __sys_sendmmsg+0x3b2/0x740 net/socket.c:2737
  __do_sys_sendmmsg net/socket.c:2766 [inline]
  __se_sys_sendmmsg net/socket.c:2763 [inline]
  __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2763
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4ce4f7def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4ce5d4a038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f4ce5135f80 RCX: 00007f4ce4f7def9
RDX: 0000000000000001 RSI: 0000000020005d40 RDI: 0000000000000006
RBP: 00007f4ce4ff0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f4ce5135f80 R15: 00007ffd4cbc6d68
 </TASK>

Fixes: d877f07112f1 ("netfilter: nf_tables: add nft_dup expression")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_dup_ipv4.c | 7 +++++--
 net/ipv6/netfilter/nf_dup_ipv6.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index 6cc5743c553a0..9a21175693db5 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -52,8 +52,9 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 {
 	struct iphdr *iph;
 
+	local_bh_disable();
 	if (this_cpu_read(nf_skb_duplicated))
-		return;
+		goto out;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
 	 * the original skb, which should continue on its way as if nothing has
@@ -61,7 +62,7 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	 */
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
-		return;
+		goto out;
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	/* Avoid counting cloned packets towards the original connection. */
@@ -90,6 +91,8 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	} else {
 		kfree_skb(skb);
 	}
+out:
+	local_bh_enable();
 }
 EXPORT_SYMBOL_GPL(nf_dup_ipv4);
 
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index a0a2de30be3e7..0c39c77fe8a8a 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -47,11 +47,12 @@ static bool nf_dup_ipv6_route(struct net *net, struct sk_buff *skb,
 void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in6_addr *gw, int oif)
 {
+	local_bh_disable();
 	if (this_cpu_read(nf_skb_duplicated))
-		return;
+		goto out;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
-		return;
+		goto out;
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	nf_reset_ct(skb);
@@ -69,6 +70,8 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	} else {
 		kfree_skb(skb);
 	}
+out:
+	local_bh_enable();
 }
 EXPORT_SYMBOL_GPL(nf_dup_ipv6);
 
-- 
2.43.0



