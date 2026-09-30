Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FB34E56E3;
	Wed, 30 Sep 2026 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783831; cv=none; b=rtsukxLaP08AwjJUMvPWB8+Kpo8KA0DPLQrqdhnUI3G7JvJOLwecoaJZ6tbyiQWRq3e2K67hekgL1R3q1sj+2TvLIyK3UBhxdP38db29kSpA6+/GbZ9ZVAjKeYVPHAOGsr/oA2m34VOnDCNhSX/B7AQ9p4dSYVySP4ZblQt9Q6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783831; c=relaxed/simple;
	bh=kkcR7uZqv6eUBpAyBNpK5KQa0SLoYwn8NMgruTbIjRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opLiw17rRBDjpODOOiH1FbQ1EUYm2erE7ANSZGmHhG8/N++HUDn9rF7eIaozFd5o4VG+ZKTyxK9FVfmAVxdkr/NzdVB64IWYRW5jmNiadowDeuU846NHPPwGI86VOPGs7fpfOkadclpZJ5J1axNqkohnyoSePPXyXtuZpu44JyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEeoIbaM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEeoIbaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759551F000FF;
	Wed, 30 Sep 2026 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783827;
	bh=gAwFmOM+AA6goyxNwk1nY6K2nT9/YwNrs9z4jKcHq0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEeoIbaMZx3c8lBN1EGJdCAZagO8bj2w9abTGuZ1R3OcKowCVuO9hwUCgK5bV4xoM
	 EugdhUWG8/1GtOfs2f80pkJnBM9P+bvLfEjzqROrwKNz6iVdHfEB9Lkw2f2Pk6yAXj
	 HEznhPoroB+4fPN8N2KC0Xx3psivfsveuId4Bgs0=
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
Subject: [PATCH 5.10 499/595] ocfs2: make ocfs2_calc_xattr_init() return void
Date: Wed, 30 Sep 2026 17:26:32 +0200
Message-ID: <20260930152358.429903519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index db6ea2ebc9688..118e368ec76be 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -332,13 +332,8 @@ static int ocfs2_mknod(struct inode *dir,
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
index 967a210225138..0f8fdb29d53b1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -613,12 +613,11 @@ int ocfs2_calc_security_init(struct inode *dir,
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
 
@@ -640,7 +639,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 	}
 
 	if (!(s_size + a_size))
-		return ret;
+		return;
 
 	/*
 	 * The max space of security xattr taken inline is
@@ -706,8 +705,6 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
 			}
 		}
 	}
-
-	return ret;
 }
 
 static int ocfs2_xattr_extend_allocation(struct inode *inode,
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index e3e2476efe1a9..c78bf7e99f1e2 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -59,10 +59,10 @@ int ocfs2_calc_security_init(struct inode *,
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



