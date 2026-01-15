Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5000B396B8F;
	Thu, 15 Jan 2026 16:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496069; cv=none; b=KzYNWWOlHCVTGd9qnpaOncQz7teCu5QB9lm/75hNt2dpjxtIvun6ax0NuywcQjjjbnh4HIU9aHNE4ehuscxZoYplJNNqgdE8sIMEETX5+SKMx+GC8lFmPEGFBmrPsrHWnbw4SkSNFfu3MRDcOCRV4fps4CgqAjgP/Dk1TLzWJaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496069; c=relaxed/simple;
	bh=Vz2q/MO8mkXqidcQMgZ6l04bNuY/emK1QhD/RO/Pt/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSl9kMf1h8N1XwAfbt5FMCagd75vMxPAQjXPj6z7XHEQBp8+WCCZUgcAV/gHzpOIYzDvmUYrwQfDVhkcSTCFdMlDbuEk7XbGBnBZ0HpPJnC3jWhFQb0QVBBKfxXpjZLGAEsUvxsYp/4jeOYMi0GbkLgC0pbel9/meE5kHvLduC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUB2eNTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUB2eNTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936ADC116D0;
	Thu, 15 Jan 2026 16:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496069;
	bh=Vz2q/MO8mkXqidcQMgZ6l04bNuY/emK1QhD/RO/Pt/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUB2eNTocPlEzOGilcjw69sq+VZeV0Y5zGuPbCBvR5fjShbnnb4KoXaTCcvhEI7e0
	 yFXy7mkH+aJopsKPsiLAKM0jM6dzeZGOsjpWmX2RRH+Ud8wjt7yL9n4eOf6UEZ9/52
	 0oIZyZiH5kkEtO5o1U0ztmZqdHMWmaNcAQl+9XWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/181] btrfs: qgroup: update all parent qgroups when doing quick inherit
Date: Thu, 15 Jan 2026 17:46:42 +0100
Message-ID: <20260115164204.673168645@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 68d4b3fa18d72b7f649e83012e7e08f1881f6b75 ]

[BUG]
There is a bug that if a subvolume has multi-level parent qgroups, and
is able to do a quick inherit, only the direct parent qgroup got
updated:

  mkfs.btrfs  -f -O quota $dev
  mount $dev $mnt
  btrfs subv create $mnt/subv1
  btrfs qgroup create 1/100 $mnt
  btrfs qgroup create 2/100 $mnt
  btrfs qgroup assign 1/100 2/100 $mnt
  btrfs qgroup assign 0/256 1/100 $mnt
  btrfs qgroup show -p --sync $mnt

  Qgroupid    Referenced    Exclusive Parent     Path
  --------    ----------    --------- ------     ----
  0/5           16.00KiB     16.00KiB -          <toplevel>
  0/256         16.00KiB     16.00KiB 1/100      subv1
  1/100         16.00KiB     16.00KiB 2/100      2/100<1 member qgroup>
  2/100         16.00KiB     16.00KiB -          <0 member qgroups>

  btrfs subv snap -i 1/100 $mnt/subv1 $mnt/snap1
  btrfs qgroup show -p --sync $mnt

  Qgroupid    Referenced    Exclusive Parent     Path
  --------    ----------    --------- ------     ----
  0/5           16.00KiB     16.00KiB -          <toplevel>
  0/256         16.00KiB     16.00KiB 1/100      subv1
  0/257         16.00KiB     16.00KiB 1/100      snap1
  1/100         32.00KiB     32.00KiB 2/100      2/100<1 member qgroup>
  2/100         16.00KiB     16.00KiB -          <0 member qgroups>
  # Note that 2/100 is not updated, and qgroup numbers are inconsistent

  umount $mnt

[CAUSE]
If the snapshot source subvolume belongs to a parent qgroup, and the new
snapshot target is also added to the new same parent qgroup, we allow a
quick update without marking qgroup inconsistent.

But that quick update only update the parent qgroup, without checking if
there is any more parent qgroups.

[FIX]
Iterate through all parent qgroups during the quick inherit.

Reported-by: Boris Burkov <boris@bur.io>
Fixes: b20fe56cd285 ("btrfs: qgroup: allow quick inherit if snapshot is created and added to the same parent")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 7faaa777010d7..febc22d1b6487 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3244,7 +3244,10 @@ static int qgroup_snapshot_quick_inherit(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_qgroup *src;
 	struct btrfs_qgroup *parent;
+	struct btrfs_qgroup *qgroup;
 	struct btrfs_qgroup_list *list;
+	LIST_HEAD(qgroup_list);
+	const u32 nodesize = fs_info->nodesize;
 	int nr_parents = 0;
 
 	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_FULL)
@@ -3284,8 +3287,19 @@ static int qgroup_snapshot_quick_inherit(struct btrfs_fs_info *fs_info,
 	if (parent->excl != parent->rfer)
 		return 1;
 
-	parent->excl += fs_info->nodesize;
-	parent->rfer += fs_info->nodesize;
+	qgroup_iterator_add(&qgroup_list, parent);
+	list_for_each_entry(qgroup, &qgroup_list, iterator) {
+		qgroup->rfer += nodesize;
+		qgroup->rfer_cmpr += nodesize;
+		qgroup->excl += nodesize;
+		qgroup->excl_cmpr += nodesize;
+		qgroup_dirty(fs_info, qgroup);
+
+		/* Append parent qgroups to @qgroup_list. */
+		list_for_each_entry(list, &qgroup->groups, next_group)
+			qgroup_iterator_add(&qgroup_list, list->group);
+	}
+	qgroup_iterator_clean(&qgroup_list);
 	return 0;
 }
 
-- 
2.51.0



