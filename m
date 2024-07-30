Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C1518801A;
	Tue, 30 Jul 2024 16:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358658; cv=none; b=gvIrBZRsUrTDyRNVW+5FNFBpTKUbtk2BYy/CVgdBsOk6GkBMsuRaFGBshznPlAn79HdxCWLjz5iVQVZAGVHPLDUTyTjgdHcasRJhjYsB2eo6zD6YI0sbsfInIOipeJISeofBlG2vUtb0MgsoT4fUb+Muu0NO/WzSgAomS7Fx+QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358658; c=relaxed/simple;
	bh=zWOL9LQCiSqHSgm1W+TMkmheMq4YSNRW07p5InAMG3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdCF7QW3kclTsKtQKVHr/1UWZ+YgCl6xmoczFdbJ3IkSvtWlTlcfOo4bV+xUeakZyH3rNcxd/wE56sXbq++BFz+7yqafBoIG339SUM1uq6fu7Fo93gkDyUMcQS8Mu0s9br6O5xCOfVQG4V6m3izC/cvQfiHYBAMoWYAoMlUTm74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qo6rcs+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qo6rcs+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40864C32782;
	Tue, 30 Jul 2024 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358657;
	bh=zWOL9LQCiSqHSgm1W+TMkmheMq4YSNRW07p5InAMG3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qo6rcs+Dk57ZrFbRy/czuKj/ExITSkiDqX7jqjmy3tx17MKQK/1tcbmR5BxJU2GTi
	 Vm9cf6hIbCD3En143Tkfd6xtA3AMDDehkTYIZojOeSgb1jVWz41LQXv3HLL6h7IkO/
	 4fDIZTGTza4tn/0tnThLTRrg8ljXlhmQvW3Nnbmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.6 383/568] ext2: Verify bitmap and itable block numbers before using them
Date: Tue, 30 Jul 2024 17:48:10 +0200
Message-ID: <20240730151654.837178041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 322a6aff03937aa1ece33b4e46c298eafaf9ac41 upstream.

Verify bitmap block numbers and inode table blocks are sane before using
them for checking bits in the block bitmap.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/balloc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -77,26 +77,33 @@ static int ext2_valid_block_bitmap(struc
 	ext2_grpblk_t next_zero_bit;
 	ext2_fsblk_t bitmap_blk;
 	ext2_fsblk_t group_first_block;
+	ext2_grpblk_t max_bit;
 
 	group_first_block = ext2_group_first_block_no(sb, block_group);
+	max_bit = ext2_group_last_block_no(sb, block_group) - group_first_block;
 
 	/* check whether block bitmap block number is set */
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	offset = bitmap_blk - group_first_block;
-	if (!ext2_test_bit(offset, bh->b_data))
+	if (offset < 0 || offset > max_bit ||
+	    !ext2_test_bit(offset, bh->b_data))
 		/* bad block bitmap */
 		goto err_out;
 
 	/* check whether the inode bitmap block number is set */
 	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
 	offset = bitmap_blk - group_first_block;
-	if (!ext2_test_bit(offset, bh->b_data))
+	if (offset < 0 || offset > max_bit ||
+	    !ext2_test_bit(offset, bh->b_data))
 		/* bad block bitmap */
 		goto err_out;
 
 	/* check whether the inode table block number is set */
 	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
 	offset = bitmap_blk - group_first_block;
+	if (offset < 0 || offset > max_bit ||
+	    offset + EXT2_SB(sb)->s_itb_per_group - 1 > max_bit)
+		goto err_out;
 	next_zero_bit = ext2_find_next_zero_bit(bh->b_data,
 				offset + EXT2_SB(sb)->s_itb_per_group,
 				offset);


