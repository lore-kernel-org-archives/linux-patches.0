Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E414EF13D;
	Thu, 17 Sep 2026 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668476; cv=none; b=INJh6smWcGu1cMALLhf14vn9njzjlzo20T4YHeIOr+tWx/htcETIoGDbvmWLcoNCfXKM+i38081qD3taQz5bWcvBV7tAg85Q23WNNa21Ol6acZS8teqhNae7OPj1IYOkVMWi5/Wez48PNF0PcZGDIYnvaaJIPaUL9YzzNQwamc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668476; c=relaxed/simple;
	bh=4DhYMJSZAA9hb1wisl0ySF44MSUWfmqK6NjoYgizCmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNzM0VOP1XUbgu7uZAEK7zE/2GCHzHKfzOoa0fRhIgM4XAmLte91gNu+OtwBokMTr+SQferK8kXF3Z022+GhJ/fknG8Iuanijqmu+Z/HhGgGbWMG6CpWT2mhYpD3eU4wQvIlivcth06jKzYFLpe66Yr15nnqGCA2Ij/QNgHSOvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xevBCVmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xevBCVmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613891F000FF;
	Thu, 17 Sep 2026 18:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668475;
	bh=Qcs++gw7opsW/V78HrYVyzcDQMd+uzxx+h44VwQZ2TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xevBCVmn3A1BcJM7ppr8E2AratpyAnvXpQeBAZwEP5Ynfmv2hEtTMleAaexXOTXwO
	 v1jhj1MBKOlTnjYdvQiUjhROo0jNkamKfXkNmFRRCIABvN1eFUa+G0zo1sxe/9rlbl
	 il3T1LDAT2JF0rJapyQynG8Bt7Nymy2fGJ4b0HOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Dave Chen <davechen@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0410/1102] btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()
Date: Thu, 17 Sep 2026 16:05:53 +0100
Message-ID: <20260917151549.957142353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index ab7f19ca21457..1245904884f5f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7877,7 +7877,8 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
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



