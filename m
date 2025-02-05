Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5621B1D8A12;
	Wed,  5 Feb 2025 15:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768487; cv=none; b=J6YtNadwYWbIF/Cy2Ix6NuSa7u/xeDllwrkgWvS/lp6ipbx1rl8pA9YHvHLLbO+5cn7Py658QajFdkMvNYkJE4aENrrjXF1NYRALFqgf+1WhbcYQ+fipp0R0BsS1FZMfP3C3LSDEBcmyP+GvWpPYpqDqGH+LD5zr45rtGHrMbik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768487; c=relaxed/simple;
	bh=QBHIHwlPXLbcCzQFFFl1KjXtjU44GpPriVbYXywnPFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLVlHRPmv/AeZWtISD8LuQIWnmQniGU2v6TRUk6yztzlprmLFpP7qqMzU+cxht18TqG/G4+OptHGXfDtO34P24P8P+PhFIRCzyWvooxfBL/m0yPMgElVaMKPb69OonI8iQVrdoJEr4g5K4Zc79NEN0cWC43fNTOfR1pTYaWhzLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1COiC5CL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1COiC5CL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FD8C4CEDD;
	Wed,  5 Feb 2025 15:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768487;
	bh=QBHIHwlPXLbcCzQFFFl1KjXtjU44GpPriVbYXywnPFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1COiC5CLFje+KPltOhc7wf/n4t3kd+/0qM+DIq/bghBu10TZYOv4ZkN9oIfd7WHCV
	 dB7JVn8pQaMZ3PhWvXHw8acrMZJDp5sr2Hhgd4deC3cmI5Gke841LudN/RlLS+Jlek
	 YhPE7XmnjFCAtRbZcO6ASuowl+DEXhLkLLr2Zjuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jann Horn <jannh@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 571/623] kernel: be more careful about dup_mmap() failures and uprobe registering
Date: Wed,  5 Feb 2025 14:45:13 +0100
Message-ID: <20250205134518.063613842@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett <Liam.Howlett@Oracle.com>

[ Upstream commit 64c37e134b120fb462fb4a80694bfb8e7be77b14 ]

If a memory allocation fails during dup_mmap(), the maple tree can be left
in an unsafe state for other iterators besides the exit path.  All the
locks are dropped before the exit_mmap() call (in mm/mmap.c), but the
incomplete mm_struct can be reached through (at least) the rmap finding
the vmas which have a pointer back to the mm_struct.

Up to this point, there have been no issues with being able to find an
mm_struct that was only partially initialised.  Syzbot was able to make
the incomplete mm_struct fail with recent forking changes, so it has been
proven unsafe to use the mm_struct that hasn't been initialised, as
referenced in the link below.

Although 8ac662f5da19f ("fork: avoid inappropriate uprobe access to
invalid mm") fixed the uprobe access, it does not completely remove the
race.

This patch sets the MMF_OOM_SKIP to avoid the iteration of the vmas on the
oom side (even though this is extremely unlikely to be selected as an oom
victim in the race window), and sets MMF_UNSTABLE to avoid other potential
users from using a partially initialised mm_struct.

When registering vmas for uprobe, skip the vmas in an mm that is marked
unstable.  Modifying a vma in an unstable mm may cause issues if the mm
isn't fully initialised.

Link: https://lore.kernel.org/all/6756d273.050a0220.2477f.003d.GAE@google.com/
Link: https://lkml.kernel.org/r/20250127170221.1761366-1-Liam.Howlett@oracle.com
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c |  4 ++++
 kernel/fork.c           | 17 ++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 5d71ef85420c5..7f1a95b4f14de 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -28,6 +28,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/workqueue.h>
 #include <linux/srcu.h>
+#include <linux/oom.h>          /* check_stable_address_space */
 
 #include <linux/uprobes.h>
 
@@ -1260,6 +1261,9 @@ register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
 		 * returns NULL in find_active_uprobe_rcu().
 		 */
 		mmap_write_lock(mm);
+		if (check_stable_address_space(mm))
+			goto unlock;
+
 		vma = find_vma(mm, info->vaddr);
 		if (!vma || !valid_vma(vma, is_register) ||
 		    file_inode(vma->vm_file) != uprobe->inode)
diff --git a/kernel/fork.c b/kernel/fork.c
index 9b301180fd416..9da032802e347 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -760,7 +760,8 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 		mt_set_in_rcu(vmi.mas.tree);
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
-	} else if (mpnt) {
+	} else {
+
 		/*
 		 * The entire maple tree has already been duplicated. If the
 		 * mmap duplication fails, mark the failure point with
@@ -768,8 +769,18 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 		 * stop releasing VMAs that have not been duplicated after this
 		 * point.
 		 */
-		mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
-		mas_store(&vmi.mas, XA_ZERO_ENTRY);
+		if (mpnt) {
+			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
+			mas_store(&vmi.mas, XA_ZERO_ENTRY);
+			/* Avoid OOM iterating a broken tree */
+			set_bit(MMF_OOM_SKIP, &mm->flags);
+		}
+		/*
+		 * The mm_struct is going to exit, but the locks will be dropped
+		 * first.  Set the mm_struct as unstable is advisable as it is
+		 * not fully initialised.
+		 */
+		set_bit(MMF_UNSTABLE, &mm->flags);
 	}
 out:
 	mmap_write_unlock(mm);
-- 
2.39.5



