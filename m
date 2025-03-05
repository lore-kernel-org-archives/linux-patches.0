Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E286ADD;
	Wed,  5 Mar 2025 17:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197095; cv=none; b=WSdQkx/T3ylIccPhrrwzmPosh7jQn/4woEbjiQ7uuzMYF7M8cvCxGZwmoSmTManHwf9H+IFShbSt8cIbFuGM08J/5vNXb8n+SwhYYITLLks0SIRNkRcdrSHY1OBDjb5DkT3PAtOysc2Cqx7kb1edusHMBVL+ZU3CfsGlxbigvJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197095; c=relaxed/simple;
	bh=jAVEoqYNHyyS3BD9k8Nh0EzANHkqoXA3Lrht+AdV3OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ANm6DpyAyCos1eUDjCZ+kT4i4jisgbM24UEsZ9N1IO/5loq1ZyQtFoa6QhnOWCRrNVZ4Z6QJ/bkISRqiySpM7gCnsxL0n3Adn+GdZQf+/kAZ+hB/fPsy931rMuCviufqF0AqxT8JsOgYRJg8KG4HIWJ9WD3l8uegqiwL6aGD034=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/BvZzEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/BvZzEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB70C4CED1;
	Wed,  5 Mar 2025 17:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197094;
	bh=jAVEoqYNHyyS3BD9k8Nh0EzANHkqoXA3Lrht+AdV3OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/BvZzEa4X9SaGXST1ssNDj+oj2qa6WVX4mt6IjwXR7Ld50+xBi+CHACYdVz7ShVs
	 Vz3bsuWh+tKFo1mQm19liNqr/ESxgcyljQfqGxymuwzRSIHi9KMVxl8StQ6eprXTbl
	 /vNRgRorIpkLJ5bXRyIhio/uACbYQh74SFv+5xmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Galo <carlosgalo@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/176] mm: update mark_victim tracepoints fields
Date: Wed,  5 Mar 2025 18:46:18 +0100
Message-ID: <20250305174505.828133345@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Galo <carlosgalo@google.com>

[ Upstream commit 72ba14deb40a9e9668ec5e66a341ed657e5215c2 ]

The current implementation of the mark_victim tracepoint provides only the
process ID (pid) of the victim process.  This limitation poses challenges
for userspace tools requiring real-time OOM analysis and intervention.
Although this information is available from the kernel logs, it’s not
the appropriate format to provide OOM notifications.  In Android, BPF
programs are used with the mark_victim trace events to notify userspace of
an OOM kill.  For consistency, update the trace event to include the same
information about the OOMed victim as the kernel logs.

- UID
   In Android each installed application has a unique UID. Including
   the `uid` assists in correlating OOM events with specific apps.

- Process Name (comm)
   Enables identification of the affected process.

- OOM Score
  Will allow userspace to get additional insight of the relative kill
  priority of the OOM victim. In Android, the oom_score_adj is used to
  categorize app state (foreground, background, etc.), which aids in
  analyzing user-perceptible impacts of OOM events [1].

- Total VM, RSS Stats, and pgtables
  Amount of memory used by the victim that will, potentially, be freed up
  by killing it.

[1] https://cs.android.com/android/platform/superproject/main/+/246dc8fc95b6d93afcba5c6d6c133307abb3ac2e:frameworks/base/services/core/java/com/android/server/am/ProcessList.java;l=188-283
Signed-off-by: Carlos Galo <carlosgalo@google.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ade81479c7dd ("memcg: fix soft lockup in the OOM process")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/oom.h | 36 ++++++++++++++++++++++++++++++++----
 mm/oom_kill.c              |  6 +++++-
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
index 26a11e4a2c361..b799f3bcba823 100644
--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -7,6 +7,8 @@
 #include <linux/tracepoint.h>
 #include <trace/events/mmflags.h>
 
+#define PG_COUNT_TO_KB(x) ((x) << (PAGE_SHIFT - 10))
+
 TRACE_EVENT(oom_score_adj_update,
 
 	TP_PROTO(struct task_struct *task),
@@ -72,19 +74,45 @@ TRACE_EVENT(reclaim_retry_zone,
 );
 
 TRACE_EVENT(mark_victim,
-	TP_PROTO(int pid),
+	TP_PROTO(struct task_struct *task, uid_t uid),
 
-	TP_ARGS(pid),
+	TP_ARGS(task, uid),
 
 	TP_STRUCT__entry(
 		__field(int, pid)
+		__string(comm, task->comm)
+		__field(unsigned long, total_vm)
+		__field(unsigned long, anon_rss)
+		__field(unsigned long, file_rss)
+		__field(unsigned long, shmem_rss)
+		__field(uid_t, uid)
+		__field(unsigned long, pgtables)
+		__field(short, oom_score_adj)
 	),
 
 	TP_fast_assign(
-		__entry->pid = pid;
+		__entry->pid = task->pid;
+		__assign_str(comm, task->comm);
+		__entry->total_vm = PG_COUNT_TO_KB(task->mm->total_vm);
+		__entry->anon_rss = PG_COUNT_TO_KB(get_mm_counter(task->mm, MM_ANONPAGES));
+		__entry->file_rss = PG_COUNT_TO_KB(get_mm_counter(task->mm, MM_FILEPAGES));
+		__entry->shmem_rss = PG_COUNT_TO_KB(get_mm_counter(task->mm, MM_SHMEMPAGES));
+		__entry->uid = uid;
+		__entry->pgtables = mm_pgtables_bytes(task->mm) >> 10;
+		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
-	TP_printk("pid=%d", __entry->pid)
+	TP_printk("pid=%d comm=%s total-vm=%lukB anon-rss=%lukB file-rss:%lukB shmem-rss:%lukB uid=%u pgtables=%lukB oom_score_adj=%hd",
+		__entry->pid,
+		__get_str(comm),
+		__entry->total_vm,
+		__entry->anon_rss,
+		__entry->file_rss,
+		__entry->shmem_rss,
+		__entry->uid,
+		__entry->pgtables,
+		__entry->oom_score_adj
+	)
 );
 
 TRACE_EVENT(wake_reaper,
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 1276e49b31b0a..4de30c6c5183f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -44,6 +44,7 @@
 #include <linux/kthread.h>
 #include <linux/init.h>
 #include <linux/mmu_notifier.h>
+#include <linux/cred.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -757,6 +758,7 @@ static inline void queue_oom_reaper(struct task_struct *tsk)
  */
 static void mark_oom_victim(struct task_struct *tsk)
 {
+	const struct cred *cred;
 	struct mm_struct *mm = tsk->mm;
 
 	WARN_ON(oom_killer_disabled);
@@ -776,7 +778,9 @@ static void mark_oom_victim(struct task_struct *tsk)
 	 */
 	__thaw_task(tsk);
 	atomic_inc(&oom_victims);
-	trace_mark_victim(tsk->pid);
+	cred = get_task_cred(tsk);
+	trace_mark_victim(tsk, cred->uid.val);
+	put_cred(cred);
 }
 
 /**
-- 
2.39.5



