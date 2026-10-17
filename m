Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B623B7770;
	Sat, 17 Oct 2026 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260331; cv=none; b=aayZD/3sCXjrWptQ0h6yrB2draB4rvlWK5vznwTitSIjWxZpyJ2jPMsZeLoeCEoO5Y44EeJIMdQp1bIOrGAgL8os9cXddDnNAxBzLfW308yHN3Z6ypBqoeNrh1RpvfGZjMaMjWhc20ohKov8XgNswNghDyJJUcYobXttcdxxN5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260331; c=relaxed/simple;
	bh=fw6vNpQctKOqaN3wXyb8wh8HBFyUMQUPnlhrzplrHlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ny/eyhtYhVELRzK5G0feiE8Tb/zzqJD4dtd5lyBgBahU8ZmLA4fw27jvoS28sBMW12XR87Yi+d7+wBejG64bX7JtK/J6OhDQEHTlk9QNXe0AZDuL+JxDDLJ6YpG5auVNAvpMP4bzqrJop8FAUHs+tbgYQegms38d8cFuLM95DVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOQ1nJ8f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOQ1nJ8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4D51F000C4;
	Sat, 17 Oct 2026 18:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260329;
	bh=/p5VLa1VnOLXJ+AhaORcMuBr5l62qMf+Hnmszze0KgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOQ1nJ8fmx8zajKQ6mF41K+S4OTRzwG+ccVImpxVVteE+Amfm07G/FT6BlGdwu+Wc
	 KV+7iGsLFmgjPmoz129oYpscEaEx7eQuqNFPiL1Ar4IH7Fq5uy33mRYlTOhYGJ1jJK
	 +tk+FFRM6XAclpY1x5FtJUbdHHHIaT9+x84Bbs60=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1510/1674] memcg: make the v1 soft limit knob inert
Date: Sat, 17 Oct 2026 18:03:02 +0200
Message-ID: <20261017160509.886754880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit a3417097fb107cea3358b19bcbb4eb655fd67f8c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/cgroup-v1/memory.rst          | 47 +++----------------
 mm/memcontrol.c                               | 40 ++++++++++------
 2 files changed, 32 insertions(+), 55 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index ff456871bf4b8..0eb71ca046872 100644
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
@@ -76,8 +75,9 @@ Brief summary of control files.
  memory.memsw.failcnt		     show the number of memory+Swap hits limits
  memory.max_usage_in_bytes	     show max memory usage recorded
  memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
- memory.soft_limit_in_bytes	     set/show soft limit of memory usage
-				     This knob is not available on CONFIG_PREEMPT_RT systems.
+ memory.soft_limit_in_bytes	     This knob is deprecated and has no effect.
+                                     Writes are ignored and reads always
+                                     return the maximum value.
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
                                      This knob is deprecated and shouldn't be
@@ -332,9 +332,6 @@ memory.kmem.usage_in_bytes, or in a separate counter when it makes sense.
 The main "kmem" counter is fed into the main counter, so kmem charges will
 also be visible from the user counter.
 
-Currently no soft limit is implemented for kernel memory. It is future work
-to trigger slab reclaim when those limits are reached.
-
 2.7.1 Current Kernel Memory resources accounted
 -----------------------------------------------
 
@@ -695,42 +692,10 @@ For compatibility reasons writing 1 to memory.use_hierarchy will always pass::
 7. Soft limits
 ==============
 
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
-
-Soft limits can be setup by using the following commands (in this example we
-assume a soft limit of 256 MiB)::
-
-	# echo 256M > memory.soft_limit_in_bytes
-
-If we want to change this to 1G, we can at any time use::
-
-	# echo 1G > memory.soft_limit_in_bytes
+Writing to memory.soft_limit_in_bytes has no effect and reading it will
+always return the maximum value.
 
-.. note::
-       Soft limits take effect over a long period of time, since they involve
-       reclaiming memory for balancing between memory cgroups
-
-.. note::
-       It is recommended to set the soft limit always below the hard limit,
-       otherwise the hard limit will take precedence.
+Use memory.low and memory.min in cgroup v2 instead.
 
 .. _cgroup-v1-memory-move-charges:
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d612b32d3ce3a..59230743af9b5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3721,9 +3721,32 @@ enum {
 	RES_LIMIT,
 	RES_MAX_USAGE,
 	RES_FAILCNT,
-	RES_SOFT_LIMIT,
 };
 
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
@@ -3760,8 +3783,6 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 		return (u64)counter->watermark * PAGE_SIZE;
 	case RES_FAILCNT:
 		return counter->failcnt;
-	case RES_SOFT_LIMIT:
-		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -3912,14 +3933,6 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 			break;
 		}
 		break;
-	case RES_SOFT_LIMIT:
-		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
-			ret = -EOPNOTSUPP;
-		} else {
-			WRITE_ONCE(memcg->soft_limit, nr_pages);
-			ret = 0;
-		}
-		break;
 	}
 	return ret ?: nbytes;
 }
@@ -5067,9 +5080,8 @@ static struct cftype mem_cgroup_legacy_files[] = {
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
-- 
2.53.0



