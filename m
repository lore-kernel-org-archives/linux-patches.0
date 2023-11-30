Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0CE54FBA;
	Thu, 30 Nov 2023 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbLavROt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DED8C433C9;
	Thu, 30 Nov 2023 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361837;
	bh=qrf0ZpiaGTGXx/mtAdwF6pudhGCWKPbOaTT+lDRLdGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbLavROtC3Zqyne85/MmyHf5rlSQVPrVXXuggqD0VVetqowKz63DHoLusxgEYJxuY
	 I3Gucf8q1H5zb0vpp4czwYeK64tvSXSMR7ZuQiikDiEzZ4vwOq8QGTiRgIPJ7mvNwL
	 o/B1wNx4pMhsUJT20aSpepiJ3wJn2Rb3YfBol0EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 49/82] ext4: using nofail preallocation in ext4_es_insert_delayed_block()
Date: Thu, 30 Nov 2023 16:22:20 +0000
Message-ID: <20231130162137.525695815@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4a2d98447b37bcb68a7f06a1078edcb4f7e6ce7e ]

Similar to in ext4_es_remove_extent(), we use a no-fail preallocation
to avoid inconsistencies, except that here we may have to preallocate
two extent_status.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230424033846.4732-8-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 8e387c89e96b ("ext4: make sure allocate pending entry not fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents_status.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index cb8241adda929..e382fe1788f1e 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -2013,7 +2013,10 @@ int ext4_es_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk,
 				 bool allocated)
 {
 	struct extent_status newes;
-	int err = 0;
+	int err1 = 0;
+	int err2 = 0;
+	struct extent_status *es1 = NULL;
+	struct extent_status *es2 = NULL;
 
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 		return 0;
@@ -2028,29 +2031,37 @@ int ext4_es_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk,
 
 	ext4_es_insert_extent_check(inode, &newes);
 
+retry:
+	if (err1 && !es1)
+		es1 = __es_alloc_extent(true);
+	if ((err1 || err2) && !es2)
+		es2 = __es_alloc_extent(true);
 	write_lock(&EXT4_I(inode)->i_es_lock);
 
-	err = __es_remove_extent(inode, lblk, lblk, NULL, NULL);
-	if (err != 0)
+	err1 = __es_remove_extent(inode, lblk, lblk, NULL, es1);
+	if (err1 != 0)
 		goto error;
-retry:
-	err = __es_insert_extent(inode, &newes, NULL);
-	if (err == -ENOMEM && __es_shrink(EXT4_SB(inode->i_sb),
-					  128, EXT4_I(inode)))
-		goto retry;
-	if (err != 0)
+
+	err2 = __es_insert_extent(inode, &newes, es2);
+	if (err2 != 0)
 		goto error;
 
 	if (allocated)
 		__insert_pending(inode, lblk);
 
+	/* es is pre-allocated but not used, free it. */
+	if (es1 && !es1->es_len)
+		__es_free_extent(es1);
+	if (es2 && !es2->es_len)
+		__es_free_extent(es2);
 error:
 	write_unlock(&EXT4_I(inode)->i_es_lock);
+	if (err1 || err2)
+		goto retry;
 
 	ext4_es_print_tree(inode);
 	ext4_print_pending_tree(inode);
-
-	return err;
+	return 0;
 }
 
 /*
-- 
2.42.0



