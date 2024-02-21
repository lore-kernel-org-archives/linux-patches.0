Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D17B69317;
	Wed, 21 Feb 2024 14:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524932; cv=none; b=N0fp7FjZ6K70u7gkLwcH0R0U1VVxezV4sGqYuQ1Qk2EJc6jg/Jz2ijsioVivPLl8ffSXgqDaSu2VgtOGV4HtwmiZy0qoSrhVC6SxZjh9mE5AnRdbKingABCYtB2sewBkswmUq0LXT3bzINFbMwsv0X2M+QLLa8M/dc+8FbM47lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524932; c=relaxed/simple;
	bh=gRtWD8zCyYLZ3yLW+JXR7SuFPqTQW5CnHGiQY4iJd+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSGPVSi9jqktnYES7X8aFJcFA+JRYg92BjooUD/JtG4E9IBuZDJAK9vqZuw9SKUfwUQUYaUCwu7wRutFcUddMyZUGChYVh+3/MW1ifiG8+StwSPxYM8EKyuZGw7Nho7TLy1Qy9h0QCqnnVe6x9FnwLNihpjHRlARE2jLrgTMgZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPm71mET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPm71mET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829F0C433F1;
	Wed, 21 Feb 2024 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524932;
	bh=gRtWD8zCyYLZ3yLW+JXR7SuFPqTQW5CnHGiQY4iJd+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPm71mETMDVbmjpypjHfI6KPQ/oe4iE5PUtRAy8tYjMOcADOuKfjFLgDjZnhFSo7h
	 2gDE14ZzilaOokI/ZbBGdEH3o6qrz8Uz8U0jeaau9E/2+xrxH02se35V6zEBXRBbq3
	 d+q3PR8SphIi4Ky717CliFUw4C6tHFnfjH4it3XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+5c04210f7c7f897c1e7f@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 371/379] nilfs2: fix potential bug in end_buffer_async_write
Date: Wed, 21 Feb 2024 14:09:10 +0100
Message-ID: <20240221130006.035511212@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
@@ -1707,7 +1707,6 @@ static void nilfs_segctor_prepare_write(
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			set_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					lock_page(bd_page);
@@ -1718,6 +1717,7 @@ static void nilfs_segctor_prepare_write(
 				}
 				break;
 			}
+			set_buffer_async_write(bh);
 			if (bh->b_page != fs_page) {
 				nilfs_begin_page_io(fs_page);
 				fs_page = bh->b_page;
@@ -1803,7 +1803,6 @@ static void nilfs_abort_logs(struct list
 
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			clear_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				clear_buffer_uptodate(bh);
 				if (bh->b_page != bd_page) {
@@ -1812,6 +1811,7 @@ static void nilfs_abort_logs(struct list
 				}
 				break;
 			}
+			clear_buffer_async_write(bh);
 			if (bh->b_page != fs_page) {
 				nilfs_end_page_io(fs_page, err);
 				fs_page = bh->b_page;
@@ -1899,8 +1899,9 @@ static void nilfs_segctor_complete_write
 				 BIT(BH_Delay) | BIT(BH_NILFS_Volatile) |
 				 BIT(BH_NILFS_Redirected));
 
-			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh == segbuf->sb_super_root) {
+				set_buffer_uptodate(bh);
+				clear_buffer_dirty(bh);
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
 					bd_page = bh->b_page;
@@ -1908,6 +1909,7 @@ static void nilfs_segctor_complete_write
 				update_sr = true;
 				break;
 			}
+			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh->b_page != fs_page) {
 				nilfs_end_page_io(fs_page, 0);
 				fs_page = bh->b_page;


