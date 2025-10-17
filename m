Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7545A2745E;
	Fri, 17 Oct 2025 15:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714891; cv=none; b=qkg4LEvBZ7Ij+JF8QN+m/olOCKUfWJYBxz3s/7yyyPLeP8eaSssHQo2U6yGlvwkLBeqb636Ftf8SiB23fklebqg24cADu+weuki+RDDdwoVaOBuO8pILNoTneE8g9HzCRROii3x7NaAz/Vz+FqVUs83pMPsSwL3NjqYG2Pd8N7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714891; c=relaxed/simple;
	bh=XnHKnIONnC705uLyKpf9r7GD7wrV177b7NPopHnPJTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqHv5GobIKaDMaRdnM13O10hxRPy2QQLE+wM0fdxOBtqTT4UrSZp9XF6sRRb3UIkTS02mot9D+uXSmCWK+7HerY7RR1Zon1kRB7CPCgdJba/tDa1xl+CUdXr7UyE0jfaFrj601BbJDTBOIPakUwDa8EsEqSBMs8Tx6AFSa3AYq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7tPAKZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7tPAKZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D128C4CEE7;
	Fri, 17 Oct 2025 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714891;
	bh=XnHKnIONnC705uLyKpf9r7GD7wrV177b7NPopHnPJTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7tPAKZgzH9tr6ZXKIFY34ISbk8ZVgH/sfTY0mO/dJk35Lvs7xGbLxj1se8DX2Yum
	 FoNst19Yk/szyBWKUanFYUPW71spF0bEnoPx6A+y0J72rBW7dbGsOFcWykInXknJZi
	 OWBbwO3RR50l1drDFSUdrvqyOlaSv/mZUYudg66Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Peilin Ye <yepeilin@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 009/371] memcg: skip cgroup_file_notify if spinning is not allowed
Date: Fri, 17 Oct 2025 16:49:44 +0200
Message-ID: <20251017145202.132070328@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

commit fcc0669c5aa681994c507b50f1c706c969d99730 upstream.

Generally memcg charging is allowed from all the contexts including NMI
where even spinning on spinlock can cause locking issues.  However one
call chain was missed during the addition of memcg charging from any
context support.  That is try_charge_memcg() -> memcg_memory_event() ->
cgroup_file_notify().

The possible function call tree under cgroup_file_notify() can acquire
many different spin locks in spinning mode.  Some of them are
cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock.  So, let's
just skip cgroup_file_notify() from memcg charging if the context does not
allow spinning.

Alternative approach was also explored where instead of skipping
cgroup_file_notify(), we defer the memcg event processing to irq_work [1].
However it adds complexity and it was decided to keep things simple until
we need more memcg events with !allow_spinning requirement.

Link: https://lore.kernel.org/all/5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd/ [1]
Link: https://lkml.kernel.org/r/20250922220203.261714-1-shakeel.butt@linux.dev
Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Closes: https://lore.kernel.org/all/20250905061919.439648-1-yepeilin@google.com/
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peilin Ye <yepeilin@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memcontrol.h |   26 +++++++++++++++++++-------
 mm/memcontrol.c            |    7 ++++---
 2 files changed, 23 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -987,22 +987,28 @@ static inline void count_memcg_event_mm(
 	count_memcg_events_mm(mm, idx, 1);
 }
 
-static inline void memcg_memory_event(struct mem_cgroup *memcg,
-				      enum memcg_memory_event event)
+static inline void __memcg_memory_event(struct mem_cgroup *memcg,
+					enum memcg_memory_event event,
+					bool allow_spinning)
 {
 	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
 			  event == MEMCG_SWAP_FAIL;
 
+	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
+	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
+
 	atomic_long_inc(&memcg->memory_events_local[event]);
-	if (!swap_event)
+	if (!swap_event && allow_spinning)
 		cgroup_file_notify(&memcg->events_local_file);
 
 	do {
 		atomic_long_inc(&memcg->memory_events[event]);
-		if (swap_event)
-			cgroup_file_notify(&memcg->swap_events_file);
-		else
-			cgroup_file_notify(&memcg->events_file);
+		if (allow_spinning) {
+			if (swap_event)
+				cgroup_file_notify(&memcg->swap_events_file);
+			else
+				cgroup_file_notify(&memcg->events_file);
+		}
 
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 			break;
@@ -1012,6 +1018,12 @@ static inline void memcg_memory_event(st
 		 !mem_cgroup_is_root(memcg));
 }
 
+static inline void memcg_memory_event(struct mem_cgroup *memcg,
+				      enum memcg_memory_event event)
+{
+	__memcg_memory_event(memcg, event, true);
+}
+
 static inline void memcg_memory_event_mm(struct mm_struct *mm,
 					 enum memcg_memory_event event)
 {
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2309,12 +2309,13 @@ static int try_charge_memcg(struct mem_c
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
+	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
 retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
 
-	if (!gfpflags_allow_spinning(gfp_mask))
+	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
 
@@ -2350,7 +2351,7 @@ retry:
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
@@ -2417,7 +2418,7 @@ force:
 	 * a MEMCG_MAX event.
 	 */
 	if (!raised_max_event)
-		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	/*
 	 * The allocation either can't fail or will lead to more memory


