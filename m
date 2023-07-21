Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A93220F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CF4C433C8;
	Fri, 21 Jul 2023 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967210;
	bh=qK7T5UjBpI9uIvzNn8qNCy7/FF7AT8/dyzfqNPzR9A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7oohGfFH9nTL8cUuecj9E8iRYNIrSDe2RXrtN9/nM7OxnyXWaIkCkLtV9qJkXn7j
	 RdaO65SrLmXrAYAixii9abGFDZbV8LpKstAFupLYEagvsA22/LIHv7lQRHAHd40kvh
	 w2eL6F8xnVeKK9CjWSvNTJHgsG39ifuTvPyuTdd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Yin <yinxin.x@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/223] erofs: fix fsdax unavailability for chunk-based regular files
Date: Fri, 21 Jul 2023 18:05:07 +0200
Message-ID: <20230721160523.156508026@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Yin <yinxin.x@bytedance.com>

[ Upstream commit 18bddc5b67038722cb88fcf51fbf41a0277092cb ]

DAX can be used to share page cache between VMs, reducing guest memory
overhead. And chunk based data format is widely used for VM and
container image. So enable dax support for it, make erofs better used
for VM scenarios.

Fixes: c5aa903a59db ("erofs: support reading chunk-based uncompressed files")
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230711062130.7860-1-yinxin.x@bytedance.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 5aadc73d57652..e090bcd46db14 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -186,7 +186,8 @@ static void *erofs_read_inode(struct erofs_buf *buf,
 
 	inode->i_flags &= ~S_DAX;
 	if (test_opt(&sbi->opt, DAX_ALWAYS) && S_ISREG(inode->i_mode) &&
-	    vi->datalayout == EROFS_INODE_FLAT_PLAIN)
+	    (vi->datalayout == EROFS_INODE_FLAT_PLAIN ||
+	     vi->datalayout == EROFS_INODE_CHUNK_BASED))
 		inode->i_flags |= S_DAX;
 	if (!nblks)
 		/* measure inode.i_blocks as generic filesystems */
-- 
2.39.2



