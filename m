Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373B434FF53;
	Fri, 21 Nov 2025 13:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732748; cv=none; b=DvlfAi5OUEuMlwsO1Zvee4QU/ShAFaATPhpW61ZNZiCWZDrU+Cvw6eew59GJ0j/3gdBcpMPyGOqWNpnzzJlJsp9cvRjW6TNdsnDErnVUtoaN0+wpAQI7ad4kzvDjFm4/xUNctQ4kGng3FRVTdI5KGs4jjvcG4iIe/AxwSC11I3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732748; c=relaxed/simple;
	bh=CNpTbdqcfKKNX17ch/5Y+0+YGyLe4UeyKbQL+bYB3yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xj038Mms/RnxvL7+/57Pw/xV/H0r3uDIyAcpH1IHDWF7lcrJxmv8PDsOrdGjRJgBOWjHZGqOSC9g9ki1VD5y+ea/NY6BK5z+CLnyy5T8nDQ1j/J1GGHidVW5JJw1JhU8vs//7ANarIxwZO6UPUl9NUtfJ5BjrfQ9Hvmr9tL5IAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFFDKZZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFFDKZZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85F7C4CEF1;
	Fri, 21 Nov 2025 13:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732748;
	bh=CNpTbdqcfKKNX17ch/5Y+0+YGyLe4UeyKbQL+bYB3yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFFDKZZkDcXINEjN129FHVFjce8nq5tQOiT1C4eCR2A4tUnyYGsk4FS7mWJ2WH5hr
	 olrXI4hX0xzMJCliCQOZO+i0bt84WySpQKMw06ZKP4uaN6t0rlT8E+qv/SlMunvdLy
	 ACJLe9WKSuxI2u5KKu7nO4qkvfHv3fk0uWTBG6GI=
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
Subject: [PATCH 6.6 229/529] net/cls_cgroup: Fix task_get_classid() during qdisc run
Date: Fri, 21 Nov 2025 14:08:48 +0100
Message-ID: <20251121130239.166826005@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



