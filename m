Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3F433F390;
	Thu, 28 May 2026 20:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999925; cv=none; b=SvKjYPr6X1Nq4ILOEta+ehKzUTCCgh8O1+pcVmmtXXZpSyAhgOYAfqFKOoweOO73+Z7Ix9zZLae+pEd2UUcdbFukBWIBmtLmgP7pC04ecPXFU51ejRpm0K9jnnibhNFGr5MFtk7BVsSrJ1j+CT6u8bePzkXqzU0iJiIPEBEuLi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999925; c=relaxed/simple;
	bh=nhuPdLDLIFUVxRrkuMKsxiTKovfXwqoL8ZY0xbT2ijY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU80FnjQtlb8RcyR91tMseIZH3q/t2YWzGW8RNo/C9YsUAZ8LFn16CRD83YzZlgzGEUsqodrCZaLsZZPNiIZEAzOaOy/aSeHRo68Q4qoOZWjEFkphoOeFrlJ3g8WnL1CA87QC9dw1aufeXaxdFslmaFKONCLYdJZFAPrYueag7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSxr7wSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSxr7wSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760AF1F00A3A;
	Thu, 28 May 2026 20:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999923;
	bh=EfjyWdwFYCJGbfOYtHDpz2GBLw25ylVDQfrbL2Tc7F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSxr7wSCpgq0zLGg/8oywxkmUy/WdtUc7lHGHp7Xr39FV114rAKB1NE84CMTo6mD8
	 wkKvBHqdkrUriCw5GlCcABDiR8lnuzHMSCXjogpcqYuXUL8apne1YsuKuFmxbXTOSf
	 ga/Fogoxx3pXcKzMeHURb4PhZeC341OApdUEsyQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/377] netfs: Fix potential deadlock in write-through mode
Date: Thu, 28 May 2026 21:47:58 +0200
Message-ID: <20260528194645.337738904@linuxfoundation.org>
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

[ Upstream commit b6a4ae1634b3ad2aaa05222e53d36da532852faf ]

Fix netfs_advance_writethrough() to always unlock the supplied folio and to
mark it dirty if it isn't yet written to the end.  Unfortunately, it can't
be marked for writeback until the folio is done with as that may cause a
deadlock against mmapped reads and writes.

Even though it has been marked dirty, premature writeback can't occur as
the caller is holding both inode->i_rwsem (which will prevent concurrent
truncation, fallocation, DIO and other writes) and ictx->wb_lock (which
will cause flushing to wait and writeback to skip or wait).

Note that this may be easier to deal with once the queuing of folios is
split from the generation of subrequests.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Closes: https://sashiko.dev/#/patchset/20260427154639.180684-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-15-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 2db688f941251..9bf05099155dc 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -413,12 +413,7 @@ static int netfs_write_folio(struct netfs_io_request *wreq,
 	if (streamw)
 		netfs_issue_write(wreq, cache);
 
-	/* Flip the page to the writeback state and unlock.  If we're called
-	 * from write-through, then the page has already been put into the wb
-	 * state.
-	 */
-	if (wreq->origin == NETFS_WRITEBACK)
-		folio_start_writeback(folio);
+	folio_start_writeback(folio);
 	folio_unlock(folio);
 
 	if (fgroup == NETFS_FOLIO_COPY_TO_CACHE) {
@@ -646,29 +641,41 @@ int netfs_advance_writethrough(struct netfs_io_request *wreq, struct writeback_c
 			       struct folio *folio, size_t copied, bool to_page_end,
 			       struct folio **writethrough_cache)
 {
+	int ret;
+
 	_enter("R=%x ic=%zu ws=%u cp=%zu tp=%u",
 	       wreq->debug_id, wreq->buffer.iter.count, wreq->wsize, copied, to_page_end);
 
-	if (!*writethrough_cache) {
-		if (folio_test_dirty(folio))
-			/* Sigh.  mmap. */
-			folio_clear_dirty_for_io(folio);
+	/* The folio is locked. */
 
+	if (*writethrough_cache != folio) {
+		if (*writethrough_cache) {
+			/* Did the folio get moved? */
+			folio_put(*writethrough_cache);
+			*writethrough_cache = NULL;
+		}
 		/* We can make multiple writes to the folio... */
-		folio_start_writeback(folio);
 		if (wreq->len == 0)
 			trace_netfs_folio(folio, netfs_folio_trace_wthru);
 		else
 			trace_netfs_folio(folio, netfs_folio_trace_wthru_plus);
 		*writethrough_cache = folio;
+		folio_get(folio);
 	}
 
 	wreq->len += copied;
-	if (!to_page_end)
+
+	if (!to_page_end) {
+		folio_mark_dirty(folio);
+		folio_unlock(folio);
 		return 0;
+	}
 
+	ret = netfs_write_folio(wreq, wbc, folio);
+	folio_put(*writethrough_cache);
 	*writethrough_cache = NULL;
-	return netfs_write_folio(wreq, wbc, folio);
+	wreq->submitted = wreq->len;
+	return ret;
 }
 
 /*
@@ -682,8 +689,12 @@ ssize_t netfs_end_writethrough(struct netfs_io_request *wreq, struct writeback_c
 
 	_enter("R=%x", wreq->debug_id);
 
-	if (writethrough_cache)
+	if (writethrough_cache) {
+		folio_lock(writethrough_cache);
 		netfs_write_folio(wreq, wbc, writethrough_cache);
+		folio_put(writethrough_cache);
+		wreq->submitted = wreq->len;
+	}
 
 	netfs_end_issue_write(wreq);
 
-- 
2.53.0



