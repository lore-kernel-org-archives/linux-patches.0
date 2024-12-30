Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FBB2AE68;
	Mon, 30 Dec 2024 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574037; cv=none; b=DBYxBGX7YNVqfRRDGq/rafkot3642oTuqbbvo5+DGNXhnZOD6OOcgiZbHn0QmoyR4jJpSGlqH26kYOORtVxQyTfaJ/J/w2TeDMDMIwlmMos1/tZXQc7aRbiBDMJUBKVlIGv/LusO19pb8WbQpNOn4vQVlQlQjX4OTYbmVuTRyh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574037; c=relaxed/simple;
	bh=vCVX+MGMNOl6Xg4c36cLoa5qK9K7ApjuVSNXf8wAS2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hxux66ZheXeGYaK2cSOhvt1+2YCJ3sqBTxiM+xV0eC/7aM7Zm5zQ+Byw4llblN6eRHMnAyAqlXxlT3cm1Hvs5UHR2zJ3qIIS69yYGAuUYXEzEo06NEOdUfMqjIffVVdAaJJDpyeexmCaj4b5eMmfZR1/a4Qi8CU/FgwFoDSeTRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBT38Ykf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBT38Ykf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9646C4CED0;
	Mon, 30 Dec 2024 15:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574037;
	bh=vCVX+MGMNOl6Xg4c36cLoa5qK9K7ApjuVSNXf8wAS2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBT38YkfB61R/TFlIzA0p4TrqfPD4k1QSUYFyEb61MGS60wB7/4ju6/v/UUJTOIo/
	 NP2vYom365j/7HGavS3JGr//kLL9WOPy7Tjdi0rVol+8aKEduVNSCoBm1wptNYvnLJ
	 G6Y9R0FvBUiKHeq+pk3EXIrSRbz5FVOonz860tXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	syzbot+2d788f4f7cb660dac4b7@syzkaller.appspotmail.com,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/114] fork: avoid inappropriate uprobe access to invalid mm
Date: Mon, 30 Dec 2024 16:42:02 +0100
Message-ID: <20241230154218.267988934@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 8ac662f5da19f5873fdd94c48a5cdb45b2e1b58f ]

If dup_mmap() encounters an issue, currently uprobe is able to access the
relevant mm via the reverse mapping (in build_map_info()), and if we are
very unlucky with a race window, observe invalid XA_ZERO_ENTRY state which
we establish as part of the fork error path.

This occurs because uprobe_write_opcode() invokes anon_vma_prepare() which
in turn invokes find_mergeable_anon_vma() that uses a VMA iterator,
invoking vma_iter_load() which uses the advanced maple tree API and thus
is able to observe XA_ZERO_ENTRY entries added to dup_mmap() in commit
d24062914837 ("fork: use __mt_dup() to duplicate maple tree in
dup_mmap()").

This change was made on the assumption that only process tear-down code
would actually observe (and make use of) these values.  However this very
unlikely but still possible edge case with uprobes exists and
unfortunately does make these observable.

The uprobe operation prevents races against the dup_mmap() operation via
the dup_mmap_sem semaphore, which is acquired via uprobe_start_dup_mmap()
and dropped via uprobe_end_dup_mmap(), and held across
register_for_each_vma() prior to invoking build_map_info() which does the
reverse mapping lookup.

Currently these are acquired and dropped within dup_mmap(), which exposes
the race window prior to error handling in the invoking dup_mm() which
tears down the mm.

We can avoid all this by just moving the invocation of
uprobe_start_dup_mmap() and uprobe_end_dup_mmap() up a level to dup_mm()
and only release this lock once the dup_mmap() operation succeeds or clean
up is done.

This means that the uprobe code can never observe an incompletely
constructed mm and resolves the issue in this case.

Link: https://lkml.kernel.org/r/20241210172412.52995-1-lorenzo.stoakes@oracle.com
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: syzbot+2d788f4f7cb660dac4b7@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6756d273.050a0220.2477f.003d.GAE@google.com/
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index ce8be55e5e04..e192bdbc9ade 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -640,11 +640,8 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	LIST_HEAD(uf);
 	VMA_ITERATOR(vmi, mm, 0);
 
-	uprobe_start_dup_mmap();
-	if (mmap_write_lock_killable(oldmm)) {
-		retval = -EINTR;
-		goto fail_uprobe_end;
-	}
+	if (mmap_write_lock_killable(oldmm))
+		return -EINTR;
 	flush_cache_dup_mm(oldmm);
 	uprobe_dup_mmap(oldmm, mm);
 	/*
@@ -783,8 +780,6 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 		dup_userfaultfd_complete(&uf);
 	else
 		dup_userfaultfd_fail(&uf);
-fail_uprobe_end:
-	uprobe_end_dup_mmap();
 	return retval;
 
 fail_nomem_anon_vma_fork:
@@ -1692,9 +1687,11 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	if (!mm_init(mm, tsk, mm->user_ns))
 		goto fail_nomem;
 
+	uprobe_start_dup_mmap();
 	err = dup_mmap(mm, oldmm);
 	if (err)
 		goto free_pt;
+	uprobe_end_dup_mmap();
 
 	mm->hiwater_rss = get_mm_rss(mm);
 	mm->hiwater_vm = mm->total_vm;
@@ -1709,6 +1706,8 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	mm->binfmt = NULL;
 	mm_init_owner(mm, NULL);
 	mmput(mm);
+	if (err)
+		uprobe_end_dup_mmap();
 
 fail_nomem:
 	return NULL;
-- 
2.39.5



