Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9D31E89C;
	Tue, 27 May 2025 17:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366483; cv=none; b=JD/vecyrIa3FcUSmaxSYyNygi0/EFajhpTRzrKOAWczWxRb4qbh59wAQnidQaXaZkBikNr8bNctFYrtssT4vkpmSo70lcNjCcqrcftZAIiuD4EWzY4xHKgDqasPlZmO7Vq9DtyYKAZIOoIJmMwr4eYGm0XK2gro2DPrxNnOalaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366483; c=relaxed/simple;
	bh=IECHKevkFWoh1HpsRRwG4mdHrYSu6XnUouTRQuVNkN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9gCTaDY8QeM27Mjwxvv5zV5eMvgN/9X0OQ9CZA7n+xTv5sNCoR+IQ2TlNoEOhy7+zS1wehCV0y6frfQ/zxaFIPVA0Eq4tgF1MLSJ0ftY0RLjmOyLFbjUJdW+hiOdlTRzBtpJrWV9L7wDsuxjFG+y1haTdtn9wBXb3dVstTkGVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWHrufte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWHrufte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C1DC4CEE9;
	Tue, 27 May 2025 17:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366483;
	bh=IECHKevkFWoh1HpsRRwG4mdHrYSu6XnUouTRQuVNkN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWHrufte7PtbdeGeMOUMdYuVNAE/MOCC5L/dv0h369ODXr8FVQs32OA5oiUMdLK76
	 P+7cfE5vNAPM3vxEJMf4/YeXkIGuSfbjSOBXqmbnet5qjh3xPy8WWh/UysCSyBVK+O
	 FTtOrTx2ONOd4iAadn70e6IH9rKZ2Q1XAWHomLao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 052/783] fuse: Return EPERM rather than ENOSYS from link()
Date: Tue, 27 May 2025 18:17:29 +0200
Message-ID: <20250527162515.248427776@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 8344213571b2ac8caf013cfd3b37bc3467c3a893 ]

link() is documented to return EPERM when a filesystem doesn't support
the operation, return that instead.

Link: https://github.com/libfuse/libfuse/issues/925
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 3b031d24d3691..8f699c67561fa 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1137,6 +1137,8 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	else if (err == -EINTR)
 		fuse_invalidate_attr(inode);
 
+	if (err == -ENOSYS)
+		err = -EPERM;
 	return err;
 }
 
-- 
2.39.5



