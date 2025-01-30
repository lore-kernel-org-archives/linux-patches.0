Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6C81E570E;
	Thu, 30 Jan 2025 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245728; cv=none; b=E78gE5CIrdI9172YJMXbIcl/oQUA8XCiB2FuFFZIAOwxMMW7x0bjPB9jBNKJ5A+Fz0ChREq/GFaHi3YokYEPqYWqR2LW6VNR/o0qbsGyY0Mnu2S+f8f2H7xFykfsIzrx3YbH116jJCUjfXz+BMuA6CrbLJuWTfuLWTnfl1qeGN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245728; c=relaxed/simple;
	bh=zQvdwU8palgefrPg/15gvJ3gsg5vhx+cP1Ex+1x8oxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMIusIIY5gG0kd04eXk0DpyCtsqZ20Z+4rS6NT32AiVsIlRkL087AsZIerfvUs2J3szzmz9LTNYggnmbV/cXRYnTqWoey4JgTpvuOa3a/1/jNls8Knwb+6qDYI+VQFUDa87yXRzFPqOdUEq33awO5nUudHIwQeDdu8EHzS/8y1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAmxqjBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAmxqjBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C836C4CED2;
	Thu, 30 Jan 2025 14:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245728;
	bh=zQvdwU8palgefrPg/15gvJ3gsg5vhx+cP1Ex+1x8oxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAmxqjBzXnYgBJwnCdSTqNUahCQbD+QtY2Lpi40MSeY5qp9Ja01tKNB+sHFNTD0PD
	 sG2gSY98B2H+aIC2NoTnYDRb1c+V8pNB5tVTgWWaPwh/tBry7RkYAT+43BxwKpFbLX
	 /lIz3n8xd6WCoWO1UUjiIyLYdMJZrGGgtwdPnWhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haowei Yan <g1042620637@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@google.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 24/40] net: sched: fix ets qdisc OOB Indexing
Date: Thu, 30 Jan 2025 14:59:24 +0100
Message-ID: <20250130133500.675509405@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit d62b04fca4340a0d468d7853bd66e511935a18cb upstream.

Haowei Yan <g1042620637@gmail.com> found that ets_class_from_arg() can
index an Out-Of-Bound class in ets_class_from_arg() when passed clid of
0. The overflow may cause local privilege escalation.

 [   18.852298] ------------[ cut here ]------------
 [   18.853271] UBSAN: array-index-out-of-bounds in net/sched/sch_ets.c:93:20
 [   18.853743] index 18446744073709551615 is out of range for type 'ets_class [16]'
 [   18.854254] CPU: 0 UID: 0 PID: 1275 Comm: poc Not tainted 6.12.6-dirty #17
 [   18.854821] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
 [   18.856532] Call Trace:
 [   18.857441]  <TASK>
 [   18.858227]  dump_stack_lvl+0xc2/0xf0
 [   18.859607]  dump_stack+0x10/0x20
 [   18.860908]  __ubsan_handle_out_of_bounds+0xa7/0xf0
 [   18.864022]  ets_class_change+0x3d6/0x3f0
 [   18.864322]  tc_ctl_tclass+0x251/0x910
 [   18.864587]  ? lock_acquire+0x5e/0x140
 [   18.865113]  ? __mutex_lock+0x9c/0xe70
 [   18.866009]  ? __mutex_lock+0xa34/0xe70
 [   18.866401]  rtnetlink_rcv_msg+0x170/0x6f0
 [   18.866806]  ? __lock_acquire+0x578/0xc10
 [   18.867184]  ? __pfx_rtnetlink_rcv_msg+0x10/0x10
 [   18.867503]  netlink_rcv_skb+0x59/0x110
 [   18.867776]  rtnetlink_rcv+0x15/0x30
 [   18.868159]  netlink_unicast+0x1c3/0x2b0
 [   18.868440]  netlink_sendmsg+0x239/0x4b0
 [   18.868721]  ____sys_sendmsg+0x3e2/0x410
 [   18.869012]  ___sys_sendmsg+0x88/0xe0
 [   18.869276]  ? rseq_ip_fixup+0x198/0x260
 [   18.869563]  ? rseq_update_cpu_node_id+0x10a/0x190
 [   18.869900]  ? trace_hardirqs_off+0x5a/0xd0
 [   18.870196]  ? syscall_exit_to_user_mode+0xcc/0x220
 [   18.870547]  ? do_syscall_64+0x93/0x150
 [   18.870821]  ? __memcg_slab_free_hook+0x69/0x290
 [   18.871157]  __sys_sendmsg+0x69/0xd0
 [   18.871416]  __x64_sys_sendmsg+0x1d/0x30
 [   18.871699]  x64_sys_call+0x9e2/0x2670
 [   18.871979]  do_syscall_64+0x87/0x150
 [   18.873280]  ? do_syscall_64+0x93/0x150
 [   18.874742]  ? lock_release+0x7b/0x160
 [   18.876157]  ? do_user_addr_fault+0x5ce/0x8f0
 [   18.877833]  ? irqentry_exit_to_user_mode+0xc2/0x210
 [   18.879608]  ? irqentry_exit+0x77/0xb0
 [   18.879808]  ? clear_bhb_loop+0x15/0x70
 [   18.880023]  ? clear_bhb_loop+0x15/0x70
 [   18.880223]  ? clear_bhb_loop+0x15/0x70
 [   18.880426]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 [   18.880683] RIP: 0033:0x44a957
 [   18.880851] Code: ff ff e8 fc 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 8974 24 10
 [   18.881766] RSP: 002b:00007ffcdd00fad8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 [   18.882149] RAX: ffffffffffffffda RBX: 00007ffcdd010db8 RCX: 000000000044a957
 [   18.882507] RDX: 0000000000000000 RSI: 00007ffcdd00fb70 RDI: 0000000000000003
 [   18.885037] RBP: 00007ffcdd010bc0 R08: 000000000703c770 R09: 000000000703c7c0
 [   18.887203] R10: 0000000000000080 R11: 0000000000000246 R12: 0000000000000001
 [   18.888026] R13: 00007ffcdd010da8 R14: 00000000004ca7d0 R15: 0000000000000001
 [   18.888395]  </TASK>
 [   18.888610] ---[ end trace ]---

Fixes: dcc68b4d8084 ("net: sch_ets: Add a new Qdisc")
Reported-by: Haowei Yan <g1042620637@gmail.com>
Suggested-by: Haowei Yan <g1042620637@gmail.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20250111145740.74755-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_ets.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -91,6 +91,8 @@ ets_class_from_arg(struct Qdisc *sch, un
 {
 	struct ets_sched *q = qdisc_priv(sch);
 
+	if (arg == 0 || arg > q->nbands)
+		return NULL;
 	return &q->classes[arg - 1];
 }
 


