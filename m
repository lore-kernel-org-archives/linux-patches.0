Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ED5FBFE
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE62C433EF;
	Mon, 15 May 2023 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170762;
	bh=28zpl+vi9TUr1cBvEqV4Hs4FqPM7lFkNXM+E3bBIidI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3J8KSkH1VytSZHeC7/E+rfHTi9YgrzlMlQi/6zrhhrdsWnX7sSSVqfPtjqwHsbyO
	 rKYC5GeL27UfEV5tr4vwi29FZkGwrKcMCEncnznfbWqib2gxShBFRZABLSvHnrZ/YY
	 m2MmiTw8BlvDM32UKUo3KCX4vAECN9Ly3AZedvtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 233/239] f2fs: fix to do sanity check on extent cache correctly
Date: Mon, 15 May 2023 18:28:16 +0200
Message-Id: <20230515161728.699732174@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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

commit d48a7b3a72f121655d95b5157c32c7d555e44c05 upstream.

In do_read_inode(), sanity_check_inode() should be called after
f2fs_init_read_extent_tree(), fix it.

Fixes: 72840cccc0a1 ("f2fs: allocate the extent_cache by default")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -413,12 +413,6 @@ static int do_read_inode(struct inode *i
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
@@ -481,6 +475,12 @@ static int do_read_inode(struct inode *i
 	/* Need all the flag bits */
 	f2fs_init_read_extent_tree(inode, node_page);
 
+	if (!sanity_check_inode(inode, node_page)) {
+		f2fs_put_page(node_page, 1);
+		f2fs_handle_error(sbi, ERROR_CORRUPTED_INODE);
+		return -EFSCORRUPTED;
+	}
+
 	f2fs_put_page(node_page, 1);
 
 	stat_inc_inline_xattr(inode);


