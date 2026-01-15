Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6491350A05;
	Thu, 15 Jan 2026 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496529; cv=none; b=ohdLnzxN52FWQACvmgP/K7G8jv98+MZ89H7cUmBYpiflj/lWWWBs9as7QH/IAOqybvrN/r3NdoDOVN07jpv5bng6a2QqaDztd4tEHEczKtCDqtEM5ITHSyT3a+s2YnQzVVHBOJ6YZpvZ55KunvcpbPZmC5KgliGt8ddigU+f8LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496529; c=relaxed/simple;
	bh=IO+JoswLJY9KxPg7y4nZA1EsTTdsJguP4HLMJ/ULNHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TF2O/Ep6xIFrfipLQpmJV4PAy4/JIjRImjnuA9rk1KClIe9nQJnC2hpXn8Gcb/Pi//BIfC6YxmkbDWjyq13ofoBtTQLuqt7IinD2iZxtUkua6jBAfc2eyVInsV1U9aIMMruiYvBqRnX+Jg0Rqod5EvbadjmCVuaU+eaJQ1P8zdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbS3A6Q0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbS3A6Q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F92C116D0;
	Thu, 15 Jan 2026 17:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496529;
	bh=IO+JoswLJY9KxPg7y4nZA1EsTTdsJguP4HLMJ/ULNHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbS3A6Q0kMfYUHuvthdL3246xNNroU/SII5X4f4wJ9hf6ZXHwVLIqfTi7b4URuZXl
	 K3SPWKOwk/9L4vc0rac+jgyVVFSnLts8crFqicyZHfl6JY6d+1i4x7wjhnfI6v46fr
	 Ihbwq/bInemGx49SY5SEskkVzS9oParj5B38uK74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/119] btrfs: fix qgroup_snapshot_quick_inherit() squota bug
Date: Thu, 15 Jan 2026 17:47:40 +0100
Message-ID: <20260115164153.586251319@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

[ Upstream commit 7ee19a59a75e3d5b9ec00499b86af8e2a46fbe86 ]

qgroup_snapshot_quick_inherit() detects conditions where the snapshot
destination would land in the same parent qgroup as the snapshot source
subvolume. In this case we can avoid costly qgroup calculations and just
add the nodesize of the new snapshot to the parent.

However, in the case of squotas this is actually a double count, and
also an undercount for deeper qgroup nestings.

The following annotated script shows the issue:

  btrfs quota enable --simple "$mnt"

  # Create 2-level qgroup hierarchy
  btrfs qgroup create 2/100 "$mnt"  # Q2 (level 2)
  btrfs qgroup create 1/100 "$mnt"  # Q1 (level 1)
  btrfs qgroup assign 1/100 2/100 "$mnt"

  # Create base subvolume
  btrfs subvolume create "$mnt/base" >/dev/null
  base_id=$(btrfs subvolume show "$mnt/base" | grep 'Subvolume ID:' | awk '{print $3}')

  # Create intermediate snapshot and add to Q1
  btrfs subvolume snapshot "$mnt/base" "$mnt/intermediate" >/dev/null
  inter_id=$(btrfs subvolume show "$mnt/intermediate" | grep 'Subvolume ID:' | awk '{print $3}')
  btrfs qgroup assign "0/$inter_id" 1/100 "$mnt"

  # Create working snapshot with --inherit (auto-adds to Q1)
  # src=intermediate (in only Q1)
  # dst=snap (inheriting only into Q1)
  # This double counts the 16k nodesize of the snapshot in Q1, and
  # undercounts it in Q2.
  btrfs subvolume snapshot -i 1/100 "$mnt/intermediate" "$mnt/snap" >/dev/null
  snap_id=$(btrfs subvolume show "$mnt/snap" | grep 'Subvolume ID:' | awk '{print $3}')

  # Fully complete snapshot creation
  sync

  # Delete working snapshot
  # Q1 and Q2 will lose the full snap usage
  btrfs subvolume delete "$mnt/snap" >/dev/null

  # Delete intermediate and remove from Q1
  # Q1 and Q2 will lose the full intermediate usage
  btrfs qgroup remove "0/$inter_id" 1/100 "$mnt"
  btrfs subvolume delete "$mnt/intermediate" >/dev/null

  # Q1 should be at 0, but still has 16k. Q2 is "correct" at 0 (for now...)

  # Trigger cleaner, wait for deletions
  mount -o remount,sync=1 "$mnt"
  btrfs subvolume sync "$mnt" "$snap_id"
  btrfs subvolume sync "$mnt" "$inter_id"

  # Remove Q1 from Q2
  # Frees 16k more from Q2, underflowing it to 16EiB
  btrfs qgroup remove 1/100 2/100 "$mnt"

  # And show the bad state:
  btrfs qgroup show -pc "$mnt"

        Qgroupid    Referenced    Exclusive Parent   Child   Path
        --------    ----------    --------- ------   -----   ----
        0/5           16.00KiB     16.00KiB -        -       <toplevel>
        0/256         16.00KiB     16.00KiB -        -       base
        1/100         16.00KiB     16.00KiB -        -       <0 member qgroups>
        2/100         16.00EiB     16.00EiB -        -       <0 member qgroups>

Fix this by simply not doing this quick inheritance with squotas.

I suspect that it is also wrong in normal qgroups to not recurse up the
qgroup tree in the quick inherit case, though other consistency checks
will likely fix it anyway.

Fixes: b20fe56cd285 ("btrfs: qgroup: allow quick inherit if snapshot is created and added to the same parent")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3c77f3506faf3..f23b482dfad9e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3298,6 +3298,9 @@ static int qgroup_snapshot_quick_inherit(struct btrfs_fs_info *fs_info,
 	struct btrfs_qgroup_list *list;
 	int nr_parents = 0;
 
+	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_FULL)
+		return 0;
+
 	src = find_qgroup_rb(fs_info, srcid);
 	if (!src)
 		return -ENOENT;
-- 
2.51.0



