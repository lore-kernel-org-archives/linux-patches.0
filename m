Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E6917FD;
	Thu, 13 Jun 2024 12:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282200; cv=none; b=BgBGNB5XiEVs5is+GEC3qzs4nLhTnjpmLMnGiKqdOmVf2JGLl4fQJ3M0g5LfShbrVYvzkei0G931j9InqqU6qn9/WYKcKSAJbSgkx60CqW+rx1CRDcbljJONBgQolEHXIY4KvtyVtFK6aZ0ELs5N3RtMwPFIZcdJ5zA+knUZkWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282200; c=relaxed/simple;
	bh=DQhK6/EL/zlzLK9kJrqIGOcT7kds4npbsDq9kKd6X6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2FZvulnlMuL1F6/hXWYPPIAFCiCi/icPap+0WQp6aDWAEE9g002igyW4fSp/+Bnq/8z2HD8tUDt30Yxs3JHMIU/X3oXXvxu+qmNbmTcN3Ioz0gZ9w6cTMGeXCCLyG5J/MVF8tCZt1COpkBkOJTy4iA0Crh1mgsFrJPuoISh6YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVUUDlEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVUUDlEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67932C2BBFC;
	Thu, 13 Jun 2024 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282199;
	bh=DQhK6/EL/zlzLK9kJrqIGOcT7kds4npbsDq9kKd6X6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVUUDlEOXxOjiB3XWHMfn1r157K1BkzMMUPgMMxqnkqJ6EH6kblQ+tQVI7jC8J9aF
	 COC7FagkQ2YjAYg0PhUK04Ncax/Bzr5hWOIq0sO/k4yCIs4f/swLA8r8h3J8LGEOml
	 oUxrQy+2ynE5fORTrC16RqJcpUhFbqv6/qOTjicU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/402] f2fs: do not allow partial truncation on pinned file
Date: Thu, 13 Jun 2024 13:32:34 +0200
Message-ID: <20240613113309.825328705@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 5fed0be8583f08c1548b4dcd9e5ee0d1133d0730 ]

If the pinned file has a hole by partial truncation, application that has
the block map will be broken.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 278a6253a673 ("f2fs: fix to relocate check condition in f2fs_fallocate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index da071ed11a3f6..959e1458412df 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1760,7 +1760,11 @@ static long f2fs_fallocate(struct file *file, int mode,
 		(mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)))
 		return -EOPNOTSUPP;
 
-	if (f2fs_compressed_file(inode) &&
+	/*
+	 * Pinned file should not support partial trucation since the block
+	 * can be used by applications.
+	 */
+	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode)) &&
 		(mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
 			FALLOC_FL_ZERO_RANGE | FALLOC_FL_INSERT_RANGE)))
 		return -EOPNOTSUPP;
-- 
2.43.0



