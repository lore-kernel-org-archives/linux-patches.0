Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381E85381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41DBC433C0;
	Mon, 19 Jun 2023 10:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170950;
	bh=d35chvhd9elvo2McThikHdsMtAtsxogv1s6xj/qPzjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FI8z27imcSnprJ1T7aBwZu/QjCaL1tYctZ3t/vQ9L2Z8ireamekfoNI1/aDjcS3no
	 86rDsRPaUcoONA2GGMMxiCkuib6fCMOZKOIROfkS9FMHtvKnAUnwJlg9JqLZixI7Hi
	 DmGeNhArl/s90n2maokhOC6hgegQHbeGIGaLOoX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ee90502d5c8fd1d0dd93@syzkaller.appspotmail.com,
	Filipe Manana <fdmanana@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.3 068/187] btrfs: fix iomap_begin length for nocow writes
Date: Mon, 19 Jun 2023 12:28:06 +0200
Message-ID: <20230619102200.954329908@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit 7833b865953c8e62abc76a3261c04132b2fb69de upstream.

can_nocow_extent can reduce the len passed in, which needs to be
propagated to btrfs_dio_iomap_begin so that iomap does not submit
more data then is mapped.

This problems exists since the btrfs_get_blocks_direct helper was added
in commit c5794e51784a ("btrfs: Factor out write portion of
btrfs_get_blocks_direct"), but the ordered_extent splitting added in
commit b73a6fd1b1ef ("btrfs: split partial dio bios before submit")
added a WARN_ON that made a syzkaller test fail.

Reported-by: syzbot+ee90502d5c8fd1d0dd93@syzkaller.appspotmail.com
Fixes: c5794e51784a ("btrfs: Factor out write portion of btrfs_get_blocks_direct")
CC: stable@vger.kernel.org # 6.1+
Tested-by: syzbot+ee90502d5c8fd1d0dd93@syzkaller.appspotmail.com
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7324,7 +7324,7 @@ static struct extent_map *create_io_em(s
 static int btrfs_get_blocks_direct_write(struct extent_map **map,
 					 struct inode *inode,
 					 struct btrfs_dio_data *dio_data,
-					 u64 start, u64 len,
+					 u64 start, u64 *lenp,
 					 unsigned int iomap_flags)
 {
 	const bool nowait = (iomap_flags & IOMAP_NOWAIT);
@@ -7335,6 +7335,7 @@ static int btrfs_get_blocks_direct_write
 	struct btrfs_block_group *bg;
 	bool can_nocow = false;
 	bool space_reserved = false;
+	u64 len = *lenp;
 	u64 prev_len;
 	int ret = 0;
 
@@ -7405,15 +7406,19 @@ static int btrfs_get_blocks_direct_write
 		free_extent_map(em);
 		*map = NULL;
 
-		if (nowait)
-			return -EAGAIN;
+		if (nowait) {
+			ret = -EAGAIN;
+			goto out;
+		}
 
 		/*
 		 * If we could not allocate data space before locking the file
 		 * range and we can't do a NOCOW write, then we have to fail.
 		 */
-		if (!dio_data->data_space_reserved)
-			return -ENOSPC;
+		if (!dio_data->data_space_reserved) {
+			ret = -ENOSPC;
+			goto out;
+		}
 
 		/*
 		 * We have to COW and we have already reserved data space before,
@@ -7454,6 +7459,7 @@ out:
 		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
 		btrfs_delalloc_release_metadata(BTRFS_I(inode), len, true);
 	}
+	*lenp = len;
 	return ret;
 }
 
@@ -7630,7 +7636,7 @@ static int btrfs_dio_iomap_begin(struct
 
 	if (write) {
 		ret = btrfs_get_blocks_direct_write(&em, inode, dio_data,
-						    start, len, flags);
+						    start, &len, flags);
 		if (ret < 0)
 			goto unlock_err;
 		unlock_extents = true;


