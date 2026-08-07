Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9123101A7;
	Fri,  7 Aug 2026 15:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115862; cv=none; b=AhtiShrVs/l94YjIlKVSGikgDCx92TgLIE0ZltmEx8VVccXC6/6GZazKoDmR50KAingI4fNAY/tAsk/DTP6cqZVYkzV37ci8u/gzTe5HtG3ka4U/m8reQXX7F3FMZqs5FnZ25jXMB1I4/xtNGhIDsdNIxTyNcjM8+pl3hjW33XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115862; c=relaxed/simple;
	bh=Vg6OLSHPn/DnB2OOS/QWhtT2evctvLKa5/JypCllV/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvzYTmunGrREi4yWGQvyiNt7psbTW2HftlSegP+pRW3S12597tRQ4bm6Zzlpg+CZ4HT51emFrQqhUPkN9pII+AKgjC2hkIyhFgpX0Y9XPqX56OCejGcfcmRvp2jkyciZWqgbZK6A1DnIQFAVLMRmGiFcBI2nVdmo3snnpWIfCzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVF9p3TP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVF9p3TP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8F11F000E9;
	Fri,  7 Aug 2026 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115860;
	bh=r3A/eZnHNwBwWmQ4bvYNqNIKSLaGdPZ3Fbz4mWkrhbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVF9p3TPEt2GC86vpEyDeltI7/fYOik9IXUFvumOE6qdBgTNr8FEp3AVAeOwVrqzp
	 XMTJAzyQ5g3z9yVMqr/ciQ1ozlgE1XQQ/cdQgjRriJm/pFla1n78J8fHJz35kDX4Pz
	 2BTe27OZhAuqYMQlFf6QsVkAws5v7OrvU+K10h1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	=?UTF-8?q?Andreas=20Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/261] sched: Add task_struct->faults_disabled_mapping
Date: Fri,  7 Aug 2026 16:36:26 +0200
Message-ID: <20260807143416.005594150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@gmail.com>

[ Upstream commit 2b69987be575b92adb6c177679f3c559134f0d8f ]

There has been a long standing page cache coherence bug with direct IO.
This provides part of a mechanism to fix it, currently just used by
bcachefs but potentially worth promoting to the VFS.

Direct IO evicts the range of the pagecache being read or written to.

For reads, we need dirty pages to be written to disk, so that the read
doesn't return stale data. For writes, we need to evict that range of
the pagecache so that it's not stale after the write completes.

However, without a locking mechanism to prevent those pages from being
re-added to the pagecache - by a buffered read or page fault - page
cache inconsistency is still possible.

This isn't necessarily just an issue for userspace when they're playing
games; filesystems may hang arbitrary state off the pagecache, and so
page cache inconsistency may cause real filesystem bugs, depending on
the filesystem. This is less of an issue for iomap based filesystems,
but e.g. buffer heads caches disk block mappings (!) and attaches them
to the pagecache, and bcachefs attaches disk reservations to pagecache
pages.

This issue has been hard to fix, because
 - we need to add a lock (henceforth called pagecache_add_lock), which
   would be held for the duration of the direct IO
 - page faults add pages to the page cache, thus need to take the same
   lock
 - dio -> gup -> page fault thus can deadlock

And we cannot enforce a lock ordering with this lock, since userspace
will be controlling the lock ordering (via the fd and buffer arguments
to direct IOs), so we need a different method of deadlock avoidance.

We need to tell the page fault handler that we're already holding a
pagecache_add_lock, and since plumbing it through the entire gup() path
would be highly impractical this adds a field to task_struct.

Then the full method is:
 - in the dio path, when we first take the pagecache_add_lock, note the
   mapping in the current task_struct
 - in the page fault handler, if faults_disabled_mapping is set, we
   check if it's the same mapping as the one we're taking a page fault
   for, and if so return an error.

   Then we check lock ordering: if there's a lock ordering violation and
   trylock fails, we'll have to cycle the locks and return an error that
   tells the DIO path to retry: faults_disabled_mapping is also used for
   signalling "locks were dropped, please retry".

Also relevant to this patch: mapping->invalidate_lock.
mapping->invalidate_lock provides most of the required semantics - it's
used by truncate/fallocate to block pages being added to the pagecache.
However, since it's a rwsem, direct IOs would need to take the write
side in order to block page cache adds, and would then be exclusive with
each other - we'll need a new type of lock to pair with this approach.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Jan Kara <jack@suse.cz>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: Andreas Grünbacher <andreas.gruenbacher@gmail.com>
Stable-dep-of: e876b75b9020 ("ipvs: fix the checksum validations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 1 +
 init/init_task.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fad3aad97c7b0..c5e90874096e9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -878,6 +878,7 @@ struct task_struct {
 
 	struct mm_struct		*mm;
 	struct mm_struct		*active_mm;
+	struct address_space		*faults_disabled_mapping;
 
 	int				exit_state;
 	int				exit_code;
diff --git a/init/init_task.c b/init/init_task.c
index fd9e27185e23a..9b363c986f824 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -85,6 +85,7 @@ struct task_struct init_task
 	.nr_cpus_allowed= NR_CPUS,
 	.mm		= NULL,
 	.active_mm	= &init_mm,
+	.faults_disabled_mapping = NULL,
 	.restart_block	= {
 		.fn = do_no_restart_syscall,
 	},
-- 
2.53.0



