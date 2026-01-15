Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A15C2C028F;
	Thu, 15 Jan 2026 17:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496532; cv=none; b=J+ySl1uOqT4/nB4mCr3GSmz9wCxzOq579ztHpAcCCzR5oI69kEWr2fMbsRyx94q5ip/OHNvMk8b466xSznSWMGSnDqPSUH+fTDwT4tKz0ehp33CQFO2iQC5qmebQF8Lg2gxducRSdx3Fhlztq/JvpQOev96PTY/JH84iLYK+KpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496532; c=relaxed/simple;
	bh=dKcqbBixiWyS6Kesxlf4sDBRrrr3AlKSwOrpYLl7/9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwG/iQLjrTAmICvViSznu5kvGmFXsS7Sa72njZePYDMw6JHbnsOAlTOF/BPH0tLHhs0EqsKSP9wReMqDlAcIcN5Rvh728yV1FMVe8KYQeaYr8iJ9QBlNFI9UHJima31pJ3b7uqhUi73k6weQ05VTxquzTGzhW9wfXu8+uFVvPGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7hUMK0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7hUMK0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27259C116D0;
	Thu, 15 Jan 2026 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496532;
	bh=dKcqbBixiWyS6Kesxlf4sDBRrrr3AlKSwOrpYLl7/9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7hUMK0YrAPq43lNFEV7vGv8FzfjyGPdVUws6XDj2gbi70du0ZUWV0uL5m6AJldLl
	 XPtukijYqWRDLAKyooNL9iGJn9rjHSSZ6/fKEm88XD4hRkSxZ4ZztED9hWY0YWYLGz
	 cwQwYbtecKUHN7qfqYjO0u3OYQzxaJkt5D+2dPU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/119] btrfs: qgroup: update all parent qgroups when doing quick inherit
Date: Thu, 15 Jan 2026 17:47:41 +0100
Message-ID: <20260115164153.622142826@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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
index f23b482dfad9e..029017afaf344 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3295,7 +3295,10 @@ static int qgroup_snapshot_quick_inherit(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_qgroup *src;
 	struct btrfs_qgroup *parent;
+	struct btrfs_qgroup *qgroup;
 	struct btrfs_qgroup_list *list;
+	LIST_HEAD(qgroup_list);
+	const u32 nodesize = fs_info->nodesize;
 	int nr_parents = 0;
 
 	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_FULL)
@@ -3335,8 +3338,19 @@ static int qgroup_snapshot_quick_inherit(struct btrfs_fs_info *fs_info,
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



