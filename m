Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402D0264A76;
	Tue,  8 Apr 2025 11:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110954; cv=none; b=k4BSJ0PROav8f4+UkRd12qE55xVu9ruoY7y3TO3lDc73Dsgt9VYJVpjL8xNCeQpqXl7JPGyqkginK4G+g5lOBf6iLyat2XOEJmHIFXBKAsDecIyzehm61AglvVJSIvqgXz3HIhRiXVUVs6fC3UwnQzB2ESvVBzyj/X7RUt3Nd9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110954; c=relaxed/simple;
	bh=RosEk+Kd4p0IHoJD9goBpz1cZQNWjwIzHyhaNJFeLPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sumJtOWQAPF/fef7qbt8qZdDNB3vP0ONcTd+kTY2y2+sfUwWJogiIELyMmwwTf4fA5NE9A1+Oy/JyPgd5g8FGwxM3E5Nr4xiRLXygOUbaS+IJ/m5L2fBz/pVOyH/m9oLQT5vphLYckMFaY8sB+ctnbPO25ALJIBxGiNMh3evDm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q1IrlVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q1IrlVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0B5C4CEE5;
	Tue,  8 Apr 2025 11:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110953;
	bh=RosEk+Kd4p0IHoJD9goBpz1cZQNWjwIzHyhaNJFeLPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q1IrlVOGIPACunWiKJvdaK8f99anBrh4h+BJL0U74Ol50fpzezyf8Qg6Dw6UDaGJ
	 iRl9v3oP6rjeLAqyX+Y5c3hR9YCLf3zLnNjo/Dqw8zdwDRXycW2x0Xc5svDaDBprLG
	 iunzJu6b/N0zh6LRNBulnmeGLgma/EFcdh+pDHfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 215/731] btrfs: get used bytes while holding lock at btrfs_reclaim_bgs_work()
Date: Tue,  8 Apr 2025 12:41:52 +0200
Message-ID: <20250408104919.283966387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c0a8f7d92acc5..ed0b1a955d74a 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1823,7 +1823,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 	list_sort(NULL, &fs_info->reclaim_bgs, reclaim_bgs_cmp);
 	while (!list_empty(&fs_info->reclaim_bgs)) {
 		u64 zone_unusable;
-		u64 reclaimed;
+		u64 used;
 		int ret = 0;
 
 		bg = list_first_entry(&fs_info->reclaim_bgs,
@@ -1915,19 +1915,30 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
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
@@ -1936,7 +1947,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 		}
 		spin_lock(&space_info->lock);
 		space_info->reclaim_count++;
-		space_info->reclaim_bytes += reclaimed;
+		space_info->reclaim_bytes += used;
 		spin_unlock(&space_info->lock);
 
 next:
-- 
2.39.5



