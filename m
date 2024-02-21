Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69607993D;
	Wed, 21 Feb 2024 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521767; cv=none; b=d9iDf4iBNleat5HrmY09ZdVt8x9LOxzMvO+2nWnf0a1ThYxa7082ItsW5FqukL3oaf4QgRo4rIN1ZMIm6NzvycAauS9f3KDn6tZiphHPbSnUqHXpUTW16lNyWtFynIVaQadYWBE+/S/avps5mXCStbX/qrZTyPUAKwaAxo6ALGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521767; c=relaxed/simple;
	bh=bWTLCzauofrI3tv1U0UbP5bap5MZLDI5l0TXvDvnQyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fayhYa/80yFNHJtXLSjcoW+Dj14X75gvR3JxeX8ONHQ2xLnyhS4PgD/d34Ljhy7Zb40+dAj3PJeVIAsNi0zJZAGt62u/eIEx3hfsbxMU8w6mXuQc1ShVSb2Lf7Wyq8Ty6SZnkiWeXnvHjNaV3+IF0OEt+kmCQKi+JjVgcmWS9bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNesxfac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNesxfac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DEFC433F1;
	Wed, 21 Feb 2024 13:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521767;
	bh=bWTLCzauofrI3tv1U0UbP5bap5MZLDI5l0TXvDvnQyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNesxfac80RNtIRLuhON/HoN5dyWqrJhrTD/GazNIxOmgc040RCBWZ3KqFbEao4s6
	 wgoSWru1bxnOh6aMyzzYuHRA2sGmXTnFLz2z6mHNMKbYg6YOcrcq3OYVXhXISSxvvb
	 /qcFPAgwJNHysUzFTkEkQxvgcoVXQjPIBWyqWVRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+5c04210f7c7f897c1e7f@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 199/202] nilfs2: fix potential bug in end_buffer_async_write
Date: Wed, 21 Feb 2024 14:08:20 +0100
Message-ID: <20240221125938.219668634@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 5bc09b397cbf1221f8a8aacb1152650c9195b02b upstream.

According to a syzbot report, end_buffer_async_write(), which handles the
completion of block device writes, may detect abnormal condition of the
buffer async_write flag and cause a BUG_ON failure when using nilfs2.

Nilfs2 itself does not use end_buffer_async_write().  But, the async_write
flag is now used as a marker by commit 7f42ec394156 ("nilfs2: fix issue
with race condition of competition between segments for dirty blocks") as
a means of resolving double list insertion of dirty blocks in
nilfs_lookup_dirty_data_buffers() and nilfs_lookup_node_buffers() and the
resulting crash.

This modification is safe as long as it is used for file data and b-tree
node blocks where the page caches are independent.  However, it was
irrelevant and redundant to also introduce async_write for segment summary
and super root blocks that share buffers with the backing device.  This
led to the possibility that the BUG_ON check in end_buffer_async_write
would fail as described above, if independent writebacks of the backing
device occurred in parallel.

The use of async_write for segment summary buffers has already been
removed in a previous change.

Fix this issue by removing the manipulation of the async_write flag for
the remaining super root block buffer.

Link: https://lkml.kernel.org/r/20240203161645.4992-1-konishi.ryusuke@gmail.com
Fixes: 7f42ec394156 ("nilfs2: fix issue with race condition of competition between segments for dirty blocks")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+5c04210f7c7f897c1e7f@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/00000000000019a97c05fd42f8c8@google.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1702,7 +1702,6 @@ static void nilfs_segctor_prepare_write(
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			set_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					lock_page(bd_page);
@@ -1713,6 +1712,7 @@ static void nilfs_segctor_prepare_write(
 				}
 				break;
 			}
+			set_buffer_async_write(bh);
 			if (bh->b_page != fs_page) {
 				nilfs_begin_page_io(fs_page);
 				fs_page = bh->b_page;
@@ -1798,7 +1798,6 @@ static void nilfs_abort_logs(struct list
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			clear_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				clear_buffer_uptodate(bh);
 				if (bh->b_page != bd_page) {
@@ -1807,6 +1806,7 @@ static void nilfs_abort_logs(struct list
 				}
 				break;
 			}
+			clear_buffer_async_write(bh);
 			if (bh->b_page != fs_page) {
 				nilfs_end_page_io(fs_page, err);
 				fs_page = bh->b_page;
@@ -1894,8 +1894,9 @@ static void nilfs_segctor_complete_write
 				 BIT(BH_Delay) | BIT(BH_NILFS_Volatile) |
 				 BIT(BH_NILFS_Redirected));
 
-			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh == segbuf->sb_super_root) {
+				set_buffer_uptodate(bh);
+				clear_buffer_dirty(bh);
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
 					bd_page = bh->b_page;
@@ -1903,6 +1904,7 @@ static void nilfs_segctor_complete_write
 				update_sr = true;
 				break;
 			}
+			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh->b_page != fs_page) {
 				nilfs_end_page_io(fs_page, 0);
 				fs_page = bh->b_page;


