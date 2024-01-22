Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E131A5A7B8;
	Tue, 23 Jan 2024 01:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974352; cv=none; b=GSTNoBmvpWb+o/2vvhLnk5XCDUbJ5WU8LN+4r3WCOD5vd0Xy8wNNDfKS90j4xZXe3X5ieHCv+6IKECSVAkfW36BTVu1hBCQ2xxrERmMFHcz9oBNUP/gNxKxpHumS+zqZnQByKq4ipxP83RnXTOZzjY5EmdHzqjS1fDd5E3H9mbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974352; c=relaxed/simple;
	bh=fbZRUCrxvH2l9HtJWm3v+o4clJOz/kZUGEia2jAYRk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DS3pk0eXEWyUMCOU5W1H+1orH/Gn2VF6i21x2xdxiHPZ7ncjXoh7oe2JRZHIBP8J2RB6ICn9Rpqa9FwDQavOCOBxfW3dBCXO7FHLTA4a0e4r4ywGMUnY4QrfRN6JOurey48tSqOb0obn+xli9jMSHIuk03Jsm7Uk7oer91rLjRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsGt+yxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsGt+yxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCCFC433F1;
	Tue, 23 Jan 2024 01:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974351;
	bh=fbZRUCrxvH2l9HtJWm3v+o4clJOz/kZUGEia2jAYRk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsGt+yxWNiycB/vPQLyYpWcD/wAweOMRxuFVeRBKD+mKrIEkMyAhDcgoKOVvM1A2z
	 AyXWC6eAdsyqma0GXkxR1MWvraJ4acZGIhVC15LcdhmlIhAm7Oo+wzBgojKFz7pjmx
	 ZSym+FvevygANDGLsa2+N9xjPkQmaHaXin0w/rzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/583] erofs: fix memory leak on short-lived bounced pages
Date: Mon, 22 Jan 2024 15:51:52 -0800
Message-ID: <20240122235813.993590053@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 93d6fda7f926451a0fa1121b9558d75ca47e861e ]

Both MicroLZMA and DEFLATE algorithms can use short-lived pages on
demand for the overlapped inplace I/O decompression.

However, those short-lived pages are actually added to
`be->compressed_pages`.  Thus, it should be checked instead of
`pcl->compressed_bvecs`.

The LZ4 algorithm doesn't work like this, so it won't be impacted.

Fixes: 67139e36d970 ("erofs: introduce `z_erofs_parse_in_bvecs'")
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20231128180431.4116991-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index a7e6847f6f8f..a33cd6757f98 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1309,12 +1309,11 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 		put_page(page);
 	} else {
 		for (i = 0; i < pclusterpages; ++i) {
-			page = pcl->compressed_bvecs[i].page;
+			/* consider shortlived pages added when decompressing */
+			page = be->compressed_pages[i];
 
 			if (erofs_page_is_managed(sbi, page))
 				continue;
-
-			/* recycle all individual short-lived pages */
 			(void)z_erofs_put_shortlivedpage(be->pagepool, page);
 			WRITE_ONCE(pcl->compressed_bvecs[i].page, NULL);
 		}
-- 
2.43.0



