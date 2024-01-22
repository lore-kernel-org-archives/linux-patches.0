Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8280B5DF15;
	Tue, 23 Jan 2024 00:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970554; cv=none; b=i3lP09I59DFKZxV+TgceWgs947w8KGY8le4GtZVgL+vClg6IhxdmIUufmVWocD8LGWkPZSqZrlrBqOKGp9B+4G2m0ORxfvspVb8m+XBLW2Nfe3nZajpEqx2VsxrroDWtiKIyAtEdVyJ17rh7aJ5NrJoZuh1EBB8DIZwMNe5TOQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970554; c=relaxed/simple;
	bh=GJv42Ns44PvxrP/8BqO033q8AAFL+lXhPwuoRPUZ1dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ7Hcj6J3BtDxJl4bAmmxwJMjLqF54uPUqaZTP2EY9bVTXgcQtOLdWNN75Mqf5gr1Ds6pdMzkMywnAnvnxG2tmkayAxRSrasSc2SRghD2M4ak0mackecTPSBWEExvH1Z0vbGBLbLesTaWa5uhKLDofpMrhlBiKYnm8U1lfRGBGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixZpiW44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixZpiW44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9024C43390;
	Tue, 23 Jan 2024 00:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970554;
	bh=GJv42Ns44PvxrP/8BqO033q8AAFL+lXhPwuoRPUZ1dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixZpiW44hr31UwryXGWgKD5RMU+SnSWSc/cZvl7iufPkjWjW+p5TeN8SVLdL90XM5
	 RAhNquK3CnlijiY6L34h41YmxAcQXNOLaq8PXq21FVqb80UTwikewOOTy7PquTJsxv
	 nfzAHKT+7M0g+XiOi1OvDUmmILuKs+QVrsqojTqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/417] erofs: fix memory leak on short-lived bounced pages
Date: Mon, 22 Jan 2024 15:53:39 -0800
Message-ID: <20240122235753.443183583@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1b91ac5be961..cf9a2fa7f55d 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1192,12 +1192,11 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
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



