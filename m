Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B429359FB6;
	Fri,  9 Jan 2026 12:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960138; cv=none; b=clChcIdK0KCUWTTJwW2/IhsWxVj0owg2cbIjB/pJeNvSHVyV1QjXT27v/ZUIJPEw78L4m5LgnUuDB6Ug/wQeBR5DavFoLWTzlqIKUccnh63LxfbqJJVHZbTEeuGRw+9mS6NqQMvn0QbChWKj8vApQnyW5KjgcIKF/Tn9oHl9DiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960138; c=relaxed/simple;
	bh=OMlfpAMRinj/Xy8raElE9IdIpU1bKUrJrDtfjDF+pSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sj2chEHzOoYC9zDwPOoP0iw9omDddwAy3wjyC7I05b2QPISSNKf8CuMHefEfTUlgnnsRG9xLPxivPzjwBFvT2VZgBlDGNMn6RKuV1lCDl52zsgTKJYpLLMzdrKN7PvOUa7n0eF5/lCuO29hYvbwB0cVWmm+WLnLoaFE8fN9+vf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogSvp2ES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogSvp2ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A3EC4CEF1;
	Fri,  9 Jan 2026 12:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960138;
	bh=OMlfpAMRinj/Xy8raElE9IdIpU1bKUrJrDtfjDF+pSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogSvp2ESrTHbR+PZo7IRWfSN2cX+CAnx3799+TMHQwAtRW93nAIW18P2xMJ64Eatu
	 QlJje1piE6SgsfaIdojw6vp1XCtO1oCPIU4nO5JYaw16N93ETcoAJSJP6KmnR7IWYP
	 Jk+Vq9YueY97Gq5KH5bmUd70d/upPu8yw1JoQA1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/737] btrfs: do not skip logging new dentries when logging a new name
Date: Fri,  9 Jan 2026 12:37:18 +0100
Message-ID: <20260109112145.256105185@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 256116a6e07c6..ca01f2daac6e4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5526,14 +5526,6 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
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



