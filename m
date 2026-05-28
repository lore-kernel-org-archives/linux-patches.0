Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0EE3346BE;
	Thu, 28 May 2026 20:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000854; cv=none; b=aF09nwoMngPOErXfV7mgE4xcgRE34/kuQI1mdOwj07T7Oy+cISH+7Bk7EFKBFsVGCoe+yKh7cKXbs0CWoy9cpeaYfSXEBwaHfICtC9pgj04pDR4S8/MSQh/ekrIUW6vS4/eoLeMxQ9TKiR9cXURECTyf6V2yrN/p3un68fFfFNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000854; c=relaxed/simple;
	bh=CP879Ykf5MC5OGY+0nQPeU8bgKyp6ncgNINpZ1AvNIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFu+p8GfENf1pR/t/LbZq6KZGUoYjI2NK1fKXttaE9eQKgQYW1AnS7Nj5UuminD68INjLX3DRFn36yQQiDGNsiOr4dzDEW1K0d507K5vSBkGbjXOhHcoLI0t2Ivgd1rmujNinH2VIy4JxwKQkEgSnZbqeLEQ9qWO/A4sgBj3G+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnSIupjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnSIupjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39841F000E9;
	Thu, 28 May 2026 20:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000853;
	bh=QIycfzmKzjFNMZcBD28iCI3zOtIuloVBEshDTuojoj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnSIupjRMAWgXMhLNCmzjqcr0XJYn/eBgiYVuxIC4QSHRof/mqZ54As9+aiOZ/yiR
	 gG+iXkVmx+yVZ5LGfMxbIIuiXWerulE5K8KEhl/ybul/kBYDv8Lx/20xLTId8rhXp6
	 vlH+Nf/GXOaAciBvUpqaK3s51Qo2TL7IvmciE7BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/272] netfs: Fix netfs_invalidate_folio() to clear dirty bit if all changes gone
Date: Thu, 28 May 2026 21:49:26 +0200
Message-ID: <20260528194634.641607182@linuxfoundation.org>
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

[ Upstream commit 156ac2ec2ee77c44c4eb7439d6d165247ba12247 ]

If a streaming write is made, this will leave the relevant modified folio
in a not-uptodate, but dirty state with a netfs_folio struct hung off of
folio->private indicating the dirty range.  Subsequently truncating the
file such that the dirty data in the folio is removed, but the first part
of the folio theoretically remains will cause the netfs_folio struct to be
discarded... but will leave the dirty flag set.

If the folio is then read via mmap(), netfs_read_folio() will see that the
page is dirty and jump to netfs_read_gaps() to fill in the missing bits.
netfs_read_gaps(), however, expects there to be a netfs_folio struct
present and can oops because truncate removed it.

Fix this by calling folio_cancel_dirty() in netfs_invalidate_folio() in the
event that all the dirty data in the folio is erased (as nfs does).

Also add some tracepoints to log modifications to a dirty page.

This can be reproduced with something like:

    dd if=/dev/zero of=/xfstest.test/foo bs=1M count=1
    umount /xfstest.test
    mount /xfstest.test
    xfs_io -c "w 0xbbbf 0xf96c" \
           -c "truncate 0xbbbf" \
           -c "mmap -r 0xb000 0x11000" \
           -c "mr 0xb000 0x11000" \
           /xfstest.test/foo

with fscaching disabled (otherwise streaming writes are suppressed) and a
change to netfs_perform_write() to disallow streaming writes if the fd is
open O_RDWR:

	if (//(file->f_mode & FMODE_READ) || <--- comment this out
	    netfs_is_cache_enabled(ctx)) {

It should be reproducible even without this change, but if prevents the
above trivial xfs_io command from reproducing it.

Note that the initial dd is important: the file must start out sufficiently
large that the zero-point logic doesn't just clear the gaps because it
knows there's nothing in the file to read yet.  Unmounting and mounting is
needed to clear the pagecache (there are other ways to do that that may
also work).

This was initially reproduced with the generic/522 xfstest on some patches
that remove the FMODE_READ restriction.

Fixes: 9ebff83e6481 ("netfs: Prep to use folio->private for write grouping and streaming write")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-12-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/misc.c              | 6 +++++-
 include/trace/events/netfs.h | 4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 78fe5796b2b2f..488a4b1914300 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -268,6 +268,7 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 			/* Move the start of the data. */
 			finfo->dirty_len = fend - iend;
 			finfo->dirty_offset = offset;
+			trace_netfs_folio(folio, netfs_folio_trace_invalidate_front);
 			return;
 		}
 
@@ -276,12 +277,14 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 		 */
 		if (iend >= fend) {
 			finfo->dirty_len = offset - fstart;
+			trace_netfs_folio(folio, netfs_folio_trace_invalidate_tail);
 			return;
 		}
 
 		/* A partial write was split.  The caller has already zeroed
 		 * it, so just absorb the hole.
 		 */
+		trace_netfs_folio(folio, netfs_folio_trace_invalidate_middle);
 	}
 	return;
 
@@ -289,8 +292,9 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 	netfs_put_group(netfs_folio_group(folio));
 	folio_detach_private(folio);
 	folio_clear_uptodate(folio);
+	folio_cancel_dirty(folio);
 	kfree(finfo);
-	return;
+	trace_netfs_folio(folio, netfs_folio_trace_invalidate_all);
 }
 EXPORT_SYMBOL(netfs_invalidate_folio);
 
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 69975c9c68239..f3e386c69cc8b 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -161,6 +161,10 @@
 	EM(netfs_folio_trace_copy_to_cache,	"mark-copy")	\
 	EM(netfs_folio_trace_end_copy,		"end-copy")	\
 	EM(netfs_folio_trace_filled_gaps,	"filled-gaps")	\
+	EM(netfs_folio_trace_invalidate_all,	"inval-all")	\
+	EM(netfs_folio_trace_invalidate_front,	"inval-front")	\
+	EM(netfs_folio_trace_invalidate_middle,	"inval-mid")	\
+	EM(netfs_folio_trace_invalidate_tail,	"inval-tail")	\
 	EM(netfs_folio_trace_kill,		"kill")		\
 	EM(netfs_folio_trace_kill_cc,		"kill-cc")	\
 	EM(netfs_folio_trace_kill_g,		"kill-g")	\
-- 
2.53.0



