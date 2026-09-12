Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1549B38B154;
	Sat, 12 Sep 2026 08:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203522; cv=none; b=Kv41kf5sjvO2hU8/C/phxGDz4t8DoJCwf0VGhTScgAWP8uLWRT9wZvkdK3bFrJHgpl/Te+VjfoY3KvnyDxIaYpa59UznqzNRHT1g0bmJFzgisuZJrBroYmGKOVqxTHmmLQtXoJ0f+Kd0zVDPpx+YPCsV92mNCjMssK+bR69P8f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203522; c=relaxed/simple;
	bh=vR7eGiSCgnWz8x6zBR2kSLJlTMidNKBK4PyCCVxO0Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwnHzH5J98CvF/EkCrHKa0iQZ1hF1NSzF6pqmwzL5zlBsuY+II+4199Om85dSMf124pqBjueQ8aJcr0fvH0KAJsgYTaBz7P5UfCqR3gtxUpcBdhuH0fIApgVTiI75EEmOURM+xw+w2MpdtFteClSRnqn61L1smNYv2sdDRv8eRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6Byy9E7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6Byy9E7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2561F000FF;
	Sat, 12 Sep 2026 08:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203521;
	bh=KM1rtUC3mJPkQ2/Q5+J3kQK6VMeSsgxj9aj5jB+WrK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6Byy9E7Bc1/CBTp/v/lZsC3svaBNcEkUFYwQyEWjB7oiQdi+NO9XFxbaRTwU86sM
	 lqmw5q0xAnuKmEz6LX49yVnJkq7AQD1KlplFqpvVJI1vyzPGdrF81GzTtQAxiYRb8X
	 kncPqciag9cHyIPY3ahMDJyuaaWdv3m8GBVDPg2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Phil Auld <pauld@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1426/1815] sched/isolation: Defer freeing of cpumask memblock memory to initcall
Date: Sat, 12 Sep 2026 08:52:56 +0200
Message-ID: <20260912065722.496360186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 2b58c749b8c5244e259a0230bc57b10b010dc545 ]

When testing a linux-next kernel with commit 59bd1d914bb5 ("memblock:
warn when freeing reserved memory before memory map is initialized"),
the following warning was hit when there was a "nohz_full" kernel boot
parameter.

  Cannot free reserved memory because of deferred initialization of the memory map
  WARNING: mm/memblock.c:904 at __free_reserved_area+0xde/0xf0, CPU#0: swapper/0/0
    :
  Call Trace:
   <TASK>
   memblock_phys_free+0xcb/0x100
   housekeeping_init+0x14c/0x170
   start_kernel+0x207/0x450
   x86_64_start_reservations+0x24/0x30
   x86_64_start_kernel+0xda/0xe0
   common_startup_64+0x13e/0x141
   </TASK>

IOW, we shouldn't free memblock allocated memory so early
in the boot process when memory map isn't fully initialized in
deferred_init_memmap().

Fix it by saving the housekeeping cpumask memblock memory to be
freed into a llist free list in housekeeping_init() and add a new
housekeeping_late_init() helper to defer the actual freeing of memblock
memory to when initcall's are being processed. The cpumask memblock
memory is treated as a llist_node with the size of a "long" type which
is also smallest cpumask size that can be allocated.

The non-atomic version of the llist APIs are used as there is no
contention.

This commit depends on the presence of commit 7c2eee9c1367 ("memblock:
don't touch memblock arrays when memblock_free() is called late")
to prevent a KASAN UAF bug report [1].

 [1] https://lore.kernel.org/lkml/20260505051821.1107133-1-longman@redhat.com/

Fixes: 27c3a5967f05 ("sched/isolation: Convert housekeeping cpumasks to rcu pointers")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Link: https://patch.msgid.link/20260701195810.477326-1-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/isolation.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index ef152d401fe20..156025ef81b75 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/sched/isolation.h>
+#include <linux/llist.h>
 #include <linux/pci.h>
 #include "sched.h"
 
@@ -27,6 +28,7 @@ struct housekeeping {
 };
 
 static struct housekeeping housekeeping;
+static __initdata LLIST_HEAD(memblock_freelist);
 
 bool housekeeping_enabled(enum hk_type type)
 {
@@ -189,10 +191,22 @@ void __init housekeeping_init(void)
 		WARN_ON_ONCE(cpumask_empty(omask));
 		cpumask_copy(nmask, omask);
 		RCU_INIT_POINTER(housekeeping.cpumasks[type], nmask);
-		memblock_free(omask, cpumask_size());
+		__llist_add((struct llist_node *)omask, &memblock_freelist);
 	}
 }
 
+static int __init housekeeping_late_init(void)
+{
+	struct llist_node *llnode, *pos, *t;
+
+	/* Free allocated memblock memory, if any */
+	llnode = __llist_del_all(&memblock_freelist);
+	llist_for_each_safe(pos, t, llnode)
+		memblock_free(pos, cpumask_size());
+	return 0;
+}
+pure_initcall(housekeeping_late_init);
+
 static void __init housekeeping_setup_type(enum hk_type type,
 					   cpumask_var_t housekeeping_staging)
 {
-- 
2.53.0



