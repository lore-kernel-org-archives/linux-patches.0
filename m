Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6741B30E82E;
	Thu, 28 May 2026 20:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998694; cv=none; b=JJygmsgjFwKhDNgMMeLPBbK+IWPQe5vcNWDsRin2io9AYgAYzpFuTr6nrbaxXVk08uGSeFzsMix1OOiD6s79sYayShsWrwlszeovB2bdClUdijmTspFb/1xUG/9it4zATPuovfX1aPMcgGZz2xPoeECm590hMF5GuqFUq0R2eBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998694; c=relaxed/simple;
	bh=LwPQEB6xmgciLemfoL75DL54QgHqo4kTfw3bMbCdriU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFft1SAw09zKtjR2IrE1sV75S4tC+F036XDFJQ3V18XhNZfQ0w+3W8d6lQY8Ve8ivIqOHnQkYA1nJf9TbRmTs9q9ooJvouUeXzltv6VYXbGFLpZbq+HW6aUo+6bhgsjgoXQnfCnoWvfzIyAvKsHzl1gb/uJ14hKwSiHmwGX4Vcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0TIh+gN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0TIh+gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B5C1F000E9;
	Thu, 28 May 2026 20:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998693;
	bh=D2g3v7t1xUR3+9glFuDOnBloeR3B9ItH/CSluPI5+9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0TIh+gNuwFc9Rz4yONXxBTbXHmE8tcfEHvud4OHVdtV5Wdh/lj7VlU+OYrn3/dej
	 1R2Y3aNO+m14UjDFL+lVqxuHe4WKIagOMl0lSxyRtOSOvwvHYo+cqgF7lk1t1dapL/
	 8kaVIsvTrXRM+zfxxQoU593a2MGzgxXHk+2BXsYI=
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
Subject: [PATCH 7.0 263/461] netfs: Fix write streaming disablement if fd open O_RDWR
Date: Thu, 28 May 2026 21:46:32 +0200
Message-ID: <20260528194654.774664581@linuxfoundation.org>
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

[ Upstream commit 70a7b9193bbbfceaab5974de66834c64ccc875dd ]

In netfs_perform_write(), "write streaming" (the caching of dirty data in
dirty but !uptodate folios) is performed to avoid the need to read data
that is just going to get immediately overwritten.  However, this is/will
be disabled in three circumstances: if the fd is open O_RDWR, if fscache is
in use (as we need to round out the blocks for DIO) or if content
encryption is enabled (again for rounding out purposes).

The idea behind disabling it if the fd is open O_RDWR is that we'd need to
flush the write-streaming page before we could read the data, particularly
through mmap.  But netfs now fills in the gaps if ->read_folio() is called
on the page, so that is unnecessary.  Further, this doesn't actually work
if a separate fd is open for reading.

Fix this by removing the check for O_RDWR, thereby allowing streaming
writes even when we might read.

This caused a number of problems with the generic/522 xfstest, but those
are now fixed.

Fixes: c38f4e96e605 ("netfs: Provide func to copy data to pagecache for buffered write")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-17-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_write.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 0ff4c790ae263..b606c3bd84bcd 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -204,11 +204,11 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		}
 
 		/* Decide how we should modify a folio.  We might be attempting
-		 * to do write-streaming, in which case we don't want to a
-		 * local RMW cycle if we can avoid it.  If we're doing local
-		 * caching or content crypto, we award that priority over
-		 * avoiding RMW.  If the file is open readably, then we also
-		 * assume that we may want to read what we wrote.
+		 * to do write-streaming, as we don't want to a local RMW cycle
+		 * if we can avoid it.  If we're doing local caching or content
+		 * crypto, we award that priority over avoiding RMW.  If the
+		 * file is open readably, then we let ->read_folio() fill in
+		 * the gaps.
 		 */
 		finfo = netfs_folio_info(folio);
 		group = netfs_folio_group(folio);
@@ -284,12 +284,9 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 
 		/* We don't want to do a streaming write on a file that loses
 		 * caching service temporarily because the backing store got
-		 * culled and we don't really want to get a streaming write on
-		 * a file that's open for reading as ->read_folio() then has to
-		 * be able to flush it.
+		 * culled.
 		 */
-		if ((file->f_mode & FMODE_READ) ||
-		    netfs_is_cache_enabled(ctx)) {
+		if (netfs_is_cache_enabled(ctx)) {
 			if (finfo) {
 				netfs_stat(&netfs_n_wh_wstream_conflict);
 				goto flush_content;
-- 
2.53.0



