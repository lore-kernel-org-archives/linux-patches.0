Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD3F6FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3796C433EF;
	Mon, 19 Dec 2022 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671478071;
	bh=hky+L9OqszPzzfyyNFRtDqP5ZOd/0ysZcJ2HNj/l+b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg4+TG1CyD5KZ0oeK4dQNT2E95VXwAaDJjDCPykUIUmOp1aKh+4IefNsaxLhm0mWR
	 5d5+G+NT0rk6/bQgzJOEWtZyNGZhqEMQj72wvM3ZfFvrQWhYpE6KFJ+iIt2sklR82a
	 3sAZzJrRqUXU0vV5+qpkvmz/Ax5OqTeqzsbzMhX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 02/18] udf: Fix preallocation discarding at indirect extent boundary
Date: Mon, 19 Dec 2022 20:24:55 +0100
Message-Id: <20221219182940.777307576@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
References: <20221219182940.701087296@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit cfe4c1b25dd6d2f056afc00b7c98bcb3dd0b1fc3 upstream.

When preallocation extent is the first one in the extent block, the
code would corrupt extent tree header instead. Fix the problem and use
udf_delete_aext() for deleting extent to avoid some code duplication.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/truncate.c |   45 +++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -120,60 +120,41 @@ void udf_truncate_tail_extent(struct ino
 
 void udf_discard_prealloc(struct inode *inode)
 {
-	struct extent_position epos = { NULL, 0, {0, 0} };
+	struct extent_position epos = {};
+	struct extent_position prev_epos = {};
 	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
-	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ||
 	    inode->i_size == iinfo->i_lenExtents)
 		return;
 
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(struct short_ad);
-	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(struct long_ad);
-	else
-		adsize = 0;
-
 	epos.block = iinfo->i_location;
 
 	/* Find the last extent in the file */
-	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
-		etype = netype;
+	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
+		brelse(prev_epos.bh);
+		prev_epos = epos;
+		if (prev_epos.bh)
+			get_bh(prev_epos.bh);
+
+		etype = udf_next_aext(inode, &epos, &eloc, &elen, 1);
 		lbcount += elen;
 	}
 	if (etype == (EXT_NOT_RECORDED_ALLOCATED >> 30)) {
-		epos.offset -= adsize;
 		lbcount -= elen;
-		extent_trunc(inode, &epos, &eloc, etype, elen, 0);
-		if (!epos.bh) {
-			iinfo->i_lenAlloc =
-				epos.offset -
-				udf_file_entry_alloc_offset(inode);
-			mark_inode_dirty(inode);
-		} else {
-			struct allocExtDesc *aed =
-				(struct allocExtDesc *)(epos.bh->b_data);
-			aed->lengthAllocDescs =
-				cpu_to_le32(epos.offset -
-					    sizeof(struct allocExtDesc));
-			if (!UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT) ||
-			    UDF_SB(inode->i_sb)->s_udfrev >= 0x0201)
-				udf_update_tag(epos.bh->b_data, epos.offset);
-			else
-				udf_update_tag(epos.bh->b_data,
-					       sizeof(struct allocExtDesc));
-			mark_buffer_dirty_inode(epos.bh, inode);
-		}
+		udf_delete_aext(inode, prev_epos);
+		udf_free_blocks(inode->i_sb, inode, &eloc, 0,
+				DIV_ROUND_UP(elen, 1 << inode->i_blkbits));
 	}
 	/* This inode entry is in-memory only and thus we don't have to mark
 	 * the inode dirty */
 	iinfo->i_lenExtents = lbcount;
 	brelse(epos.bh);
+	brelse(prev_epos.bh);
 }
 
 static void udf_update_alloc_ext_desc(struct inode *inode,


