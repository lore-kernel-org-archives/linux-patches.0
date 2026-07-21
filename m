Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AF24195C9;
	Tue, 21 Jul 2026 19:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660507; cv=none; b=Gffx2JFCKKO4Y2/o9HkaD9PM8TbZMzlXRosT25ADcO2IZL6wrk4ogtfWvBxctFvP7v7LB6vBMUQpLzKfsff0tx6ab9emzuAKYEA1fGd8IMtQaTktuk3AiVFm52NoAV0vNvZDVSCjDtMu896BTHH3HDkYUSlTVM3+YO5XCPBL7Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660507; c=relaxed/simple;
	bh=bkT6eBrrjoSk5HIEQ7cIqorQbnDDpCHmcJGqd6Ej/F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jd5gSz+HyqWHAi3TeST+WOmRRF0Mmr45xIfoybee97SwrhAdpW19qX6jxj//hdNzQ9NnpyduypSkjkXfjBhcfcTFoQweuQVrhsjTxHkTc/DNNIsOqOjZblDdqk0ljNEqKEA89iml0h1bydYj+EHfIfjyBppKeq+/S4MH2m8UENk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O++sMa+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O++sMa+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACF11F00A3A;
	Tue, 21 Jul 2026 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660504;
	bh=geNp5sSju8bvive3ZOa7Xo6BxO1uQ04AMTjbAa0XPhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O++sMa+eWqIZvRwM1sykfJ7+pziyS7Ak2Ay2V4b0nkAp6Gz/7CEwuKUDPbh4pixNE
	 xK+U99amAJZsV48mdgiqiP7y2ee8Mi32wePRp6DB5/jjti3PQ4nGWakluib66TrUp0
	 nczMfstO+VD5ZQ3VJfBRtqziXChLVDDkB7DjBtOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0968/2077] nfs: keep PG_UPTODATE clear after read errors in page groups
Date: Tue, 21 Jul 2026 17:10:41 +0200
Message-ID: <20260721152615.654755061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e1fe78d7b8d0ff..2b70bd2b934b9a 100644
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
index afe1d8f09d89f8..4b9a35dbc062da 100644
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



