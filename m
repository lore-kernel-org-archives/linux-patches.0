Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929BC3A3E90;
	Wed, 20 May 2026 16:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294394; cv=none; b=QYVBcQuMPF/FdTPTKQyG9RMGGY7xA5YpNqQycQi4pBin88CCnwHc9HHipPf6jkuX3M55XaygyKChttOD9zbqTEUCP2WDPFJCbqv+18MOozBO1ueUZIqNF+Sf9gCGIrg0yUwNy+dKM6iRKcUynbh/ugdoFIkQhmRbezhphFzSkrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294394; c=relaxed/simple;
	bh=YO5043Qhbh1NOFUUoUKJIGMs75Zu/K/LecvfU+HSrfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIu9++10+9pUpun6TIsx2jWVukfgNWOGFL1JaOjLtcQpAPjIEr3WEzxZ9WlzeQPm/i9vMcDvkxarMUbEntJ9S6/RcE6NzMbHfrfUrLZSAFyhDI7JsEDRDb4wolNj+nQtdyU1wZAaw82FozQEWqQuWDbuGV85TPvtRjkQwljf/qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uP6BpeZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uP6BpeZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B904B1F000E9;
	Wed, 20 May 2026 16:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294392;
	bh=I4FgGhrlCHMP/SmMxdkr5FAdy2dkNUBBYshZaDH2Z+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uP6BpeZyiFupMP4zKwBz+ZfHdKnT6/m1JRFAR1gj/R7d+j6YbzoB8zawUHwR0k5Ji
	 oucU4pr0HdYJt7t64RI3rzz0kt/4tjGsSEmvQRe0Lijvj0bx3zclI5bzB+7dxncJHt
	 vYo0mYV0wVVqRNDHRIY6XTDKEIjYjT4WpmiKuAGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0022/1146] btrfs: fix the inline compressed extent check in inode_need_compress()
Date: Wed, 20 May 2026 18:04:32 +0200
Message-ID: <20260520162148.888054547@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 883adb6dcff0f96dbbdb6488842a38b121ebd68c ]

[BUG]
Since commit 59615e2c1f63 ("btrfs: reject single block sized compression
early"), the following script will result the inode to have NOCOMPRESS
flag, meanwhile old kernels don't:

  # mkfs.btrfs -f $dev
  # mount $dev $mnt -o max_inline=2k,compress=zstd
  # truncate -s 8k $mnt/foobar
  # xfs_io -f -c "pwrite 0 2k" $mnt/foobar
  # sync

Before that commit, the inode will not have NOCOMPRESS flag:

	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 9 size 8192 nbytes 4096
		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
		sequence 3 flags 0x0(none)

But after that commit, the inode will have NOCOMPRESS flag:

	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 10 size 8192 nbytes 4096
		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
		sequence 3 flags 0x8(NOCOMPRESS)

This will make a lot of files no longer to be compressed.

[CAUSE]
The old compressed inline check looks like this:

	if (total_compressed <= blocksize &&
	   (start > 0 || end + 1 < inode->disk_i_size))
		goto cleanup_and_bail_uncompressed;

That inline part check is equal to "!(start == 0 && end + 1 >=
inode->disk_i_size)", but the new check no longer has that disk_i_size
check.

Thus it means any single block sized write at file offset 0 will pass
the inline check, which is wrong.

Furthermore, since we have merged the old check into
inode_need_compress(), there is no disk_i_size based inline check
anymore, we will always try compressing that single block at file offset
0, then later find out it's not a net win and go to the
mark_incompressible tag.

This results the inode to have NOCOMPRESS flag.

[FIX]
Add back the missing disk_i_size based check into inode_need_compress().

Now the same script will no longer cause NOCOMPRESS flag.

Fixes: 59615e2c1f63 ("btrfs: reject single block sized compression early")
Reported-by: Chris Mason <clm@meta.com>
Link: https://lore.kernel.org/linux-btrfs/20260208183840.975975-1-clm@meta.com/
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2ad2d503e79af..c5b291ddb4776 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -811,7 +811,8 @@ static inline int inode_need_compress(struct btrfs_inode *inode, u64 start,
 	 * do not even bother try compression, as there will be no space saving
 	 * and will always fallback to regular write later.
 	 */
-	if (start != 0 && end + 1 - start <= fs_info->sectorsize)
+	if (end + 1 - start <= fs_info->sectorsize &&
+	    (start > 0 || end + 1 < inode->disk_i_size))
 		return 0;
 	/* Defrag ioctl takes precedence over mount options and properties. */
 	if (inode->defrag_compress == BTRFS_DEFRAG_DONT_COMPRESS)
-- 
2.53.0



