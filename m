Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07C32EBB8D;
	Tue, 21 Jul 2026 20:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666368; cv=none; b=mhuU/k1//jfjE6p85fldj4l9WCdWHpozEPjYF08ZH6noL2zedtWlOOV9/vIrBDAEj75mDCQeyb6UZc5y2J6sSTI5FHVA688tAtfxM9CFJMVG5Kn509PovMq1tQKWk8r/3PED1IiorO+JWmKsKMSaiGRa7Ju8buvL+a8NJ6mRlpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666368; c=relaxed/simple;
	bh=8VszE0d81Qo5gZmpSEQ4US1uNBzyCKpZmNzLkJOg+VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGLHbBgyrQm94IprTTa+JfjunFu5nqowYpxHtNFWnXbXyZSHQHJR89mQgrKKNJ8rZvC0mkFqM0VsPSW5pjdZiR2BMEFYKJzCKeQ9lVntDvM6EBHNKiczyzLbtW9zB0lctc+m/Ddh9IEBGGxynJ5lyaIRjdrwrn8kV8U2XtldGuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+9UYzqa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+9UYzqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520241F00A3A;
	Tue, 21 Jul 2026 20:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666366;
	bh=17KHLKzpRK/z2LqluH7hZVQGG3z1XzpseCd5aAlhgiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j+9UYzqa+1Shn3UwWy2JMbje2W3oc4n0dDJ0bXT0/ndnbkNtdtL0h9lZoJyACWXgE
	 MJ0jlA3qSXfkC+UJJvXqopbr21jhU1A6Zxm9DmTFMx37MnzSi1p9hXe4DJbc9Jyzyn
	 gh+liOKVSoP3x7aqm+t0t6gbH4rFt86dK2tBh4iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0657/1266] nfs: keep PG_UPTODATE clear after read errors in page groups
Date: Tue, 21 Jul 2026 17:18:14 +0200
Message-ID: <20260721152456.560076642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index ed411897e33faf..bf0b6b91a1ec30 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -134,10 +134,32 @@ static void nfs_readpage_release(struct nfs_page *req, int error)
 
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
@@ -174,6 +196,7 @@ static void nfs_read_completion(struct nfs_pgio_header *hdr)
 			if (bytes <= hdr->good_bytes)
 				nfs_page_group_set_uptodate(req);
 			else {
+				nfs_page_group_mark_read_failed(req);
 				error = hdr->error;
 				xchg(&nfs_req_openctx(req)->error, error);
 			}
diff --git a/include/linux/nfs_page.h b/include/linux/nfs_page.h
index 6a46069c5a3689..dbffbd86c7ba37 100644
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



