Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493F82745E;
	Fri, 21 Nov 2025 13:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731976; cv=none; b=ah21/XdyThT+jIKm2b8Agb/lc4mcfDdNKHHYVA5gJ9GmYKldoUccvSwyVZN36hZYdkDSWDon81wrj07pt3FG6Cq4gFXItQ4YxoSkmdWD1b6T9Mmm51m1Io7LYiw6wgJiE2DCRun+qxyBoSeA82BvA7UCOxFL0txfEtRdIt/DOqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731976; c=relaxed/simple;
	bh=W9qMx2Qfuu/Qh0O9aRiWJw2kFtuQhBcmtmFhEdNHp48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pStmYxNJLQqMvzRnEYbFnJn5uF/j4UEckc0caZ0H4WqBbCdxtkfNcafN6Tcgy7JC492imDT+uoeBZsqmq+gNuG82pXh7ACnvkT6xzrEzduckOEu/9kqOVYleHMdXXEaGDlB9fMUP+H11YTvmPr2oVl+fReHPexsuYGM8TX3r9NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkz0j1SJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkz0j1SJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EAAC4CEF1;
	Fri, 21 Nov 2025 13:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731976;
	bh=W9qMx2Qfuu/Qh0O9aRiWJw2kFtuQhBcmtmFhEdNHp48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkz0j1SJDYqGChilkqhh/WpF/3p+X/dGoZV7vpxOvzDa0mzyaT8JKNnu4emZDGmAs
	 M7TVny6JoG3d7ntGDkX8LP+S90dDRgv+1UDXoI1d8AxSPtc7D7ceW32ijoMYBcC0jF
	 PAuFgDohlJ9nsyI7LTYMrowuICRXFEpw/44Chw7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 146/185] btrfs: do not update last_log_commit when logging inode due to a new name
Date: Fri, 21 Nov 2025 14:12:53 +0100
Message-ID: <20251121130149.146291652@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

commit bfe3d755ef7cec71aac6ecda34a107624735aac7 upstream.

When logging that a new name exists, we skip updating the inode's
last_log_commit field to prevent a later explicit fsync against the inode
from doing nothing (as updating last_log_commit makes btrfs_inode_in_log()
return true). We are detecting, at btrfs_log_inode(), that logging a new
name is happening by checking the logging mode is not LOG_INODE_EXISTS,
but that is not enough because we may log parent directories when logging
a new name of a file in LOG_INODE_ALL mode - we need to check that the
logging_new_name field of the log context too.

An example scenario where this results in an explicit fsync against a
directory not persisting changes to the directory is the following:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt

  $ touch /mnt/foo

  $ sync

  $ mkdir /mnt/dir

  # Write some data to our file and fsync it.
  $ xfs_io -c "pwrite -S 0xab 0 64K" -c "fsync" /mnt/foo

  # Add a new link to our file. Since the file was logged before, we
  # update it in the log tree by calling btrfs_log_new_name().
  $ ln /mnt/foo /mnt/dir/bar

  # fsync the root directory - we expect it to persist the dentry for
  # the new directory "dir".
  $ xfs_io -c "fsync" /mnt

  <power fail>

After mounting the fs the entry for directory "dir" does not exists,
despite the explicit fsync on the root directory.

Here's why this happens:

1) When we fsync the file we log the inode, so that it's present in the
   log tree;

2) When adding the new link we enter btrfs_log_new_name(), and since the
   inode is in the log tree we proceed to updating the inode in the log
   tree;

3) We first set the inode's last_unlink_trans to the current transaction
   (early in btrfs_log_new_name());

4) We then eventually enter btrfs_log_inode_parent(), and after logging
   the file's inode, we call btrfs_log_all_parents() because the inode's
   last_unlink_trans matches the current transaction's ID (updated in the
   previous step);

5) So btrfs_log_all_parents() logs the root directory by calling
   btrfs_log_inode() for the root's inode with a log mode of LOG_INODE_ALL
   so that new dentries are logged;

6) At btrfs_log_inode(), because the log mode is LOG_INODE_ALL, we
   update root inode's last_log_commit to the last transaction that
   changed the inode (->last_sub_trans field of the inode), which
   corresponds to the current transaction's ID;

7) Then later when user space explicitly calls fsync against the root
   directory, we enter btrfs_sync_file(), which calls skip_inode_logging()
   and that returns true, since its call to btrfs_inode_in_log() returns
   true and there are no ordered extents (it's a directory, never has
   ordered extents). This results in btrfs_sync_file() returning without
   syncing the log or committing the current transaction, so all the
   updates we did when logging the new name, including logging the root
   directory,  are not persisted.

So fix this by but updating the inode's last_log_commit if we are sure
we are not logging a new name (if ctx->logging_new_name is false).

A test case for fstests will follow soon.

Reported-by: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/03c5d7ec-5b3d-49d1-95bc-8970a7f82d87@gmail.com/
Fixes: 130341be7ffa ("btrfs: always update the logged transaction when logging new names")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6795,7 +6795,7 @@ log_extents:
 	 *    a power failure unless the log was synced as part of an fsync
 	 *    against any other unrelated inode.
 	 */
-	if (inode_only != LOG_INODE_EXISTS)
+	if (!ctx->logging_new_name && inode_only != LOG_INODE_EXISTS)
 		inode->last_log_commit = inode->last_sub_trans;
 	spin_unlock(&inode->lock);
 


