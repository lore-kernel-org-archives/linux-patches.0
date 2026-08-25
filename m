Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2A247B432;
	Tue, 25 Aug 2026 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664614; cv=none; b=BOinzNQeURk40e+aOnlC2VjjqlTdz9qPsYFd8E7QeY1FWAi+5DEFhZ42cG10iWgbMwjdHueWMFQjw7HuLh8gYiF50tRbgZtrOloZ1HscBCRQTO1zLW+VScyO3q2jI64xI9aF5mGXm53hNS/xdKMiWLZpLVRxPSxUGb28wYbhy3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664614; c=relaxed/simple;
	bh=bAJTSVhKooEkxXWL+/T0Br26g0hUjjNMx6ou4Fscskk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t85XZNxnke13qal+9DY/78FyRB1g93H/OdhCYvr2rxlhTv4idCT4C07fh286vFdBJp28Rc/M+cow0leQYURpoYylChrSLrWbiVuwnSD8a0teHwD/JzBdEe78obyFfo0FPHWOHZU4J03wvfOo02UIIGhryVfs/xDLqgoZNlzXCwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IF9mkFwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IF9mkFwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354571F000E9;
	Tue, 25 Aug 2026 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664612;
	bh=3f48n1MRpRV5WaE7sZBCVe1Ivr1qqPmuDwnggwhhx2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IF9mkFwNWJItsGCFW079+STcj/EFWftWzCoNhqhIbtl2M8f+G1ZgZICl7q4bi8Wl4
	 3VjKYw5KKjiPZrM0x3diZcAE9oQPEJMMzyhKAJOyjgDHr409GZqGpg+7PuJtXZpb1B
	 zFkdK3Tqg3z/ezhPuSOKkG6EeBlr99e7zrLxCyjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 7.2 28/82] ext4: avoid tail write_begin walk for uptodate folios
Date: Tue, 25 Aug 2026 15:25:15 +0200
Message-ID: <20260825132542.613052099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Zhu <zhujia.zj@bytedance.com>

commit d09811183db2891776dbf0c0f1094540e29938f6 upstream.

Ext4 buffered writes into large folios also pay a full buffer_head
walk in ext4_block_write_begin().  For a small overwrite of an existing
cached folio, the folio is already uptodate and the write only needs to
prepare the buffers through the written range.  Walking the suffix still
makes the write_begin cost proportional to the folio size.

Before ext4 enabled large folios for regular files, the same loop was
bounded by a single page of buffers.  That commit made the existing
full-folio walk visible as a regression for cached small overwrites.

The suffix walk is needed for non-uptodate folios, where ext4 may have
to submit reads for partial blocks, preserve new-buffer cleanup, and run
error zeroing.  Keep those folios on the old full walk.

For already-uptodate folios, keep the walk starting at the first buffer
rather than seeking directly to from.  This preserves the existing prefix
buffer state handling.  Stop once block_start reaches the end of the
write range, because the skipped suffix would only repeat the
outside-range uptodate handling for buffers beyond @to.

On current master, the libMicro ext4 large-folio overwrite test shows
the following full-series result.  Results are median usecs/call over 10
runs, lower is better:

case        nofix     this series   improvement
write_u1k   1.418     0.3405        76.0%
write_u10k  1.887     0.4175        77.9%
pwrite_u1k  1.6775    0.3390        79.8%
pwrite_u10k 1.9035    0.4130        78.3%

Fixes: 7ac67301e82f0 ("ext4: enable large folio for regular file")
Cc: stable@vger.kernel.org # v6.16+
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Link: https://patch.msgid.link/20260609035202.90669-3-zhujia.zj@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1182,6 +1182,7 @@ int ext4_block_write_begin(handle_t *han
 	int nr_wait = 0;
 	int i;
 	bool should_journal_data = ext4_should_journal_data(inode);
+	bool folio_uptodate = folio_test_uptodate(folio);
 
 	BUG_ON(!folio_test_locked(folio));
 	BUG_ON(to > folio_size(folio));
@@ -1193,13 +1194,13 @@ int ext4_block_write_begin(handle_t *han
 		head = create_empty_buffers(folio, blocksize, 0);
 	block = EXT4_PG_TO_LBLK(inode, folio->index);
 
-	for (bh = head, block_start = 0; bh != head || !block_start;
+	for (bh = head, block_start = 0;
+	     block_start < to || (!folio_uptodate && bh != head);
 	    block++, block_start = block_end, bh = bh->b_this_page) {
 		block_end = block_start + blocksize;
 		if (block_end <= from || block_start >= to) {
-			if (folio_test_uptodate(folio)) {
+			if (folio_uptodate)
 				set_buffer_uptodate(bh);
-			}
 			continue;
 		}
 		if (WARN_ON_ONCE(buffer_new(bh)))
@@ -1220,7 +1221,7 @@ int ext4_block_write_begin(handle_t *han
 				if (should_journal_data)
 					do_journal_get_write_access(handle,
 								    inode, bh);
-				if (folio_test_uptodate(folio)) {
+				if (folio_uptodate) {
 					/*
 					 * Unlike __block_write_begin() we leave
 					 * dirtying of new uptodate buffers to
@@ -1237,7 +1238,7 @@ int ext4_block_write_begin(handle_t *han
 				continue;
 			}
 		}
-		if (folio_test_uptodate(folio)) {
+		if (folio_uptodate) {
 			set_buffer_uptodate(bh);
 			continue;
 		}


