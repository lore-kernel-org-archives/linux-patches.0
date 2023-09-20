Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1C42AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75271C433C8;
	Wed, 20 Sep 2023 12:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211271;
	bh=cHDXbe4LHkdMeRZm0sGA91VbxxuhQf5JFXn+ejGZ9GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tdqqcc+49wSKeWP9mbV1CZbmCHsmidCqx85qtDDV6SxvZ5Fp73sWZpTqVVOeS3cOS
	 ixTwEnyXgJ65+FO9sxc9zHeGq29xScRpN+o9jbshVRbJPt8B2lbZ2NQPb+xB8xpDjB
	 B7qaCowZKek7nNZ5HMXjZNczr/J8woRhvbLaB52g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladislav Efanov <VEfanov@ispras.ru>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4.14 032/186] udf: Check consistency of Space Bitmap Descriptor
Date: Wed, 20 Sep 2023 13:28:55 +0200
Message-ID: <20230920112838.097341316@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladislav Efanov <VEfanov@ispras.ru>

commit 1e0d4adf17e7ef03281d7b16555e7c1508c8ed2d upstream.

Bits, which are related to Bitmap Descriptor logical blocks,
are not reset when buffer headers are allocated for them. As the
result, these logical blocks can be treated as free and
be used for other blocks.This can cause usage of one buffer header
for several types of data. UDF issues WARNING in this situation:

WARNING: CPU: 0 PID: 2703 at fs/udf/inode.c:2014
  __udf_add_aext+0x685/0x7d0 fs/udf/inode.c:2014

RIP: 0010:__udf_add_aext+0x685/0x7d0 fs/udf/inode.c:2014
Call Trace:
 udf_setup_indirect_aext+0x573/0x880 fs/udf/inode.c:1980
 udf_add_aext+0x208/0x2e0 fs/udf/inode.c:2067
 udf_insert_aext fs/udf/inode.c:2233 [inline]
 udf_update_extents fs/udf/inode.c:1181 [inline]
 inode_getblk+0x1981/0x3b70 fs/udf/inode.c:885

Found by Linux Verification Center (linuxtesting.org) with syzkaller.

[JK: Somewhat cleaned up the boundary checks]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Vladislav Efanov <VEfanov@ispras.ru>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/balloc.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -36,18 +36,41 @@ static int read_block_bitmap(struct supe
 			     unsigned long bitmap_nr)
 {
 	struct buffer_head *bh = NULL;
-	int retval = 0;
+	int i;
+	int max_bits, off, count;
 	struct kernel_lb_addr loc;
 
 	loc.logicalBlockNum = bitmap->s_extPosition;
 	loc.partitionReferenceNum = UDF_SB(sb)->s_partition;
 
 	bh = udf_tread(sb, udf_get_lb_pblock(sb, &loc, block));
+	bitmap->s_block_bitmap[bitmap_nr] = bh;
 	if (!bh)
-		retval = -EIO;
+		return -EIO;
 
-	bitmap->s_block_bitmap[bitmap_nr] = bh;
-	return retval;
+	/* Check consistency of Space Bitmap buffer. */
+	max_bits = sb->s_blocksize * 8;
+	if (!bitmap_nr) {
+		off = sizeof(struct spaceBitmapDesc) << 3;
+		count = min(max_bits - off, bitmap->s_nr_groups);
+	} else {
+		/*
+		 * Rough check if bitmap number is too big to have any bitmap
+		 * blocks reserved.
+		 */
+		if (bitmap_nr >
+		    (bitmap->s_nr_groups >> (sb->s_blocksize_bits + 3)) + 2)
+			return 0;
+		off = 0;
+		count = bitmap->s_nr_groups - bitmap_nr * max_bits +
+				(sizeof(struct spaceBitmapDesc) << 3);
+		count = min(count, max_bits);
+	}
+
+	for (i = 0; i < count; i++)
+		if (udf_test_bit(i + off, bh->b_data))
+			return -EFSCORRUPTED;
+	return 0;
 }
 
 static int __load_block_bitmap(struct super_block *sb,


