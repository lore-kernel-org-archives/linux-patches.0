Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008F033F8A0;
	Tue,  6 Jan 2026 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719684; cv=none; b=hpE00czmvTgQ6mxtOSygjzMXBbBUo9D9h7KhwBX6RUrRz/q74CvdZSiduKL2Y+lhYXDX+eMfa++2CzFTdHYog9Py333ODjO0GN9yWky8T/CUN5EqeKXG+AStnEJP2uvKTmrRLwxv2tOA7wGpqym2ZH0hOvGsWMjzeNpvcnzcsLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719684; c=relaxed/simple;
	bh=g07DO8jQYqI0244wH3YhnM26vGxFCQlvv/6qLe0VulM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5Zdjwo4mxwIyLA4NGe+Y2FtwyB3Xq4ioaDm8Xc3jvD6z1hfCaJAG7TisHbADqFfOZRKvKMVCilNZ1U0yOGG3Kdo3WQjVpKRNRTVqJg4KBrM7vse8oHwGe31VtYNgkL30DdSlEHghNh/WGTKqD04fFMlkmK71uVq69alBPSuNvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZpMnJdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZpMnJdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F5FC116C6;
	Tue,  6 Jan 2026 17:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719683;
	bh=g07DO8jQYqI0244wH3YhnM26vGxFCQlvv/6qLe0VulM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZpMnJdJ0corrN2z76lus//0wx8Zzf0Q1PGBn37Txyk1mNvRDxnBqkSMBSs3Sdc98
	 9P1YegVdO0qbLi0PQFoG6lEBhoCVNll+zTfnKxn8vybZ//F6G2mSWDJCbXh6o5EoaD
	 peF0U5HJqUYHVp6l62GYHAHoDpub+oRcpIsMNPkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/567] btrfs: do not skip logging new dentries when logging a new name
Date: Tue,  6 Jan 2026 17:56:23 +0100
Message-ID: <20260106170451.395993144@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

[ Upstream commit 5630f7557de61264ccb4f031d4734a1a97eaed16 ]

When we are logging a directory and the log context indicates that we
are logging a new name for some other file (that is or was inside that
directory), we skip logging the inodes for new dentries in the directory.

This is ok most of the time, but if after the rename or link operation
that triggered the logging of that directory, we have an explicit fsync
of that directory without the directory inode being evicted and reloaded,
we end up never logging the inodes for the new dentries that we found
during the new name logging, as the next directory fsync will only process
dentries that were added after the last time we logged the directory (we
are doing an incremental directory logging).

So make sure we always log new dentries for a directory even if we are
in a context of logging a new name.

We started skipping logging inodes for new dentries as of commit
c48792c6ee7a ("btrfs: do not log new dentries when logging that a new name
exists") and it was fine back then, because when logging a directory we
always iterated over all the directory entries (for leaves changed in the
current transaction) so a subsequent fsync would always log anything that
was previously skipped while logging a directory when logging a new name
(with btrfs_log_new_name()). But later support for incrementally logging
a directory was added in commit dc2872247ec0 ("btrfs: keep track of the
last logged keys when logging a directory"), to avoid checking all dir
items every time we log a directory, so the check to skip dentry logging
added in the first commit should have been removed when the incremental
support for logging a directory was added.

A test case for fstests will follow soon.

Reported-by: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/84c4e713-85d6-42b9-8dcf-0722ed26cb05@gmail.com/
Fixes: dc2872247ec0 ("btrfs: keep track of the last logged keys when logging a directory")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 609f221d4c309..25ab8f3af56c8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5556,14 +5556,6 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 	struct btrfs_inode *curr_inode = start_inode;
 	int ret = 0;
 
-	/*
-	 * If we are logging a new name, as part of a link or rename operation,
-	 * don't bother logging new dentries, as we just want to log the names
-	 * of an inode and that any new parents exist.
-	 */
-	if (ctx->logging_new_name)
-		return 0;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
2.51.0



