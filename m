Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2A77DA78;
	Thu, 15 Aug 2024 13:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728752; cv=none; b=ph5bUvh76TqcR2z3HQrl36b92RGzzJ7UAlKSlAK6VlXK4QYwh1N5r4zaKsVpJY3hBBGRwMj9Opk4LX8ObMZg+uqL2blcONhxJawpeVE04jsJGVw9hfR2AnTmTFfLJ8aMzhHK63XQOii0msxS/caDCY0AWDUtsZeqrGGyjMzYot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728752; c=relaxed/simple;
	bh=9MYnBfNO9X4mAZ0jx7N/gZbXNTyswrOoBF2bcS0dsIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pewA43gxJ10+bSteFtXXSFZZ2S3Oqa8lCguw7AeDRTlv3EtIIsOucA/VGZm6dmVPWC68Uce5KjoTXi/m0BfO3H3dlGAc8Xj4sCc8RJTAbIrMUb/d/ZODWcB6zUqZr1tODhk9AEWLHvFjRTOCvohcbKWARy9jcwXuVT7zMy8voWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fuqf6Jsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fuqf6Jsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07B8C4AF0A;
	Thu, 15 Aug 2024 13:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728752;
	bh=9MYnBfNO9X4mAZ0jx7N/gZbXNTyswrOoBF2bcS0dsIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fuqf6Jsuh1SUmSEMsJesJRrv3b4CN6wZ1TvwvvW57nXSfjY6RM8a5RIsnm7Oul/Se
	 +3dF+dRrVc0uD/NgDAPecDO9GJnkezXw9Q2VFQhWYA2lxYca+4zf37wDVY9pIq+/vp
	 QZNPd6qNCHlr4nO8Neq+lS7Z2IxM5bpyEOEiLqyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+241c815bda521982cb49@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/196] jfs: Fix array-index-out-of-bounds in diFree
Date: Thu, 15 Aug 2024 15:23:35 +0200
Message-ID: <20240815131855.831480875@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit f73f969b2eb39ad8056f6c7f3a295fa2f85e313a ]

Reported-by: syzbot+241c815bda521982cb49@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_imap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 00800c8c6f077..9893cb6b8a756 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -305,7 +305,7 @@ int diSync(struct inode *ipimap)
 int diRead(struct inode *ip)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(ip->i_sb);
-	int iagno, ino, extno, rc;
+	int iagno, ino, extno, rc, agno;
 	struct inode *ipimap;
 	struct dinode *dp;
 	struct iag *iagp;
@@ -354,8 +354,11 @@ int diRead(struct inode *ip)
 
 	/* get the ag for the iag */
 	agstart = le64_to_cpu(iagp->agstart);
+	agno = BLKTOAG(agstart, JFS_SBI(ip->i_sb));
 
 	release_metapage(mp);
+	if (agno >= MAXAG || agno < 0)
+		return -EIO;
 
 	rel_inode = (ino & (INOSPERPAGE - 1));
 	pageno = blkno >> sbi->l2nbperpage;
-- 
2.43.0



