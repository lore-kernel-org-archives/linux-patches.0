Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0A6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC80C433CB;
	Sun, 17 Sep 2023 20:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981595;
	bh=uY9olRqdYZC1rilv4s3dErHWExJV61lWAPOkx4yyNsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJOlRsB5mVeb4jI73M/ToTmuI7SXS150/M87HNVukUtLFK+AvaN8XxLjHeA8Iysc4
	 dACI+vbs76nPOfBCU3gdss+QGj/fGKWXVCAuhc3P5ul4QcKWUWZiVm/bVR6wzdA/rM
	 i/9Rzma1glCJ4NST6Q0laNZU3O8TkUg/lPwjkxBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 054/511] udf: Handle error when adding extent to a file
Date: Sun, 17 Sep 2023 21:08:01 +0200
Message-ID: <20230917191115.187555850@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 19fd80de0a8b5170ef34704c8984cca920dffa59 upstream.

When adding extent to a file fails, so far we've silently squelshed the
error. Make sure to propagate it up properly.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -57,15 +57,15 @@ static int udf_update_inode(struct inode
 static int udf_sync_inode(struct inode *inode);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static sector_t inode_getblk(struct inode *, sector_t, int *, int *);
-static int8_t udf_insert_aext(struct inode *, struct extent_position,
-			      struct kernel_lb_addr, uint32_t);
+static int udf_insert_aext(struct inode *, struct extent_position,
+			   struct kernel_lb_addr, uint32_t);
 static void udf_split_extents(struct inode *, int *, int, udf_pblk_t,
 			      struct kernel_long_ad *, int *);
 static void udf_prealloc_extents(struct inode *, int, int,
 				 struct kernel_long_ad *, int *);
 static void udf_merge_extents(struct inode *, struct kernel_long_ad *, int *);
-static void udf_update_extents(struct inode *, struct kernel_long_ad *, int,
-			       int, struct extent_position *);
+static int udf_update_extents(struct inode *, struct kernel_long_ad *, int,
+			      int, struct extent_position *);
 static int udf_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
 static void __udf_clear_extent_cache(struct inode *inode)
@@ -887,7 +887,9 @@ static sector_t inode_getblk(struct inod
 	/* write back the new extents, inserting new extents if the new number
 	 * of extents is greater than the old number, and deleting extents if
 	 * the new number of extents is less than the old number */
-	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
+	*err = udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
+	if (*err < 0)
+		goto out_free;
 
 	newblock = udf_get_pblock(inode->i_sb, newblocknum,
 				iinfo->i_location.partitionReferenceNum, 0);
@@ -1155,21 +1157,30 @@ static void udf_merge_extents(struct ino
 	}
 }
 
-static void udf_update_extents(struct inode *inode, struct kernel_long_ad *laarr,
-			       int startnum, int endnum,
-			       struct extent_position *epos)
+static int udf_update_extents(struct inode *inode, struct kernel_long_ad *laarr,
+			      int startnum, int endnum,
+			      struct extent_position *epos)
 {
 	int start = 0, i;
 	struct kernel_lb_addr tmploc;
 	uint32_t tmplen;
+	int err;
 
 	if (startnum > endnum) {
 		for (i = 0; i < (startnum - endnum); i++)
 			udf_delete_aext(inode, *epos);
 	} else if (startnum < endnum) {
 		for (i = 0; i < (endnum - startnum); i++) {
-			udf_insert_aext(inode, *epos, laarr[i].extLocation,
-					laarr[i].extLength);
+			err = udf_insert_aext(inode, *epos,
+					      laarr[i].extLocation,
+					      laarr[i].extLength);
+			/*
+			 * If we fail here, we are likely corrupting the extent
+			 * list and leaking blocks. At least stop early to
+			 * limit the damage.
+			 */
+			if (err < 0)
+				return err;
 			udf_next_aext(inode, epos, &laarr[i].extLocation,
 				      &laarr[i].extLength, 1);
 			start++;
@@ -1181,6 +1192,7 @@ static void udf_update_extents(struct in
 		udf_write_aext(inode, epos, &laarr[i].extLocation,
 			       laarr[i].extLength, 1);
 	}
+	return 0;
 }
 
 struct buffer_head *udf_bread(struct inode *inode, udf_pblk_t block,
@@ -2215,12 +2227,13 @@ int8_t udf_current_aext(struct inode *in
 	return etype;
 }
 
-static int8_t udf_insert_aext(struct inode *inode, struct extent_position epos,
-			      struct kernel_lb_addr neloc, uint32_t nelen)
+static int udf_insert_aext(struct inode *inode, struct extent_position epos,
+			   struct kernel_lb_addr neloc, uint32_t nelen)
 {
 	struct kernel_lb_addr oeloc;
 	uint32_t oelen;
 	int8_t etype;
+	int err;
 
 	if (epos.bh)
 		get_bh(epos.bh);
@@ -2230,10 +2243,10 @@ static int8_t udf_insert_aext(struct ino
 		neloc = oeloc;
 		nelen = (etype << 30) | oelen;
 	}
-	udf_add_aext(inode, &epos, &neloc, nelen, 1);
+	err = udf_add_aext(inode, &epos, &neloc, nelen, 1);
 	brelse(epos.bh);
 
-	return (nelen >> 30);
+	return err;
 }
 
 int8_t udf_delete_aext(struct inode *inode, struct extent_position epos)


