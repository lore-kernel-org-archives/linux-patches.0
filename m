Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5831223DC6;
	Sat, 30 May 2026 17:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163122; cv=none; b=bmdgWlNsbBBKk3tJvmNJR9vhb8kkhGV74V8GkfjyZFmsMAn4TXwiTqGFcvv5nhlChDwCqem5V6SHnlm91tPOqGICtCJpTSjZCwh9ZAsqAPhiB3xh+AbfU3oE+Vtfkc2bdq7nt6DH3SGck4/JBUw0yZ0UDQv7zbbshxdLpQEpLuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163122; c=relaxed/simple;
	bh=oZGQ57FFfm/4uizaqR9KXdEXCD6epBEpuAL2Xq2vcaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWWLGz+ds+IyfX/4/TQVTEMOKL8I/hnvswB2CFyZHMGBQrEkh9KQLyhPmd2Mmi8Vu9oIW8pq6+pG2JIdl4D84htUxbVJyBTt1RL5u8vgB0gy+E6Al7udfnimKJRWel38vyGTmW5t7MoMwqZs04K8WZJZ/o2ozYTt1COABAMa+RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgNLXs+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgNLXs+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40591F00893;
	Sat, 30 May 2026 17:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163121;
	bh=dueVMz9mhXmpBGVx/rhCNzKdbrD8TvDjeq/1GTH6pc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgNLXs+Gn18CuWltWTssesCFK+iYgbN/tHIAcfGRp/ipHH+26LjSpwhR4oLrMN0Te
	 72d9/MYzS2yizVrsBw/g+mzc/Sd09aGdNbJ++cOXfuARWUw9hIhqMVwS0kD/Ak+4Uc
	 fIbxtY6I6l13gXQ36/juWChFKWLJfYeh8G0GzWMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Dennis Zhou <dennis@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Josef Bacik <josef@toxicpanda.com>,
	JP Kobryn <inwardvessel@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/776] mm: blk-cgroup: fix use-after-free in cgwb_release_workfn()
Date: Sat, 30 May 2026 17:57:08 +0200
Message-ID: <20260530160243.311924910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 8f5857be99f1ed1fa80991c72449541f634626ee ]

cgwb_release_workfn() calls css_put(wb->blkcg_css) and then later accesses
wb->blkcg_css again via blkcg_unpin_online().  If css_put() drops the last
reference, the blkcg can be freed asynchronously (css_free_rwork_fn ->
blkcg_css_free -> kfree) before blkcg_unpin_online() dereferences the
pointer to access blkcg->online_pin, resulting in a use-after-free:

  BUG: KASAN: slab-use-after-free in blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
  Write of size 4 at addr ff11000117aa6160 by task kworker/71:1/531
   Workqueue: cgwb_release cgwb_release_workfn
   Call Trace:
    <TASK>
     blkcg_unpin_online (./include/linux/instrumented.h:112 ./include/linux/atomic/atomic-instrumented.h:400 ./include/linux/refcount.h:389 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 block/blk-cgroup.c:1367)
     cgwb_release_workfn (mm/backing-dev.c:629)
     process_scheduled_works (kernel/workqueue.c:3278 kernel/workqueue.c:3385)

   Freed by task 1016:
    kfree (./include/linux/kasan.h:235 mm/slub.c:2689 mm/slub.c:6246 mm/slub.c:6561)
    css_free_rwork_fn (kernel/cgroup/cgroup.c:5542)
    process_scheduled_works (kernel/workqueue.c:3302 kernel/workqueue.c:3385)

** Stack based on commit 66672af7a095 ("Add linux-next specific files
for 20260410")

I am seeing this crash sporadically in Meta fleet across multiple kernel
versions.  A full reproducer is available at:
https://github.com/leitao/debug/blob/main/reproducers/repro_blkcg_uaf.sh

(The race window is narrow.  To make it easily reproducible, inject a
msleep(100) between css_put() and blkcg_unpin_online() in
cgwb_release_workfn().  With that delay and a KASAN-enabled kernel, the
reproducer triggers the splat reliably in less than a second.)

Fix this by moving blkcg_unpin_online() before css_put(), so the
cgwb's CSS reference keeps the blkcg alive while blkcg_unpin_online()
accesses it.

Link: https://lore.kernel.org/20260413-blkcg-v1-1-35b72622d16c@debian.org
Fixes: 59b57717fff8 ("blkcg: delay blkg destruction until after writeback has finished")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: JP Kobryn <inwardvessel@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/backing-dev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -404,12 +404,13 @@ static void cgwb_release_workfn(struct w
 	wb_shutdown(wb);
 
 	css_put(wb->memcg_css);
-	css_put(wb->blkcg_css);
-	mutex_unlock(&wb->bdi->cgwb_release_mutex);
 
 	/* triggers blkg destruction if no online users left */
 	blkcg_unpin_online(blkcg);
 
+	css_put(wb->blkcg_css);
+	mutex_unlock(&wb->bdi->cgwb_release_mutex);
+
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 
 	spin_lock_irq(&cgwb_lock);


