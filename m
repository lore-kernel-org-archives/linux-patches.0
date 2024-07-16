Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5EF1DA4D;
	Tue, 16 Jul 2024 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145579; cv=none; b=NbB1aIJxNkvMH7Rt5f6JMlixXjaXzCquh37iSXMqAPt2wOJh3WPoNRLgEe9O7QSvpaHNpqHaRIvl+1URRM4M0u5G/cU6p/PU8s6Yf07UtbQxUZNjLZdLXiSK04xona/N1rniw1AiYMUel00ZR8js8EELNdGU5s6//6Dudfn8A8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145579; c=relaxed/simple;
	bh=V1ZgPJor0kDbpHzh2dVMzuWuNsLRr/5NTz+QjJ5jV1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tpe/sclwGPgbe7IzfwsBBnyIH2mWNhxm5hy7w/WX0Y5gSN2lFMKfWDwQcTYLGtizE0L9tNTLeE6v0l4pLGIdlBUaRoZFEEU1SyPTzjfdkRQ82Hm9vxsiqOyJKdQZ1J8wRI92u4jWmOu78oR8YQTZy+b/2afrX25XFp7mDjYHGh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f821AkN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f821AkN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D3EC116B1;
	Tue, 16 Jul 2024 15:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145579;
	bh=V1ZgPJor0kDbpHzh2dVMzuWuNsLRr/5NTz+QjJ5jV1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f821AkN0wH34hvBrBJUYon/vrv6mLEKwnyS9u9xfE7zjaOWVk1460n3ZgeBxjX8kK
	 FvLsSUULfFzGhIZHVjPcKLuPDBBYSmjxc6YW8C9BaRnjOlQjwgbg91xn6SXgT3dHvo
	 uiZZfsYiCG0YEfkxnaIzFuOKzEezZOYWmvE08AoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	Ian Kent <ikent@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Waiman Long <longman@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/121] vfs: dont mod negative dentry count when on shrinker list
Date: Tue, 16 Jul 2024 17:31:18 +0200
Message-ID: <20240716152751.946109354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit aabfe57ebaa75841db47ea59091ec3c5a06d2f52 ]

The nr_dentry_negative counter is intended to only account negative
dentries that are present on the superblock LRU. Therefore, the LRU
add, remove and isolate helpers modify the counter based on whether
the dentry is negative, but the shrinker list related helpers do not
modify the counter, and the paths that change a dentry between
positive and negative only do so if DCACHE_LRU_LIST is set.

The problem with this is that a dentry on a shrinker list still has
DCACHE_LRU_LIST set to indicate ->d_lru is in use. The additional
DCACHE_SHRINK_LIST flag denotes whether the dentry is on LRU or a
shrink related list. Therefore if a relevant operation (i.e. unlink)
occurs while a dentry is present on a shrinker list, and the
associated codepath only checks for DCACHE_LRU_LIST, then it is
technically possible to modify the negative dentry count for a
dentry that is off the LRU. Since the shrinker list related helpers
do not modify the negative dentry count (because non-LRU dentries
should not be included in the count) when the dentry is ultimately
removed from the shrinker list, this can cause the negative dentry
count to become permanently inaccurate.

This problem can be reproduced via a heavy file create/unlink vs.
drop_caches workload. On an 80xcpu system, I start 80 tasks each
running a 1k file create/delete loop, and one task spinning on
drop_caches. After 10 minutes or so of runtime, the idle/clean cache
negative dentry count increases from somewhere in the range of 5-10
entries to several hundred (and increasingly grows beyond
nr_dentry_unused).

Tweak the logic in the paths that turn a dentry negative or positive
to filter out the case where the dentry is present on a shrink
related list. This allows the above workload to maintain an accurate
negative dentry count.

Fixes: af0c9af1b3f6 ("fs/dcache: Track & report number of negative dentries")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Link: https://lore.kernel.org/r/20240703121301.247680-1-bfoster@redhat.com
Acked-by: Ian Kent <ikent@redhat.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index fca3e7490d091..186c0e1b5713f 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -356,7 +356,11 @@ static inline void __d_clear_type_and_inode(struct dentry *dentry)
 	flags &= ~(DCACHE_ENTRY_TYPE | DCACHE_FALLTHRU);
 	WRITE_ONCE(dentry->d_flags, flags);
 	dentry->d_inode = NULL;
-	if (flags & DCACHE_LRU_LIST)
+	/*
+	 * The negative counter only tracks dentries on the LRU. Don't inc if
+	 * d_lru is on another list.
+	 */
+	if ((flags & (DCACHE_LRU_LIST|DCACHE_SHRINK_LIST)) == DCACHE_LRU_LIST)
 		this_cpu_inc(nr_dentry_negative);
 }
 
@@ -2000,9 +2004,11 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 
 	spin_lock(&dentry->d_lock);
 	/*
-	 * Decrement negative dentry count if it was in the LRU list.
+	 * The negative counter only tracks dentries on the LRU. Don't dec if
+	 * d_lru is on another list.
 	 */
-	if (dentry->d_flags & DCACHE_LRU_LIST)
+	if ((dentry->d_flags &
+	     (DCACHE_LRU_LIST|DCACHE_SHRINK_LIST)) == DCACHE_LRU_LIST)
 		this_cpu_dec(nr_dentry_negative);
 	hlist_add_head(&dentry->d_u.d_alias, &inode->i_dentry);
 	raw_write_seqcount_begin(&dentry->d_seq);
-- 
2.43.0



