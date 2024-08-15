Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E3C1A00F8;
	Thu, 15 Aug 2024 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732289; cv=none; b=ul1mLdFgpYGpvyaWU2jjjgu9JyN92UBGMD+i1Wy1tOJ+mx74qJ37EJ3nNFEU7I39QSsXLj6dwldAfpUWsAYBalWcAbAanSmz7UnuhHszDgQ0nAhrHLOgmnG/AWLBoHaaz79DTcDaXCujltxH/oyK5ZqkdURCb7VOdEHjb0Tz9ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732289; c=relaxed/simple;
	bh=V6Ai6/yIK+CekMjuyEwgcJotEfcWiBoFtodwXQ7Z7bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSyiR/w+fVYI3IGV/2LvAZiSDaeGdNm5iG7Sg0M4JXefVt4B28vZqnM+0bdIR7wDMbiZPzhVuVNgjbktJzzepc1YaEz7ijMVXO3ujjqnqH4cF8bR9zQPpOnW24iuycIoDI7RMzIZuEqo04Q9UhIiMSnc0/vF0pVud5fNBg08Duk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/d8n3Ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/d8n3Ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20694C32786;
	Thu, 15 Aug 2024 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732289;
	bh=V6Ai6/yIK+CekMjuyEwgcJotEfcWiBoFtodwXQ7Z7bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/d8n3LlP7glkK8PhFKlKaNWb6CEwltEckJrQe8mfJJNZflDT+QX7gmxpY4n+nZzn
	 R7jn1Ip89vEgD8L8sYwIPwf1YTSS3cORtG6+DnP+BfR5LmllW2zvjyWsjhY7+nkqXw
	 78dTAsUfhAfa4S2qBGWIXPd5ZSC6qrLeQQclkTOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 133/352] ext2: Verify bitmap and itable block numbers before using them
Date: Thu, 15 Aug 2024 15:23:19 +0200
Message-ID: <20240815131924.396664356@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
@@ -79,26 +79,33 @@ static int ext2_valid_block_bitmap(struc
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


