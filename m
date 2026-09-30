Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD146407CEF;
	Wed, 30 Sep 2026 19:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796759; cv=none; b=tHYMvL5AGAxyPSDY3sZfKj12eyy3dVtskDTMK4poYcQuK1T1f28M802tHBgZRBg4DAZb11WFS3wuSRUNAGczNBnBvBwhwu9JTt4/izRjilldrpeswOFgTxRWsyaBFM17JeDNvh7hetnaDy8db9gqkkOta+VQPa74XAKHXWiqF/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796759; c=relaxed/simple;
	bh=LhM/c0H52aEc4JvQpywPVBzrxBu3w3Px3WC7ceckrdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJfQiP6kzfKFlbkqrgAurhDjZfqx6Oxu5kiThnqgxSyxfjHuNXqxtxiJ+zrc+g72PxRDN39NdFKshmIKXrTe57xyH1jz/U7fG43SNuRY3p2Ksvzlf0zXy+HsMs1au5hmyKgSRo1uYmU9ibx2II2U1+90348w8a0I/poYBQqr9kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haJoL3kS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haJoL3kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2FF1F000FF;
	Wed, 30 Sep 2026 19:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796757;
	bh=q+3cXwV5IjWSGnKvp5GZ6138LI2llxfRStXSG5H83Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=haJoL3kSXty/W8a6Tyu2XTkr6PTvtaZtYiRl4ObcdSYalDqS7ZePQS7nEw8QK1w2A
	 hckBXrqd0vARgxYHh1r9p4njx+kIY1aQ/uueOwFpX3Y18LtENKUPq0IIHMmKAJlnZr
	 LWadgXhlKeuo20fh9cTWxQzeeu2GkVv+9SozkLys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel test robot <lkp@intel.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0999/1193] ocfs2: make ocfs2_calc_xattr_init() return void
Date: Wed, 30 Sep 2026 17:28:03 +0200
Message-ID: <20260930152456.435457091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 525c0edc032b3297d0c1056cf1fa20cf1f9e6184 ]

ocfs2_calc_xattr_init() used to read the default ACL off the parent inode
itself, so it could return an error from ocfs2_xattr_get_nolock().  Commit
bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
ocfs2_init_acl()") moved that lookup before the transaction starts and
deleted the error path, but left the now vestigial 'int ret = 0'
declaration and both 'return ret' statements behind, along with an
unreachable error branch in ocfs2_mknod().

Drop the leftover variable and convert the return type to void, so the
callee states that it always succeeds and the caller no longer carries a
check that can never trigger.

No functional change.

Link: https://lore.kernel.org/20260904023751.3703334-1-joseph.qi@linux.alibaba.com
Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/namei.c |  9 ++-------
 fs/ocfs2/xattr.c | 13 +++++--------
 fs/ocfs2/xattr.h |  8 ++++----
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 113102009431d..111e60ac19b94 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -332,13 +332,8 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 		goto leave;
 
 	/* calculate meta data/clusters for setting security and acl xattr */
-	status = ocfs2_calc_xattr_init(dir, mode, &si, &want_clusters,
-				       &xattr_credits, &want_meta,
-				       &acl_state);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_calc_xattr_init(dir, mode, &si, &want_clusters, &xattr_credits,
+			      &want_meta, &acl_state);
 
 	/* Reserve a cluster if creating an extent based directory. */
 	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb)) {
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3023b33afef40..dc3d88a09d106 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -607,12 +607,11 @@ int ocfs2_calc_security_init(struct inode *dir,
 	return ret;
 }
 
-int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
-			  struct ocfs2_security_xattr_info *si,
-			  int *want_clusters, int *xattr_credits,
-			  int *want_meta, struct ocfs2_acl_state *acl_state)
+void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
+			   struct ocfs2_security_xattr_info *si,
+			   int *want_clusters, int *xattr_credits,
+			   int *want_meta, struct ocfs2_acl_state *acl_state)
 {
-	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
 
@@ -634,7 +633,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 	}
 
 	if (!(s_size + a_size))
-		return ret;
+		return;
 
 	/*
 	 * The max space of security xattr taken inline is
@@ -700,8 +699,6 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 			}
 		}
 	}
-
-	return ret;
 }
 
 static int ocfs2_xattr_extend_allocation(struct inode *inode,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 5901f2095bc57..016374e9a147e 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -57,10 +57,10 @@ int ocfs2_calc_security_init(struct inode *,
 			     int *, int *, struct ocfs2_alloc_context **);
 
 struct ocfs2_acl_state;
-int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
-			  struct ocfs2_security_xattr_info *si,
-			  int *want_clusters, int *xattr_credits,
-			  int *want_meta, struct ocfs2_acl_state *acl_state);
+void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
+			   struct ocfs2_security_xattr_info *si,
+			   int *want_clusters, int *xattr_credits,
+			   int *want_meta, struct ocfs2_acl_state *acl_state);
 
 /*
  * xattrs can live inside an inode, as part of an external xattr block,
-- 
2.53.0



