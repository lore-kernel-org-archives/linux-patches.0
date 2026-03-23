Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B7039890A;
	Mon, 23 Mar 2026 14:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274758; cv=none; b=k9G9SLuTThqf0g8nseTI752a/dmMkuX5whP/tWYF14uV141UFNK/K0yFQsj4FSb3GipVJPKllEK7I/p7KQTVr0Pk/Qkp59+Etc1rzlg0xm0Cc96q1Lw+0+um8YFlYGXZhO076JtwiqegBvW0vYPoeKdR0+BvBxzvVuotIkFAv5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274758; c=relaxed/simple;
	bh=UrSkLn73ZVPOdv604Np05CZeQAQXe57Ofpvc3CpTe2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPq7o9YLowlT+0up4vijg9TNphE2bokb/mFGTK5qKje85x6+FKW5mgB4swY+FYbCBqMBHAtINueOA36Puuhxkk5dkkAlxIuzKKg2AsYF5POlypMJ+P79kAsCnU2+OaA7aWiJTJMjD/lk+YauDz2RWz6MiN0pb9liV0GjR0eBG+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RE4QhhGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RE4QhhGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4F9C4CEF7;
	Mon, 23 Mar 2026 14:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274758;
	bh=UrSkLn73ZVPOdv604Np05CZeQAQXe57Ofpvc3CpTe2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RE4QhhGDQ13m0nF6BZ8+plZskG7Q/o/k0+b57HpK+H90kZyErE8iyLHw0YIeJrDY7
	 vo1xyTRhA7NJWUxQQU3NCICzUP20blqNre87GmPkHpOc4VVsYaHdBNHF7J1f72OAFt
	 JkJH/Y/sItvcgwaj5Wqa2jIOgaAOe0+zxdx252s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/212] btrfs: log new dentries when logging parent dir of a conflicting inode
Date: Mon, 23 Mar 2026 14:45:20 +0100
Message-ID: <20260323134506.907374138@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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
index 6c5db73c3e85f..7505a87522fd7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6203,6 +6203,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  struct btrfs_log_ctx *ctx)
 {
+	const bool orig_log_new_dentries = ctx->log_new_dentries;
 	int ret = 0;
 
 	/*
@@ -6264,7 +6265,11 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
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
@@ -6299,6 +6304,7 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 			break;
 	}
 
+	ctx->log_new_dentries = orig_log_new_dentries;
 	ctx->logging_conflict_inodes = false;
 	if (ret)
 		free_conflicting_inodes(ctx);
-- 
2.51.0



