Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB291F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D02BC433C8;
	Fri, 21 Jul 2023 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955959;
	bh=p+ta6kh3doQDH2PjT9w1qzxfNh0BKZvFwXSVaHwHfLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZ8cTWZj/uHx2dh4/i8iVHSw3os7DrnZNf80b+YhDyMHNW46Uyjb49+q+X7mC5mQB
	 nMmZY4pBGJu5HItxNxY3vXHHU5TT4ot5P2/TmOzyBz/8+NnOG4C5HIpz/iW5VlLJIH
	 kzSC6Qinq6ePhhTHaTkSyK1LD2PkW8sj8YPAHsuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Yin <yinxin.x@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 091/292] erofs: fix fsdax unavailability for chunk-based regular files
Date: Fri, 21 Jul 2023 18:03:20 +0200
Message-ID: <20230721160532.708073288@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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
index d70b12b81507f..e12592727a546 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -183,7 +183,8 @@ static void *erofs_read_inode(struct erofs_buf *buf,
 
 	inode->i_flags &= ~S_DAX;
 	if (test_opt(&sbi->opt, DAX_ALWAYS) && S_ISREG(inode->i_mode) &&
-	    vi->datalayout == EROFS_INODE_FLAT_PLAIN)
+	    (vi->datalayout == EROFS_INODE_FLAT_PLAIN ||
+	     vi->datalayout == EROFS_INODE_CHUNK_BASED))
 		inode->i_flags |= S_DAX;
 
 	if (!nblks)
-- 
2.39.2



