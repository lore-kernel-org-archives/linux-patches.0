Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D9825F988;
	Fri,  7 Aug 2026 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116764; cv=none; b=aFzheckpY1rHlTx7zPTrNieipgaZJ2yJDoqQ+7jwGEJQcITwfTXOwj8CPIaeoQg2efJ+swrB1DOZlrLfiX4mwUK800fNUiRKrgprxXrh5ylXNgseJrKqwlIqGYYYyXn/BK+T0vItn90sgUoAeBeqRvrLYIqWeBHFeVUTvMjGRJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116764; c=relaxed/simple;
	bh=EvOhOdLH7dksXtg5WXY4EwGxy8PgqRMHO4CpLNW2VJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKLXt+CHChLiufBz1axxdmGzAplJuin9zqqDDG71d9FteCQViS3uo4Z2SN2Iu8gYxih07gtsxzWR8/0B0Ob839E9DhkHu9+RQI0YX+kw4kyh5gudmyxkMLZaaEZzHpZUxgqOveAYv3XFjawCJOlEZlrqLE51AUlRogav8PNMX+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8TMF1QD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8TMF1QD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FD71F000E9;
	Fri,  7 Aug 2026 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116763;
	bh=z1uJqsTcCKOZ/BzzOQUG/ooCXvSJPS5gKZeCk2iXSKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8TMF1QDoWtPJqq+0X7uz2m7Y4klJAO20spCMw/2Hvf8oDV3vxAHCIv69RoSsaPeJ
	 ularFsjMUkIlG2f9MkY1U9x5PN91Y/xzByihivbcdeX6vn/S/RmkKj3HqGwuiEAX7y
	 /6G722+WWE6SQ2kb11608llWcjX05yUouisQyS2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 083/438] erofs: clean up erofs_ishare_fill_inode()
Date: Fri,  7 Aug 2026 16:34:39 +0200
Message-ID: <20260807143429.752718626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1ccc75909ca7c3b52163b408a3e1eb5453db013f ]

 - Use the shorthand `si` to replace the overly long `sharedinode`;

 - Introduce erofs_warn() and get rid of barely-used _erofs_printk();

 - Get rid of the variable `hash`;

 - Simplify error paths.

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 96b2dbbe58a1 ("erofs: ensure valid f_path for page cache sharing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/internal.h |  2 ++
 fs/erofs/ishare.c   | 45 +++++++++++++++++++--------------------------
 2 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 4792490161ec9..9e2ae7b619773 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -23,6 +23,8 @@
 __printf(2, 3) void _erofs_printk(struct super_block *sb, const char *fmt, ...);
 #define erofs_err(sb, fmt, ...)	\
 	_erofs_printk(sb, KERN_ERR fmt "\n", ##__VA_ARGS__)
+#define erofs_warn(sb, fmt, ...) \
+	_erofs_printk(sb, KERN_WARNING fmt "\n", ##__VA_ARGS__)
 #define erofs_info(sb, fmt, ...) \
 	_erofs_printk(sb, KERN_INFO fmt "\n", ##__VA_ARGS__)
 
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 6ed66b17359ba..35cbd0bc04d7d 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -40,49 +40,42 @@ static int erofs_ishare_iget5_set(struct inode *inode, void *data)
 bool erofs_ishare_fill_inode(struct inode *inode)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
-	struct erofs_inode *vi = EROFS_I(inode);
 	const struct address_space_operations *aops;
+	struct erofs_inode *vi = EROFS_I(inode);
 	struct erofs_inode_fingerprint fp;
-	struct inode *sharedinode;
-	unsigned long hash;
+	struct inode *si;
 
 	aops = erofs_get_aops(inode, true);
 	if (IS_ERR(aops))
 		return false;
 	if (erofs_xattr_fill_inode_fingerprint(&fp, inode, sbi->domain_id))
 		return false;
-	hash = xxh32(fp.opaque, fp.size, 0);
-	sharedinode = iget5_locked(erofs_ishare_mnt->mnt_sb, hash,
-				   erofs_ishare_iget5_eq, erofs_ishare_iget5_set,
-				   &fp);
-	if (!sharedinode) {
-		kfree(fp.opaque);
-		return false;
-	}
 
-	if (inode_state_read_once(sharedinode) & I_NEW) {
-		sharedinode->i_mapping->a_ops = aops;
-		sharedinode->i_size = vi->vfs_inode.i_size;
-		unlock_new_inode(sharedinode);
+	si = iget5_locked(erofs_ishare_mnt->mnt_sb,
+			  xxh32(fp.opaque, fp.size, 0),
+			  erofs_ishare_iget5_eq, erofs_ishare_iget5_set, &fp);
+	if (si && (inode_state_read_once(si) & I_NEW)) {
+		si->i_mapping->a_ops = aops;
+		si->i_size = inode->i_size;
+		unlock_new_inode(si);
 	} else {
 		kfree(fp.opaque);
-		if (aops != sharedinode->i_mapping->a_ops) {
-			iput(sharedinode);
+		if (!si || aops != si->i_mapping->a_ops) {
+			iput(si);
 			return false;
 		}
-		if (sharedinode->i_size != vi->vfs_inode.i_size) {
-			_erofs_printk(inode->i_sb, KERN_WARNING
-				"size(%lld:%lld) not matches for the same fingerprint\n",
-				vi->vfs_inode.i_size, sharedinode->i_size);
-			iput(sharedinode);
+		if (si->i_size != inode->i_size) {
+			erofs_warn(inode->i_sb, "i_size mismatch (%lld != %lld) for the same fingerprint",
+				   inode->i_size, si->i_size);
+			iput(si);
 			return false;
 		}
 	}
-	vi->sharedinode = sharedinode;
+	vi->sharedinode = si;
 	INIT_LIST_HEAD(&vi->ishare_list);
-	spin_lock(&EROFS_I(sharedinode)->ishare_lock);
-	list_add(&vi->ishare_list, &EROFS_I(sharedinode)->ishare_list);
-	spin_unlock(&EROFS_I(sharedinode)->ishare_lock);
+	spin_lock(&EROFS_I(si)->ishare_lock);
+	list_add(&vi->ishare_list, &EROFS_I(si)->ishare_list);
+	spin_unlock(&EROFS_I(si)->ishare_lock);
 	return true;
 }
 
-- 
2.53.0



