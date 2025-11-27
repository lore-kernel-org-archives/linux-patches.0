Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99FA28135D;
	Thu, 27 Nov 2025 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255918; cv=none; b=EdRvcBzT8tmXgGEKe9A1VkxgPPf9XgpGnD8tP6OTCx8k5PyiKsTQjZMPa9nyQiuBeSpH5wOEe2XlukZmaPGc3Owa8uZCnB3ReRf8kdsqmb2h+woxu0f/7XCBhbeM++knD0q/YMpGDV9nWVf+HdMjOxfpBP2V8/rJ4BgSDwtkqIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255918; c=relaxed/simple;
	bh=vG3HDGHnAhZZ6HMJ2UzI5T89x7VzgNXnKesGaqivPeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro0scJFz3my53dL9z6rjpc8X9H26MCgnAM32SjEEfw3Q00cFno394yE+8Jbv8Kt/7hnnPjSl7db8rck1QkpWAdVoiKM+PfQVzQLOu1df5zuvfqZojiqAZFNMfX+2oEPuEuG2Zcw0JKDfSniWl0YR5rzJNyiqmTlSgZWJJaxq7q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4vMeEEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4vMeEEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A438C4CEF8;
	Thu, 27 Nov 2025 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255917;
	bh=vG3HDGHnAhZZ6HMJ2UzI5T89x7VzgNXnKesGaqivPeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4vMeEEMSisUJm2WcvfQUBXbAOZMWtFirEvz5xhpXeeAP7dr1Wr8Q+HROm8RH97FR
	 /IGrnveMwHGmhlt3Lf0/9tKtKSK1D10p89wABdQ5upMF+qeJPqO4M19v1WFzypwdtp
	 bffBtNTO9WFrBD9PPjGB5MwcQwiamp/mDd2cdju4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 159/175] btrfs: set inode flag BTRFS_INODE_COPY_EVERYTHING when logging new name
Date: Thu, 27 Nov 2025 15:46:52 +0100
Message-ID: <20251127144048.760253388@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 953902e4fb4c373c81a977f78e40f9f93a79e20f ]

If we are logging a new name make sure our inode has the runtime flag
BTRFS_INODE_COPY_EVERYTHING set so that at btrfs_log_inode() we will find
new inode refs/extrefs in the subvolume tree and copy them into the log
tree.

We are currently doing it when adding a new link but we are missing it
when renaming.

An example where this makes a new name not persisted:

  1) create symlink with name foo in directory A
  2) fsync directory A, which persists the symlink
  3) rename the symlink from foo to bar
  4) fsync directory A to persist the new symlink name

Step 4 isn't working correctly as it's not logging the new name and also
leaving the old inode ref in the log tree, so after a power failure the
symlink still has the old name of "foo". This is because when we first
fsync directoy A we log the symlink's inode (as it's a new entry) and at
btrfs_log_inode() we set the log mode to LOG_INODE_ALL and then because
we are using that mode and the inode has the runtime flag
BTRFS_INODE_NEEDS_FULL_SYNC set, we clear that flag as well as the flag
BTRFS_INODE_COPY_EVERYTHING. That means the next time we log the inode,
during the rename through the call to btrfs_log_new_name() (calling
btrfs_log_inode_parent() and then btrfs_log_inode()), we will not search
the subvolume tree for new refs/extrefs and jump directory to the
'log_extents' label.

Fix this by making sure we set BTRFS_INODE_COPY_EVERYTHING on an inode
when we are about to log a new name. A test case for fstests will follow
soon.

Reported-by: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/ac949c74-90c2-4b9a-b7fd-1ffc5c3175c7@gmail.com/
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c    | 1 -
 fs/btrfs/tree-log.c | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 68b2140c9fdb1..79a68f1871679 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6850,7 +6850,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	BTRFS_I(inode)->dir_index = 0ULL;
 	inode_inc_iversion(inode);
 	inode_set_ctime_current(inode);
-	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
 
 	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
 			     &fname.disk_name, 1, index);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index dc0f3b5778b48..b203d8f2d2aaf 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7608,6 +7608,9 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	bool log_pinned = false;
 	int ret;
 
+	/* The inode has a new name (ref/extref), so make sure we log it. */
+	set_bit(BTRFS_INODE_COPY_EVERYTHING, &inode->runtime_flags);
+
 	btrfs_init_log_ctx(&ctx, inode);
 	ctx.logging_new_name = true;
 
-- 
2.51.0



