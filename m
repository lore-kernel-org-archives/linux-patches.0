Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5681015C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1189C433D6;
	Mon,  5 Dec 2022 19:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268795;
	bh=uX9pye5y8zlsZPEPmAbioGWdQIZXZjdHpdgBNDIJKh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDmwvWjKn2FfJ1t3Ye/P+b0fov3ZxMUmz6FqnJmSfvwSALSxdtQn0VbBO6ysEhCsZ
	 zgLPaW5M2/8HvIJaDy/zvbv0Tpb2nUvY8VQD3PcCJQ/SgYOGjc3S6f6i48Fiz6sHRX
	 YjKV8VSdTUQSNf+kBGmAYklJMXPLSfjQYDIw8CPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f966c13b1b4fc0403b19@syzkaller.appspotmail.com,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/120] erofs: fix order >= MAX_ORDER warning due to crafted negative i_size
Date: Mon,  5 Dec 2022 20:09:04 +0100
Message-Id: <20221205190806.676284261@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

[ Upstream commit 1dd73601a1cba37a0ed5f89a8662c90191df5873 ]

As syzbot reported [1], the root cause is that i_size field is a
signed type, and negative i_size is also less than EROFS_BLKSIZ.
As a consequence, it's handled as fast symlink unexpectedly.

Let's fall back to the generic path to deal with such unusual i_size.

[1] https://lore.kernel.org/r/000000000000ac8efa05e7feaa1f@google.com

Reported-by: syzbot+f966c13b1b4fc0403b19@syzkaller.appspotmail.com
Fixes: 431339ba9042 ("staging: erofs: add inode operations")
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Link: https://lore.kernel.org/r/20220909023948.28925-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index a552399e211d..0c293ff6697b 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -222,7 +222,7 @@ static int erofs_fill_symlink(struct inode *inode, void *data,
 
 	/* if it cannot be handled with fast symlink scheme */
 	if (vi->datalayout != EROFS_INODE_FLAT_INLINE ||
-	    inode->i_size >= PAGE_SIZE) {
+	    inode->i_size >= PAGE_SIZE || inode->i_size < 0) {
 		inode->i_op = &erofs_symlink_iops;
 		return 0;
 	}
-- 
2.35.1



