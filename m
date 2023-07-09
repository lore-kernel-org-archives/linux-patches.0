Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35846522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ED3C433C8;
	Sun,  9 Jul 2023 11:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901563;
	bh=yyH2au+Rqak31HUVZhw6F4nlzzchIFf7ftg7lXYNzHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORfpy1kF940tlQt1UkF1qm8nuG5iiakh+jKPwVF1J3ZwtDlF06KdkX3rq/nazZWuB
	 2H8ErH1Qhp3yFWbzFjmD5gRBZuQWBnovGlIedj3aypsX+2zxuXofJ8x2TRnY5Kd5kT
	 i2mGNSzJIh82SO+XpE3wL4Xsu6TlUkqGUIOSEPME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 036/431] btrfs: make btrfs_split_bio work on struct btrfs_bio
Date: Sun,  9 Jul 2023 13:09:44 +0200
Message-ID: <20230709111451.944139638@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit 2cef0c79bb81d8bae1dbc45195771a824ca45e76 ]

btrfs_split_bio expects a btrfs_bio as argument and always allocates one.
Type both the orig_bio argument and the return value as struct btrfs_bio
to improve type safety.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: c731cd0b6d25 ("btrfs: fix file_offset for REQ_BTRFS_ONE_ORDERED bios that get split")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/bio.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index ada899613486a..67e5156f940d3 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -59,30 +59,31 @@ struct bio *btrfs_bio_alloc(unsigned int nr_vecs, blk_opf_t opf,
 	return bio;
 }
 
-static struct bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
-				   struct bio *orig, u64 map_length,
-				   bool use_append)
+static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
+					 struct btrfs_bio *orig_bbio,
+					 u64 map_length, bool use_append)
 {
-	struct btrfs_bio *orig_bbio = btrfs_bio(orig);
+	struct btrfs_bio *bbio;
 	struct bio *bio;
 
 	if (use_append) {
 		unsigned int nr_segs;
 
-		bio = bio_split_rw(orig, &fs_info->limits, &nr_segs,
+		bio = bio_split_rw(&orig_bbio->bio, &fs_info->limits, &nr_segs,
 				   &btrfs_clone_bioset, map_length);
 	} else {
-		bio = bio_split(orig, map_length >> SECTOR_SHIFT, GFP_NOFS,
-				&btrfs_clone_bioset);
+		bio = bio_split(&orig_bbio->bio, map_length >> SECTOR_SHIFT,
+				GFP_NOFS, &btrfs_clone_bioset);
 	}
-	btrfs_bio_init(btrfs_bio(bio), orig_bbio->inode, NULL, orig_bbio);
+	bbio = btrfs_bio(bio);
+	btrfs_bio_init(bbio, orig_bbio->inode, NULL, orig_bbio);
 
-	btrfs_bio(bio)->file_offset = orig_bbio->file_offset;
-	if (!(orig->bi_opf & REQ_BTRFS_ONE_ORDERED))
+	bbio->file_offset = orig_bbio->file_offset;
+	if (!(orig_bbio->bio.bi_opf & REQ_BTRFS_ONE_ORDERED))
 		orig_bbio->file_offset += map_length;
 
 	atomic_inc(&orig_bbio->pending_ios);
-	return bio;
+	return bbio;
 }
 
 static void btrfs_orig_write_end_io(struct bio *bio);
@@ -631,8 +632,8 @@ static bool btrfs_submit_chunk(struct bio *bio, int mirror_num)
 		map_length = min(map_length, fs_info->max_zone_append_size);
 
 	if (map_length < length) {
-		bio = btrfs_split_bio(fs_info, bio, map_length, use_append);
-		bbio = btrfs_bio(bio);
+		bbio = btrfs_split_bio(fs_info, bbio, map_length, use_append);
+		bio = &bbio->bio;
 	}
 
 	/*
-- 
2.39.2



