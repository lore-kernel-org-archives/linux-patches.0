Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757891A01BF;
	Fri, 22 Aug 2025 12:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755866259; cv=none; b=SJYbKZIi+xNSxy3ZzdGUTSoSx73M03I3qLHuyknkgR1E0blL70t2J/TC6OWgk4pLsz22j7LOvnAwwal3Z+7/Fv4tg6e4mxD9oke77Cn8/VERZsa8JnaiAS/ETCOUI72aX7JvTn0nXp61QFGONZqcnk/bjZRSgNS64L7DTyFAzag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755866259; c=relaxed/simple;
	bh=P6Qh4CG6ZHFW9KxkGIgHK8CcdsBmJxPsnRmYRsJzEO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUHOvX/HDNtvzAYAJipRdRaRMn40HqeNlAl50ABycj+VXzcqnwyPU9U+OG7N8CKojF/JqmkF0MJPbn261OO9UyX0Nr6pH7XvwLC2AoivjQzIeQ3jpvaugd0BzpgLtijEzV5sRSB/hXzIZII+h7joczQHa25lJ9orz6GykiE0B+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oss9BeIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oss9BeIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812A2C4CEED;
	Fri, 22 Aug 2025 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755866257;
	bh=P6Qh4CG6ZHFW9KxkGIgHK8CcdsBmJxPsnRmYRsJzEO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oss9BeIoxyF8iIer8sTvwM+g7/BKX0LJYWjza5YXKsJ2IL7+XlTtbqExSojvrsNc4
	 vs8c/e7L3YhlAUasU3Vna+64NkECD0dfS03C5bGnI1CnMDtoCEh90GgaYAu/omEyBU
	 lqXaOksNFjpic5uOA6h3SB8suo/KkAnoHUuSXxdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.16 7/9] ext4: correct the reserved credits for extent conversion
Date: Fri, 22 Aug 2025 14:37:07 +0200
Message-ID: <20250822123517.056513501@linuxfoundation.org>
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

commit 95ad8ee45cdbc321c135a2db895d48b374ef0f87 upstream.

Now, we reserve journal credits for converting extents in only one page
to written state when the I/O operation is complete. This is
insufficient when large folio is enabled.

Fix this by reserving credits for converting up to one extent per block in
the largest 2MB folio, this calculation should only involve extents index
and leaf blocks, so it should not estimate too many credits.

Fixes: 7ac67301e82f ("ext4: enable large folio for regular file")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250707140814.542883-8-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2850,12 +2850,12 @@ static int ext4_do_writepages(struct mpa
 	mpd->journalled_more_data = 0;
 
 	if (ext4_should_dioread_nolock(inode)) {
+		int bpf = ext4_journal_blocks_per_folio(inode);
 		/*
 		 * We may need to convert up to one extent per block in
-		 * the page and we may dirty the inode.
+		 * the folio and we may dirty the inode.
 		 */
-		rsv_blocks = 1 + ext4_chunk_trans_blocks(inode,
-						PAGE_SIZE >> inode->i_blkbits);
+		rsv_blocks = 1 + ext4_ext_index_trans_blocks(inode, bpf);
 	}
 
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)


