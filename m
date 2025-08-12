Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CC8305E2D;
	Tue, 12 Aug 2025 19:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026367; cv=none; b=m2J4xgzgBjHMN6YvzpXWAuccvUYYqvaCQ0kJHW27WBsHhxnYK91jh0G4qhZQ+A+gyhXzXKigzJReSizTWIQaI3EiYgydwKprCXDcv8xK38zDvHH90BIgPCBVAPw+KwSHLlJB5Pgoda+eyzZpNpvObfEVv0FZdmOSuRNe6nLXSG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026367; c=relaxed/simple;
	bh=QgUoqy6rOM0tg80aDXK6Bf35re687tIhSR4aLQqFQKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meE9wCTNfJiBBRXGnPVZIS05BsApa8rau8T9UqrY09TG9+7olShGKvUjXIEHwQMiKLSx+qsb7Ao4iVxoAKSKP0S0Dm56lBu+u3w+s/DnxkJbJMnlmXjIZ0YFLiZAXBuEkkQCyTwep4nMH4rOynS9VLcvczN1Us44eIsaeY8U+Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF7E8wtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF7E8wtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31703C4CEF0;
	Tue, 12 Aug 2025 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026367;
	bh=QgUoqy6rOM0tg80aDXK6Bf35re687tIhSR4aLQqFQKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XF7E8wtkXHK0DC0pK3kh+HJl1dPTfafqZoYP+62i5tZbVC22WoJhXFEgJJ+9T6Plb
	 wwQJ0JlzYcUZXvCvNEggKGS14ojYCVxXhA/3PlmCOzQhHzJxVc09KbCS/j6oXjndCL
	 CvpJAPyQOAVpsfmFVfRWGJu+OPEtDBgUxW4FhFms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yu <zheng.yu@northwestern.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 316/480] jfs: fix metapage reference count leak in dbAllocCtl
Date: Tue, 12 Aug 2025 19:48:44 +0200
Message-ID: <20250812174410.465493990@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 35e063c9f3a4..5a877261c3fe 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1809,8 +1809,10 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
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



