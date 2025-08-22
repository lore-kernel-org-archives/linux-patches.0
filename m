Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AA51A01BF;
	Fri, 22 Aug 2025 12:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755866262; cv=none; b=OJXxyHomLqGIzKUFxZb/4hQBUEfenv9L4S05pVVsahvo/2nEKZiEGmGh64fSDrkCB9kLreHXhP0ESzVPOMI7SSvrX6W7QD0/JcsxCE3Uiu93/cu99uSiYRpn/K2nnYkCeGXX4qJxgyf7YTDMeNpWaHEzzq0Eg923kpv+ae/Fy5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755866262; c=relaxed/simple;
	bh=nCsQVj/doiqtRsr20dwsi6rEaVYLuC4YiZCgTBdFNjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0Mxtiy7I+jTv2+JH1VJh+5Q7eB0JGA2a8ABCNjGn58sKNHney2nu1TVARFuklNQMtP+aYClFkm8HF3cttkE+FkBx7tce1rwu9sSVfoF1aihtgMUctOfPEgRc5M63WOmxbiXDDFIRIbb4GjIIhI18q1PfGfe/JkVb8kzd03jREY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4mv3wvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4mv3wvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4505CC113CF;
	Fri, 22 Aug 2025 12:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755866261;
	bh=nCsQVj/doiqtRsr20dwsi6rEaVYLuC4YiZCgTBdFNjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4mv3wvFgrKpKxRdPQezQbToNrlttHBsGVBBrQe6qpmShVGDmcdci8z4barf+l3bb
	 01H1AR5jdVy8NehDCbovl3ObDKR3Z5x2LQdd2KXO/06xId6oPUk1Vm/Zr3cGCqb9TC
	 InG6GXunQFskRggm18QCX7V03pqbCZfXVOOOSwH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.16 8/9] ext4: reserved credits for one extent during the folio writeback
Date: Fri, 22 Aug 2025 14:37:08 +0200
Message-ID: <20250822123517.094089854@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250822123516.780248736@linuxfoundation.org>
References: <20250822123516.780248736@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit bbbf150f3f85619569ac19dc6458cca7c492e715 upstream.

After ext4 supports large folios, reserving journal credits for one
maximum-ordered folio based on the worst case cenario during the
writeback process can easily exceed the maximum transaction credits.
Additionally, reserving journal credits for one page is also no
longer appropriate.

Currently, the folio writeback process can either extend the journal
credits or initiate a new transaction if the currently reserved journal
credits are insufficient. Therefore, it can be modified to reserve
credits for only one extent at the outset. In most cases involving
continuous mapping, these credits are generally adequate, and we may
only need to perform some basic credit expansion. However, in extreme
cases where the block size and folio size differ significantly, or when
the folios are sufficiently discontinuous, it may be necessary to
restart a new transaction and resubmit the folios.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250707140814.542883-9-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2548,21 +2548,6 @@ update_disksize:
 	return err;
 }
 
-/*
- * Calculate the total number of credits to reserve for one writepages
- * iteration. This is called from ext4_writepages(). We map an extent of
- * up to MAX_WRITEPAGES_EXTENT_LEN blocks and then we go on and finish mapping
- * the last partial page. So in total we can map MAX_WRITEPAGES_EXTENT_LEN +
- * bpp - 1 blocks in bpp different extents.
- */
-static int ext4_da_writepages_trans_blocks(struct inode *inode)
-{
-	int bpp = ext4_journal_blocks_per_folio(inode);
-
-	return ext4_meta_trans_blocks(inode,
-				MAX_WRITEPAGES_EXTENT_LEN + bpp - 1, bpp);
-}
-
 static int ext4_journal_folio_buffers(handle_t *handle, struct folio *folio,
 				     size_t len)
 {
@@ -2919,8 +2904,14 @@ retry:
 		 * not supported by delalloc.
 		 */
 		BUG_ON(ext4_should_journal_data(inode));
-		needed_blocks = ext4_da_writepages_trans_blocks(inode);
-
+		/*
+		 * Calculate the number of credits needed to reserve for one
+		 * extent of up to MAX_WRITEPAGES_EXTENT_LEN blocks. It will
+		 * attempt to extend the transaction or start a new iteration
+		 * if the reserved credits are insufficient.
+		 */
+		needed_blocks = ext4_chunk_trans_blocks(inode,
+						MAX_WRITEPAGES_EXTENT_LEN);
 		/* start a new transaction */
 		handle = ext4_journal_start_with_reserve(inode,
 				EXT4_HT_WRITE_PAGE, needed_blocks, rsv_blocks);


