Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61F5423A62;
	Tue, 31 Mar 2026 17:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976404; cv=none; b=WBkcf8INQrZfqjyiAMULjsGzGQxPuJ0dmNAoi4FEifzk6EYCxpqzkvJJwx8p3mdFT48dnx79tLiudwhKlpoMjNeiWtdMjWj9y2WoQ3gJaQt6bwiNo6gh4wgXcW7Yiu6+7TM3tZEInahrLMSqXEN3/iNTbmD5opmbsuMDh78uNVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976404; c=relaxed/simple;
	bh=0Qlle7kK7BSgRfmctvfDE5g7PA5H1XR7eL1Pto46faM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCjkHiYTZBHvo9DN2+c2SziFZEFJkunLHhA8XW4ABe9nV5DFJJB1uxlcXKTfAp6gYxbiMlW5S45BrYegt7hooeMrnWExEFQ8l4ScyCueup4UVIT24uWK2h+lC+Bye6xv8r4JOW5dUU5uaQSuGdNMLTb/JGIoogOU7oOiHxKE0Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oF/qGBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oF/qGBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DABAC19423;
	Tue, 31 Mar 2026 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976404;
	bh=0Qlle7kK7BSgRfmctvfDE5g7PA5H1XR7eL1Pto46faM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oF/qGBasVUJZiQINchL+2Mu2S//WndQMmJH+qPOhZ1fFE1ezadnF/+VetZqDIEd0
	 x2TfJAeOW7zOzSVcHCTil6+V3KxV/G7FbxPal8+T7L7eo8JaNkt7abPPZOsrPxZxeG
	 tNjsJsjvYdUZEDl+I3G2V82YJEaWwhRRMm/7Fauo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chenguanyou <chenguanyou@xiaomi.com>,
	Yunlei He <heyunlei@xiaomi.com>,
	Sheng Yong <shengyong1@xiaomi.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/309] erofs: set fileio bio failed in short read case
Date: Tue, 31 Mar 2026 18:19:42 +0200
Message-ID: <20260331161756.395878647@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Sheng Yong <shengyong1@xiaomi.com>

[ Upstream commit eade54040384f54b7fb330e4b0975c5734850b3c ]

For file-backed mount, IO requests are handled by vfs_iocb_iter_read().
However, it can be interrupted by SIGKILL, returning the number of
bytes actually copied. Unused folios in bio are unexpectedly marked
as uptodate.

  vfs_read
    filemap_read
      filemap_get_pages
        filemap_readahead
          erofs_fileio_readahead
            erofs_fileio_rq_submit
              vfs_iocb_iter_read
                filemap_read
                  filemap_get_pages  <= detect signal
              erofs_fileio_ki_complete  <= set all folios uptodate

This patch addresses this by setting short read bio with an error
directly.

Fixes: bc804a8d7e86 ("erofs: handle end of filesystem properly for file-backed mounts")
Reported-by: chenguanyou <chenguanyou@xiaomi.com>
Signed-off-by: Yunlei He <heyunlei@xiaomi.com>
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fileio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index 5b77ee8cc99f4..740efd2097bf1 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -25,10 +25,8 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 			container_of(iocb, struct erofs_fileio_rq, iocb);
 	struct folio_iter fi;
 
-	if (ret >= 0 && ret != rq->bio.bi_iter.bi_size) {
-		bio_advance(&rq->bio, ret);
-		zero_fill_bio(&rq->bio);
-	}
+	if (ret >= 0 && ret != rq->bio.bi_iter.bi_size)
+		ret = -EIO;
 	if (!rq->bio.bi_end_io) {
 		bio_for_each_folio_all(fi, &rq->bio) {
 			DBG_BUGON(folio_test_uptodate(fi.folio));
-- 
2.51.0



