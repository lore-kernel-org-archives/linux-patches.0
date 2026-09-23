Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0B553162E;
	Wed, 23 Sep 2026 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174081; cv=none; b=NIpi/4I4Aq0o3WAP6xmp+TFTcyz3/uPraZNQ8Na32I+SrIM0/ARNMRuc4wJyBv7iOzurkjbkgrHjdo5orwPHEDYieGk+T5ECgylPAAWoGjPHHbrrsTlLvvb68tmlsvYrMd8sl75UksMZ78dTEoH/f4En4LLapgf3K8+kDSJAocM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174081; c=relaxed/simple;
	bh=EEmyaEE0usAKnj5RB3IEOW/UFTyRaqwt6ttsqKWNmRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfrneLFuv6Rh1pziYpzIyeENEmSCONjoDZOWtYuPb1dv2BqGOppQ1vm8y+HHzS7lFk69rML5LQjOykwuJGtLPar98PbPSrP8FOdXLGWSk0O7QfuEuuIPpho93mTxUGka5yASAREOEUGepPsmDmG9zRhW1B0/rajnusoLuPJeggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrWJGy/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrWJGy/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C6E1F000FF;
	Wed, 23 Sep 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174080;
	bh=lOyBuEcCxrzwLjoD6+SKItJKcGsCF9vd5kRz2nh8UL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrWJGy/xSdEIDkjID/g4QxOaiqvsiHOlpa0UNQWPAeV1x/Bel2ET4UQ1tsBbhXLUq
	 +gcJEqu8kHtI2qTE1tbsknsJ8swtodEyBzxhKHMJpkf2mRcoKxtnZBwLBujgYMCI8/
	 vnTvQkmUxA97kg45O7ifprijExJRAu7iC6wF69ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 428/438] fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink
Date: Wed, 23 Sep 2026 16:07:29 +0200
Message-ID: <20260923140656.013440884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Usama Arif <usama.arif@linux.dev>

[ Upstream commit 0baad6f9b9970c6e3f1d33dbfd17d1a77702771d ]

The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
dentry and inode LRUs are memcg-aware (via list_lru). But the optional
->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
btrfs extent maps and xfs inode reclaim operate on filesystem-global
state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
None of them filter by sc->memcg.

The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
whose bit is set in the per-superblock shrinker bitmap, which on a busy
host means hundreds of calls per reclaim pass. Each scan queues the same
global shrinker work item that's already kicked from the root path.

Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
the returned total stays positive even if a memcg's own dentry/inode LRUs
are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
in the memcg bitmap, so subsequent reclaim passes from the same memcg
re-enter super_cache_count() and pay for the global counter walk again.

Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
or root). The memcg-aware dentry/inode LRUs keep being counted and
scanned per memcg as before; only the global fs-specific hooks are skipped.
The root/global shrink path still drives those hooks; only their
invocation from non-root memcg slab reclaim is removed.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
Link: https://patch.msgid.link/20260609123047.1948242-1-usama.arif@linux.dev
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 641aade99f06 ("fs: fix missed removal of super_fs_objects_eligible()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/memcontrol.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/writeback.h>		/* for the emergency remount stuff */
@@ -170,6 +171,19 @@ static void super_wake(struct super_bloc
 }
 
 /*
+ * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
+ * operate on filesystem-global state and ignore sc->memcg. Driving them
+ * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
+ * per-cpu counters and queueing duplicate work: the actual reclaim happens on
+ * the global path (kswapd or root direct reclaim) regardless. Restrict them
+ * to that path.
+ */
+static inline bool super_fs_objects_eligible(struct shrink_control *sc)
+{
+	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
+}
+
+/*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
  * If that happens we could trigger unregistering the shrinker from within the
@@ -198,7 +212,7 @@ static unsigned long super_cache_scan(st
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects)
+	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -259,7 +273,8 @@ static unsigned long super_cache_count(s
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects)
+	if (sb->s_op && sb->s_op->nr_cached_objects &&
+	    super_fs_objects_eligible(sc))
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);


