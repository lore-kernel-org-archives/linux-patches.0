Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70B222CBD9;
	Mon, 29 Dec 2025 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024857; cv=none; b=gSPQBeu5T6A8AvVT/MbPQVUUq9qRJJJvqUImZAeG7hijpJTrx2i6xqH/zzibjr6LH6JktzWLGmtLoGxBV0u9ictoZcQvzDxsF9ZAIiUTEGHdLb6sNuOx1V/XitQ1X1KQzgEh0vdacTfwYmwFjbC9akBfXIabTOeivV5cKhUKbCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024857; c=relaxed/simple;
	bh=UdMXJ4UBAEAvdGghkwy2/RisPHrnXFv6tH9e+Op6Ngg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAwei7YFi9NpyVFn2ksgi+KGVosvSUKzZ/sf4ZX5Sq7V+1Semx/DjZPIvsJm+HX6/l29ppLe0Q+XE+EIk1e3glwi1d7z4iIp4ditim+pUHVX5huh6N+UQZwaUXWON0K0aCcSx1SMeM/4qvR98xVdZv233zHKrVrXNtY4iWXSKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+WdVXQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+WdVXQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC259C4CEF7;
	Mon, 29 Dec 2025 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024857;
	bh=UdMXJ4UBAEAvdGghkwy2/RisPHrnXFv6tH9e+Op6Ngg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+WdVXQ1m33Ukx59ZPIVA7JGx37IAZh9yOixTd34yZHpA8GsF/WTS2WLiD0j8OXUl
	 mVEVxwh8vZb8BA2w/zB3Lt5/gQwsfoCXDNQhnu9fzB4ayLafljifwCMXZdgRLahFcX
	 PqYNi7g/96SSPHWk6/cSZYCNteaiyMLXZ93qHgNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/430] btrfs: do not skip logging new dentries when logging a new name
Date: Mon, 29 Dec 2025 17:06:43 +0100
Message-ID: <20251229160724.199955913@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 30f3c3b849c14..f55d886debe2f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5872,14 +5872,6 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
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



