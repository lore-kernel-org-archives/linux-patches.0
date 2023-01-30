Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302B028EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13AEC433EF;
	Mon, 30 Jan 2023 13:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087018;
	bh=O4AOiPTScS8CAvcfXnyo72MTwMlCfaSHyw2mQUvFu4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKJgUxkbVyJEJTZUGJd4lol708r8PPhPcGtJ4dOwnDxt17gfHnyM7byIsRzxtdE3c
	 eXGd9e06lUG5COVbLrOidrAoyN5fUkGG0hDL2ogapMSkKahcZ0JiS7PWeScUECLl1C
	 gnZcZHPG4trEPJlvcKxhpKhpEgFLn2PB4HNY0k7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c3729cda01706a04fb98@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/313] erofs: fix kvcalloc() misuse with __GFP_NOFAIL
Date: Mon, 30 Jan 2023 14:47:58 +0100
Message-Id: <20230130134338.693382044@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 12724ba38992bd045e92a9a88a868a530f89d13e ]

As reported by syzbot [1], kvcalloc() cannot work with  __GFP_NOFAIL.
Let's use kcalloc() instead.

[1] https://lore.kernel.org/r/0000000000007796bd05f1852ec2@google.com

Reported-by: syzbot+c3729cda01706a04fb98@syzkaller.appspotmail.com
Fixes: fe3e5914e6dc ("erofs: try to leave (de)compressed_pages on stack if possible")
Fixes: 4f05687fd703 ("erofs: introduce struct z_erofs_decompress_backend")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230110074927.41651-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index cf4871834ebb..ee7c88c9b5af 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1047,12 +1047,12 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 
 	if (!be->decompressed_pages)
 		be->decompressed_pages =
-			kvcalloc(be->nr_pages, sizeof(struct page *),
-				 GFP_KERNEL | __GFP_NOFAIL);
+			kcalloc(be->nr_pages, sizeof(struct page *),
+				GFP_KERNEL | __GFP_NOFAIL);
 	if (!be->compressed_pages)
 		be->compressed_pages =
-			kvcalloc(pclusterpages, sizeof(struct page *),
-				 GFP_KERNEL | __GFP_NOFAIL);
+			kcalloc(pclusterpages, sizeof(struct page *),
+				GFP_KERNEL | __GFP_NOFAIL);
 
 	z_erofs_parse_out_bvecs(be);
 	err2 = z_erofs_parse_in_bvecs(be, &overlapped);
@@ -1100,7 +1100,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 	}
 	if (be->compressed_pages < be->onstack_pages ||
 	    be->compressed_pages >= be->onstack_pages + Z_EROFS_ONSTACK_PAGES)
-		kvfree(be->compressed_pages);
+		kfree(be->compressed_pages);
 	z_erofs_fill_other_copies(be, err);
 
 	for (i = 0; i < be->nr_pages; ++i) {
@@ -1119,7 +1119,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 	}
 
 	if (be->decompressed_pages != be->onstack_pages)
-		kvfree(be->decompressed_pages);
+		kfree(be->decompressed_pages);
 
 	pcl->length = 0;
 	pcl->partial = true;
-- 
2.39.0



