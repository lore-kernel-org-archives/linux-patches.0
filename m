Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D561A76A4;
	Tue, 30 Jul 2024 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359818; cv=none; b=f3m1RzE+UorK7EqbJwB34iz5S/jI/EyqcU2jy5Y6dWBbZwpR3eHOdRlLWR1iWpwwy+8h6vsEco23EZA/mkNwO5n9wbD4A97COYYSxwbseR9/5BPjCpLlmf3zcTMnFDfPkshHKD/qqfvMVgP8l22Wq9UNx/NVq7Zx/mgwOUa5TbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359818; c=relaxed/simple;
	bh=e/GtWJ0IDF4pVJapzj00/41+0deX5Qb57kLiAHfGdzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqpGOgB2lTac3lmPU+rKpXsTSholM026gi/L98VfYDcfflpIU1zvyFq39mXMejROwbFlfb5oS92Y84SgCvm6QwEqYCnA7E6UdN7DpRtFgh8Z5FRAH9NkuGRJEaZt24i/ophrr6y2brKZaJPfn4I3QvG16KjG2dJMYco3nfHWfoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymBoz66b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymBoz66b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01F9C32782;
	Tue, 30 Jul 2024 17:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359818;
	bh=e/GtWJ0IDF4pVJapzj00/41+0deX5Qb57kLiAHfGdzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymBoz66bJsIC9FfEG5ENxsCvOPcaO8tbxkZDldlkiT5nuWYqOe3Uyg8JOpzwIN9X1
	 4k75oGt2WyvQTHfllvdsS7wXPbOT0E6swh+Rvm2liWUUd9xIpv5W83qrRBqxY/FczI
	 rAMAl9LAdnYWdxLZeKwe3IMm17guMMxKkATo7+08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+241c815bda521982cb49@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 518/568] jfs: Fix array-index-out-of-bounds in diFree
Date: Tue, 30 Jul 2024 17:50:25 +0200
Message-ID: <20240730151700.403295481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eeedf606cf9d4..4bc589c4dcca9 100644
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



