Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A914F55A5;
	Wed,  9 Sep 2026 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962091; cv=none; b=ubu95sUFtSPNWOxIjDbrnkXeHuWEeohXpw9xNRTNZgLiADpTWTlikEtMvEYt3YtV+xhA46+6XXoT5qIYrgx+zGmN54GUl3GH1JmOiH5/H51l7vNmh8cr+JUymRzG7GGwESa8khZxaa8WfrDiI7uPESetXcsdCi7bm2u4QEnARbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962091; c=relaxed/simple;
	bh=HxFPz6WKjzY1kNzJbu0grhU+M10KkNtgGB/9TYo9Q7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bwt08hhjwpffkcQZUEA1DBU7q0wiw6+eN9rKZiE4dgkBk2qjT6tzFBCnhHjTUKskUGbEOAZLb85YsYXg6Ltmc2J5oVhAFpJMxpqBCnJP/xY8F4VWQnf9C9ln1azg31bfRR+NPuasHOKLCLQUdXrT2F72vA5vh03+/S4KUwLnt4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyKf9fuU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyKf9fuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9470E1F00A3D;
	Wed,  9 Sep 2026 13:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962090;
	bh=Ol5DEq+rBJnTNBIMqD6dwl11mg/gncBF8micMNnYCEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyKf9fuU8w1Ct5xNrRsiILqAQY7Oa4IBdfuhFrc+tXK209Gr4SACliHA1nbTBylJs
	 8ZAKqftJ0CafTJARhKkWF+RuF8VApBo4iz5Nb2553SIkfLHs/J509sGLzSqge226kE
	 mdRvsXL6SIqPREi/qxy0kx+bffCydDC0HZafvyHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 129/556] memcg: make the v1 soft limit knob inert
Date: Wed,  9 Sep 2026 15:36:49 +0200
Message-ID: <20260909134234.995200375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit a3417097fb107cea3358b19bcbb4eb655fd67f8c upstream.

The v1 soft limit has been deprecated since v6.12 and nobody has reported
depending on it.  Start the removal by decoupling the interface from the
implementation: keep memory.soft_limit_in_bytes, but ignore writes to it
and always report the maximum value on read similar to what
memory.kmem.limit_in_bytes already does.

Writes are still parsed, so malformed input keeps returning -EINVAL.  The
knob now also behaves the same everywhere: it used to return -EOPNOTSUPP
on PREEMPT_RT, where soft limit reclaim has always been disabled.

This also fixes the syzbot report linked below.  Soft limit reclaim is the
only caller that runs shrink_lruvec() from kswapd against a specific
memcg, so it is the only way to reach lru_gen_shrink_lruvec() and in turn
set_mm_walk(), which warns when called from kswapd.

Link: https://lore.kernel.org/20260811203203.3456029-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst |   49 +++----------------------
 mm/memcontrol-v1.c                             |   43 +++++++++++++--------
 2 files changed, 32 insertions(+), 60 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -47,7 +47,6 @@ Features:
  - pages are linked to per-memcg LRU exclusively, and there is no global LRU.
  - optionally, memory+swap usage can be accounted and limited.
  - hierarchical accounting
- - soft limit
  - moving (recharging) account at moving a task is selectable.
  - usage threshold notifier
  - memory pressure notifier
@@ -76,10 +75,9 @@ Brief summary of control files.
  memory.memsw.failcnt		     show the number of memory+Swap hits limits
  memory.max_usage_in_bytes	     show max memory usage recorded
  memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
- memory.soft_limit_in_bytes	     set/show soft limit of memory usage
-				     This knob is not available on CONFIG_PREEMPT_RT systems.
-                                     This knob is deprecated and shouldn't be
-                                     used.
+ memory.soft_limit_in_bytes	     This knob is deprecated and has no effect.
+                                     Writes are ignored and reads always
+                                     return the maximum value.
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
                                      This knob is deprecated and shouldn't be
@@ -340,9 +338,6 @@ memory.kmem.usage_in_bytes, or in a sepa
 The main "kmem" counter is fed into the main counter, so kmem charges will
 also be visible from the user counter.
 
-Currently no soft limit is implemented for kernel memory. It is future work
-to trigger slab reclaim when those limits are reached.
-
 2.7.1 Current Kernel Memory resources accounted
 -----------------------------------------------
 
@@ -710,42 +705,10 @@ For compatibility reasons writing 1 to m
 
 THIS IS DEPRECATED!
 
-Soft limits allow for greater sharing of memory. The idea behind soft limits
-is to allow control groups to use as much of the memory as needed, provided
-
-a. There is no memory contention
-b. They do not exceed their hard limit
-
-When the system detects memory contention or low memory, control groups
-are pushed back to their soft limits. If the soft limit of each control
-group is very high, they are pushed back as much as possible to make
-sure that one control group does not starve the others of memory.
-
-Please note that soft limits is a best-effort feature; it comes with
-no guarantees, but it does its best to make sure that when memory is
-heavily contended for, memory is allocated based on the soft limit
-hints/setup. Currently soft limit based reclaim is set up such that
-it gets invoked from balance_pgdat (kswapd).
-
-7.1 Interface
--------------
+Writing to memory.soft_limit_in_bytes has no effect and reading it will
+always return the maximum value.
 
-Soft limits can be setup by using the following commands (in this example we
-assume a soft limit of 256 MiB)::
-
-	# echo 256M > memory.soft_limit_in_bytes
-
-If we want to change this to 1G, we can at any time use::
-
-	# echo 1G > memory.soft_limit_in_bytes
-
-.. note::
-       Soft limits take effect over a long period of time, since they involve
-       reclaiming memory for balancing between memory cgroups
-
-.. note::
-       It is recommended to set the soft limit always below the hard limit,
-       otherwise the hard limit will take precedence.
+Use memory.low and memory.min in cgroup v2 instead.
 
 .. _cgroup-v1-memory-move-charges:
 
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -95,7 +95,6 @@ enum {
 	RES_LIMIT,
 	RES_MAX_USAGE,
 	RES_FAILCNT,
-	RES_SOFT_LIMIT,
 };
 
 #ifdef CONFIG_LOCKDEP
@@ -1589,6 +1588,30 @@ static int mem_cgroup_hierarchy_write(st
 	return -EINVAL;
 }
 
+static u64 mem_cgroup_soft_limit_read(struct cgroup_subsys_state *css,
+				      struct cftype *cft)
+{
+	return (u64)PAGE_COUNTER_MAX * PAGE_SIZE;
+}
+
+static ssize_t mem_cgroup_soft_limit_write(struct kernfs_open_file *of,
+					   char *buf, size_t nbytes, loff_t off)
+{
+	unsigned long nr_pages;
+	int ret;
+
+	ret = page_counter_memparse(strstrip(buf), "-1", &nr_pages);
+	if (ret)
+		return ret;
+
+	pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
+		     "Writing any value to this file has no effect. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
+
+	return nbytes;
+}
+
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
@@ -1625,8 +1648,6 @@ static u64 mem_cgroup_read_u64(struct cg
 		return (u64)counter->watermark * PAGE_SIZE;
 	case RES_FAILCNT:
 		return counter->failcnt;
-	case RES_SOFT_LIMIT:
-		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -1721,17 +1742,6 @@ static ssize_t mem_cgroup_write(struct k
 			break;
 		}
 		break;
-	case RES_SOFT_LIMIT:
-		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
-			ret = -EOPNOTSUPP;
-		} else {
-			pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
-				     "Please report your usecase to linux-mm@kvack.org if you "
-				     "depend on this functionality.\n");
-			WRITE_ONCE(memcg->soft_limit, nr_pages);
-			ret = 0;
-		}
-		break;
 	}
 	return ret ?: nbytes;
 }
@@ -2085,9 +2095,8 @@ struct cftype mem_cgroup_legacy_files[]
 	},
 	{
 		.name = "soft_limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
-		.write = mem_cgroup_write,
-		.read_u64 = mem_cgroup_read_u64,
+		.write = mem_cgroup_soft_limit_write,
+		.read_u64 = mem_cgroup_soft_limit_read,
 	},
 	{
 		.name = "failcnt",


