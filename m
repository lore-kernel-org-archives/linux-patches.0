Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1852D3209;
	Thu, 13 Jun 2024 12:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281163; cv=none; b=BiAEveHYElBwx2zMTi3xMmnGkwnlWPgo5PY5ZnVgWOG9qzlW/pE4Z8ce0f/tWa071+TLbFOCyP/xv1/IpTuhs9OtO4vhiiuh7XSMTJzYPmttFwc/ST/YDg86r1Dg+AhfaGmDhSX0dATgZCYAuqXmVSX/pOIrUUSlA/Cw0eMvR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281163; c=relaxed/simple;
	bh=TBZyJWC/XCXjUs8ocxWE1o4RaEbeUWv1kTfSXD5CTtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGb7nQ4BWSundXCtKgfutzSzH8ng8Cb+2UjWlovtvBq+P/Y0q0NMNHKdKEQwbkbruJmBeYD3AnzJ7ZxvthU21FW6g8jQxF0BkhLJkLZdjh9crFHlq51nJgbZ/1TKmZve/m9nou0Y7YleiiLsF0O8GSfFVEM4n0Iq1kQCCmhyGYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOx4s8Ie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOx4s8Ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927DFC2BBFC;
	Thu, 13 Jun 2024 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281163;
	bh=TBZyJWC/XCXjUs8ocxWE1o4RaEbeUWv1kTfSXD5CTtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOx4s8IeXheDdiiXwnZqwFJ1hdUMKN1WZDXK9VDG7uHeXZkYj5Aj7r35giXjLGna1
	 nQp3CxxrRKHzUGzr4Xs3opUgpy2D9HfLAusA7+xVkTBPPGN5uiiU5dvMicSAiwZtr5
	 TP1ZZfskhAj/4096y3Aaygn9N3bka2pcPlBuSFrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/317] f2fs: fix to relocate check condition in f2fs_fallocate()
Date: Thu, 13 Jun 2024 13:32:58 +0200
Message-ID: <20240613113253.755759837@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 278a6253a673611dbc8ab72a3b34b151a8e75822 ]

compress and pinfile flag should be checked after inode lock held to
avoid race condition, fix it.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Fixes: 5fed0be8583f ("f2fs: do not allow partial truncation on pinned file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 367b19f059f3c..9cf04b9d3ad8e 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1745,15 +1745,6 @@ static long f2fs_fallocate(struct file *file, int mode,
 		(mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)))
 		return -EOPNOTSUPP;
 
-	/*
-	 * Pinned file should not support partial truncation since the block
-	 * can be used by applications.
-	 */
-	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode)) &&
-		(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
-			FALLOC_FL_ZERO_RANGE | FALLOC_FL_INSERT_RANGE)))
-		return -EOPNOTSUPP;
-
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 			FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
 			FALLOC_FL_INSERT_RANGE))
@@ -1761,6 +1752,17 @@ static long f2fs_fallocate(struct file *file, int mode,
 
 	inode_lock(inode);
 
+	/*
+	 * Pinned file should not support partial truncation since the block
+	 * can be used by applications.
+	 */
+	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode)) &&
+		(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
+			FALLOC_FL_ZERO_RANGE | FALLOC_FL_INSERT_RANGE))) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	ret = file_modified(file);
 	if (ret)
 		goto out;
-- 
2.43.0



