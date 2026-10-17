Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A0E15E5BB;
	Sat, 17 Oct 2026 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260854; cv=none; b=cRDOw8sPCTKI6UG3iuYWZcsioE5tsk4iqOZvvoLecuOvaHjTnrNDectP7KanmmETFNB8P8u2IkDz9r8cyi4gA6sFEsqbk37b4NL45fN+p4nfM/uuh6vCXxGrfr5YfYzoYlNHWkOpdSDFcWirLaHRUL30Il51UsuVFneDij9nlIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260854; c=relaxed/simple;
	bh=B9PR24tVQMiW5231qd+L/oXAW/8AmIDXwlZksIf8Dvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsaQI/bDC/pyTIvHtIhNKPNRw6jhpiCuG+MCDraFMnr+bwO0oITqH5hQrzWzSlzQcFKsQtRoTE5bwLdzrlvprTJDLoj0g9lzqM34KHbLuD7SwfigchncszRj9clxaOCNIQ0Jmlf9MU2nN54Ddz5QWTT8931HBGUR6j2uc4yuwYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuNO9MIx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuNO9MIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140641F000C4;
	Sat, 17 Oct 2026 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260853;
	bh=VkUpRe4EVCKaZnpfZbaiNzorp+CtVtBveNBv2xioaCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuNO9MIx/fQTg1Hu5Nzvl/vT3ZK4io7JAA1ryJXAUkiIGMNwNR8N2jnOssXpPEyjI
	 f5RY9bz58xHvH2Eio1IEY6rStPVJ3n/qohgbudsf/V8jtVlHKo/NuWEgCk4BuFR2QA
	 5QuWYBbD4VzzwoisgHcAfkjGwceT2+UdITMhkVN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1670/1674] xfs: factor out stale buffer item completion
Date: Sat, 17 Oct 2026 18:05:42 +0200
Message-ID: <20261017160513.932772162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3 ]

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1b323b3c0eb93..ade89a233e686 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -541,6 +541,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -590,13 +626,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -607,22 +636,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0



