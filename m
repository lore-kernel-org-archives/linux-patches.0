Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DED17B515;
	Fri, 27 Sep 2024 12:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440020; cv=none; b=LNwjuLzuvkn/7ivgRra9qku8W+Y6XjKXmGWoI4eozq5gjlqwGAenVEVe4jE4mMQAkrSeHfHzUgh6bH8HkaDtWjb1TlTfo7nPsFNPstYt/jnqkXCRJI7hyKwX/mmC8QJ2KDBfFliyRA7hIdDBJB5R0O4EG3qIb0J4vElH9glPobs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440020; c=relaxed/simple;
	bh=bDNNJUTV6b7ho0p1GmRU2kvEB5mpsl7x1i4j/tqdk/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ud4SIKPdCX2s6dkUGec+DKR+lWB6ZY0fR7vqvbrrGJc0FKUHh0Hfw9ExNHoGiUj2yNNU5Uv9NFkWRn2MPf9DtT3INKwQVCzTL4gCCcF7F+MTc+u6na0wTwetd8R92FeRXKcc2xu82m/kIt/YrP/XDoP+3ZnYYVDSFUiAalmC0ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JADnRwro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JADnRwro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749CCC4CEC4;
	Fri, 27 Sep 2024 12:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440020;
	bh=bDNNJUTV6b7ho0p1GmRU2kvEB5mpsl7x1i4j/tqdk/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JADnRwro9BH9S3pYCeHKSnwVze8B0zW9/2SS5IiOR4clH0cAZ23ebBTq1Y3wqUO9A
	 s77vWNGsOqElQaaJJvbR4RzIMGcKPKcPKzzT0jeSyWnUtiII8O9Swe6xBAKh3pkG7m
	 A6QyAyf/s4xNPuAB+DckVfxPTsuD+uAJ2juygfzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Meng <mengferry@linux.alibaba.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	lei lu <llfamsec@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 37/54] ocfs2: add bounds checking to ocfs2_xattr_find_entry()
Date: Fri, 27 Sep 2024 14:23:29 +0200
Message-ID: <20240927121721.240542789@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ferry Meng <mengferry@linux.alibaba.com>

[ Upstream commit 9e3041fecdc8f78a5900c3aa51d3d756e73264d6 ]

Add a paranoia check to make sure it doesn't stray beyond valid memory
region containing ocfs2 xattr entries when scanning for a match.  It will
prevent out-of-bound access in case of crafted images.

Link: https://lkml.kernel.org/r/20240520024024.1976129-1-joseph.qi@linux.alibaba.com
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: lei lu <llfamsec@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: af77c4fc1871 ("ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b562cfef888ad..e6220f7f7cf34 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1062,7 +1062,7 @@ ssize_t ocfs2_listxattr(struct dentry *dentry,
 	return i_ret + b_ret;
 }
 
-static int ocfs2_xattr_find_entry(int name_index,
+static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 				  const char *name,
 				  struct ocfs2_xattr_search *xs)
 {
@@ -1076,6 +1076,10 @@ static int ocfs2_xattr_find_entry(int name_index,
 	name_len = strlen(name);
 	entry = xs->here;
 	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
+		if ((void *)entry >= xs->end) {
+			ocfs2_error(inode->i_sb, "corrupted xattr entries");
+			return -EFSCORRUPTED;
+		}
 		cmp = name_index - ocfs2_xattr_get_type(entry);
 		if (!cmp)
 			cmp = name_len - entry->xe_name_len;
@@ -1166,7 +1170,7 @@ static int ocfs2_xattr_ibody_get(struct inode *inode,
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
-	ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 	if (ret)
 		return ret;
 	size = le64_to_cpu(xs->here->xe_value_size);
@@ -2698,7 +2702,7 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
 
 	/* Find the named attribute. */
 	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 		if (ret && ret != -ENODATA)
 			return ret;
 		xs->not_found = ret;
@@ -2833,7 +2837,7 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
 		xs->here = xs->header->xh_entries;
 
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 	} else
 		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
 						   name_index,
-- 
2.43.0



