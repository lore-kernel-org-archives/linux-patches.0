Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8AF4FE2EA;
	Thu, 17 Sep 2026 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664884; cv=none; b=Kno/5sDYq1zW+sNCubxbhdihUxyCNncALhqJsKiNWCYMhYYaCSV7Qu3mW9eFqdie6Q3rYlQO6M2dkObFlwZBJO1S0pmXN47LlFueL0kcyPYuZzgM+eub5X3sr8W8AUT7295BE3TIaSRzwckcbP2tp3Srr0LQWyxA5/EV+SIZJx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664884; c=relaxed/simple;
	bh=5gZ1zzTeDG2ONF1kO3mAZCK5goQtnaIoBnkt5xURzIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8tel/LykYf5VsPhU7kCZRNUe+NRAbhUXjvraKevDfWvvVbGjUD4p+j5JxuTczWMGYVSgQOfFkA1/ncaECzM9lG2J7U+OZfyO1zxFe2iHkwoWRYFD+S9eBLR8cjwiyg/AzkYDOVYQYlcMh5c4eooNEhDWP+ozkjdl7G5Pke5oMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BujSbHl6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BujSbHl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085C61F000FF;
	Thu, 17 Sep 2026 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664882;
	bh=RbSub+9A/Zt9Jf0jm96gthvQk5sdKrHp47R/E9ku1ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BujSbHl6NaUt9eoMCGSIjKMsl+XVDmh7xjD+T4PlrOvk3simZ4Rf8UWj75mdW/qY4
	 5azXYEPuXMHZpBEW2lqjHJEZWOE47P1D/RVrUMfgD/xuxx+Y2NohjtwFqaLxdChAY7
	 goTBQzovH82j5yQM4zB9rcznCLrYsJzPAumqkgNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Dave Chen <davechen@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0513/1250] btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()
Date: Thu, 17 Sep 2026 16:05:08 +0100
Message-ID: <20260917151605.862033809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index cca9840bee896..6795f87314c45 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8166,7 +8166,8 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 	stat->result_mask |= STATX_SUBVOL;
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
+	delalloc_bytes = S_ISREG(inode->i_mode) ?
+			 BTRFS_I(inode)->new_delalloc_bytes : 0;
 	inode_bytes = inode_get_bytes(inode);
 	spin_unlock(&BTRFS_I(inode)->lock);
 	stat->blocks = (ALIGN(inode_bytes, blocksize) +
-- 
2.53.0



