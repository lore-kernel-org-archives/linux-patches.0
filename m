Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699B73370E3;
	Fri, 17 Oct 2025 14:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713111; cv=none; b=BqJmQpGr9ZqrkmGCNAHilsIpOaTYlBPQ3eyLCKp2yhW/l1h7LUhcf21vWopNrURH3ScsF2q4ob1FxuFJLR5tnyC2SEBn1OoKtk2uk8RanjK9t2WhHbk1OcUStQdDap3eaWcTgiSMAGRITA6dHUoslPPLBWbzvTeRMbjcnZQwGkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713111; c=relaxed/simple;
	bh=LZRIJbmo3jQsbnDKi0u5WRrsQonz6cUM1QzY4eQBWTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o60NdL4W0N2uYu73ahpxIEcjn7FGmoXquZm1vsOanisqkyK+CqWDMZjEvSCZZvkUWwYS/cvoaS4+RGl6I5p6DJluQxdLUQznpT23QJcbXaDzTrXI2JPenmX0e5LgH23oVSXrlZAha975UdzWuGOtDFvDZTHbqwv1wMHVlXwfVdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moXZziKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moXZziKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7316C4CEE7;
	Fri, 17 Oct 2025 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713111;
	bh=LZRIJbmo3jQsbnDKi0u5WRrsQonz6cUM1QzY4eQBWTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moXZziKtYQ9J766ogiC9C3PDbpNZG3IuBy8T/2+z5qrrRdY8xHhDyZoAlQ57+h6cH
	 VUEs6rSDZ1abA5j5rY+EZCjug+Ff+iu4D3I97nRHf18S+OpPkIXG0FtBrSuBkZQV8G
	 BxJd161D9LVKkStmRyMbzorCrZX5atpLwH1/IJj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Le Chen <tom2cat@sjtu.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	KaFai Wan <kafai.wan@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/168] bpf: Avoid RCU context warning when unpinning htab with internal structs
Date: Fri, 17 Oct 2025 16:52:09 +0200
Message-ID: <20251017145130.860904545@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KaFai Wan <kafai.wan@linux.dev>

[ Upstream commit 4f375ade6aa9f37fd72d7a78682f639772089eed ]

When unpinning a BPF hash table (htab or htab_lru) that contains internal
structures (timer, workqueue, or task_work) in its values, a BUG warning
is triggered:
 BUG: sleeping function called from invalid context at kernel/bpf/hashtab.c:244
 in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 14, name: ksoftirqd/0
 ...

The issue arises from the interaction between BPF object unpinning and
RCU callback mechanisms:
1. BPF object unpinning uses ->free_inode() which schedules cleanup via
   call_rcu(), deferring the actual freeing to an RCU callback that
   executes within the RCU_SOFTIRQ context.
2. During cleanup of hash tables containing internal structures,
   htab_map_free_internal_structs() is invoked, which includes
   cond_resched() or cond_resched_rcu() calls to yield the CPU during
   potentially long operations.

However, cond_resched() or cond_resched_rcu() cannot be safely called from
atomic RCU softirq context, leading to the BUG warning when attempting
to reschedule.

Fix this by changing from ->free_inode() to ->destroy_inode() and rename
bpf_free_inode() to bpf_destroy_inode() for BPF objects (prog, map, link).
This allows direct inode freeing without RCU callback scheduling,
avoiding the invalid context warning.

Reported-by: Le Chen <tom2cat@sjtu.edu.cn>
Closes: https://lore.kernel.org/all/1444123482.1827743.1750996347470.JavaMail.zimbra@sjtu.edu.cn/
Fixes: 68134668c17f ("bpf: Add map side support for bpf timers.")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: KaFai Wan <kafai.wan@linux.dev>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20251008102628.808045-2-kafai.wan@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 4f841e16779e7..9b184f3fbf45f 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -610,7 +610,7 @@ static int bpf_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
-static void bpf_free_inode(struct inode *inode)
+static void bpf_destroy_inode(struct inode *inode)
 {
 	enum bpf_type type;
 
@@ -625,7 +625,7 @@ static const struct super_operations bpf_super_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 	.show_options	= bpf_show_options,
-	.free_inode	= bpf_free_inode,
+	.destroy_inode	= bpf_destroy_inode,
 };
 
 enum {
-- 
2.51.0



