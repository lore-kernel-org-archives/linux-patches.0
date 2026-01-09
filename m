Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258AD31E107;
	Fri,  9 Jan 2026 12:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962041; cv=none; b=e1S9QqWa/pRZmy5/N22UhG2QgcNgvzCxWoJAPcQQbzdw7X/hcOmI1A/Dg8N8EGzlGYzqFa2PZBNjjKN9eOnTD962VQs9jqWMkdNL4U0N9o1uHTtuFTeXKntQYUHOCJchivuV1gsbMLHrc+0JBFsk3xMzTUmRZcY4J9WQuaQ//aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962041; c=relaxed/simple;
	bh=ZrjxTgoGh/C2jogyd0Tjt4/LtpL9ETWUzAZ5wOXBAao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2AaAZQ3+xej4IfHWppj+7d8mG4hudXhpSeZkulOP53NsdCMKphbzmBhqngxXEP+7LtGU+3LrTuaLDd9J6wAq2OsLhOs2HuT6PNeX+OEU0jM1z6CjG6TYn2kM9IvfCKHNI6pJh2Sko/bWd/8XOF1CdKtIzlFTDibQyLCOPuLBX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utzVe5gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utzVe5gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4B8C4CEF1;
	Fri,  9 Jan 2026 12:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962040;
	bh=ZrjxTgoGh/C2jogyd0Tjt4/LtpL9ETWUzAZ5wOXBAao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utzVe5gi6L3OHl2a2JrGdLCgKWyZU3j1Ko2HlFgI3OX2HJukfPrDwj5QwgryCWpwe
	 HWRlZSuXpJq+gUBqhamH8e1du/OWEn93cdqB2vkW+BSf5r913nhukwmcLC8HSMw8iv
	 if45UNU6bp761LAMRGV35rFnqqU1hnO+B8/9jDqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 225/634] btrfs: do not skip logging new dentries when logging a new name
Date: Fri,  9 Jan 2026 12:38:23 +0100
Message-ID: <20260109112125.897906771@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 11a7408ebc265..aa506716e9201 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5478,14 +5478,6 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 	u64 ino = btrfs_ino(start_inode);
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



