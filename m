Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C26D35973;
	Tue,  8 Apr 2025 11:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112286; cv=none; b=UNkGAuT8SMvyJJSrAjMFd13T4rxTdzFfhCp4pyXc70o6Cm6jvlUh/IgU4h/ICfGY647kvb3bzOuCzYMQ9recxrfo3Kic5IX1RujCdw6CYKvCe9avO8cHTN33CRQ+KMn6p+e8Ppb9OK2IF02wdvj2wD9iqW2wspb5kYAIPpvZstg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112286; c=relaxed/simple;
	bh=2bUIK2EfUVDmb3y1yxVaCgdA2mfzFeBTJoU3bsorxBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWioESXIhTCaa78umsSeV1rhraa8VATYc8BjPgQfCc/wvnVmBIhU6NKEtEUxiAZ3atPlsg3RBAmzD0qmPrpZL8CUlLlPzISzb/SBp8FdgdBb8xHJI4lm0j0fGpkA8o+ZWSL/KZwZx2uu/U6K9mpsnt/8bS1tMG42K2Ak33OJe44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2EKvZ1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2EKvZ1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9D8C4CEE5;
	Tue,  8 Apr 2025 11:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112286;
	bh=2bUIK2EfUVDmb3y1yxVaCgdA2mfzFeBTJoU3bsorxBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2EKvZ1fJ3akeiIPPR1HPm0rJf0eV2LSTLzj3UA0uYvPzuW4cuNf06Ae8Kpu1kEWF
	 KkRh9EoTUaPNR5SJUGtf6jJnzEsW6veahHHSzvxsB7vhiF9R9ga06qMRbdV5VaQj9z
	 s7ZNEMaEev47XGqxFjVVoa962pvyrzS28k9gxlN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+83fed965338b573115f7@syzkaller.appspotmail.com,
	Kohei Enju <enjuk@amazon.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/279] netfilter: nf_conncount: Fully initialize struct nf_conncount_tuple in insert_tree()
Date: Tue,  8 Apr 2025 12:46:36 +0200
Message-ID: <20250408104826.739531523@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit d653bfeb07ebb3499c403404c21ac58a16531607 ]

Since commit b36e4523d4d5 ("netfilter: nf_conncount: fix garbage
collection confirm race"), `cpu` and `jiffies32` were introduced to
the struct nf_conncount_tuple.

The commit made nf_conncount_add() initialize `conn->cpu` and
`conn->jiffies32` when allocating the struct.
In contrast, count_tree() was not changed to initialize them.

By commit 34848d5c896e ("netfilter: nf_conncount: Split insert and
traversal"), count_tree() was split and the relevant allocation
code now resides in insert_tree().
Initialize `conn->cpu` and `conn->jiffies32` in insert_tree().

BUG: KMSAN: uninit-value in find_or_evict net/netfilter/nf_conncount.c:117 [inline]
BUG: KMSAN: uninit-value in __nf_conncount_add+0xd9c/0x2850 net/netfilter/nf_conncount.c:143
 find_or_evict net/netfilter/nf_conncount.c:117 [inline]
 __nf_conncount_add+0xd9c/0x2850 net/netfilter/nf_conncount.c:143
 count_tree net/netfilter/nf_conncount.c:438 [inline]
 nf_conncount_count+0x82f/0x1e80 net/netfilter/nf_conncount.c:521
 connlimit_mt+0x7f6/0xbd0 net/netfilter/xt_connlimit.c:72
 __nft_match_eval net/netfilter/nft_compat.c:403 [inline]
 nft_match_eval+0x1a5/0x300 net/netfilter/nft_compat.c:433
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x426/0x2290 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x1a5/0x230 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
 nf_hook_slow_list+0x24d/0x860 net/netfilter/core.c:663
 NF_HOOK_LIST include/linux/netfilter.h:350 [inline]
 ip_sublist_rcv+0x17b7/0x17f0 net/ipv4/ip_input.c:633
 ip_list_rcv+0x9ef/0xa40 net/ipv4/ip_input.c:669
 __netif_receive_skb_list_ptype net/core/dev.c:5936 [inline]
 __netif_receive_skb_list_core+0x15c5/0x1670 net/core/dev.c:5983
 __netif_receive_skb_list net/core/dev.c:6035 [inline]
 netif_receive_skb_list_internal+0x1085/0x1700 net/core/dev.c:6126
 netif_receive_skb_list+0x5a/0x460 net/core/dev.c:6178
 xdp_recv_frames net/bpf/test_run.c:280 [inline]
 xdp_test_run_batch net/bpf/test_run.c:361 [inline]
 bpf_test_run_xdp_live+0x2e86/0x3480 net/bpf/test_run.c:390
 bpf_prog_test_run_xdp+0xf1d/0x1ae0 net/bpf/test_run.c:1316
 bpf_prog_test_run+0x5e5/0xa30 kernel/bpf/syscall.c:4407
 __sys_bpf+0x6aa/0xd90 kernel/bpf/syscall.c:5813
 __do_sys_bpf kernel/bpf/syscall.c:5902 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5900 [inline]
 __ia32_sys_bpf+0xa0/0xe0 kernel/bpf/syscall.c:5900
 ia32_sys_call+0x394d/0x4180 arch/x86/include/generated/asm/syscalls_32.h:358
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:387
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:412
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:450
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4121 [inline]
 slab_alloc_node mm/slub.c:4164 [inline]
 kmem_cache_alloc_noprof+0x915/0xe10 mm/slub.c:4171
 insert_tree net/netfilter/nf_conncount.c:372 [inline]
 count_tree net/netfilter/nf_conncount.c:450 [inline]
 nf_conncount_count+0x1415/0x1e80 net/netfilter/nf_conncount.c:521
 connlimit_mt+0x7f6/0xbd0 net/netfilter/xt_connlimit.c:72
 __nft_match_eval net/netfilter/nft_compat.c:403 [inline]
 nft_match_eval+0x1a5/0x300 net/netfilter/nft_compat.c:433
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x426/0x2290 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x1a5/0x230 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
 nf_hook_slow_list+0x24d/0x860 net/netfilter/core.c:663
 NF_HOOK_LIST include/linux/netfilter.h:350 [inline]
 ip_sublist_rcv+0x17b7/0x17f0 net/ipv4/ip_input.c:633
 ip_list_rcv+0x9ef/0xa40 net/ipv4/ip_input.c:669
 __netif_receive_skb_list_ptype net/core/dev.c:5936 [inline]
 __netif_receive_skb_list_core+0x15c5/0x1670 net/core/dev.c:5983
 __netif_receive_skb_list net/core/dev.c:6035 [inline]
 netif_receive_skb_list_internal+0x1085/0x1700 net/core/dev.c:6126
 netif_receive_skb_list+0x5a/0x460 net/core/dev.c:6178
 xdp_recv_frames net/bpf/test_run.c:280 [inline]
 xdp_test_run_batch net/bpf/test_run.c:361 [inline]
 bpf_test_run_xdp_live+0x2e86/0x3480 net/bpf/test_run.c:390
 bpf_prog_test_run_xdp+0xf1d/0x1ae0 net/bpf/test_run.c:1316
 bpf_prog_test_run+0x5e5/0xa30 kernel/bpf/syscall.c:4407
 __sys_bpf+0x6aa/0xd90 kernel/bpf/syscall.c:5813
 __do_sys_bpf kernel/bpf/syscall.c:5902 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5900 [inline]
 __ia32_sys_bpf+0xa0/0xe0 kernel/bpf/syscall.c:5900
 ia32_sys_call+0x394d/0x4180 arch/x86/include/generated/asm/syscalls_32.h:358
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:387
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:412
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:450
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Reported-by: syzbot+83fed965338b573115f7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83fed965338b573115f7
Fixes: b36e4523d4d5 ("netfilter: nf_conncount: fix garbage collection confirm race")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 0ce12a33ffda4..a66a27fe7f458 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -366,6 +366,8 @@ insert_tree(struct net *net,
 
 	conn->tuple = *tuple;
 	conn->zone = *zone;
+	conn->cpu = raw_smp_processor_id();
+	conn->jiffies32 = (u32)jiffies;
 	memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
 
 	nf_conncount_list_init(&rbconn->list);
-- 
2.39.5



