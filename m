Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6AA51002;
	Thu, 30 Nov 2023 16:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPB3AXkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7C0C433C7;
	Thu, 30 Nov 2023 16:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361978;
	bh=3qjntAyF7BgsedV09s9mxYiszKlqeHrKkVdJe57O27Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPB3AXkAsadAODNUr1r4biZWspFbFNh40Verh2WVZkBjQOEyOxvrGE2YcVAmqFC8Y
	 wqUL7Q4dH5sEGyC6xeLp91cY4KPwZJR/flIBwuROrXHe5hWTzcweYJuxivkJu2mOER
	 QwCYBcSuOISrHpUqOiUG8VZDoT+Jtkd0CrxRJtPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/69] ext4: using nofail preallocation in ext4_es_insert_extent()
Date: Thu, 30 Nov 2023 16:22:36 +0000
Message-ID: <20231130162134.369177464@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 2a69c450083db164596c75c0f5b4d9c4c0e18eba ]

Similar to in ext4_es_insert_delayed_block(), we use preallocations that
do not fail to avoid inconsistencies, but we do not care about es that are
not must be kept, and we return 0 even if such es memory allocation fails.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230424033846.4732-9-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 8e387c89e96b ("ext4: make sure allocate pending entry not fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents_status.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 4163a4801f969..1327cd9505db7 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -841,8 +841,11 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 {
 	struct extent_status newes;
 	ext4_lblk_t end = lblk + len - 1;
-	int err = 0;
+	int err1 = 0;
+	int err2 = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct extent_status *es1 = NULL;
+	struct extent_status *es2 = NULL;
 
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 		return 0;
@@ -870,29 +873,40 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 
 	ext4_es_insert_extent_check(inode, &newes);
 
+retry:
+	if (err1 && !es1)
+		es1 = __es_alloc_extent(true);
+	if ((err1 || err2) && !es2)
+		es2 = __es_alloc_extent(true);
 	write_lock(&EXT4_I(inode)->i_es_lock);
-	err = __es_remove_extent(inode, lblk, end, NULL, NULL);
-	if (err != 0)
+
+	err1 = __es_remove_extent(inode, lblk, end, NULL, es1);
+	if (err1 != 0)
+		goto error;
+
+	err2 = __es_insert_extent(inode, &newes, es2);
+	if (err2 == -ENOMEM && !ext4_es_must_keep(&newes))
+		err2 = 0;
+	if (err2 != 0)
 		goto error;
-retry:
-	err = __es_insert_extent(inode, &newes, NULL);
-	if (err == -ENOMEM && __es_shrink(EXT4_SB(inode->i_sb),
-					  128, EXT4_I(inode)))
-		goto retry;
-	if (err == -ENOMEM && !ext4_es_must_keep(&newes))
-		err = 0;
 
 	if (sbi->s_cluster_ratio > 1 && test_opt(inode->i_sb, DELALLOC) &&
 	    (status & EXTENT_STATUS_WRITTEN ||
 	     status & EXTENT_STATUS_UNWRITTEN))
 		__revise_pending(inode, lblk, len);
 
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
-
-	return err;
+	return 0;
 }
 
 /*
-- 
2.42.0



