Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9F727E040;
	Tue, 11 Nov 2025 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823942; cv=none; b=C2LgjClDrx/SqI0jvyZeFbyAYLUyhuVfbSWSrCWHfp+/Jof0+3NXojgIpzVG7mr3Aiue7ttR0ywu4QcUx4twIvM82gtIlzQh7r1V5TaZ7zCLsfZL2Nq6mCScv0JR0L0wRp0hy8iNyEhcVLahdR7gpueOMLEI1+Uka8fYiUJR/p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823942; c=relaxed/simple;
	bh=gpIKHO6uvRpFwD/Jsh7lhmBouexOW32Bx2z01K/VeGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sptpBxWnhxiw5lah7qbeH5qQHN3It0QaeBfiGbbXwHlXh40FlazEQpvffihMzfnpiBLg27+eoHJLyN0LKk1kJnZqckbNNCDYo8f42NRlctlxCrufCpqCzWwuDOs0Z/2t3CN6KYbNQpNKSfDgvGwDRcxr4UvC9Y8ucBURWNfaXO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OpI8cQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OpI8cQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE36C4CEFB;
	Tue, 11 Nov 2025 01:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823942;
	bh=gpIKHO6uvRpFwD/Jsh7lhmBouexOW32Bx2z01K/VeGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OpI8cQxic3ErkmrIvyIDPqZzgDB6z4vVfgAzySB9FDTmYc9b6XbqzP/BtcoNYuCG
	 iAGJqI6sygRUYZcoBu0PQ411aU1P0XtBxwq+wGAFB0/yNOPzrUGyl0wsawmPXBbJ44
	 Le49dvI+zgo9XJLr0CDe0QRpC9ESUhddXRf9Iz5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Thomas Graf <tgraf@suug.ch>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 354/565] net/cls_cgroup: Fix task_get_classid() during qdisc run
Date: Tue, 11 Nov 2025 09:43:30 +0900
Message-ID: <20251111004534.835951592@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 66048f8b3cc7e462953c04285183cdee43a1cb89 ]

During recent testing with the netem qdisc to inject delays into TCP
traffic, we observed that our CLS BPF program failed to function correctly
due to incorrect classid retrieval from task_get_classid(). The issue
manifests in the following call stack:

        bpf_get_cgroup_classid+5
        cls_bpf_classify+507
        __tcf_classify+90
        tcf_classify+217
        __dev_queue_xmit+798
        bond_dev_queue_xmit+43
        __bond_start_xmit+211
        bond_start_xmit+70
        dev_hard_start_xmit+142
        sch_direct_xmit+161
        __qdisc_run+102             <<<<< Issue location
        __dev_xmit_skb+1015
        __dev_queue_xmit+637
        neigh_hh_output+159
        ip_finish_output2+461
        __ip_finish_output+183
        ip_finish_output+41
        ip_output+120
        ip_local_out+94
        __ip_queue_xmit+394
        ip_queue_xmit+21
        __tcp_transmit_skb+2169
        tcp_write_xmit+959
        __tcp_push_pending_frames+55
        tcp_push+264
        tcp_sendmsg_locked+661
        tcp_sendmsg+45
        inet_sendmsg+67
        sock_sendmsg+98
        sock_write_iter+147
        vfs_write+786
        ksys_write+181
        __x64_sys_write+25
        do_syscall_64+56
        entry_SYSCALL_64_after_hwframe+100

The problem occurs when multiple tasks share a single qdisc. In such cases,
__qdisc_run() may transmit skbs created by different tasks. Consequently,
task_get_classid() retrieves an incorrect classid since it references the
current task's context rather than the skb's originating task.

Given that dev_queue_xmit() always executes with bh disabled, we can use
softirq_count() instead to obtain the correct classid.

The simple steps to reproduce this issue:
1. Add network delay to the network interface:
  such as: tc qdisc add dev bond0 root netem delay 1.5ms
2. Build two distinct net_cls cgroups, each with a network-intensive task
3. Initiate parallel TCP streams from both tasks to external servers.

Under this specific condition, the issue reliably occurs. The kernel
eventually dequeues an SKB that originated from Task-A while executing in
the context of Task-B.

It is worth noting that it will change the established behavior for a
slightly different scenario:

  <sock S is created by task A>
  <class ID for task A is changed>
  <skb is created by sock S xmit and classified>

prior to this patch the skb will be classified with the 'new' task A
classid, now with the old/original one. The bpf_get_cgroup_classid_curr()
function is a more appropriate choice for this case.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250902062933.30087-1-laoar.shao@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cls_cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index 7e78e7d6f0152..668aeee9b3f66 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -63,7 +63,7 @@ static inline u32 task_get_classid(const struct sk_buff *skb)
 	 * calls by looking at the number of nested bh disable calls because
 	 * softirqs always disables bh.
 	 */
-	if (in_serving_softirq()) {
+	if (softirq_count()) {
 		struct sock *sk = skb_to_full_sk(skb);
 
 		/* If there is an sock_cgroup_classid we'll use that. */
-- 
2.51.0



