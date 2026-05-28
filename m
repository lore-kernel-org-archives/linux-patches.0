Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBD92F39B4;
	Thu, 28 May 2026 20:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999930; cv=none; b=ASXocnzat1e1ZCn5xFxoqs+zJYUc/ELSwnpmcMyLMNTu5hPgXpbf45e/dd9NYl0sr8u25NePpAYpYbNmxQorVLRp6gqL1cpH6paSHtKoOeFz6E09ohOHySVkfwjCO6/AtEaZud3V71uaQeg+tGMgwY1huw2j1UwIH4divyzQSNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999930; c=relaxed/simple;
	bh=U8X05u6F1cQ8doQYvo7FvyzIdfZqlDb61Ri/O4IUtv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzIyMdk23LYhtrjfRY7qIkrnHKkcvsDe5zdhLc94fDzNjcRwH4xpxladxlDmNy10+0uJia6DbhRrbcTROdHMHH2la5jpBsGCm4O7dBf4/YQvKIgBYuVnb7ipGq/Xx+ai0Q8Kt/bfm8wlHLng9tVMLIcmpIDQEf/MABZjiGCoXXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pae5v9X6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pae5v9X6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5861F00A3A;
	Thu, 28 May 2026 20:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999928;
	bh=c+VxF3nI+obrP+jYCH3myhDLgSUntVq1WEiYmapHrz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pae5v9X6ESVSOoDS5a8NBKi5l52Ki/GkRQoLsdpdiyovWDiADP9czjYUwd1QM6PqG
	 AUf9HCqY6RR8qlWLGVvoU2rbvk7RLnsEJionWzzvULB8UBrmDp29b/lIY+n655+Gqs
	 t8rXRquUEW0YNQad/xl9YZrMPFxa52dt/5BfJslQ=
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
Subject: [PATCH 6.18 242/377] netfs: Fix write streaming disablement if fd open O_RDWR
Date: Thu, 28 May 2026 21:48:00 +0200
Message-ID: <20260528194645.391512992@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 99736895e964f..60215a7723574 100644
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



