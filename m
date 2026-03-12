Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE292BCF7F;
	Thu, 12 Mar 2026 20:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346691; cv=none; b=P5jfCy2G69wNCsbEXvjp7MRTrhYmu2t4KORtKvadzpaKMMjUZCznGIButBPTYRC/+id+q6OPTAfi92arHivBMJiaNqDInnJ5iV5+qXqJumaIt7D4VZ0kx0WzWc9GSgPGIIlKwV1/NMYxymIDqO+1NWMvVkD5WPfjTmxYdeFTsOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346691; c=relaxed/simple;
	bh=YNGbJfa87dTEZzRpGEjfRo5P5eNtVZDWrra3l2yu5v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eftUr+0dlVf160FtVXp3Gs++5nLIg1i2ygwIiYSbrldR/TK7BU3cpNRZMP1I9xKO6ZiQNVxTp/BFcQ6lbr5P5ZdyXFUtzE87UjWrq4HuS8nWyZQY5oAjSaEctbuPjfCv61zOuIEBkDn8upSve1CIJ6Ij/rsi8nNKB8yhzJeWgVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyebXbFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyebXbFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF11C4CEF7;
	Thu, 12 Mar 2026 20:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346691;
	bh=YNGbJfa87dTEZzRpGEjfRo5P5eNtVZDWrra3l2yu5v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyebXbFrN4UfCWlzYytOGrJ/s8lXgkHWKwZLrakvdUosdZ3jb0Q5hAVx3jhq8pge4
	 QkFjKFAk7vPEcLpJ/zQ/Dya2IM2Gkf9Z0J1GZ24T3WvkvR7ZcZkSWWMfdq/PNmwbh3
	 P54oVJY7Lg1QCQRbSw/7FyV8p17I4xdy0MZK+1I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/265] btrfs: get used bytes while holding lock at btrfs_reclaim_bgs_work()
Date: Thu, 12 Mar 2026 21:08:08 +0100
Message-ID: <20260312201021.877425350@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ba5d06440cae63edc4f49465baf78f1f43e55c77 ]

At btrfs_reclaim_bgs_work(), we are grabbing twice the used bytes counter
of the block group while not holding the block group's spinlock. This can
result in races, reported by KCSAN and similar tools, since a concurrent
task can be updating that counter while at btrfs_update_block_group().

So avoid these races by grabbing the counter in a critical section
delimited by the block group's spinlock after setting the block group to
RO mode. This also avoids using two different values of the counter in
case it changes in between each read. This silences KCSAN and is required
for the next patch in the series too.

Fixes: 243192b67649 ("btrfs: report reclaim stats in sysfs")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 19eff93dc738 ("btrfs: fix periodic reclaim condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 79daf6fac58f3..2316be6ee41db 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1877,7 +1877,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 	list_sort(NULL, &fs_info->reclaim_bgs, reclaim_bgs_cmp);
 	while (!list_empty(&fs_info->reclaim_bgs)) {
 		u64 zone_unusable;
-		u64 reclaimed;
+		u64 used;
 		int ret = 0;
 
 		bg = list_first_entry(&fs_info->reclaim_bgs,
@@ -1973,19 +1973,30 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 		if (ret < 0)
 			goto next;
 
+		/*
+		 * Grab the used bytes counter while holding the block group's
+		 * spinlock to prevent races with tasks concurrently updating it
+		 * due to extent allocation and deallocation (running
+		 * btrfs_update_block_group()) - we have set the block group to
+		 * RO but that only prevents extent reservation, allocation
+		 * happens after reservation.
+		 */
+		spin_lock(&bg->lock);
+		used = bg->used;
+		spin_unlock(&bg->lock);
+
 		btrfs_info(fs_info,
 			"reclaiming chunk %llu with %llu%% used %llu%% unusable",
 				bg->start,
-				div64_u64(bg->used * 100, bg->length),
+				div64_u64(used * 100, bg->length),
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
-		reclaimed = bg->used;
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
 		if (ret) {
 			btrfs_dec_block_group_ro(bg);
 			btrfs_err(fs_info, "error relocating chunk %llu",
 				  bg->start);
-			reclaimed = 0;
+			used = 0;
 			spin_lock(&space_info->lock);
 			space_info->reclaim_errors++;
 			if (READ_ONCE(space_info->periodic_reclaim))
@@ -1994,7 +2005,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 		}
 		spin_lock(&space_info->lock);
 		space_info->reclaim_count++;
-		space_info->reclaim_bytes += reclaimed;
+		space_info->reclaim_bytes += used;
 		spin_unlock(&space_info->lock);
 
 next:
-- 
2.51.0



