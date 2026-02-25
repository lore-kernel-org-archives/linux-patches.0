Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3577D276050;
	Wed, 25 Feb 2026 01:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983725; cv=none; b=nn9ErlM7fcvj9SBjdUr+ueU4EC+A40JueVLoguHTEE4Zq4BksOgVyFFQbgS3UE292isY+qidfrEGLPBY05biTuHFI6v8Gp8kIzJkFusj3u9mVgGL+Df6u0qlegKjY1LOe41G96pjti56nIoVyhJRZiCBEg7eh2QHoSd7k7GNiCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983725; c=relaxed/simple;
	bh=aFxJKg0pDb8L1HxiOu6BZwTU7i+1s6ISfsbefU0XaXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taS32lR/sX6pSmdd2faB0x5cRnpJKUX8z7/X99uM0Fra9nFh6/x6yHDeQVGCBXCPR+6LMWPwv0kXtqcFgU8bGB3o1vOSRNYkDM2Zf6mMJZ2A7j/3NMOeQkXU1L9UaIJVA95VRSyISxIhV5b+G3w2wAtvq8cTHjlMMb4nFfQvALU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mU/jYbXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mU/jYbXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0057EC2BC86;
	Wed, 25 Feb 2026 01:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983725;
	bh=aFxJKg0pDb8L1HxiOu6BZwTU7i+1s6ISfsbefU0XaXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mU/jYbXHjm5dh1gTMsfBUo3FNvHbbYXfaVECBz4l7c4SHz6qfWplagvQGNaUPjWD1
	 CsO69GunLfeC3vArBawTkhKM5uhMagxG7Ex1gnFC64S+72bkcoWRYXOAyPrm7xUw97
	 lPxISfy5gyU/ktQGNFAZHRSiDMfjbLFfBtXPSLV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/641] erofs: handle end of filesystem properly for file-backed mounts
Date: Tue, 24 Feb 2026 17:15:47 -0800
Message-ID: <20260225012349.488110624@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index e2eaa7119bd4f..5b77ee8cc99f4 100644
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
@@ -51,7 +47,7 @@ static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
 {
 	const struct cred *old_cred;
 	struct iov_iter iter;
-	int ret;
+	ssize_t ret;
 
 	if (!rq)
 		return;
-- 
2.51.0



