Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E1F350835;
	Tue, 26 Aug 2025 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217435; cv=none; b=oWov1x+QxbmUfHm8madaGMYYzYe4zN/85YrouiK5YpVm+QH+Qv+dVPZ3R58/qXjdP4lLi1wMOw6ZACsQ3OVf0cPRAAKvDgYsio13zq8FgAvJob1m4Qzz4VdHNMbPmd+lesMBhZFO3J1GRaBJNVfB/EXQ2JeJs0w4Z4bKOLcdHG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217435; c=relaxed/simple;
	bh=WN7HFyuD9oCRka0GLS5oWXVKeSM7BNtGwu4nyEv1mbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSD41qjFseQF/HqB7YK9oKb5r6FxJd+3+ztL4X2jBL7GyaI+cKArnuz0m+J/ccEYN5HJBmI6jFx0X6Zv6h96wVnB7hEf6F8wdCdhoYhVDShw9rM7LSqtWThvBn7y6tGvJG1DuQ1HqOtbmJVupdf7Zlk4JXKPCMMIJjhgIMWl3kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxMsnqaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxMsnqaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3745CC4CEF1;
	Tue, 26 Aug 2025 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217435;
	bh=WN7HFyuD9oCRka0GLS5oWXVKeSM7BNtGwu4nyEv1mbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxMsnqaUHFYMVqbhFbStZYtgcbDKbNmG0/2BrfeBZfRcVszaooBWeJkepoawNHSvL
	 HsJTNbjAX5elv4jxN0Wp35FKZMGJVkikMmu6MCIjJB9iTsi0vcGtn28vyJEoUi2bfJ
	 VisrxhN3HqrKuA+9rWJtX+0rmM9jdy7PbrKp07UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yu <zheng.yu@northwestern.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/523] jfs: fix metapage reference count leak in dbAllocCtl
Date: Tue, 26 Aug 2025 13:05:53 +0200
Message-ID: <20250826110928.021786454@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yu <zheng.yu@northwestern.edu>

[ Upstream commit 856db37592021e9155384094e331e2d4589f28b1 ]

In dbAllocCtl(), read_metapage() increases the reference count of the
metapage. However, when dp->tree.budmin < 0, the function returns -EIO
without calling release_metapage() to decrease the reference count,
leading to a memory leak.

Add release_metapage(mp) before the error return to properly manage
the metapage reference count and prevent the leak.

Fixes: a5f5e4698f8abbb25fe4959814093fb5bfa1aa9d ("jfs: fix shift-out-of-bounds in dbSplit")

Signed-off-by: Zheng Yu <zheng.yu@northwestern.edu>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 37888187b977..234b7cc4acfa 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1877,8 +1877,10 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
 
-		if (dp->tree.budmin < 0)
+		if (dp->tree.budmin < 0) {
+			release_metapage(mp);
 			return -EIO;
+		}
 
 		/* try to allocate the blocks.
 		 */
-- 
2.39.5



