Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA2284881;
	Mon, 23 Mar 2026 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282267; cv=none; b=UegOJK/eUSU9pRg1Y37sMAmh5pqhDvsAWhLrNftKnuuSqmyeHT1BjE1KjuNQf0Ugsj+uwgA1Q6y42NQP+2Bj/nMcqh1TvMcU4yjhnUshwt3SL7nSqjnNpWFnSPbnVwa0cv8XOLwApnhCPep+lst8EOi8pffisc0bbwc6ns5SH3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282267; c=relaxed/simple;
	bh=CaKjdepu4vgGoQgmu54JWLJPXS8ysGGaYA0b36EhQJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zr7NokTorLO4XQlNspfmM+jeH33+mBBi7JpM6dcVdQ3YgK3heOa1GJTcwa1OjSZB2Fj99mLORotmqqQW/1ZU/WF+BVbT1SgeTPQ9NwyTEKJMbK5//OJoYZGULf/0e9464dVs3B34Sj2SM4TFBd7UtP9tdAkDGi1WAm48TBjKFlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IE8x6Y4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IE8x6Y4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F23AC4CEF7;
	Mon, 23 Mar 2026 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282267;
	bh=CaKjdepu4vgGoQgmu54JWLJPXS8ysGGaYA0b36EhQJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IE8x6Y4AsBZ59WGQ3EifF3wHddJO0BY7Eg3MZrGhWAQibLwzsWTHGNZmE3r6FBjuz
	 x1xgGgx6j5O2gEhtLCemOkW1pw6TYAVk32uBf2kPqm5uLGR4WjgP601Yp77lmifo74
	 z4MFJIqaeT4jpG5MppGgkBnOP9bEvYtPJOMHgBFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/481] ext4: delete redundant calculations in ext4_mb_get_buddy_page_lock()
Date: Mon, 23 Mar 2026 14:40:32 +0100
Message-ID: <20260323134526.447604596@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit f2fec3e99a32d7c14dbf63c824f8286ebc94b18d ]

'blocks_per_page' is always 1 after 'if (blocks_per_page >= 2)',
'pnum' and 'block' are equal in this case.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231024035215.29474-1-gouhao@uniontech.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: bdc56a9c46b2 ("ext4: fix e4b bitmap inconsistency reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2a385dc610704..899d7eb6df3dc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1370,9 +1370,8 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 		return 0;
 	}
 
-	block++;
-	pnum = block / blocks_per_page;
-	page = find_or_create_page(inode->i_mapping, pnum, gfp);
+	/* blocks_per_page == 1, hence we need another page for the buddy */
+	page = find_or_create_page(inode->i_mapping, block + 1, gfp);
 	if (!page)
 		return -ENOMEM;
 	BUG_ON(page->mapping != inode->i_mapping);
-- 
2.51.0



