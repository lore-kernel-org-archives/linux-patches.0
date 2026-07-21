Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4130B46EC8E;
	Tue, 21 Jul 2026 19:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661136; cv=none; b=ul6kG2mWM3lqtUTymx4eSTAesHwCjs8oZLYWdorL+t+RbIct9/P5DLxlIwK+q5a5hpPZYAJsrKlyUl2LIateSHbhFFOIY24SMRKriuzk40x/ySS3jFKR0Mjqoqxt1crJFIPLS6y/ISZPLHgBaEMCDTzzfbuv9NW35beVX3LjrZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661136; c=relaxed/simple;
	bh=fF2diqZQFZjSnaef0XC9lAfiaEmUO/BEEBAUvL0RPCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/knxaqJKFvwB7yhGqfwWGcy1FUik29YWY6ocfwf5+lrTfPMTgkzdnd1rwLcA2vAL4gMIO8C6y7iSEnDIASPpmIGAvkyvDXwlin9ozqvH3+Y18q3pOYaOi428jaD+5mNJjqEddznkr2WeM0AinIFWV7Hly2Q35bsbmve6UGRO44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KW8zhtbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KW8zhtbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E8D1F00A3A;
	Tue, 21 Jul 2026 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661135;
	bh=LTGF4z36K0vUIkXyGdZqxy+NKV4pIxf1+SS41tK0hWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KW8zhtbsMcg5HjMa/ObX5Vy4KzoinP5LMxTvQ0ELGCOKr7Ror7lXyt58CzNrOWz6C
	 dgz/++6CkmDo+uYyA5R3MbAzqD++Hose03JRQLqQAODNDUeRB8y7GP/nNtF8l9mluw
	 Y09Sd0hHwdhYSk6mhe8CfJKfz0VwSbfERTzl6P8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1200/2077] erofs: handle 48-bit blocks_hi for compressed inodes
Date: Tue, 21 Jul 2026 17:14:33 +0200
Message-ID: <20260721152621.115164757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

[ Upstream commit 803d09a554055aba160a62abd1e4b1260b899dc1 ]

Combine i_nb.blocks_hi with i_u.blocks_lo when computing
inode->i_blocks for compressed inodes, mirroring the startblk_hi
handling for unencoded inodes a few lines above.  Also evaluate
the shift in u64 to avoid truncation.

Fixes: efb2aef569b3 ("erofs: add encoded extent on-disk definition")
Fixes: 1d191b4ca51d ("erofs: implement encoded extent metadata")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index a188c570087aec..e0c47da4f09e00 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -191,8 +191,9 @@ static int erofs_read_inode(struct inode *inode)
 		err = -EFSCORRUPTED;
 		goto err_out;
 	} else {
-		inode->i_blocks = le32_to_cpu(copied.i_u.blocks_lo) <<
-				(sb->s_blocksize_bits - 9);
+		inode->i_blocks = (le32_to_cpu(copied.i_u.blocks_lo) |
+			((u64)le16_to_cpu(copied.i_nb.blocks_hi) << 32)) <<
+				  (sb->s_blocksize_bits - 9);
 	}
 
 	if (vi->datalayout == EROFS_INODE_CHUNK_BASED) {
-- 
2.53.0



