Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9641A6195;
	Tue, 30 Jul 2024 16:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358491; cv=none; b=MrI4opK5fXNN8sen6W9gMvmB9vWCaGH5t5+Lhy4sVB94CH/ed2GIxQEr4NLtbrxAxJk1rVv0JyqLAoqjBkwSJCeagObiv+e1YoSmCyf3ulhcjNypl6qTloY+c4Smfc1L/1VMRVVieoRsqaKboU4ZJkV74571KvL/GFTisvjjjoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358491; c=relaxed/simple;
	bh=4PfF17anwQyV7ELzH/e7MgiBDjbySxgVKuaGJccIIPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTk2efIYcoK9pK6EGM8qlQm5Ewy6DYX1O1jcNCParu/m97MCNms00AehmSHW6wFF9y5CEf+y8Pgpt75oX2JmcS/SFOhRv50RKLTdOa0GMYYzTWfoJI0y7vp7QL0raFCqmnmgUV2OAPiKPCPwJuz6BBAMXpJfSQrV4pplueA3EG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJQ85BBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJQ85BBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FDDC32782;
	Tue, 30 Jul 2024 16:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358491;
	bh=4PfF17anwQyV7ELzH/e7MgiBDjbySxgVKuaGJccIIPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJQ85BBcn8x4P1HrV6tM5tzpoxLDORGj7QKE/h3UPcncdvouv+n6sYgcSYmp3CV93
	 doysJnQe7org9g3dJ/5ufGETXRH9n9ZQMgzDg0VgXdy2dAYdCuKuCbb6SlenKvLc9y
	 zZCn+a6yYtO00D+mxvMBYS6u8FokJBo+cJyQ5PkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+241c815bda521982cb49@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 395/440] jfs: Fix array-index-out-of-bounds in diFree
Date: Tue, 30 Jul 2024 17:50:28 +0200
Message-ID: <20240730151631.231550718@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ac42f8ee553fc..ba6f28521360b 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -290,7 +290,7 @@ int diSync(struct inode *ipimap)
 int diRead(struct inode *ip)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(ip->i_sb);
-	int iagno, ino, extno, rc;
+	int iagno, ino, extno, rc, agno;
 	struct inode *ipimap;
 	struct dinode *dp;
 	struct iag *iagp;
@@ -339,8 +339,11 @@ int diRead(struct inode *ip)
 
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



