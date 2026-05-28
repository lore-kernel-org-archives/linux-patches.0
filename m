Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087FB33B6FC;
	Thu, 28 May 2026 20:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000860; cv=none; b=IX3QM7CdJowYe4UpJpb6bWdLII+PDB3pGqp3jVGAhOZbccjXhV7Oao+Zh/jBCSLX5+x85VMBue/kPazon8Zb44kohhY75LQG0DqGN/1RHWv3U/TwETRGFkedi1KbCDKX/5/2nBknwURBW5oI1u+wb0JLDrzYk4QsItxEuOGVoWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000860; c=relaxed/simple;
	bh=41pBTBs3LxKskaPC1Uh/8pza1fJO4wdbwEN+WTL6IQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO/BkTJ9NQkPoCLnrD1FUpigc86W3SRG2gRZzh6h9DF9e+0ZeH1H5A2HruSX4E5CsP3heg+8TR7CJ1ZUNqRLdDPCSwkEdw4z4Ovxl7hGz6jXgU86s6m6HEJma82KFvD8Cg7yXRd21OOIr015q56dnWGkI2dZqLq/AelDeXX6a7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIKIthVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIKIthVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD511F000E9;
	Thu, 28 May 2026 20:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000858;
	bh=32RpTw8+jwP7EIlE702GuAJ8CKxMO7YCgu2j8kz1eH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIKIthVpvXmks8fBAVa4qv8fXMS5u8V5OcDpB5SY7RY7ZPyjSJwegK5Lxh+6G/jDN
	 9ACVsSOssZEgWKU7KakzjUl5qj3vGUQipeGjLOVlTo3Zcm4a5t2vtYWBpUVjDnWfyZ
	 fcfHL4nAH5no+sApd95afxewcB0R61dT+5loRJPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/272] netfs: Fix streaming write being overwritten
Date: Thu, 28 May 2026 21:49:28 +0200
Message-ID: <20260528194634.697855607@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 7b4dcf1b9455a6e52ac7478b4057dbe10359576d ]

In order to avoid reading whilst writing, netfslib will allow "streaming
writes" in which dirty data is stored directly into folios without reading
them first.  Such folios are marked dirty but may not be marked uptodate.
If a folio is entirely written by a streaming write, uptodate will be set,
otherwise it will have a netfs_folio struct attached to ->private recording
the dirty region.

In the event that a partially written streaming write page is to be
overwritten entirely by a single write(), netfs_perform_write() will try to
copy over it, but doesn't discard the netfs_folio if it succeeds; further,
it doesn't correctly handle a partial copy that overwrites some of the
dirty data.

Fix this by the following:

 (1) If the folio is successfully overwritten, free the netfs_folio struct
     before marking the page uptodate.

 (2) If the copy to the folio partially fails, but short of the dirty data,
     just ignore the copy.

 (3) If the copy partially fails and overwrites some of the dirty data,
     accept the copy, update the netfs_folio struct to record the new data.
     If the folio is now filled, free the netfs_folio and set uptodate,
     otherwise return a partial write.

Found with:

	fsx -q -N 1000000 -p 10000 -o 128000 -l 600000 \
	  /xfstest.test/junk --replay-ops=junk.fsxops

using the following as junk.fsxops:

	truncate 0x0 0 0x927c0
	write 0x63fb8 0x53c8 0
	copy_range 0xb704 0x19b9 0x24429 0x79380
	write 0x2402b 0x144a2 0x90660 *
	write 0x204d5 0x140a0 0x927c0 *
	copy_range 0x1f72c 0x137d0 0x7a906 0x927c0 *
	read 0x00000 0x20000 0x9157c
	read 0x20000 0x20000 0x9157c
	read 0x40000 0x20000 0x9157c
	read 0x60000 0x20000 0x9157c
	read 0x7e1a0 0xcfb9 0x9157c

on cifs with the default cache option.

It shows folio 0x24 misbehaving if the FMODE_READ check is commented out in
netfs_perform_write():

		if (//(file->f_mode & FMODE_READ) ||
		    netfs_is_cache_enabled(ctx)) {

and no fscache.  This was initially found with the generic/522 xfstest.

Fixes: 8f52de0077ba ("netfs: Reduce number of conditional branches in netfs_perform_write()")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-14-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_write.c    | 47 ++++++++++++++++++++++++++----------
 include/trace/events/netfs.h |  3 +++
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 48c66d26e7b7e..19a58aea670cb 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -240,18 +240,38 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		/* See if we can write a whole folio in one go. */
 		if (!maybe_trouble && offset == 0 && part >= flen) {
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
-			if (unlikely(copied == 0))
+			if (likely(copied == part)) {
+				if (finfo) {
+					trace = netfs_whole_folio_modify_filled;
+					goto folio_now_filled;
+				}
+				__netfs_set_group(folio, netfs_group);
+				folio_mark_uptodate(folio);
+				trace = netfs_whole_folio_modify;
+				goto copied;
+			}
+			if (copied == 0)
 				goto copy_failed;
-			if (unlikely(copied < part)) {
+			if (!finfo || copied <= finfo->dirty_offset) {
 				maybe_trouble = true;
 				iov_iter_revert(iter, copied);
 				copied = 0;
 				folio_unlock(folio);
 				goto retry;
 			}
-			__netfs_set_group(folio, netfs_group);
-			folio_mark_uptodate(folio);
-			trace = netfs_whole_folio_modify;
+
+			/* We overwrote some existing dirty data, so we have to
+			 * accept the partial write.
+			 */
+			finfo->dirty_len += finfo->dirty_offset;
+			if (finfo->dirty_len == flen) {
+				trace = netfs_whole_folio_modify_filled_efault;
+				goto folio_now_filled;
+			}
+			if (copied > finfo->dirty_len)
+				finfo->dirty_len = copied;
+			finfo->dirty_offset = 0;
+			trace = netfs_whole_folio_modify_efault;
 			goto copied;
 		}
 
@@ -321,16 +341,10 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 				goto copy_failed;
 			finfo->dirty_len += copied;
 			if (finfo->dirty_offset == 0 && finfo->dirty_len == flen) {
-				if (finfo->netfs_group)
-					folio_change_private(folio, finfo->netfs_group);
-				else
-					folio_detach_private(folio);
-				folio_mark_uptodate(folio);
-				kfree(finfo);
 				trace = netfs_streaming_cont_filled_page;
-			} else {
-				trace = netfs_streaming_write_cont;
+				goto folio_now_filled;
 			}
+			trace = netfs_streaming_write_cont;
 			goto copied;
 		}
 
@@ -344,6 +358,13 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			goto out;
 		continue;
 
+	folio_now_filled:
+		if (finfo->netfs_group)
+			folio_change_private(folio, finfo->netfs_group);
+		else
+			folio_detach_private(folio);
+		folio_mark_uptodate(folio);
+		kfree(finfo);
 	copied:
 		trace_netfs_folio(folio, trace);
 		flush_dcache_folio(folio);
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index f3e386c69cc8b..6395827e83954 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -145,6 +145,9 @@
 	EM(netfs_folio_is_uptodate,		"mod-uptodate")	\
 	EM(netfs_just_prefetch,			"mod-prefetch")	\
 	EM(netfs_whole_folio_modify,		"mod-whole-f")	\
+	EM(netfs_whole_folio_modify_efault,	"mod-whole-f!")	\
+	EM(netfs_whole_folio_modify_filled,	"mod-whole-f+")	\
+	EM(netfs_whole_folio_modify_filled_efault, "mod-whole-f+!") \
 	EM(netfs_modify_and_clear,		"mod-n-clear")	\
 	EM(netfs_streaming_write,		"mod-streamw")	\
 	EM(netfs_streaming_write_cont,		"mod-streamw+")	\
-- 
2.53.0



