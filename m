Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2270194A45;
	Thu,  5 Sep 2024 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530307; cv=none; b=lo6QUuytdHgBMzhAAV7z9/ZrC7NZEl/W+GVGujGic/IGCg3pL0ulChxpJeIiZ9E5GRT7H+F5np6k5E+NwYT04Ez7RfRxLJB0qWapi92nnzukkzeOWc/bYD619IJdlag7ZzQd68hYRWEbbq8DOg3e+yzfIhkqb3a7B8ZN3v2LUOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530307; c=relaxed/simple;
	bh=fpWZRn54upBAc5IzPA+o2hUQ7DxP0KGopHKq8qY33bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pgv+sn4FVepcNb30GzNai2JgbhtYap5EpPBzWXwon6OEIcA8BuuVNx4gmTntbHIrwW6+XEoHkN3QEHV/yPQpxWMBGkRppeQb7xVmsNWsEMIAyLN+RcH7ciCSDXZacHWC08NkHTZdfGwiQF1C9P6s9oQ5xRbi+i7CT7e+IfMxBf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4moAu+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4moAu+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC4CC4CEC3;
	Thu,  5 Sep 2024 09:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530307;
	bh=fpWZRn54upBAc5IzPA+o2hUQ7DxP0KGopHKq8qY33bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4moAu+aJjlzr/KH6hD6Fuv3QK1YnkAvAemHYb/Sqd9sEy4F0DS8znT190ioS9N4q
	 E5JNCsC/T9vgQ1yel5COJy+8a+JgQ8x+i1qjPQe1OQABpweU8QIK/bCP3wnKxPUnFh
	 6GhYGWZ61EkGn51M8BQSw9ndZdboZeFP+THXmSb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/132] f2fs: fix to do sanity check on blocks for inline_data inode
Date: Thu,  5 Sep 2024 11:41:44 +0200
Message-ID: <20240905093726.771873090@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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
index 00eff023cd9d..6371b295fba6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4148,7 +4148,7 @@ extern struct kmem_cache *f2fs_inode_entry_slab;
  * inline.c
  */
 bool f2fs_may_inline_data(struct inode *inode);
-bool f2fs_sanity_check_inline_data(struct inode *inode);
+bool f2fs_sanity_check_inline_data(struct inode *inode, struct page *ipage);
 bool f2fs_may_inline_dentry(struct inode *inode);
 void f2fs_do_read_inline_data(struct page *page, struct page *ipage);
 void f2fs_truncate_inline_inode(struct inode *inode,
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 2cbe557f971e..a3f8b4ed495e 100644
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
index 26e857fee631..709b2f79872f 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -346,7 +346,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 		}
 	}
 
-	if (f2fs_sanity_check_inline_data(inode)) {
+	if (f2fs_sanity_check_inline_data(inode, node_page)) {
 		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
 			  __func__, inode->i_ino, inode->i_mode);
 		return false;
-- 
2.43.0



