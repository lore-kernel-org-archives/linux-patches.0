Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB9417AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74D6C433C7;
	Wed,  9 Aug 2023 11:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580396;
	bh=4vO7TP1O+UKlJm4nlGCP6wtRwRBbXlKCUd7ou7u8a98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCItTg1j5lF+lbQ2Kw3Xt3/Qzclb3OKgPeQIytvYvdH3Ent0DUYeKJkVMJ0GNJ3f5
	 w9sAmhugIPHAiu5s29K+zkzI9F19WjivkQGThQd1H0JC030TWALzSQBPE0WpReUZJg
	 TBozrv1cQ9bEvDzELzSGlIog2fHfWQ7LFDFBi348=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/154] btrfs: fix race between quota disable and relocation
Date: Wed,  9 Aug 2023 12:40:41 +0200
Message-ID: <20230809103637.266686722@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 8a4a0b2a3eaf75ca8854f856ef29690c12b2f531 ]

If we disable quotas while we have a relocation of a metadata block group
that has extents belonging to the quota root, we can cause the relocation
to fail with -ENOENT. This is because relocation builds backref nodes for
extents of the quota root and later needs to walk the backrefs and access
the quota root - however if in between a task disables quotas, it results
in deleting the quota root from the root tree (with btrfs_del_root(),
called from btrfs_quota_disable().

This can be sporadically triggered by test case btrfs/255 from fstests:

  $ ./check btrfs/255
  FSTYP         -- btrfs
  PLATFORM      -- Linux/x86_64 debian0 6.4.0-rc6-btrfs-next-134+ #1 SMP PREEMPT_DYNAMIC Thu Jun 15 11:59:28 WEST 2023
  MKFS_OPTIONS  -- /dev/sdc
  MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

  btrfs/255 6s ... _check_dmesg: something found in dmesg (see /home/fdmanana/git/hub/xfstests/results//btrfs/255.dmesg)
  - output mismatch (see /home/fdmanana/git/hub/xfstests/results//btrfs/255.out.bad)
#      --- tests/btrfs/255.out	2023-03-02 21:47:53.876609426 +0000
#      +++ /home/fdmanana/git/hub/xfstests/results//btrfs/255.out.bad	2023-06-16 10:20:39.267563212 +0100
#      @@ -1,2 +1,4 @@
#       QA output created by 255
#      +ERROR: error during balancing '/home/fdmanana/btrfs-tests/scratch_1': No such file or directory
#      +There may be more info in syslog - try dmesg | tail
#       Silence is golden
#      ...
      (Run 'diff -u /home/fdmanana/git/hub/xfstests/tests/btrfs/255.out /home/fdmanana/git/hub/xfstests/results//btrfs/255.out.bad'  to see the entire diff)
  Ran: btrfs/255
  Failures: btrfs/255
  Failed 1 of 1 tests

To fix this make the quota disable operation take the cleaner mutex, as
relocation of a block group also takes this mutex. This is also what we
do when deleting a subvolume/snapshot, we take the cleaner mutex in the
cleaner kthread (at cleaner_kthread()) and then we call btrfs_del_root()
at btrfs_drop_snapshot() while under the protection of the cleaner mutex.

Fixes: bed92eae26cc ("Btrfs: qgroup implementation and prototypes")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 7821bef061fe6..b6cce67520f04 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1164,12 +1164,23 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	int ret = 0;
 
 	/*
-	 * We need to have subvol_sem write locked, to prevent races between
-	 * concurrent tasks trying to disable quotas, because we will unlock
-	 * and relock qgroup_ioctl_lock across BTRFS_FS_QUOTA_ENABLED changes.
+	 * We need to have subvol_sem write locked to prevent races with
+	 * snapshot creation.
 	 */
 	lockdep_assert_held_write(&fs_info->subvol_sem);
 
+	/*
+	 * Lock the cleaner mutex to prevent races with concurrent relocation,
+	 * because relocation may be building backrefs for blocks of the quota
+	 * root while we are deleting the root. This is like dropping fs roots
+	 * of deleted snapshots/subvolumes, we need the same protection.
+	 *
+	 * This also prevents races between concurrent tasks trying to disable
+	 * quotas, because we will unlock and relock qgroup_ioctl_lock across
+	 * BTRFS_FS_QUOTA_ENABLED changes.
+	 */
+	mutex_lock(&fs_info->cleaner_mutex);
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root)
 		goto out;
@@ -1251,6 +1262,7 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 		btrfs_end_transaction(trans);
 	else if (trans)
 		ret = btrfs_end_transaction(trans);
+	mutex_unlock(&fs_info->cleaner_mutex);
 
 	return ret;
 }
-- 
2.39.2



