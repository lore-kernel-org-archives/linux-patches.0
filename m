Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0036C322C80;
	Mon, 18 Aug 2025 14:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525917; cv=none; b=bIjV/Y7JTOlbETY2TOJ1rM5f6DqDm+DCyUnSL/6WR7b8Fhd2jp8bWiXj2BEmNr54zVwGAU88mxXVmRNuMeuMNXQcS+XcJaEiL1I/Yjk/k2eIbb9xSyd1KEpAtvYOAWkYrRg4MRve7SbUoZnQekmMeljEe1h0IOaWyw2HEkjh4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525917; c=relaxed/simple;
	bh=4xH6R9Ep+RUOH5C23tG5JpgcW91P9c60P1ukDFjcXwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTVoGM104+PPH2dg0mnAO/zmtIp0niu4nVS8aYAr9nTJDz1gI6/Q5iVOPLPhFw5cXjMpROWLMTB9iRADU5z+EF3wO1ueWJ+27PN8TwiJgJSHzxxUEaWuRTPmAo7XW7GnlnLYJi9J0wMOmeu2c6yiTlseYbEZylee9uGPBcrBpwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0TuRo1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0TuRo1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E46CC4CEEB;
	Mon, 18 Aug 2025 14:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525916;
	bh=4xH6R9Ep+RUOH5C23tG5JpgcW91P9c60P1ukDFjcXwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0TuRo1H47t+2IKr+X+jG0z3BZkMOJD6fyqGuq+ssM1BM7fYycXPTnIOszq7ULkPv
	 imHlxJHb4NoFYgIx0Vsv2MQG2gHUKiiepLrRmqBkUdkmM8jaQT6SfqJOqCF5LbSfDw
	 5/lfxME+a+8e3G9/+umoALPa3xwWiETfUH36gp1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Joseph Qi <jiangqi903@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 377/570] ext4: limit the maximum folio order
Date: Mon, 18 Aug 2025 14:46:04 +0200
Message-ID: <20250818124520.378510131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit b12f423d598fd874df9ecfb2436789d582fda8e6 ]

In environments with a page size of 64KB, the maximum size of a folio
can reach up to 128MB. Consequently, during the write-back of folios,
the 'rsv_blocks' will be overestimated to 1,577, which can make
pressure on the journal space where the journal is small. This can
easily exceed the limit of a single transaction. Besides, an excessively
large folio is meaningless and will instead increase the overhead of
traversing the bhs within the folio. Therefore, limit the maximum order
of a folio to 2048 filesystem blocks.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Joseph Qi <jiangqi903@gmail.com>
Closes: https://lore.kernel.org/linux-ext4/CA+G9fYsyYQ3ZL4xaSg1-Tt5Evto7Zd+hgNWZEa9cQLbahA1+xg@mail.gmail.com/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250707140814.542883-12-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h   |  2 +-
 fs/ext4/ialloc.c |  3 +--
 fs/ext4/inode.c  | 22 +++++++++++++++++++---
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 18373de980f2..fe3366e98493 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3020,7 +3020,7 @@ int ext4_walk_page_buffers(handle_t *handle,
 				     struct buffer_head *bh));
 int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 				struct buffer_head *bh);
-bool ext4_should_enable_large_folio(struct inode *inode);
+void ext4_set_inode_mapping_order(struct inode *inode);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define CONVERT_INLINE_DATA	 2
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 79aa3df8d019..df4051613b29 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1335,8 +1335,7 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 		}
 	}
 
-	if (ext4_should_enable_large_folio(inode))
-		mapping_set_large_folios(inode->i_mapping);
+	ext4_set_inode_mapping_order(inode);
 
 	ext4_update_inode_fsync_trans(handle, inode, 1);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ee4129b5ecce..0f316632b8dd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5107,7 +5107,7 @@ static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
 	return -EFSCORRUPTED;
 }
 
-bool ext4_should_enable_large_folio(struct inode *inode)
+static bool ext4_should_enable_large_folio(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
@@ -5124,6 +5124,22 @@ bool ext4_should_enable_large_folio(struct inode *inode)
 	return true;
 }
 
+/*
+ * Limit the maximum folio order to 2048 blocks to prevent overestimation
+ * of reserve handle credits during the folio writeback in environments
+ * where the PAGE_SIZE exceeds 4KB.
+ */
+#define EXT4_MAX_PAGECACHE_ORDER(i)		\
+		umin(MAX_PAGECACHE_ORDER, (11 + (i)->i_blkbits - PAGE_SHIFT))
+void ext4_set_inode_mapping_order(struct inode *inode)
+{
+	if (!ext4_should_enable_large_folio(inode))
+		return;
+
+	mapping_set_folio_order_range(inode->i_mapping, 0,
+				      EXT4_MAX_PAGECACHE_ORDER(inode));
+}
+
 struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 			  ext4_iget_flags flags, const char *function,
 			  unsigned int line)
@@ -5441,8 +5457,8 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
-	if (ext4_should_enable_large_folio(inode))
-		mapping_set_large_folios(inode->i_mapping);
+
+	ext4_set_inode_mapping_order(inode);
 
 	ret = check_igot_inode(inode, flags, function, line);
 	/*
-- 
2.39.5



