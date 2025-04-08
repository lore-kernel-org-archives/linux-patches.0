Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1405265CC8;
	Tue,  8 Apr 2025 11:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110793; cv=none; b=ZI4bcDvXlvH7Qvjon9AVFP/7oCVuuxGX+7gO13bHSIiIAe/u7UPYrq7TGkYI7zQzqIBBAqnvch1Hr96P7KPjze1jsl2sr/W09qvSAJ2pwTlisfLRuGwhH8Fc1h4+LoXdWqTACaRxeb5At5Te0svLTGgYPW8Ao98MW6gtIrmUtpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110793; c=relaxed/simple;
	bh=t2x/UwY+GkeTGKffbMO1k7hzuVOqgqq9nHfeOljQdnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqrNKmDhCYXjFuCqBavRs+cx9O137E6VT9UWH5GGRzMzm6pUVX9rSRaL/y8WHOjFL3gK8PIgtQkyn9zzrOWkzmR3cgT5HNrLUUckZ682U/59Fa8XpWmd/+Mrh87QoXdrfmecrIEdIXXj2mDY5p7i7TidJapTQcoYMY+/n3glDjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KI2D38fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KI2D38fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFD7C4CEE5;
	Tue,  8 Apr 2025 11:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110793;
	bh=t2x/UwY+GkeTGKffbMO1k7hzuVOqgqq9nHfeOljQdnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KI2D38fwIZU0ujJc9G3YV66p9ZyIsFXTdLNNQVQ/LiqkAbSpF0YuxBPrYaUTL6TQV
	 +deB4KL2qNQyr1ZXO+KuHBgvtUMrlD0eYfkYms46dN3XcDLhZImwWkrFvAPeFPUlAk
	 3v5l71dYVZSOumxrhnqkWL9ztFlByCXqvA2n76vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 196/731] ext4: introduce ITAIL helper
Date: Tue,  8 Apr 2025 12:41:33 +0200
Message-ID: <20250408104918.839585533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 69f3a3039b0d0003de008659cafd5a1eaaa0a7a4 ]

Introduce ITAIL helper to get the bound of xattr in inode.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250208063141.1539283-2-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 5701875f9609 ("ext4: fix out-of-bound read in ext4_xattr_inode_dec_ref_all()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 10 +++++-----
 fs/ext4/xattr.h |  3 +++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7647e9f6e1903..0e4494863d153 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -649,7 +649,7 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 		return error;
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
-	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+	end = ITAIL(inode, raw_inode);
 	error = xattr_check_inode(inode, header, end);
 	if (error)
 		goto cleanup;
@@ -793,7 +793,7 @@ ext4_xattr_ibody_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 		return error;
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
-	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+	end = ITAIL(inode, raw_inode);
 	error = xattr_check_inode(inode, header, end);
 	if (error)
 		goto cleanup;
@@ -879,7 +879,7 @@ int ext4_get_inode_usage(struct inode *inode, qsize_t *usage)
 			goto out;
 		raw_inode = ext4_raw_inode(&iloc);
 		header = IHDR(inode, raw_inode);
-		end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+		end = ITAIL(inode, raw_inode);
 		ret = xattr_check_inode(inode, header, end);
 		if (ret)
 			goto out;
@@ -2235,7 +2235,7 @@ int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 	header = IHDR(inode, raw_inode);
 	is->s.base = is->s.first = IFIRST(header);
 	is->s.here = is->s.first;
-	is->s.end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+	is->s.end = ITAIL(inode, raw_inode);
 	if (ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
 		error = xattr_check_inode(inode, header, is->s.end);
 		if (error)
@@ -2786,7 +2786,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	 */
 
 	base = IFIRST(header);
-	end = (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
+	end = ITAIL(inode, raw_inode);
 	min_offs = end - base;
 	total_ino = sizeof(struct ext4_xattr_ibody_header) + sizeof(u32);
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index b25c2d7b5f991..5197f17ffd9a2 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -67,6 +67,9 @@ struct ext4_xattr_entry {
 		((void *)raw_inode + \
 		EXT4_GOOD_OLD_INODE_SIZE + \
 		EXT4_I(inode)->i_extra_isize))
+#define ITAIL(inode, raw_inode) \
+	((void *)(raw_inode) + \
+	 EXT4_SB((inode)->i_sb)->s_inode_size)
 #define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
 
 /*
-- 
2.39.5



