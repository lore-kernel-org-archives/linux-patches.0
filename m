Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8D8367F
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 03:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7583FC340EF;
	Sat, 26 Feb 2022 03:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1645845066;
	bh=vfJjeD6UaeMWHVng8jjExvaUWg885puAEYUfr8nUkAw=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=EJII1OXapn7RuHvP6jdzLMqnTq9Uyh+fZ4x+upCZqM/t0IZ1BskkZKcTOLeDCTJQt
	 uLnVVxkIVmz1T9DYBZtdUjXahnxdkjEYSeRb5VJ33BnMI7TFFB/4l7R26wIbl2uP7V
	 94DMbhuYtZrJMnUC+M7LyxpdespMYcbwutmJgdrw=
Date: Fri, 25 Feb 2022 19:11:05 -0800
To: willy@infradead.org,timmurray@google.com,shy828301@gmail.com,shakeelb@google.com,roman.gushchin@linux.dev,rientjes@google.com,riel@surriel.com,oleg@redhat.com,minchan@kernel.org,mhocko@suse.com,luto@kernel.org,kirill@shutemov.name,jengelh@inai.de,jannh@google.com,hch@infradead.org,hannes@cmpxchg.org,fweimer@redhat.com,david@redhat.com,christian.brauner@ubuntu.com,brauner@kernel.org,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 05/12] mm: fix use-after-free bug when mm->mmap is reused after being freed
Message-Id: <20220226031106.7583FC340EF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix use-after-free bug when mm->mmap is reused after being freed

oom reaping (__oom_reap_task_mm) relies on a 2 way synchronization with
exit_mmap.  First it relies on the mmap_lock to exclude from unlock
path[1], page tables tear down (free_pgtables) and vma destruction. 
This alone is not sufficient because mm->mmap is never reset.  For
historical reasons[2] the lock is taken there is also MMF_OOM_SKIP set
for oom victims before.

The oom reaper only ever looks at oom victims so the whole scheme works
properly but process_mrelease can opearate on any task (with fatal
signals pending) which doesn't really imply oom victims.  That means
that the MMF_OOM_SKIP part of the synchronization doesn't work and it
can see a task after the whole address space has been demolished and
traverse an already released mm->mmap list.  This leads to use after
free as properly caught up by KASAN report.

Fix the issue by reseting mm->mmap so that MMF_OOM_SKIP synchronization
is not needed anymore.  The MMF_OOM_SKIP is not removed from exit_mmap
yet but it acts mostly as an optimization now.

[1] 27ae357fa82b ("mm, oom: fix concurrent munlock and oom reaper unmap, v3")
[2] 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run concurrently")

[mhocko@suse.com: changelog rewrite]
Link: https://lore.kernel.org/all/00000000000072ef2c05d7f81950@google.com/
Link: https://lkml.kernel.org/r/20220215201922.1908156-1-surenb@google.com
Fixes: 64591e8605d6 ("mm: protect free_pgtables with mmap_lock write lock in exit_mmap")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+2ccf63a4bd07cf39cab0@syzkaller.appspotmail.com
Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c~mm-fix-use-after-free-bug-when-mm-mmap-is-reused-after-being-freed
+++ a/mm/mmap.c
@@ -3186,6 +3186,7 @@ void exit_mmap(struct mm_struct *mm)
 		vma = remove_vma(vma);
 		cond_resched();
 	}
+	mm->mmap = NULL;
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
_
