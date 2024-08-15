Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7842F1494C5;
	Thu, 15 Aug 2024 13:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729968; cv=none; b=oyOiLiAfR8Vq6kBkaeClBZ85jrdZhhsiiCnjxHwnugrqBagvoutZLwydFZC6y5tggBQl3lerk6J9OyLCCe4ianNRGzIGRtfbGvt0KInjRtmbRBoX+q9exAYqz0aKmEqW4IemCYd9wzjH3+bNcUedbWhQmQd69/jl1QrRNUvQlyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729968; c=relaxed/simple;
	bh=6RgZOTvIq6Oy2xw1nrFZ7YTwzCDLHEncWR3Fzi6PBcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4FC2W1MOVp/V3gNKZnWR/Vr29mpmU1QWlg64CF+rJ1d59GBPtTOPJxVRTG+ev4ickt/o0nHbYNILgqfsIswfD3dq7Kd1S7UTV4aicQyspYxM3Os0NNweuwUaW9BtaaY9e2meVj7LTjSRwuZvJO3MqAPrDo1ibDwtdcGrlVv+Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwkQe+Ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwkQe+Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010F8C32786;
	Thu, 15 Aug 2024 13:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729968;
	bh=6RgZOTvIq6Oy2xw1nrFZ7YTwzCDLHEncWR3Fzi6PBcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwkQe+UiS+Gr5oGRPzjEi0rEtULj85JYxFxhp/R/AVx4YuWFfB7SNKjGtjB2d/yvl
	 CDRD9X/zipFGJ2xySeM7RUU8MDQGcV7UyN1Cd+dlgPc0weWOyy80671qrBaslpWII6
	 g+G26U6IoCO9Gg06VCE74FUKYax7DoY87Fxiq+0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+241c815bda521982cb49@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/484] jfs: Fix array-index-out-of-bounds in diFree
Date: Thu, 15 Aug 2024 15:22:00 +0200
Message-ID: <20240815131951.521571752@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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



