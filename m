Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E877E3C3BF7;
	Thu, 16 Jul 2026 13:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209459; cv=none; b=Lg/6YZRHKSWptxvuYIC7/cnodi8Dtg/+xQu8XuVGDpYk7jaTxsXWYFo4Ck/9Din5LVlT8zOvBCAWuBXXRIPL3Bw1r8RjLtOEqxMrFuODuDbiblUseGqYm153zC6tYOe+lnQQTCYmyOK5M9HZcSVXPHaMAyCa7cCjR8dO8tZ/TGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209459; c=relaxed/simple;
	bh=irErblq2KPWjvZaPOMUh1jXRz5L8aryCj+UEn2fkbR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVeN3vQBBpXYpNDBkrcX/qKSldURsOuQlQApEKSXF/sfYjM5uW2sM358tN56C6jth5SnSwFA90vo9it6QyAaabUUCuF2EDBOEvV5FwK2UhHMOp8Op0h5bQlQykDuUv4i02YzCHW2JSJRSHpyaB6ewFnXyYaLYKo6c603GPnFnvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcKg16O1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcKg16O1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAD01F00A3A;
	Thu, 16 Jul 2026 13:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209455;
	bh=UNUPVvMArhAOGBpqdr08av3OTGHCKNzG063STDnT/uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IcKg16O1XvRzQ+tXFg0FVdPOVIbrY0D0slooQCbUNgZbsD3OM3ISuY9d/RLSvLbkx
	 ZHOrA7Z+r7OB55fahq/TZjlkMJiMdj00vnIFavDnkxGxMbQY/+xL5o00S7M9lbZFNd
	 Aq4H4wnn7gqIGRy8po/IJNVmHe8bcBCDnxO/6rpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 192/518] mm/shrinker: do not hold RCU lock in shrinker_debugfs_count_show()
Date: Thu, 16 Jul 2026 15:27:40 +0200
Message-ID: <20260716133052.032056984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

commit b902890c62d200b3509cb5e09cf1e0a66553c128 upstream.

Reading the debugfs "count" file of a memcg-aware shrinker can sleep
inside an RCU read-side critical section:

  BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
  RCU nest depth: 1, expected: 0
   css_rstat_flush
   mem_cgroup_flush_stats
   zswap_shrinker_count
   shrinker_debugfs_count_show

shrinker_debugfs_count_show() invokes the ->count_objects() callback under
rcu_read_lock().  The zswap callback flushes memcg stats via
css_rstat_flush(), which may sleep, so it must not run under RCU.

The RCU lock is not needed here.  mem_cgroup_iter() takes RCU internally
and returns a memcg holding a css reference (dropped on the next iteration
or by mem_cgroup_iter_break()), so the memcg stays alive without it.  The
shrinker is kept alive by the open debugfs file: shrinker_free() removes
the debugfs entries via debugfs_remove_recursive(), which waits for
in-flight readers to drain, before call_rcu(..., shrinker_free_rcu_cb).
The sibling "scan" handler already invokes the sleeping ->scan_objects()
callback with no RCU section.

Drop the rcu_read_lock()/rcu_read_unlock().

Link: https://lore.kernel.org/20260610232048.62930-1-shakeel.butt@linux.dev
Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shrinker_debug.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(s
 	if (!count_per_node)
 		return -ENOMEM;
 
-	rcu_read_lock();
-
 	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
@@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(s
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
-	rcu_read_unlock();
-
 	kfree(count_per_node);
 	return ret;
 }


