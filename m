Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C403B27C5;
	Mon, 23 Mar 2026 15:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279165; cv=none; b=fMnlTl8DNcdnLWZMSzmddeyEBXFo07/0biFOKmOLf/JGtQdGYbXQ3ffvFoCi/6uY6NBBO+iQYbp4bpsLljw7GPDyouD2QtNoY9eGfuAa8TqW7gkUNUlQ2KOkC4GxWU31PpwogHQUaSuVo8tJ19VoHpeF0bVFRTO/BRUAQ0LduGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279165; c=relaxed/simple;
	bh=wGMkXCv9q3dutJvHvrxHhtkS3lLkze+TH+rSUlBalUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOO9kddUuYJhKSWnQHu0acSznTAANSxZmrDTPjnsXsuFpzyrTJw+zVx/F1hcB9JZh/r8QZmaN/I4sEikYXQc4XCVJrr5VK6MRZjjIfOF+oF9gmVw/cW09vF/rVsgLn2QyVAtO+t5GsSeNSDCWfJI+z6A2J6FglbuuLJl9F7Y84Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwjInWWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwjInWWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3255C4CEF7;
	Mon, 23 Mar 2026 15:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279165;
	bh=wGMkXCv9q3dutJvHvrxHhtkS3lLkze+TH+rSUlBalUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwjInWWiVIHXOsFQ3qAbUHkaqR7+LEVS+7dzQHV4oYyuCPXlM5p/TPO2Hs3BM7eX+
	 /A5A6rC81ehB+JNM0zhri1k1ZRIZFZdY0v7Hxz5mDlPnhGT6DHlfOQEJSPKzm1PkDe
	 2q12bg2iGQzd7BxsbuqTxBTYIU/7gtCZUfuLUzw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 496/567] btrfs: log new dentries when logging parent dir of a conflicting inode
Date: Mon, 23 Mar 2026 14:46:56 +0100
Message-ID: <20260323134546.301694739@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

[ Upstream commit 9573a365ff9ff45da9222d3fe63695ce562beb24 ]

If we log the parent directory of a conflicting inode, we are not logging
the new dentries of the directory, so when we finish we have the parent
directory's inode marked as logged but we did not log its new dentries.
As a consequence if the parent directory is explicitly fsynced later and
it does not have any new changes since we logged it, the fsync is a no-op
and after a power failure the new dentries are missing.

Example scenario:

  $ mkdir foo

  $ sync

  $rmdir foo

  $ mkdir dir1
  $ mkdir dir2

  # A file with the same name and parent as the directory we just deleted
  # and was persisted in a past transaction. So the deleted directory's
  # inode is a conflicting inode of this new file's inode.
  $ touch foo

  $ ln foo dir2/link

  # The fsync on dir2 will log the parent directory (".") because the
  # conflicting inode (deleted directory) does not exists anymore, but it
  # it does not log its new dentries (dir1).
  $ xfs_io -c "fsync" dir2

  # This fsync on the parent directory is no-op, since the previous fsync
  # logged it (but without logging its new dentries).
  $ xfs_io -c "fsync" .

  <power failure>

  # After log replay dir1 is missing.

Fix this by ensuring we log new dir dentries whenever we log the parent
directory of a no longer existing conflicting inode.

A test case for fstests will follow soon.

Reported-by: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/182055fa-e9ce-4089-9f5f-4b8a23e8dd91@gmail.com/
Fixes: a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 882bb3c04c23f..c77852dc32399 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5856,6 +5856,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  struct btrfs_log_ctx *ctx)
 {
+	const bool orig_log_new_dentries = ctx->log_new_dentries;
 	int ret = 0;
 
 	/*
@@ -5917,7 +5918,11 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 			 * dir index key range logged for the directory. So we
 			 * must make sure the deletion is recorded.
 			 */
+			ctx->log_new_dentries = false;
 			ret = btrfs_log_inode(trans, inode, LOG_INODE_ALL, ctx);
+			if (!ret && ctx->log_new_dentries)
+				ret = log_new_dir_dentries(trans, inode, ctx);
+
 			btrfs_add_delayed_iput(inode);
 			if (ret)
 				break;
@@ -5952,6 +5957,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 			break;
 	}
 
+	ctx->log_new_dentries = orig_log_new_dentries;
 	ctx->logging_conflict_inodes = false;
 	if (ret)
 		free_conflicting_inodes(ctx);
-- 
2.51.0



