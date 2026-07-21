Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9752A46F4B8;
	Tue, 21 Jul 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656780; cv=none; b=D8z9MgVTe/4k/NbJ2vYQmoNmexbeg0KBCteglk2YpVckMLhYesc33fgcLsEdaOgXe52CknFs2VZZWbVzw26dPGi7Qu9vpwLnHbOQOTVV0s0714Y7J+NniExr1pNSilQuPVZrPfmDiwtN2ZBokF/XXfbitA7d/fnyyWzkzxJ0214=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656780; c=relaxed/simple;
	bh=Mvyz9blmLpwkRgfcF4dqKwGlmO12sBBxGi0wVXZAJRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnLxPcqAEFdcrxl2eR1VVYICoZo2zXefIBJkFT+aWCIAnkue/WqPiisTWGpNDKchOi/+XjJYd4QhBA+xKOpSQOn8ZaSp1ZixFk6i5qNSQCQ7JSgQYozGqXz6YU3VZsLwHMv5YA3VZhafb0hTAmisjnl0MswBxrwiejuTB3pVMqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=or/dQ0w1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="or/dQ0w1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0952C1F000E9;
	Tue, 21 Jul 2026 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656779;
	bh=jl/t5fjm8L6C7N7Bm7+k/Lx8DQx62BbD40RSt3XGicY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=or/dQ0w1Ria9QnwHvimbznSOsc7eKlxXOD0fNbvlpWcKLw17MIHTe0PnAsBnYUxFg
	 ncBTKW5TJoCWahrP3pLe9eEpq/5CPfajIf+VsfqIOPs+g68AxgBSmV4vUThvaTChKZ
	 1U4akJcwctS0DCQUusIyDchHV5V9gQWgwjCOKKqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxwell Doose <m32285159@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0472/1611] fs: efs: remove unneeded debug prints
Date: Tue, 21 Jul 2026 17:09:48 +0200
Message-ID: <20260721152525.940715060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



