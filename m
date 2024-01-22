Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C84F634F8;
	Tue, 23 Jan 2024 00:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971269; cv=none; b=kAfeKVbG1ayJWu6XU+19+MjwEPCtUsJDVGx/KdLUnAIvaPaZQ26WB2ZIdWrEP8n2o6goMkuYESCsyl+lQPMB5wxEqx5yq3iI0RO9grOW9LY8TxlYGqyKxyjv+AZPcbexxwTFe0MLGWRNBU+QZ5oW+hCQYbVy6LZE8t6CS9I9K7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971269; c=relaxed/simple;
	bh=RkmlUiHot1vJbPao7lpcpK7e3uEGLbQWMJWj4m9n8S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RB1+kf3ZeprGtTPPYIbt7cYwCCNmk3prEDmEbJ1CgLbHwEsEvkzv+JCy+62g3DF4LRVc0uJO59eW0cvZAa2unpoViH73BI43/uXRc9EVl6sZOKQSBWiXU3iKUOIzCkOPznzbBwL3t3nLTn9XSpewekxmarBnNyqENtfCXjg6z9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0LFkqht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0LFkqht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB47C433F1;
	Tue, 23 Jan 2024 00:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971269;
	bh=RkmlUiHot1vJbPao7lpcpK7e3uEGLbQWMJWj4m9n8S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0LFkqhtXGl3Ob76T8vu5VGT1G1PtbF7N6yoLcXK30NZc0bIOo7VGdJDX95hlmnUi
	 qHoZAVfXx/8Mg2eD9UVVIpL0fL3An667++XVJpBPibh3oZ0/GKGmLkCWa2/uTt4QJG
	 0AqADGSB6QWHnJS8A7QBTxxZc6lHChwEchS1ZciI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/417] f2fs: fix to check return value of f2fs_recover_xattr_data
Date: Mon, 22 Jan 2024 15:56:22 -0800
Message-ID: <20240122235759.334407942@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 6efccd7ccfe1..c6d0e0709632 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2738,11 +2738,11 @@ int f2fs_recover_xattr_data(struct inode *inode, struct page *page)
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
index 8816e13ca7c9..0631b383e21f 100644
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



