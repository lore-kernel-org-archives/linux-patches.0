Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8324821D596;
	Wed, 25 Feb 2026 01:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982885; cv=none; b=QrEdKQTyqxMJlq7y9zVjEhuGweNzLucJTg5Fqsz3C9Q7oU6ZJtJc2Y2moQZgxE88T/T3IWHoVxnsRGI5i/ok8SnWHmFXalgD0exIfthfjZDCvW3gxPajRfv90QJ9NyL30V6/43YKW2PFJpAeuzFuAcc86U8JGA234SMp2r97Bu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982885; c=relaxed/simple;
	bh=f+TWwylB06KOgXOdjQQy9TOoATFamGMs2ea8J1PBiJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONvwgrmXPt0jiqxaywBRVSg7mzNtCQhMOxbrxUNAgSkJiWAqDDo8pZ3rvBsCCFNATupD9O0tOWoO6dzjsat0uJDo1ZP570OprOLt0tNM95ZllzLPU7OuWDZ7E/NnIgB59mc70jTc0xBsL3/0gu3bQiokxScG2rmAROPpy1PDZeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoefOvII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoefOvII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1E5C116D0;
	Wed, 25 Feb 2026 01:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982885;
	bh=f+TWwylB06KOgXOdjQQy9TOoATFamGMs2ea8J1PBiJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoefOvIIGF2J0+/etNNqnhPS3Z09+XeFAXmUsabUWB9lMCJ93/SAq1FC0UsPZMy8T
	 zLaDSxacfGfPpfNdlJEAmXR0J6C+AoJ5X3yKBnFo+wCuczFY/8TI57bbM+OzNoA7OU
	 tr+0mjv8vDTVE97iq8mkldWN5RbBIT1zInUcrI3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 026/781] erofs: handle end of filesystem properly for file-backed mounts
Date: Tue, 24 Feb 2026 17:12:15 -0800
Message-ID: <20260225012400.341829218@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 1673c5416fba1..2a778a02681a0 100644
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



