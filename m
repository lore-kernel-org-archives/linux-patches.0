Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A546E00F;
	Tue, 21 Jul 2026 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672503; cv=none; b=XPC/hD83mOemnVSYT8LaZh3zadEBpLXq3uNnsh3E4tslvUrA8WYJdbQ10LVFqn3wvTGXvaltGs9CKAeC5MNvTiS9qPFzdBIqJ4PO+lSNHUPEixOjh6Csw2ToHjAMRf35/PIleEvruUgLn/FqSyqEMx7shmifUeUHlybpHCJY9IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672503; c=relaxed/simple;
	bh=gylvZ2LypINp45IATIwSCXmYKjwnhgVymrpQZmSZP7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ib9BKop/z0WNW/1vA6GgsUofFyh2HNtzvEa08ppKOquGAprraRWx+VwFndkrip+ieCNru607+gxX08IJJmSXCkfDxAPipSG+ktTzBIpP1vbGgtN8DxIGtGHhkNwX833IO+reU54qEtcqzg0FWBFTBxXR0hg2PevxcpTyQds9rSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXDLaWlo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXDLaWlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA50E1F000E9;
	Tue, 21 Jul 2026 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672502;
	bh=mMu2Spr7+T31Ly7RFLaBarNaPJsR7+3q1NajfH06FZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXDLaWloUNmQZBBb+BBV9qveAYcpSfV/2t2R+U2C+GWuE5AofMueEv9lup2ux5auK
	 b0jvoMslXbvl5QMiD37S7sg2vVYfweWF3M5dE0smC6JM4x3B27NW4BlB7FHIY5tvrV
	 INkxvNFo+l4rZSDFzWPGhc2zp+7MYJiPKGTO3L4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 632/843] ocfs2: reject non-inline dinodes with i_size and zero i_clusters
Date: Tue, 21 Jul 2026 17:24:27 +0200
Message-ID: <20260721152420.279829628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 7ebc672fab7a76e1e47e0f2fc1ee48118d27fde4 upstream.

On a volume mounted without OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC, a
non-inline regular file with non-zero i_size and zero i_clusters is
structurally malformed: the extent map declares no allocated clusters yet
the size header claims content exists.  Keep rejecting that shape, but
express it through a shared predicate so the same invariant is available
to normal inode reads and online filecheck.

The same zero-cluster shape is also malformed for non-inline directories.
ocfs2 directory growth allocates backing storage before advancing i_size,
and ocfs2_dir_foreach_blk_el() later walks until ctx->pos reaches
i_size_read(inode).  A forged directory dinode with a huge i_size and no
clusters would repeatedly fail on holes while advancing through the
claimed size.

Sparse regular files remain exempt: on sparse-alloc volumes, truncate can
legitimately grow i_size without allocating clusters.  System inodes and
inline-data dinodes also retain their separate storage rules.

Mirror the check in ocfs2_filecheck_validate_inode_block() as well.
filecheck reports through its own error namespace, so malformed
size/cluster state is logged as a filecheck invalid-inode result rather
than via ocfs2_error(), but it must not proceed into
ocfs2_populate_inode().

Link: https://lore.kernel.org/20260519110404.1803902-4-michael.bommarito@gmail.com
Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito%40gmail.com
Assisted-by: Claude:claude-opus-4-7
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/inode.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -83,6 +83,24 @@ static bool ocfs2_dinode_has_unexpected_
 	return !S_ISCHR(mode) && !S_ISBLK(mode) && di->id1.dev1.i_rdev != 0;
 }
 
+static bool ocfs2_dinode_has_size_without_clusters(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	umode_t mode = le16_to_cpu(di->i_mode);
+
+	if (le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)
+		return false;
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)
+		return false;
+	if (!le64_to_cpu(di->i_size) || le32_to_cpu(di->i_clusters))
+		return false;
+
+	if (S_ISDIR(mode))
+		return true;
+
+	return !ocfs2_sparse_alloc(OCFS2_SB(sb)) && S_ISREG(mode);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1484,6 +1502,33 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	/*
+	 * Non-inline directories must not have i_size without allocated
+	 * clusters: directory growth adds storage before advancing i_size,
+	 * and readdir walks i_size block-by-block.  A forged directory
+	 * with zero clusters and a huge i_size would repeatedly fault on
+	 * holes while advancing through the claimed size.
+	 *
+	 * Non-inline regular files have the same invariant on non-sparse
+	 * volumes.  Sparse regular files are different: truncate can
+	 * legitimately grow i_size without allocating clusters, so keep
+	 * the sparse-alloc carveout for S_IFREG only.  System inodes and
+	 * inline-data dinodes have their own storage rules.
+	 */
+	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
+		if (S_ISDIR(le16_to_cpu(di->i_mode)))
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: directory i_size %llu with i_clusters 0 and no inline-data flag\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size));
+		else
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
@@ -1599,6 +1644,21 @@ static int ocfs2_filecheck_validate_inod
 		     le16_to_cpu(di->i_mode),
 		     (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
+		if (S_ISDIR(le16_to_cpu(di->i_mode)))
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: directory i_size %llu with i_clusters 0 and no inline-data flag\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)le64_to_cpu(di->i_size));
+		else
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)le64_to_cpu(di->i_size));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
 bail:


