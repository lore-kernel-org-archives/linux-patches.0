Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7640F1A76C1;
	Tue, 30 Jul 2024 17:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360569; cv=none; b=I0+cs/HRpF+rykE1/IFfJjz5JRovLP4LsrO9QzLayk92T++8MqmW1QtZiDvqNwpjcW98hlrIUlmFiklSh6cafSKSbEqi+WEQg4an6YGbAcO+5Zd/Q992j8asSf5+rFpqEhWiv1jUvZvUZ14NgULRHqWAijUU5Pa1pdtS1UaFHyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360569; c=relaxed/simple;
	bh=gwfzc6fz1+YQr6CcPG6GkPKEkq4xfx7r8YrzfcQ4tCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ey4+SBXmAXE4JOCXAD8WeJtXptXlhSLkOATBvyfXVclK9LQUBj20xsQLkpIdHUWTRmY12NFYkg5pOM9zEtgyEhjxnHvXlEEHAenNOYUhwCkhJgc2kMRAphxr8HStXYJhIQ4uB9LAv6txMG+Sp5WFHybasUvfjTdw+G7BLx3F17Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCDBHqZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCDBHqZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81C9C32782;
	Tue, 30 Jul 2024 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360569;
	bh=gwfzc6fz1+YQr6CcPG6GkPKEkq4xfx7r8YrzfcQ4tCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCDBHqZYLqIHUpiPwTDiQpV5SOuolgDaRvfh5XDoY/rkGkNkbqvcv7U91XBQb+SGq
	 oemEnVSHZmpWo0PipVhG9s/ezMgjJNVBzPRJ3ucb6WoUEeedoa+JBwFbQo5BZB6Q9E
	 JSn+m7n3MOym3AgzGp+a3VxqN1qZpkpzERfSdgDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+241c815bda521982cb49@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 740/809] jfs: Fix array-index-out-of-bounds in diFree
Date: Tue, 30 Jul 2024 17:50:16 +0200
Message-ID: <20240730151754.176736710@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2ec35889ad24e..1407feccbc2d0 100644
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



