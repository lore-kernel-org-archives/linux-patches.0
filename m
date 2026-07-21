Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C553330EF9A;
	Tue, 21 Jul 2026 19:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662558; cv=none; b=MoM0LGMnKYr+LFd75QP2Ua26CLGkd+d4baV80vjiA/edjFKK7ZO8u2vEbIpGjVsuX7yHDHGsX88A/QMHPIoU6aOWPpfNwrbPy2vkQlWaN7YZJvYRcy8tCPVlP0NUqant7sxCBUvZ8HqmNJyBperVYQoIIZoSzNdCyu0wUJLAxoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662558; c=relaxed/simple;
	bh=iwFE9zOsQmO/8uwlFtOTyiyVjBN/VqogKkXUN7PBN7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FanonuBGGXdA0qKz5E1VdK+XjO0iilED1RUR9F2wfY/O+2VCbBhmYqIAJJ/QAt2Sy/CW+k9A8pDiqRZb7qJlxJoS2G003SpZ+b65YC1K72zZcHrA9KmvhkF+NrbKS/CScQx5IBVsbV/XexRJOfsBC/KXWriw7AhcMKG9enU84lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQx9Zogu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQx9Zogu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87B81F000E9;
	Tue, 21 Jul 2026 19:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662557;
	bh=0YisRL3kvSFImzgTLQzDtfVGaAHSnaw0UOfFXIDGbtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQx9ZoguetdZW5q1VIM9chgHiQvDDBqWUtvVNxY5wvusOTTb+Ah92UsCIWSc7MzqF
	 Pmndda8JET/Pbpy/oLhybETW9izCXScKl+jB9PkEa24OzRWCh9cAB5iizqEU/FaFDY
	 DMsDe0FIIrnoJaDrxv28MWTW6glPAYmmjnQtbVg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0489/1276] nfs: keep PG_UPTODATE clear after read errors in page groups
Date: Tue, 21 Jul 2026 17:15:32 +0200
Message-ID: <20260721152457.044379054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit 3ff72e1cdf5c337b6acfcf3fcef748c5b9a5316b ]

When a read request is split into multiple subrequests, earlier
completions may advance PG_UPTODATE state for the page group once
their bytes fall within hdr->good_bytes. If a later subrequest in
the same group then completes with NFS_IOHDR_ERROR, the read path
needs to clear any accumulated PG_UPTODATE state and keep later
completions from rebuilding it.

Otherwise, a subsequent successful subrequest can re-enter
nfs_page_group_set_uptodate(), restore the page-group sync state,
and leave stale PG_UPTODATE behind for nfs_page_group_destroy()
to trip over in nfs_free_request().

Add a sticky page-group read-failed flag. Once any subrequest in
the group is known to be bad, mark the group failed, clear any
accumulated PG_UPTODATE state, and refuse further PG_UPTODATE
synchronization for the rest of the completion walk.

Fixes: 67d0338edd71 ("nfs: page group syncing in read path")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/read.c            | 25 ++++++++++++++++++++++++-
 include/linux/nfs_page.h |  1 +
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 3c1fa320b3f1bd..fe41e42729944c 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -132,10 +132,32 @@ static void nfs_readpage_release(struct nfs_page *req, int error)
 
 static void nfs_page_group_set_uptodate(struct nfs_page *req)
 {
-	if (nfs_page_group_sync_on_bit(req, PG_UPTODATE))
+	bool uptodate = false;
+
+	nfs_page_group_lock(req);
+	if (!test_bit(PG_READ_FAILED, &req->wb_head->wb_flags) &&
+	    nfs_page_group_sync_on_bit_locked(req, PG_UPTODATE))
+		uptodate = true;
+	nfs_page_group_unlock(req);
+
+	if (uptodate)
 		folio_mark_uptodate(nfs_page_to_folio(req));
 }
 
+static void nfs_page_group_mark_read_failed(struct nfs_page *req)
+{
+	struct nfs_page *tmp;
+
+	nfs_page_group_lock(req);
+	set_bit(PG_READ_FAILED, &req->wb_head->wb_flags);
+	tmp = req;
+	do {
+		clear_bit(PG_UPTODATE, &tmp->wb_flags);
+		tmp = tmp->wb_this_page;
+	} while (tmp != req);
+	nfs_page_group_unlock(req);
+}
+
 static void nfs_read_completion(struct nfs_pgio_header *hdr)
 {
 	unsigned long bytes = 0;
@@ -172,6 +194,7 @@ static void nfs_read_completion(struct nfs_pgio_header *hdr)
 			if (bytes <= hdr->good_bytes)
 				nfs_page_group_set_uptodate(req);
 			else {
+				nfs_page_group_mark_read_failed(req);
 				error = hdr->error;
 				xchg(&nfs_req_openctx(req)->error, error);
 			}
diff --git a/include/linux/nfs_page.h b/include/linux/nfs_page.h
index 9aed39abc94bc3..cf085f7f65cddd 100644
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -33,6 +33,7 @@ enum {
 	PG_TEARDOWN,		/* page group sync for destroy */
 	PG_UNLOCKPAGE,		/* page group sync bit in read path */
 	PG_UPTODATE,		/* page group sync bit in read path */
+	PG_READ_FAILED,		/* page group saw a read error */
 	PG_WB_END,		/* page group sync bit in write path */
 	PG_REMOVE,		/* page group sync bit in write path */
 	PG_CONTENDED1,		/* Is someone waiting for a lock? */
-- 
2.53.0



