Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AA65172F8;
	Wed, 30 Sep 2026 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784867; cv=none; b=EZtSVBKOfQDnlvPtIDsoLmYek8BDGkgEGODZTVheoLlNmEFc5fUDK98FFrEjnuBPGPrRqRIGOiwUJIjY585eNE39qsOAwbZ7FHrEWBH2q/vNTH4BySpKITR9Z44Wx5+BCNPE2eknluaBUfbgcll0Icy+rG9opGhXn7o6pGEMb/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784867; c=relaxed/simple;
	bh=UuADlHMARCLy/v9bsAFHzefv6EAGHygWY67DqY2mQq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPI9AqQFEaImQeK17jXDA/Cm73OY+10lSGqd0k0tgmCFfcoQzgKNcroUyUuKRzr06t+3lMv86WEZSRlaeI06l3ZXmQGxIe3cZwRhdJ72dl+0geqiNag5M8BcR+BsN0PuHz5Pa5qzM5zKpAwx+Jxz+3qinJxUpmyD1T/umpAAUMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERgsWBny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERgsWBny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16CE1F00898;
	Wed, 30 Sep 2026 16:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784864;
	bh=WYuULiD+qITh60IPHhgo9qHqzY+IlpIAAph2mR0IM+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERgsWBnyXm5cgt/s9k0K0bWooA0z5g5Ob9vsCjoxoi67G5YNLZmyEt1Hg7U6hp+fX
	 ps1Uwml5LPwoOvEs76n93Uymh5EgnPiR2G7VP/9jFlG7KP6HN7KgSa3uoXXOU48FN9
	 dGKmzPSPcZp4Z0qQARkr/vlItZHGAltiGqiqzcTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Dave Chen <davechen@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/982] btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()
Date: Wed, 30 Sep 2026 17:16:37 +0200
Message-ID: <20260930152422.403019037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Dave Chen <davechen@synology.com>

[ Upstream commit 9411aafdf352b8d72668732af5a37dcb27383e25 ]

btrfs_getattr() unconditionally reads BTRFS_I(inode)->new_delalloc_bytes
and adds it (sector-aligned) to stat->blocks for every inode type.
However, new_delalloc_bytes lives in a union with last_dir_index_offset:

    union {
        u64 new_delalloc_bytes;     /* files only */
        u64 last_dir_index_offset;  /* directories only */
    };

For a directory inode this memory holds last_dir_index_offset, which is
set during directory logging (e.g. flush_dir_items_batch()) to the
offset of the last logged BTRFS_DIR_INDEX_KEY.  That offset grows with
the number of entries ever created in the directory (dir indexes are
monotonic and never reused), so it can be arbitrarily large.

As a result, after a directory has been logged (e.g. via an fsync that
triggers directory logging), btrfs_getattr() reports inflated st_blocks
for that directory.  The inflation is purely in-core and disappears
after the inode is evicted and reloaded (btrfs_alloc_inode() zeroes the
union), e.g. after a remount.

Reproducer (on a btrfs filesystem):

    D=/mnt/btrfs/d
    mkdir -p $D
    for i in $(seq 1 20000); do touch $D/f$i; done
    sync                      # commit, push dir index high
    touch $D/trigger          # dirty the dir in a new transaction
    xfs_io -c fsync $D        # log the directory -> sets last_dir_index_offset
    stat -c '%b' $D           # st_blocks is now inflated (e.g. 40)
    # umount + mount -> st_blocks drops back to the correct value

The evict path already knows this union is type-dependent and guards the
corresponding WARN_ON with !S_ISDIR() in btrfs_destroy_inode(); only
btrfs_getattr() was missing the equivalent check.

Only read new_delalloc_bytes for regular files, which are the only
inodes that ever set it.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Dave Chen <davechen@synology.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b2a1d96a806a9..e53b42a047e8b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9275,7 +9275,8 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
 	stat->dev = BTRFS_I(inode)->root->anon_dev;
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
+	delalloc_bytes = S_ISREG(inode->i_mode) ?
+			 BTRFS_I(inode)->new_delalloc_bytes : 0;
 	inode_bytes = inode_get_bytes(inode);
 	spin_unlock(&BTRFS_I(inode)->lock);
 	stat->blocks = (ALIGN(inode_bytes, blocksize) +
-- 
2.53.0



