Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE242472A2;
	Mon, 23 Jun 2025 13:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685420; cv=none; b=MKXKdza2HPxpGynSB8hFGvp7NNRXk45W7YE6iaDZycBp2L5I9okL/3pn12GpK2ysvPJIbF8b0BkhQVTVk32QbHCU9jObpmPfb27v/J/zEWZ2nZJmXXgVSQH70WecekhHqn+WSsa9S/4AI8f6fkUd/JJDOEoiZ9Q4zR1KAkoBBF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685420; c=relaxed/simple;
	bh=NpIDkXqD3f9FL04xKfTGVdgEYFZfJV0hkl6iUt3AMnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhlAe/EERtWxTjAYkIeVeTLc4+9poh6ZQM+WZhWzdXSj6oIsgHWg2y0xfXzNfAjwui8VGBjd8LRuOWe8nX812dK1IJG4TDzCNvP2Wlj1r9w3cpXy4jfbIIa7xu27dL7h5AtwfzRNkNgINGpwVNFaBxO9GlenSsFyjlAsRSEjMqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egk71HbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egk71HbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02801C4CEEA;
	Mon, 23 Jun 2025 13:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685420;
	bh=NpIDkXqD3f9FL04xKfTGVdgEYFZfJV0hkl6iUt3AMnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egk71HbEU7oUHZQKq/5hfEK1R4NLxAREzisFC/2I07lrrYgzPH08BPXlOD3BgnQAk
	 ecZvm8FTLOw8Gqr4rbDJNp2BSWuhrxvG4yDYg/yBhnVkB8KmHqsQxLfRQ/yj3Z1O5+
	 UezrakM35D8DOCSPIi/J8C9rCazaLhtZezifF5YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45b0c89a0fc7ae8dbadc@syzkaller.appspotmail.com,
	Alexei Starovoitov <ast@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/411] bpf: Fix WARN() in get_bpf_raw_tp_regs
Date: Mon, 23 Jun 2025 15:03:22 +0200
Message-ID: <20250623130634.732225896@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit 3880cdbed1c4607e378f58fa924c5d6df900d1d3 ]

syzkaller reported an issue:

WARNING: CPU: 3 PID: 5971 at kernel/trace/bpf_trace.c:1861 get_bpf_raw_tp_regs+0xa4/0x100 kernel/trace/bpf_trace.c:1861
Modules linked in:
CPU: 3 UID: 0 PID: 5971 Comm: syz-executor205 Not tainted 6.15.0-rc5-syzkaller-00038-g707df3375124 #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:get_bpf_raw_tp_regs+0xa4/0x100 kernel/trace/bpf_trace.c:1861
RSP: 0018:ffffc90003636fa8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffffff81c6bc4c
RDX: ffff888032efc880 RSI: ffffffff81c6bc83 RDI: 0000000000000005
RBP: ffff88806a730860 R08: 0000000000000005 R09: 0000000000000003
R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000004
R13: 0000000000000001 R14: ffffc90003637008 R15: 0000000000000900
FS:  0000000000000000(0000) GS:ffff8880d6cdf000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7baee09130 CR3: 0000000029f5a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ____bpf_get_stack_raw_tp kernel/trace/bpf_trace.c:1934 [inline]
 bpf_get_stack_raw_tp+0x24/0x160 kernel/trace/bpf_trace.c:1931
 bpf_prog_ec3b2eefa702d8d3+0x43/0x47
 bpf_dispatcher_nop_func include/linux/bpf.h:1316 [inline]
 __bpf_prog_run include/linux/filter.h:718 [inline]
 bpf_prog_run include/linux/filter.h:725 [inline]
 __bpf_trace_run kernel/trace/bpf_trace.c:2363 [inline]
 bpf_trace_run3+0x23f/0x5a0 kernel/trace/bpf_trace.c:2405
 __bpf_trace_mmap_lock_acquire_returned+0xfc/0x140 include/trace/events/mmap_lock.h:47
 __traceiter_mmap_lock_acquire_returned+0x79/0xc0 include/trace/events/mmap_lock.h:47
 __do_trace_mmap_lock_acquire_returned include/trace/events/mmap_lock.h:47 [inline]
 trace_mmap_lock_acquire_returned include/trace/events/mmap_lock.h:47 [inline]
 __mmap_lock_do_trace_acquire_returned+0x138/0x1f0 mm/mmap_lock.c:35
 __mmap_lock_trace_acquire_returned include/linux/mmap_lock.h:36 [inline]
 mmap_read_trylock include/linux/mmap_lock.h:204 [inline]
 stack_map_get_build_id_offset+0x535/0x6f0 kernel/bpf/stackmap.c:157
 __bpf_get_stack+0x307/0xa10 kernel/bpf/stackmap.c:483
 ____bpf_get_stack kernel/bpf/stackmap.c:499 [inline]
 bpf_get_stack+0x32/0x40 kernel/bpf/stackmap.c:496
 ____bpf_get_stack_raw_tp kernel/trace/bpf_trace.c:1941 [inline]
 bpf_get_stack_raw_tp+0x124/0x160 kernel/trace/bpf_trace.c:1931
 bpf_prog_ec3b2eefa702d8d3+0x43/0x47

Tracepoint like trace_mmap_lock_acquire_returned may cause nested call
as the corner case show above, which will be resolved with more general
method in the future. As a result, WARN_ON_ONCE will be triggered. As
Alexei suggested, remove the WARN_ON_ONCE first.

Fixes: 9594dc3c7e71 ("bpf: fix nested bpf tracepoints with per-cpu data")
Reported-by: syzbot+45b0c89a0fc7ae8dbadc@syzkaller.appspotmail.com
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250513042747.757042-1-chen.dylane@linux.dev

Closes: https://lore.kernel.org/bpf/8bc2554d-1052-4922-8832-e0078a033e1d@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index dba736defdfec..e08928f4a862f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1408,7 +1408,7 @@ static struct pt_regs *get_bpf_raw_tp_regs(void)
 	struct bpf_raw_tp_regs *tp_regs = this_cpu_ptr(&bpf_raw_tp_regs);
 	int nest_level = this_cpu_inc_return(bpf_raw_tp_nest_level);
 
-	if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(tp_regs->regs))) {
+	if (nest_level > ARRAY_SIZE(tp_regs->regs)) {
 		this_cpu_dec(bpf_raw_tp_nest_level);
 		return ERR_PTR(-EBUSY);
 	}
-- 
2.39.5



