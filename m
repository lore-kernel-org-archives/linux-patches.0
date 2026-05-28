Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D30840963C;
	Thu, 28 May 2026 20:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998708; cv=none; b=hVkwq0hoWIGcqrNc7R/eTaCU0vwwqEuHxocVK/9t8nOERN/zfR5lMWOicsKjKLgpi/G2yy7cRutOodq8WtQwOr4rY67lv0nCj34N/Go/eCkcGzOehfOFkglLm71mgZ3VJhsdbAfjRItT99HG3raIdmAU/JcYiML1NAwwMJrWZRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998708; c=relaxed/simple;
	bh=Mgz6nKslV/D0A28ABX+Lu4+IOrHLoMq1F2+Xp/6ic6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyM9vgjK2kPHae0ONelAYc43NJkDyS44CPMmuu/etD+NHoE9Rrv6foFJYEu+DmvJrMbp0FJFBBAH1dDl+2sGtVlii2JXlQ0Io2ehyeCkZrWzUz1Rs7i2Few2ohfhHaFoDBCKQc7Mz8E51VAzedHHM7S6A9Mz1L7ZhN/C8hBqxas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4g0QMjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4g0QMjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F381F00A3A;
	Thu, 28 May 2026 20:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998707;
	bh=jyB5zFaHg728AJAAFZMO0WWVpKc5r6VTJ/awald3sL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4g0QMjVRZ/qaqayIH0Du1HOAtJD1wjaZw0Caz6tRNUQDOhQXZfM1GA5vxonOzsfq
	 aS+2ecC99VqaqVmSlNdvz8XrlALp0cnqU9k9Ia0luGz2/zweAq7kNS5wdqtYzc4T6+
	 iGj6koq+1op5PypzPWJIWQS7h0jDbyaY6Wp0hC/M=
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
Subject: [PATCH 7.0 268/461] netfs: Fix folio->private handling in netfs_perform_write()
Date: Thu, 28 May 2026 21:46:37 +0200
Message-ID: <20260528194654.924901009@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit ccde2ac757c713535b224233a296de40efe5212d ]

Under some circumstances, netfs_perform_write() doesn't correctly
manipulate folio->private between NULL, NETFS_FOLIO_COPY_TO_CACHE, pointing
to a group and pointing to a netfs_folio struct, leading to potential
multiple attachments of private data with associated folio ref leaks and
also leaks of netfs_folio structs or netfs_group refs.

Fix this by consolidating the place at which a folio is marked uptodate in
one place and having that look at what's attached to folio->private and
decide how to clean it up and then set the new group.  Also, the content
shouldn't be flushed if group is NULL, even if a group is specified in the
netfs_group parameter, as that would be the case for a new folio.  A
filesystem should always specify netfs_group or never specify netfs_group.

The Sashiko auto-review tool noted that it was theoretically possible that
the fpos >= ctx->zero_point section might leak if it modified a streaming
write folio.  This is unlikely, but with a network filesystem, third party
changes can happen.  It also pointed out that __netfs_set_group() would
leak if called multiple times on the same folio from the "whole folio
modify section".

Fixes: 8f52de0077ba ("netfs: Reduce number of conditional branches in netfs_perform_write()")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-22-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_write.c    | 134 +++++++++++++++++++++--------------
 include/trace/events/netfs.h |   1 +
 2 files changed, 82 insertions(+), 53 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index b606c3bd84bcd..dee10570383bb 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -13,24 +13,6 @@
 #include <linux/pagevec.h>
 #include "internal.h"
 
-static void __netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
-{
-	if (netfs_group)
-		folio_attach_private(folio, netfs_get_group(netfs_group));
-}
-
-static void netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
-{
-	void *priv = folio_get_private(folio);
-
-	if (unlikely(priv != netfs_group)) {
-		if (netfs_group && (!priv || priv == NETFS_FOLIO_COPY_TO_CACHE))
-			folio_attach_private(folio, netfs_get_group(netfs_group));
-		else if (!netfs_group && priv == NETFS_FOLIO_COPY_TO_CACHE)
-			folio_detach_private(folio);
-	}
-}
-
 /*
  * Grab a folio for writing and lock it.  Attempt to allocate as large a folio
  * as possible to hold as much of the remaining length as possible in one go.
@@ -158,6 +140,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		size_t offset;	/* Offset into pagecache folio */
 		size_t part;	/* Bytes to write to folio */
 		size_t copied;	/* Bytes copied from user */
+		void *priv;
 
 		offset = pos & (max_chunk - 1);
 		part = min(max_chunk - offset, iov_iter_count(iter));
@@ -203,6 +186,25 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			goto error_folio_unlock;
 		}
 
+		finfo = netfs_folio_info(folio);
+		group = netfs_folio_group(folio);
+
+		/* If the requested group differs from the group set on the
+		 * page, then we need to flush out the folio if it has a group
+		 * set (ie. is non-NULL).  Note that COPY_TO_CACHE is a special
+		 * case, being a netfs annotation rather than an actual group.
+		 *
+		 * The filesystem isn't permitted to mix writes with groups and
+		 * writes without groups as the NULL group is used to indicate
+		 * that no group is set.
+		 */
+		if (unlikely(group != netfs_group) &&
+		    group != NETFS_FOLIO_COPY_TO_CACHE &&
+		    group) {
+			WARN_ON_ONCE(!netfs_group);
+			goto flush_content;
+		}
+
 		/* Decide how we should modify a folio.  We might be attempting
 		 * to do write-streaming, as we don't want to a local RMW cycle
 		 * if we can avoid it.  If we're doing local caching or content
@@ -210,22 +212,14 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		 * file is open readably, then we let ->read_folio() fill in
 		 * the gaps.
 		 */
-		finfo = netfs_folio_info(folio);
-		group = netfs_folio_group(folio);
-
-		if (unlikely(group != netfs_group) &&
-		    group != NETFS_FOLIO_COPY_TO_CACHE)
-			goto flush_content;
-
 		if (folio_test_uptodate(folio)) {
 			if (mapping_writably_mapped(mapping))
 				flush_dcache_folio(folio);
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
 			if (unlikely(copied == 0))
 				goto copy_failed;
-			netfs_set_group(folio, netfs_group);
 			trace = netfs_folio_is_uptodate;
-			goto copied;
+			goto copied_uptodate;
 		}
 
 		/* If the page is above the zero-point then we assume that the
@@ -238,24 +232,22 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			folio_zero_segment(folio, offset + copied, flen);
-			__netfs_set_group(folio, netfs_group);
-			folio_mark_uptodate(folio);
-			trace = netfs_modify_and_clear;
-			goto copied;
+			if (finfo)
+				trace = netfs_modify_and_clear_rm_finfo;
+			else
+				trace = netfs_modify_and_clear;
+			goto mark_uptodate;
 		}
 
 		/* See if we can write a whole folio in one go. */
 		if (!maybe_trouble && offset == 0 && part >= flen) {
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
 			if (likely(copied == part)) {
-				if (finfo) {
+				if (finfo)
 					trace = netfs_whole_folio_modify_filled;
-					goto folio_now_filled;
-				}
-				__netfs_set_group(folio, netfs_group);
-				folio_mark_uptodate(folio);
-				trace = netfs_whole_folio_modify;
-				goto copied;
+				else
+					trace = netfs_whole_folio_modify;
+				goto mark_uptodate;
 			}
 			if (copied == 0)
 				goto copy_failed;
@@ -273,7 +265,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			finfo->dirty_len += finfo->dirty_offset;
 			if (finfo->dirty_len == flen) {
 				trace = netfs_whole_folio_modify_filled_efault;
-				goto folio_now_filled;
+				goto mark_uptodate;
 			}
 			if (copied > finfo->dirty_len)
 				finfo->dirty_len = copied;
@@ -301,11 +293,11 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
 			if (unlikely(copied == 0))
 				goto copy_failed;
-			netfs_set_group(folio, netfs_group);
 			trace = netfs_just_prefetch;
-			goto copied;
+			goto copied_uptodate;
 		}
 
+		/* Do a streaming write on a folio that has nothing in it yet. */
 		if (!finfo) {
 			ret = -EIO;
 			if (WARN_ON(folio_get_private(folio)))
@@ -314,10 +306,8 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			if (offset == 0 && copied == flen) {
-				__netfs_set_group(folio, netfs_group);
-				folio_mark_uptodate(folio);
 				trace = netfs_streaming_filled_page;
-				goto copied;
+				goto mark_uptodate;
 			}
 
 			finfo = kzalloc_obj(*finfo);
@@ -346,7 +336,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			finfo->dirty_len += copied;
 			if (finfo->dirty_offset == 0 && finfo->dirty_len == flen) {
 				trace = netfs_streaming_cont_filled_page;
-				goto folio_now_filled;
+				goto mark_uptodate;
 			}
 			trace = netfs_streaming_write_cont;
 			goto copied;
@@ -362,13 +352,36 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			goto out;
 		continue;
 
-	folio_now_filled:
-		if (finfo->netfs_group)
-			folio_change_private(folio, finfo->netfs_group);
-		else
-			folio_detach_private(folio);
+		/* Mark a folio as being up to data when we've filled it
+		 * completely.  If the folio has a group attached, then it must
+		 * be the same group, otherwise we should have flushed it out
+		 * above.  We have to get rid of the netfs_folio struct if
+		 * there was one.
+		 */
+	mark_uptodate:
 		folio_mark_uptodate(folio);
-		kfree(finfo);
+
+	copied_uptodate:
+		priv = folio_get_private(folio);
+		if (likely(priv == netfs_group)) {
+			/* Already set correctly; no change required. */
+		} else if (priv == NETFS_FOLIO_COPY_TO_CACHE) {
+			if (!netfs_group)
+				folio_detach_private(folio);
+			else
+				folio_change_private(folio, netfs_get_group(netfs_group));
+		} else if (!priv) {
+			folio_attach_private(folio, netfs_get_group(netfs_group));
+		} else {
+			WARN_ON_ONCE(!finfo);
+			if (netfs_group)
+				/* finfo->netfs_group has a ref */
+				folio_change_private(folio, netfs_group);
+			else
+				folio_detach_private(folio);
+			kfree(finfo);
+		}
+
 	copied:
 		trace_netfs_folio(folio, trace);
 		flush_dcache_folio(folio);
@@ -531,6 +544,7 @@ vm_fault_t netfs_page_mkwrite(struct vm_fault *vmf, struct netfs_group *netfs_gr
 	struct inode *inode = file_inode(file);
 	struct netfs_inode *ictx = netfs_inode(inode);
 	vm_fault_t ret = VM_FAULT_NOPAGE;
+	void *priv;
 	int err;
 
 	_enter("%lx", folio->index);
@@ -551,7 +565,9 @@ vm_fault_t netfs_page_mkwrite(struct vm_fault *vmf, struct netfs_group *netfs_gr
 	}
 
 	group = netfs_folio_group(folio);
-	if (group != netfs_group && group != NETFS_FOLIO_COPY_TO_CACHE) {
+	if (group &&
+	    group != netfs_group &&
+	    group != NETFS_FOLIO_COPY_TO_CACHE) {
 		folio_unlock(folio);
 		err = filemap_fdatawrite_range(mapping,
 					       folio_pos(folio),
@@ -573,7 +589,19 @@ vm_fault_t netfs_page_mkwrite(struct vm_fault *vmf, struct netfs_group *netfs_gr
 		trace_netfs_folio(folio, netfs_folio_trace_mkwrite_plus);
 	else
 		trace_netfs_folio(folio, netfs_folio_trace_mkwrite);
-	netfs_set_group(folio, netfs_group);
+
+	priv = folio_get_private(folio);
+	if (priv != netfs_group) {
+		if (!netfs_group && priv == NETFS_FOLIO_COPY_TO_CACHE)
+			folio_detach_private(folio);
+		else if (netfs_group && priv == NETFS_FOLIO_COPY_TO_CACHE)
+			folio_change_private(folio, netfs_get_group(netfs_group));
+		else if (netfs_group && !priv)
+			folio_attach_private(folio, netfs_get_group(netfs_group));
+		else
+			WARN_ON_ONCE(1);
+	}
+
 	file_update_time(file);
 	set_bit(NETFS_ICTX_MODIFIED_ATTR, &ictx->flags);
 	if (ictx->ops->post_modify)
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index db045135406c9..3fe3980902c24 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -181,6 +181,7 @@
 	EM(netfs_whole_folio_modify_filled,	"mod-whole-f+")	\
 	EM(netfs_whole_folio_modify_filled_efault, "mod-whole-f+!") \
 	EM(netfs_modify_and_clear,		"mod-n-clear")	\
+	EM(netfs_modify_and_clear_rm_finfo,	"mod-n-clear+")	\
 	EM(netfs_streaming_write,		"mod-streamw")	\
 	EM(netfs_streaming_write_cont,		"mod-streamw+")	\
 	EM(netfs_flush_content,			"flush")	\
-- 
2.53.0



