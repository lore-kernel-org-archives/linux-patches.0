Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435FD19444
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ4HbEmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B294CC433C7;
	Mon,  9 Oct 2023 13:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856993;
	bh=SvQF6HEJ4Iqni93ujiKR1KEqKTgT5ML3Idf1vw/F3Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJ4HbEmpFl9qsJWalAj3MkpCBo29jYEXjQS2sVn0kyoAIm0wYIakR3rJR2oo/Xl6H
	 V0gD/3QNPoqk42qabyTLwSJvs9Ki7jHjd0rzcI9JSdpZWosIFi9ie8QcTk2W+MR35Z
	 Dx4RX6ob96R9/FYzAuDUrRE1Jy0OZ4pivBmk5SkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 059/163] erofs: fix memory leak of LZMA global compressed deduplication
Date: Mon,  9 Oct 2023 15:00:23 +0200
Message-ID: <20231009130125.664636564@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 75a5221630fe5aa3fedba7a06be618db0f79ba1e ]

When stressing microLZMA EROFS images with the new global compressed
deduplication feature enabled (`-Ededupe`), I found some short-lived
temporary pages weren't properly released, which could slowly cause
unexpected OOMs hours later.

Let's fix it now (LZ4 and DEFLATE don't have this issue.)

Fixes: 5c2a64252c5d ("erofs: introduce partial-referenced pclusters")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230907050542.97152-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor_lzma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index 73091fbe3ea45..dee10d22ada96 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -217,9 +217,12 @@ int z_erofs_lzma_decompress(struct z_erofs_decompress_req *rq,
 			strm->buf.out_size = min_t(u32, outlen,
 						   PAGE_SIZE - pageofs);
 			outlen -= strm->buf.out_size;
-			if (!rq->out[no] && rq->fillgaps)	/* deduped */
+			if (!rq->out[no] && rq->fillgaps) {	/* deduped */
 				rq->out[no] = erofs_allocpage(pagepool,
 						GFP_KERNEL | __GFP_NOFAIL);
+				set_page_private(rq->out[no],
+						 Z_EROFS_SHORTLIVED_PAGE);
+			}
 			if (rq->out[no])
 				strm->buf.out = kmap(rq->out[no]) + pageofs;
 			pageofs = 0;
-- 
2.40.1



