Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FDF4218AF;
	Tue, 31 Mar 2026 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975710; cv=none; b=YR3hAg4e8x8CtHj27rb4o2tIElbpWM9TkMzwYWnJN8MjCG7IIxUFdLHgRTHGrwEsKKnSM4S3XFl05rsKBFSfPliGbz0jG6NxYwRQ9aO7ArJr1FCV8iYmt6agSs7vct1y1RpNzXo80k28CY9QTkXS4P9IJZkXdWi2iWv2+4pAf6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975710; c=relaxed/simple;
	bh=4yxndi37QZSCY5RcbYlOnLX56AEg6Z4ZJTCWjlc92D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRNhZqRme/yp46sDhopr8pHqG+dn97oT1qIhib1DkPt1Kl4nliIKYNSUULaW7bm40UU+S8/BLDAXCTlx0KzfU0LJFsN391mnmW/xfk0VBihFEwNBtDaf3ZaD2BoZNLGeWLSQ3PUrVqg9USQZ0r2BCA/3f04ly1ujKfKkZRnF3KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyNsG5k5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyNsG5k5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520C5C19423;
	Tue, 31 Mar 2026 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975709;
	bh=4yxndi37QZSCY5RcbYlOnLX56AEg6Z4ZJTCWjlc92D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyNsG5k5uRaycS6sqxSncyZmrnF6HN/m5XZcAsrW1NTgdH7Utg4VL3unSXTbu0Ajt
	 YthAQFdKWRVUwUvVdwZZGoVpd1DMSm0KHBeSbtv31EZIcNnP0xMauz50CJ5mf/KYNS
	 ntwI0TdHkpj/tDu22GMXZdbzO4Yaj9+2HXBpZnHo=
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
Subject: [PATCH 6.12 056/244] erofs: set fileio bio failed in short read case
Date: Tue, 31 Mar 2026 18:20:06 +0200
Message-ID: <20260331161743.761275876@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index 2c7f066daacdd..2c46c69f43295 100644
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



