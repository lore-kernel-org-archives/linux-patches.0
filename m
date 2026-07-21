Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF774189DA;
	Tue, 21 Jul 2026 22:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671674; cv=none; b=PluhkE1vsXJap9Zlk2s17Lf5uhnIth0yrQaqz0wdaC5vMc5fTRmnUh1oSzfy9AotaApsdh5l9ZxhwzxdYGe4ost4j9xhOc8kNmAV/jPZGX+DYtHHCD9Camr9lt+MLTiteIfekz5HnDAwhkIaNEJ4qwUzeruUTPr1JbqmPZ8o+WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671674; c=relaxed/simple;
	bh=mP2GXEEqVK+Xe0jIEyE0ZVSUaFwfIzu3GKnroVpZ8Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NraUiwdKZVAqjuua6DXZt/MMdQlub+tgw2YZqmkULnE1reuw6LCUYF2MNl2ULBZrfJD3vdenRIB5FJJeiBJMdDQmfZ2NpizJQdJc6rt0Yt2ciK2QY1yoUKpi5WXzN+q3vEXkVLoLcQibu4AW4uTwytfuHwn24P3EWrMSklwMq7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUhy1+zt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUhy1+zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A181F000E9;
	Tue, 21 Jul 2026 22:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671672;
	bh=r1v/xw6sywKqAf8G1Q8J+4WfrpmSJlbKYN4UY56HQc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUhy1+ztG1JadhDAytPHUbjXt0BFjPFBnx+iHvxUdADB8nBaGKYcF1CUC6URfHMjP
	 LchFf8GY3ElzBgcpZdRGsURD00ZPEsu9is1IRQmqsF+RL7r7EYu8qmyJlGJn/POUhi
	 VUbnVpDKn9CYKNNeBMnyP++I8cxXtJLZm4DJTKb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxwell Doose <m32285159@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/843] fs: efs: remove unneeded debug prints
Date: Tue, 21 Jul 2026 17:19:30 +0200
Message-ID: <20260721152413.556143921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxwell Doose <m32285159@gmail.com>

[ Upstream commit 89009392c80da5da00876c8334ff20028e6e3eb6 ]

The current code uses debug prints conditionally compiled with #ifdef
DEBUG.  However, that code, when compiled, causes compiler errors due to
incompatible formatters and undefined variables, notably:

fs/efs/file.c: In function `efs_get_block':
fs/efs/file.c:26:35: error: `block' undeclared (first use in this
function); did you mean `iblock'?
  26 |                         __func__, block, inode->i_blocks, inode->i_size);
     |                                   ^~~~~

and:

fs/efs/file.c: In function `efs_bmap':
./include/linux/kern_levels.h:5:25: error: format `%ld' expects
argument of type `long int', but argument 4 has type `blkcnt_t' {aka
`long long unsigned int'} [-Werror=format=]
   5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
     |                         ^~~~~~

which also extends to the other formatters.  As this part of the code has
been dead for just about 14 years now, it has not been modernized to stay
compatible with the most recent gcc compilers.  Fix these issues by
removing the debug prints.

Link: https://lore.kernel.org/20260605035251.89305-2-m32285159@gmail.com
Fixes: f403d1dbac6d ("fs/efs: add pr_fmt / use __func__")
Signed-off-by: Maxwell Doose <m32285159@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/efs/file.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/fs/efs/file.c b/fs/efs/file.c
index 9e641da6fab276..9153dfe79bbcc9 100644
--- a/fs/efs/file.c
+++ b/fs/efs/file.c
@@ -18,16 +18,9 @@ int efs_get_block(struct inode *inode, sector_t iblock,
 
 	if (create)
 		return error;
-	if (iblock >= inode->i_blocks) {
-#ifdef DEBUG
-		/*
-		 * i have no idea why this happens as often as it does
-		 */
-		pr_warn("%s(): block %d >= %ld (filesize %ld)\n",
-			__func__, block, inode->i_blocks, inode->i_size);
-#endif
+	if (iblock >= inode->i_blocks)
 		return 0;
-	}
+
 	phys = efs_map_block(inode, iblock);
 	if (phys)
 		map_bh(bh_result, inode->i_sb, phys);
@@ -42,16 +35,8 @@ int efs_bmap(struct inode *inode, efs_block_t block) {
 	}
 
 	/* are we about to read past the end of a file ? */
-	if (!(block < inode->i_blocks)) {
-#ifdef DEBUG
-		/*
-		 * i have no idea why this happens as often as it does
-		 */
-		pr_warn("%s(): block %d >= %ld (filesize %ld)\n",
-			__func__, block, inode->i_blocks, inode->i_size);
-#endif
+	if (!(block < inode->i_blocks))
 		return 0;
-	}
 
 	return efs_map_block(inode, block);
 }
-- 
2.53.0



