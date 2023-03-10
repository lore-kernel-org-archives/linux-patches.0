Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329D9847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A888CC433D2;
	Fri, 10 Mar 2023 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456488;
	bh=k7RKJ4vBt+RHbIddyslBZNzUIWuELE7Ou2WLCmjtEL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U311OhmIYvTAV0+2dF6PisiwWnXix4rZGONwmDwc3TWpkaNK0MrpkSwkgaVqpYYH0
	 HHr6rGLuxsJnWl63EXBUMprFDPE1xSdFfkwvdCVId3VUWfhsXYlvJZMRtY/aKSwZ5Q
	 XuY3L8lNGZnQDPfyeUbWsl6HrUzoX8I1DROAHbqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 020/211] f2fs: fix to do sanity check on extent cache correctly
Date: Fri, 10 Mar 2023 14:36:40 +0100
Message-Id: <20230310133719.348391176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit d48a7b3a72f121655d95b5157c32c7d555e44c05 ]

In do_read_inode(), sanity_check_inode() should be called after
f2fs_init_read_extent_tree(), fix it.

Fixes: 72840cccc0a1 ("f2fs: allocate the extent_cache by default")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index fb489f55fef3a..622eb7963afac 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -413,12 +413,6 @@ static int do_read_inode(struct inode *inode)
 		fi->i_inline_xattr_size = 0;
 	}
 
-	if (!sanity_check_inode(inode, node_page)) {
-		f2fs_put_page(node_page, 1);
-		f2fs_handle_error(sbi, ERROR_CORRUPTED_INODE);
-		return -EFSCORRUPTED;
-	}
-
 	/* check data exist */
 	if (f2fs_has_inline_data(inode) && !f2fs_exist_data(inode))
 		__recover_inline_status(inode, node_page);
@@ -482,6 +476,12 @@ static int do_read_inode(struct inode *inode)
 	f2fs_init_read_extent_tree(inode, node_page);
 	f2fs_init_age_extent_tree(inode);
 
+	if (!sanity_check_inode(inode, node_page)) {
+		f2fs_put_page(node_page, 1);
+		f2fs_handle_error(sbi, ERROR_CORRUPTED_INODE);
+		return -EFSCORRUPTED;
+	}
+
 	f2fs_put_page(node_page, 1);
 
 	stat_inc_inline_xattr(inode);
-- 
2.39.2



