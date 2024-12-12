Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B1A1487CD;
	Thu, 12 Dec 2024 15:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016884; cv=none; b=g+PKQYvcKbkdXombM/QQUOgAKWA5lWWHDoKUBlJcbls1TzTdpgt5ODhvEMQyoaNoaSV0pUCl8Q/2REMOZ2WhBJsMo4WD0EQlfu6OrjI2HOjZ4oW/mvOBGgxwUbApxBWkR1UJbVBoaK7fuvgDc8isze9bDvUIavDFLg2HgSWkq1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016884; c=relaxed/simple;
	bh=P7ym09U9iISElfv6t6WxqNV3GN+AwbAViihv75nl+yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MP9UPqd+v+xhxUb0usUSA6TZbaMpG9WO68g8LdP/5y9cudOWAJS59iJ56VxVArlaDMhPYnbEDgLV80htPmbCUeogjSsXdxZ2cehBbexJD/w58QBTkLoQ3Bzw/G+EV/WbXbu8yK4htoFSPPqd5JyQdnyncbciMF9qAvus3VnL6bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEYz2YV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEYz2YV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9063FC4CECE;
	Thu, 12 Dec 2024 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016884;
	bh=P7ym09U9iISElfv6t6WxqNV3GN+AwbAViihv75nl+yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEYz2YV0416pXVqCVrkC/3UInwTGIASqXwVOuNRngQs3bjHt7M7ptYQeg8uG3fcJ5
	 RGXTbyIyGEE++hCYfqW2wE7ldE73718SgW1a9ZA5yScjZYLAvlF7TPE8xeioJUza/V
	 3TQWWDU/dTTX93YadA6GvnUg4k48c5wsPaE8t0e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0315f8fe99120601ba88@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/466] jfs: fix array-index-out-of-bounds in jfs_readdir
Date: Thu, 12 Dec 2024 15:58:10 +0100
Message-ID: <20241212144319.477849877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit 839f102efb168f02dfdd46717b7c6dddb26b015e ]

The stbl might contain some invalid values. Added a check to
return error code in that case.

Reported-by: syzbot+0315f8fe99120601ba88@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0315f8fe99120601ba88
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 69fd936fbdb37..8f85177f284b5 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2891,6 +2891,14 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		stbl = DT_GETSTBL(p);
 
 		for (i = index; i < p->header.nextindex; i++) {
+			if (stbl[i] < 0 || stbl[i] > 127) {
+				jfs_err("JFS: Invalid stbl[%d] = %d for inode %ld, block = %lld",
+					i, stbl[i], (long)ip->i_ino, (long long)bn);
+				free_page(dirent_buf);
+				DT_PUTPAGE(mp);
+				return -EIO;
+			}
+
 			d = (struct ldtentry *) & p->slot[stbl[i]];
 
 			if (((long) jfs_dirent + d->namlen + 1) >
-- 
2.43.0



