Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D85063D5;
	Thu, 15 Aug 2024 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732472; cv=none; b=FfyKUgODUmi2xVNXGBHAOR5FnvWqu3LAoT1yL6UTSM98BHCfyc52thX+vG8nva1OKPLqTtKpWyZHERR383zpSIrE8SeQbcx2tiXvt4NTi7KJW66ZW5SRj7UNOTbr2MP+PrNaEKi1V3KEte0+8vYKfzF8ROteABFNuMgLxz0/PPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732472; c=relaxed/simple;
	bh=2y7cHl+dlIMjkzQ6cLQGBI3Q+2TZQz5DWur+lBR6orA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DapvV0yppWQX82Q10iVlRaF2Zqey3iRZP9ny7h+SDdUix3RVox5gPIoIBlflJjES2/sNsES4e9K6oiRRvwhFewCtCIfbJ/tglYMVxL1pvQocqBGzY1S0vwyAlWF+jVn8wSR6+QZz73X/d0VNWy6Fu0cxY6i3z3/YHOyJ3rePoaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbXTcH8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbXTcH8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CC5C32786;
	Thu, 15 Aug 2024 14:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732472;
	bh=2y7cHl+dlIMjkzQ6cLQGBI3Q+2TZQz5DWur+lBR6orA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbXTcH8dxmWciThaKX6s9o+5nRXitooS527Tj2BBOXdcd9eUJ4rNxGKy6ADXMgyZM
	 ufPddPp4+aU7fr1iBGW6dNFdAwxokCdXB/WRbY8vG2nVemRlHGPQk/IxQg8p9Ey2BQ
	 hSAceX/nHdbCo/gEbIHvx45g1V74xPrjz6PJ3Vlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+241c815bda521982cb49@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/352] jfs: Fix array-index-out-of-bounds in diFree
Date: Thu, 15 Aug 2024 15:24:16 +0200
Message-ID: <20240815131926.620601851@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
index b0965f3ef1865..36ed756820648 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -292,7 +292,7 @@ int diSync(struct inode *ipimap)
 int diRead(struct inode *ip)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(ip->i_sb);
-	int iagno, ino, extno, rc;
+	int iagno, ino, extno, rc, agno;
 	struct inode *ipimap;
 	struct dinode *dp;
 	struct iag *iagp;
@@ -341,8 +341,11 @@ int diRead(struct inode *ip)
 
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



