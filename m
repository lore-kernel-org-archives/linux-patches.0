Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E72D192D73;
	Thu,  5 Sep 2024 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529927; cv=none; b=nkY90B1oPOd3cgpH8U7LCGM7yU49sng+vXR/sAUOB/zekHrjhQJQA9PYhxVIGu9BsryKpZSokkzfJma0WEFaVI4hVUGS79itmlgR6z/LJzqA9H876miZK4UR13kx4dyXeEBvDXfhpeLIgR08cqhztfI0bb19+r0JS9mXqRXyWEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529927; c=relaxed/simple;
	bh=2qYum8MBUdIQqxsdl0EuxZ8fbcY8J+THhvYPuo1d1PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSYqow2UGr4XwwUK4Cl0omYJcABvLKe0DELmb0iCLw+VmvME+d3ltlgW7qSlRnPnVQe+PzRggupt7nq5+UCKTbieZz4Ijmr+lHwpvBJg71mm+hCa3N9/x2ftBYVmLeB25VJb8JCMIQCyaqsnIELKgFWMIdry8Y405vbbZ3w7L/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGKhIBG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGKhIBG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91EBC4CEC6;
	Thu,  5 Sep 2024 09:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529927;
	bh=2qYum8MBUdIQqxsdl0EuxZ8fbcY8J+THhvYPuo1d1PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGKhIBG5cN0FQB1ylmb8Nu9SVMWo/Zgqxz/N8EX4p4oNkc4VaQ7bGRbWa8YYscg42
	 ivJPNFWdF4aHpeE2Lp3wWtX707yVMDymLlUSqB7onxReu/rhjFFifq1tBVvT7SyAxy
	 CWd/3tmaztT1PZkI0haWIvposA1WFNwCCjoRsjcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 159/184] f2fs: fix to do sanity check on blocks for inline_data inode
Date: Thu,  5 Sep 2024 11:41:12 +0200
Message-ID: <20240905093738.550068365@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit c240c87bcd44a1a2375fc8ef8c645d1f1fe76466 ]

inode can be fuzzed, so it can has F2FS_INLINE_DATA flag and valid
i_blocks/i_nid value, this patch supports to do extra sanity check
to detect such corrupted state.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h   |  2 +-
 fs/f2fs/inline.c | 20 +++++++++++++++++++-
 fs/f2fs/inode.c  |  2 +-
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5556ab491368..92fda31c68cd 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4154,7 +4154,7 @@ extern struct kmem_cache *f2fs_inode_entry_slab;
  * inline.c
  */
 bool f2fs_may_inline_data(struct inode *inode);
-bool f2fs_sanity_check_inline_data(struct inode *inode);
+bool f2fs_sanity_check_inline_data(struct inode *inode, struct page *ipage);
 bool f2fs_may_inline_dentry(struct inode *inode);
 void f2fs_do_read_inline_data(struct folio *folio, struct page *ipage);
 void f2fs_truncate_inline_inode(struct inode *inode,
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 215daa71dc18..cca7d448e55c 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -33,11 +33,29 @@ bool f2fs_may_inline_data(struct inode *inode)
 	return !f2fs_post_read_required(inode);
 }
 
-bool f2fs_sanity_check_inline_data(struct inode *inode)
+static bool inode_has_blocks(struct inode *inode, struct page *ipage)
+{
+	struct f2fs_inode *ri = F2FS_INODE(ipage);
+	int i;
+
+	if (F2FS_HAS_BLOCKS(inode))
+		return true;
+
+	for (i = 0; i < DEF_NIDS_PER_INODE; i++) {
+		if (ri->i_nid[i])
+			return true;
+	}
+	return false;
+}
+
+bool f2fs_sanity_check_inline_data(struct inode *inode, struct page *ipage)
 {
 	if (!f2fs_has_inline_data(inode))
 		return false;
 
+	if (inode_has_blocks(inode, ipage))
+		return false;
+
 	if (!support_inline_data(inode))
 		return true;
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index ed629dabbfda..57da02bfa823 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -347,7 +347,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 		}
 	}
 
-	if (f2fs_sanity_check_inline_data(inode)) {
+	if (f2fs_sanity_check_inline_data(inode, node_page)) {
 		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
 			  __func__, inode->i_ino, inode->i_mode);
 		return false;
-- 
2.43.0



