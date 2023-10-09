Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3565B1A5A3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJb+vjxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4237C433CB;
	Mon,  9 Oct 2023 13:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859293;
	bh=yadoFXXp0qSxTKLmwr7uBYB4hyh+gFl9mhYsHjj/lIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJb+vjxY6WT9iQCJdYqY8u6cvKOQjx0AgRHqUYLaXrNOdmza1tX08fX9mY9WtfHkT
	 JKiek5INZa5ASGniRk5m6+ypuZSXNXiD9nR3KAMxVORG4blTLRxDI5y/9xWA/9h4tw
	 BL3goIlrbN2zlWR59S7pYwGvv9wWm4TEYkRjPcGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Andreas Dilger <adilger@dilger.ca>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Shida Zhang <zhangshida@kylinos.cn>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 32/55] ext4: fix rec_len verify error
Date: Mon,  9 Oct 2023 15:06:31 +0200
Message-ID: <20231009130108.933669173@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
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

From: Shida Zhang <zhangshida@kylinos.cn>

commit 7fda67e8c3ab6069f75888f67958a6d30454a9f6 upstream.

With the configuration PAGE_SIZE 64k and filesystem blocksize 64k,
a problem occurred when more than 13 million files were directly created
under a directory:

EXT4-fs error (device xx): ext4_dx_csum_set:492: inode #xxxx: comm xxxxx: dir seems corrupt?  Run e2fsck -D.
EXT4-fs error (device xx): ext4_dx_csum_verify:463: inode #xxxx: comm xxxxx: dir seems corrupt?  Run e2fsck -D.
EXT4-fs error (device xx): dx_probe:856: inode #xxxx: block 8188: comm xxxxx: Directory index failed checksum

When enough files are created, the fake_dirent->reclen will be 0xffff.
it doesn't equal to the blocksize 65536, i.e. 0x10000.

But it is not the same condition when blocksize equals to 4k.
when enough files are created, the fake_dirent->reclen will be 0x1000.
it equals to the blocksize 4k, i.e. 0x1000.

The problem seems to be related to the limitation of the 16-bit field
when the blocksize is set to 64k.
To address this, helpers like ext4_rec_len_{from,to}_disk has already
been introduced to complete the conversion between the encoded and the
plain form of rec_len.

So fix this one by using the helper, and all the other in this file too.

Cc: stable@kernel.org
Fixes: dbe89444042a ("ext4: Calculate and verify checksums for htree nodes")
Suggested-by: Andreas Dilger <adilger@dilger.ca>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20230803060938.1929759-1-zhangshida@kylinos.cn
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -321,17 +321,17 @@ static struct ext4_dir_entry_tail *get_d
 						   struct ext4_dir_entry *de)
 {
 	struct ext4_dir_entry_tail *t;
+	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 
 #ifdef PARANOID
 	struct ext4_dir_entry *d, *top;
 
 	d = de;
 	top = (struct ext4_dir_entry *)(((void *)de) +
-		(EXT4_BLOCK_SIZE(inode->i_sb) -
-		sizeof(struct ext4_dir_entry_tail)));
-	while (d < top && d->rec_len)
+		(blocksize - sizeof(struct ext4_dir_entry_tail)));
+	while (d < top && ext4_rec_len_from_disk(d->rec_len, blocksize))
 		d = (struct ext4_dir_entry *)(((void *)d) +
-		    le16_to_cpu(d->rec_len));
+		    ext4_rec_len_from_disk(d->rec_len, blocksize));
 
 	if (d != top)
 		return NULL;
@@ -342,7 +342,8 @@ static struct ext4_dir_entry_tail *get_d
 #endif
 
 	if (t->det_reserved_zero1 ||
-	    le16_to_cpu(t->det_rec_len) != sizeof(struct ext4_dir_entry_tail) ||
+	    (ext4_rec_len_from_disk(t->det_rec_len, blocksize) !=
+	     sizeof(struct ext4_dir_entry_tail)) ||
 	    t->det_reserved_zero2 ||
 	    t->det_reserved_ft != EXT4_FT_DIR_CSUM)
 		return NULL;
@@ -424,13 +425,14 @@ static struct dx_countlimit *get_dx_coun
 	struct ext4_dir_entry *dp;
 	struct dx_root_info *root;
 	int count_offset;
+	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
+	unsigned int rlen = ext4_rec_len_from_disk(dirent->rec_len, blocksize);
 
-	if (le16_to_cpu(dirent->rec_len) == EXT4_BLOCK_SIZE(inode->i_sb))
+	if (rlen == blocksize)
 		count_offset = 8;
-	else if (le16_to_cpu(dirent->rec_len) == 12) {
+	else if (rlen == 12) {
 		dp = (struct ext4_dir_entry *)(((void *)dirent) + 12);
-		if (le16_to_cpu(dp->rec_len) !=
-		    EXT4_BLOCK_SIZE(inode->i_sb) - 12)
+		if (ext4_rec_len_from_disk(dp->rec_len, blocksize) != blocksize - 12)
 			return NULL;
 		root = (struct dx_root_info *)(((void *)dp + 12));
 		if (root->reserved_zero ||
@@ -1243,6 +1245,7 @@ static int dx_make_map(struct inode *dir
 	unsigned int buflen = bh->b_size;
 	char *base = bh->b_data;
 	struct dx_hash_info h = *hinfo;
+	int blocksize = EXT4_BLOCK_SIZE(dir->i_sb);
 
 	if (ext4_has_metadata_csum(dir->i_sb))
 		buflen -= sizeof(struct ext4_dir_entry_tail);
@@ -1256,11 +1259,12 @@ static int dx_make_map(struct inode *dir
 			map_tail--;
 			map_tail->hash = h.hash;
 			map_tail->offs = ((char *) de - base)>>2;
-			map_tail->size = le16_to_cpu(de->rec_len);
+			map_tail->size = ext4_rec_len_from_disk(de->rec_len,
+								blocksize);
 			count++;
 			cond_resched();
 		}
-		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
+		de = ext4_next_entry(de, blocksize);
 	}
 	return count;
 }


