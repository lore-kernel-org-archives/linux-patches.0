Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B25FBA34;
	Mon,  6 Jan 2025 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179075; cv=none; b=FxXTG51SR4hhLZZj/uP+a8DuH7L+FraM+7YoXR4j2N6lkts6bc7t2YvmpdCMmJZxLrvbgIJqhGFjDSSf01rWZFWXrNbFjBcF6tcNsd8onoSDafSyhFEyf3a3L6yoKCpm3amSek4BLjrRLwxF8mVZkPz3FnIuDESCZaFLVN893zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179075; c=relaxed/simple;
	bh=qTMB2zLKvp5caWdfhnF5EJaV5WOM2qjj9L4SrmTsVj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mti69Hr949pMb/840fngLhuxXtBBg9en+a5vuG3L0bLywq4mgz6JcxPOOih7ENfYOeVx/pc2Ki3VUB5W+zcnjY+VW/VvJZDk3p4tivHRUzBaSYf2o3yYuaEBeGDOZ0PRsXGN8LJxedkqWs3I1OFq1gPsmA61hvvq6gIqO2V5DzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2heewfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2heewfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E412DC4CED2;
	Mon,  6 Jan 2025 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179075;
	bh=qTMB2zLKvp5caWdfhnF5EJaV5WOM2qjj9L4SrmTsVj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2heewfYxAfpTWSmQhIp8IV1O+PniiLYZvoSqbUWg3UVObgk6vNjciVmADgtCq8YH
	 xaPKyWzqbKCse7NbUU3T+PXYDaRvPpxzxDqJrDXDMsg9W4AEuQT8ZSAb55faq3iEM5
	 xDHcnz9Hcz3p+dL9LN7XHbSOhMzhOOafJ0cGueyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f966c13b1b4fc0403b19@syzkaller.appspotmail.com,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/93] erofs: fix order >= MAX_ORDER warning due to crafted negative i_size
Date: Mon,  6 Jan 2025 16:16:44 +0100
Message-ID: <20250106151129.012013987@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 1dd73601a1cba37a0ed5f89a8662c90191df5873 upstream.

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
index 0dbeaf68e1d6..ba981076d6f2 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -202,7 +202,7 @@ static int erofs_fill_symlink(struct inode *inode, void *data,
 
 	/* if it cannot be handled with fast symlink scheme */
 	if (vi->datalayout != EROFS_INODE_FLAT_INLINE ||
-	    inode->i_size >= PAGE_SIZE) {
+	    inode->i_size >= PAGE_SIZE || inode->i_size < 0) {
 		inode->i_op = &erofs_symlink_iops;
 		return 0;
 	}
-- 
2.39.5



