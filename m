Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1966E1E9078;
	Tue, 15 Oct 2024 11:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992400; cv=none; b=Xmp+ZEpN+U6Dy5er5PP/x+mQ/tsHkPnULWnJS08rIxhrtU7UI3hq8IMCXOwgEMXaedOXuJON2b0S9zIHMOjYVhCORFgVIj0nfqlw6D7b8uUzfv66SA7jYT8XjGI/mX46Ip5fe61U2AvtmczUOE92B4p6grKZ8sHOojAP6YGzXzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992400; c=relaxed/simple;
	bh=/w6O7Z2yLVjPVKaQkrGSY36JBgvYSJBOcyssaIeExec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bq94C2PihUZ8cWMEkwPaxKVTuxxetnVTXNsztVPIlslApdIoaRUhnzi4kZzMfo2FuyEslR4E9Hn+QcL99tM/77CZeJj62H2J7uLRtN5u0O64enfzh8jsjpzoFvarF7vCv+Zty+BLbwy0wLXv/xr+tHHv8wSWBXaCEpEvvdpjU7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZ8UGgee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZ8UGgee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9D4C4CEC6;
	Tue, 15 Oct 2024 11:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992400;
	bh=/w6O7Z2yLVjPVKaQkrGSY36JBgvYSJBOcyssaIeExec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZ8UGgee5EyVR24mUUAzO8QcxwopoGq7tKnm2af6hR7mvFSJyv53T3hEIfkSuf/PG
	 IibiLXgsSThfVllYD95GGXndhc7IyocAcQ1peyOxJZyT8P+lBh/lB8om0HrlZDFply
	 JYB8e8OqeM9gShMzy4SOPDtQjXGEV0ryj+mNZj0g=
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
Subject: [PATCH 5.15 078/691] ocfs2: add bounds checking to ocfs2_xattr_find_entry()
Date: Tue, 15 Oct 2024 13:20:26 +0200
Message-ID: <20241015112443.453063162@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index c101a71a52ae8..884e45d27564b 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1066,7 +1066,7 @@ ssize_t ocfs2_listxattr(struct dentry *dentry,
 	return i_ret + b_ret;
 }
 
-static int ocfs2_xattr_find_entry(int name_index,
+static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 				  const char *name,
 				  struct ocfs2_xattr_search *xs)
 {
@@ -1080,6 +1080,10 @@ static int ocfs2_xattr_find_entry(int name_index,
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
@@ -1170,7 +1174,7 @@ static int ocfs2_xattr_ibody_get(struct inode *inode,
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
-	ret = ocfs2_xattr_find_entry(name_index, name, xs);
+	ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 	if (ret)
 		return ret;
 	size = le64_to_cpu(xs->here->xe_value_size);
@@ -2702,7 +2706,7 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
 
 	/* Find the named attribute. */
 	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 		if (ret && ret != -ENODATA)
 			return ret;
 		xs->not_found = ret;
@@ -2837,7 +2841,7 @@ static int ocfs2_xattr_block_find(struct inode *inode,
 		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
 		xs->here = xs->header->xh_entries;
 
-		ret = ocfs2_xattr_find_entry(name_index, name, xs);
+		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
 	} else
 		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
 						   name_index,
-- 
2.43.0



