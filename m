Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0F033D6F7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301628; cv=none; b=MglJgk6bALnSb4YT7lmZPJO+BdQwa05LEKt1nohdlSeVZaUqk07rPU/ZXXHavSb2rWZf0YYtExpY0b9Be3mu7lqUlmMRWXD2AuVlMSPZmjYR2iZ4xqw105AvOZGe6XbUSaODIdi3896Yw2BBOnT1R4Tqwxx1Dway7/DkClHk0r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301628; c=relaxed/simple;
	bh=SOzyJEmZKHIu531OwX7ODBHCplP8qcT9onnS5S7Cjm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKPPrOy36bclfr+e3+TW0op4uDZTOxLkWFqQy2Ej7f87CarkQaBpD64CEPBHIu4LxtDjq+/cCJi0zkKypY+aGPqvP9JBipS8jI9aXsv4f2IXc0QsVMpjKHQVj8jM9V4fx7AHcX5IGZ5dDgRmp8fS6aHDMXtecYYvpY89bSPCNAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6mxqfAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6mxqfAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCC7C19424;
	Sat, 28 Feb 2026 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301628;
	bh=SOzyJEmZKHIu531OwX7ODBHCplP8qcT9onnS5S7Cjm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6mxqfAKxBoiI9M0M0yXhSsy3a4o7F6nzvYmXx8o+BiRpiTBjDHVzS9dOm3Q5Gkc4
	 bqchcfIsOeMC1unUP+p1+/rbW0fiCbL2cAIKYcEDUH7LL9wOl9C4V0OCeigPnDriG+
	 OsALdPErb48MniB8ctMCYoL5sEopC404ycE+eSz6h8bGXewgY4EjAIJnew3NDf0JKP
	 ZVtOjo7l8wiCGEfTMswLbll74OMexKt8IF3vENwphNz1cXjjqnCBBm6eWZhVtDkbQe
	 H4MkKVyQunXzM7AL7BIQCoYlTAuxxYYKvCJvISkMnTfqdeYIfezPs9vshgf9jYo62M
	 hMX8LvJJViYyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/385] erofs: handle end of filesystem properly for file-backed mounts
Date: Sat, 28 Feb 2026 12:54:02 -0500
Message-ID: <20260228180011.1568201-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit bc804a8d7e865ef47fb7edcaf5e77d18bf444ebc ]

I/O requests beyond the end of the filesystem should be zeroed out,
similar to loopback devices and that is what we expect.

Fixes: ce63cb62d794 ("erofs: support unencoded inodes for fileio")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fileio.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index bc2c9fb44236e..2c7f066daacdd 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -25,21 +25,17 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 			container_of(iocb, struct erofs_fileio_rq, iocb);
 	struct folio_iter fi;
 
-	if (ret > 0) {
-		if (ret != rq->bio.bi_iter.bi_size) {
-			bio_advance(&rq->bio, ret);
-			zero_fill_bio(&rq->bio);
-		}
-		ret = 0;
+	if (ret >= 0 && ret != rq->bio.bi_iter.bi_size) {
+		bio_advance(&rq->bio, ret);
+		zero_fill_bio(&rq->bio);
 	}
-	if (rq->bio.bi_end_io) {
-		if (ret < 0 && !rq->bio.bi_status)
-			rq->bio.bi_status = errno_to_blk_status(ret);
-	} else {
+	if (!rq->bio.bi_end_io) {
 		bio_for_each_folio_all(fi, &rq->bio) {
 			DBG_BUGON(folio_test_uptodate(fi.folio));
-			erofs_onlinefolio_end(fi.folio, ret, false);
+			erofs_onlinefolio_end(fi.folio, ret < 0, false);
 		}
+	} else if (ret < 0 && !rq->bio.bi_status) {
+		rq->bio.bi_status = errno_to_blk_status(ret);
 	}
 	bio_endio(&rq->bio);
 	bio_uninit(&rq->bio);
@@ -50,7 +46,7 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
 {
 	struct iov_iter iter;
-	int ret;
+	ssize_t ret;
 
 	if (!rq)
 		return;
-- 
2.51.0

