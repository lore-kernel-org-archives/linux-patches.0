Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167D043F8D3;
	Thu, 30 Jul 2026 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422948; cv=none; b=FpGUVUC+P4RcqTgsKPSJdxB+gLgYD2m1zD8n92cNZZwslqi2FXqs12BrF7hfZieU/h1IrfUwSGZck4fK4JeNrv+GYoCqtKW19Ak7I35Qvki5A22B+1pJyo1Fp2wZuBb3tV9tsyT50eHJ9JSSMSDgUTCiDnB+epVpcgRXxwpWeEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422948; c=relaxed/simple;
	bh=YAPebNE7o/frOFyS5++9iDoh+0K68NYm+EaL0CmkD4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYfWFeczoKdr/R9SVXhESyslkxnSOHED/C6z8rgp8K9mDZOemoz9XThKHMIWPBBMB6udnGBESmX7sn9TELd/qsIqpiqoEtmOfce8rMHs2itta3kd5FlN8MnOKWCx+Mv2o8BU4wQdO1zUkeSLl7fO18fWaUKQt3cCuGoENJWiym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMLf1mAG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMLf1mAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344A81F000E9;
	Thu, 30 Jul 2026 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422946;
	bh=qrosRTlEXNHvNko17/7jGVckK6xGyy7KPILMSTo9ytI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMLf1mAGWjX5LzgektMuSznsiyD52KIq5f01ZqpxHySMigprY1We6QVWEnCvP+FJn
	 5+m/8UgoFL2Yi0v3fcgtFMgIOzGHBtQKEwMCoi2oVBg4XAw8zSCYDaf65pr1oP7dik
	 d49CCEyJeKv9kr9R2ldGzibqAJJlX6d7fkfEMfTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.1 613/744] btrfs: do not try compression for data reloc inodes
Date: Thu, 30 Jul 2026 16:14:46 +0200
Message-ID: <20260730141457.303020577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit ae4316f332e03e628712e9dfb89f2b7d3c70c21a upstream.

[BUG]
There is a syzbot report that the check inside get_new_location()
triggered:

  BTRFS info (device loop0): found 31 extents, stage: move data extents
  BTRFS info (device loop0): leaf 8908800 gen 16 total ptrs 28 free space 1676 owner 18446744073709551607
         item 0 key (256 INODE_ITEM 0) itemoff 3835 itemsize 160
                 inode generation 5 transid 0 size 0 nbytes 0
                 block group 0 mode 40755 links 1 uid 0 gid 0
                 rdev 0 sequence 0 flags 0x0
                 atime 1669132761.0
                 ctime 1669132761.0
                 mtime 1669132761.0
                 otime 0.0
         item 1 key (256 INODE_REF 256) itemoff 3823 itemsize 12
                 index 0 name_len 2
         item 2 key (258 INODE_ITEM 0) itemoff 3663 itemsize 160
                 inode generation 1 transid 16 size 733184 nbytes 106496
                 block group 0 mode 100600 links 0 uid 0 gid 0
                 rdev 0 sequence 24 flags 0x18
         item 3 key (258 EXTENT_DATA 0) itemoff 3595 itemsize 68
                 generation 16 type 0
                 inline extent data size 47 ram_bytes 4096 compression 1
  [...]
         item 27 key (18446744073709551611 ORPHAN_ITEM 258) itemoff 2376 itemsize 0
  BTRFS error (device loop0): unexpected non-zero offset in file extent item for data reloc inode 258 key offset 0 offset 9277520992061368337
  ------------[ cut here ]------------
  btrfs_abort_should_print_stack(__error)

[CAUSE]
The above dump tree shows the first file extent item is inlined, which
should make no sense for data reloc inodes, as such inodes just
represent where the data extents are in the relocation destination chunk.

However the relocation path preallocates space for each block,
then dirties them, cluster by cluster.
It's possible to have a single block at the beginning of the block
group, and no other block in the same cluster.

So relocation will preallocate a file extent for that block and dirty
the first block.  Then memory pressure forces the data reloc inode to be
written back, before any other blocks are dirtied/allocated.

Finally commit 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated
delalloc helper") changed the sequence of delalloc. Before that commit we
always tried NOCOW first, so that dirtied block would be written back into
the preallocated space, and appear as a regular extent.

But with that commit, we always try inline first, and since compression
is forced, we try compressing the first block, and then inline the
compressed data, resulting in the above inlined file extent in the data
reloc tree.

Then the check in get_new_location() will check the file offset, without
checking if the file extent is inlined or not, resulting in the above
failure.

[FIX]
Do not allow compression for data reloc inodes.

Since data reloc inode sizes are always block aligned, as long as we do
not compress, @data_len will always be at least one block, and
that will cause can_cow_file_range_inline() to return false, thus no
inlined extent will be created.

Reported-by: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6a373dc5.764cf64f.168fbe.0001.GAE@google.com/
Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated delalloc helper")
CC: stable@vger.kernel.org
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/btrfs_inode.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -507,6 +507,8 @@ static inline bool btrfs_inode_can_compr
 	if (inode->flags & BTRFS_INODE_NODATACOW ||
 	    inode->flags & BTRFS_INODE_NODATASUM)
 		return false;
+	if (btrfs_is_data_reloc_root(inode->root))
+		return false;
 	return true;
 }
 


