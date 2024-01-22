Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB959155316;
	Tue, 23 Jan 2024 00:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969576; cv=none; b=W2YkEsiIKuZCb67M3IZKPOZD+vLldDXCVLQD8xEMmxhIiInI/uo8fwxfzAMQOqt0jGyAtZytiVKDLD+CY0lzYRhLEBv5d7rrqb4lRVfczIPXhxdZPrm7worAohs8OjQaBtsyKEybbDEQKtmw8k3fm/0eqJ4/1PEu06Zo6pIt7fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969576; c=relaxed/simple;
	bh=c6uMW6n16CUKl+tgAjmnjUJzR4ZxReQ+c9ndBc+zF84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCX7IbCGul6J1vP83vFdN1Jb6Uomgk2F9jX+sKFEtQEYV/dOulOnpy3gzE973P/lILShJ39EJiW83vFg0EEtC2oq/bMPnydqAo2YJ8tLxr1fOyLwF1gSl3dyHj+xT2gibRePEKo/AYHr1dMxgf57b0kCia4rblJsUUvp6fiNY30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2u/EN9eZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2u/EN9eZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0BDC433F1;
	Tue, 23 Jan 2024 00:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969575;
	bh=c6uMW6n16CUKl+tgAjmnjUJzR4ZxReQ+c9ndBc+zF84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2u/EN9eZwXJ73uYJ9tvx5U49b0Uo5X5FFpaguGHVz6Hw6r0MGFGgbe0HY+QvpUfKP
	 2MZZGE1PSvVfOOzHCYUVpKHof+GwD2BAReI9YYAh16mITW4BVGTa1rKJnE1yBruvbb
	 n82qWJLtRYa3/wLZd1+fZs9yzJH93TIw95BcZ9Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 332/641] f2fs: fix to check return value of f2fs_recover_xattr_data
Date: Mon, 22 Jan 2024 15:53:56 -0800
Message-ID: <20240122235828.293368156@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 86d7d57a3f096c8349b32a0cd5f6f314e4416a6d ]

Should check return value of f2fs_recover_xattr_data in
__f2fs_setxattr rather than doing invalid retry if error happen.

Also just do set_page_dirty in f2fs_recover_xattr_data when
page is changed really.

Fixes: 50a472bbc79f ("f2fs: do not return EFSCORRUPTED, but try to run online repair")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c  |  6 +++---
 fs/f2fs/xattr.c | 11 +++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 6c7f6a649d27..9b546fd21010 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2751,11 +2751,11 @@ int f2fs_recover_xattr_data(struct inode *inode, struct page *page)
 	f2fs_update_inode_page(inode);
 
 	/* 3: update and set xattr node page dirty */
-	if (page)
+	if (page) {
 		memcpy(F2FS_NODE(xpage), F2FS_NODE(page),
 				VALID_XATTR_BLOCK_SIZE);
-
-	set_page_dirty(xpage);
+		set_page_dirty(xpage);
+	}
 	f2fs_put_page(xpage, 1);
 
 	return 0;
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index a8fc2cac6879..f290fe9327c4 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -660,11 +660,14 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	here = __find_xattr(base_addr, last_base_addr, NULL, index, len, name);
 	if (!here) {
 		if (!F2FS_I(inode)->i_xattr_nid) {
+			error = f2fs_recover_xattr_data(inode, NULL);
 			f2fs_notice(F2FS_I_SB(inode),
-				"recover xattr in inode (%lu)", inode->i_ino);
-			f2fs_recover_xattr_data(inode, NULL);
-			kfree(base_addr);
-			goto retry;
+				"recover xattr in inode (%lu), error(%d)",
+					inode->i_ino, error);
+			if (!error) {
+				kfree(base_addr);
+				goto retry;
+			}
 		}
 		f2fs_err(F2FS_I_SB(inode), "set inode (%lu) has corrupted xattr",
 								inode->i_ino);
-- 
2.43.0



