Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9022E84A;
	Fri, 24 Nov 2023 19:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkS8+o/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7675C433C7;
	Fri, 24 Nov 2023 19:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852930;
	bh=HF5D9bmBvZuHwKQtvm+U9EbzTRP+TgLnVJ7dud2XM5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkS8+o/TFbJJTBGWoivP3lwEneIQqaWTjCPm5VPn9hR4nOv+JPIADlnoR9OhMHb4O
	 WLDMaRNNfWV1gdj2wYvnb8zBw38WmBmsW9zK3gILbQPOHrvhL0mKg4/xstWoEebnv7
	 p2+GJsN5Vtp6zmRp477hn3naqQJtuOfXDPI7XFTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 180/193] ext4: correct offset of gdb backup in non meta_bg group to update_backups
Date: Fri, 24 Nov 2023 17:55:07 +0000
Message-ID: <20231124171954.355473507@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 31f13421c004a420c0e9d288859c9ea9259ea0cc upstream.

Commit 0aeaa2559d6d5 ("ext4: fix corruption when online resizing a 1K
bigalloc fs") found that primary superblock's offset in its group is
not equal to offset of backup superblock in its group when block size
is 1K and bigalloc is enabled. As group descriptor blocks are right
after superblock, we can't pass block number of gdb to update_backups
for the same reason.

The root casue of the issue above is that leading 1K padding block is
count as data block offset for primary block while backup block has no
padding block offset in its group.

Remove padding data block count to fix the issue for gdb backups.

For meta_bg case, update_backups treat blk_off as block number, do no
conversion in this case.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20230826174712.4059355-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1543,6 +1543,8 @@ exit_journal:
 		int gdb_num_end = ((group + flex_gd->count - 1) /
 				   EXT4_DESC_PER_BLOCK(sb));
 		int meta_bg = ext4_has_feature_meta_bg(sb);
+		sector_t padding_blocks = meta_bg ? 0 : sbi->s_sbh->b_blocknr -
+					 ext4_group_first_block_no(sb, 0);
 		sector_t old_gdb = 0;
 
 		update_backups(sb, ext4_group_first_block_no(sb, 0),
@@ -1554,8 +1556,8 @@ exit_journal:
 						     gdb_num);
 			if (old_gdb == gdb_bh->b_blocknr)
 				continue;
-			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
-				       gdb_bh->b_size, meta_bg);
+			update_backups(sb, gdb_bh->b_blocknr - padding_blocks,
+				       gdb_bh->b_data, gdb_bh->b_size, meta_bg);
 			old_gdb = gdb_bh->b_blocknr;
 		}
 	}


