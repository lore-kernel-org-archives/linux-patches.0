Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A1915D1;
	Sat,  7 Jun 2025 10:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291040; cv=none; b=YTYMtT8t68BjRE4Hh/7N79MLTmKGTkKA1rBL7XVebhTd9TEpLXT6ZkZTlX7FdwqfMeS9XMjtYvlNX8TuZ0fQHpeInZInYuXWJzm/3CS6dwoHmtfjfAtj3NI8NLOsCVHJ3r27XB+LO02TQg2tSt2rMMbhLDfbOVw9VBIEYjuJFEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291040; c=relaxed/simple;
	bh=1KGsHZpbrW/MWkN0UD5spF84MRWalTABOiZd6mCv/bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LY1SF9MdiGHOYeebaKuVhTD/kCyFjLEDWQZuzJcyHapvW8dKgvkvqNwo4+H0dMR1Uik2tRJUX3IrCAqNIIwEyfRHfdLnFf5LYPp/vXJwCebJeDyG0uIv/i5mBYkXLP0+z4NToS2kaaME5ILLmgfCG/ilhkDqxGV8xmDQOdpa+Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFLwmZ/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFLwmZ/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD03C4CEE4;
	Sat,  7 Jun 2025 10:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291039;
	bh=1KGsHZpbrW/MWkN0UD5spF84MRWalTABOiZd6mCv/bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFLwmZ/jQLsatXmc6vvQ8ewjpw7FRtQ/dh8nJq0RyI/RFxGqZ6cASyLsw8DdZT1Zp
	 y5osE+hjPBss7Q8yvuAFITQwuM+3p5wWZM/NF/0RcGGYrOVFqDxDOi+HnXNa3N8yTT
	 p+vt12xioNnYYnwgnfHwRe9an3gfIs4V6c5rFFLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.15 14/34] bcachefs: Kill un-reverted directory i_size code
Date: Sat,  7 Jun 2025 12:07:55 +0200
Message-ID: <20250607100720.279128777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 95fafc0f3407a6446082c11849df585bd3246571 upstream.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/dirent.c |   12 ++----------
 fs/bcachefs/dirent.h |    4 ++--
 fs/bcachefs/namei.c  |    4 ++--
 3 files changed, 6 insertions(+), 14 deletions(-)

--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -395,8 +395,8 @@ int bch2_dirent_read_target(struct btree
 }
 
 int bch2_dirent_rename(struct btree_trans *trans,
-		subvol_inum src_dir, struct bch_hash_info *src_hash, u64 *src_dir_i_size,
-		subvol_inum dst_dir, struct bch_hash_info *dst_hash, u64 *dst_dir_i_size,
+		subvol_inum src_dir, struct bch_hash_info *src_hash,
+		subvol_inum dst_dir, struct bch_hash_info *dst_hash,
 		const struct qstr *src_name, subvol_inum *src_inum, u64 *src_offset,
 		const struct qstr *dst_name, subvol_inum *dst_inum, u64 *dst_offset,
 		enum bch_rename_mode mode)
@@ -535,14 +535,6 @@ int bch2_dirent_rename(struct btree_tran
 	    new_src->v.d_type == DT_SUBVOL)
 		new_src->v.d_parent_subvol = cpu_to_le32(src_dir.subvol);
 
-	if (old_dst.k)
-		*dst_dir_i_size -= bkey_bytes(old_dst.k);
-	*src_dir_i_size -= bkey_bytes(old_src.k);
-
-	if (mode == BCH_RENAME_EXCHANGE)
-		*src_dir_i_size += bkey_bytes(&new_src->k);
-	*dst_dir_i_size += bkey_bytes(&new_dst->k);
-
 	ret = bch2_trans_update(trans, &dst_iter, &new_dst->k_i, 0);
 	if (ret)
 		goto out;
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -80,8 +80,8 @@ enum bch_rename_mode {
 };
 
 int bch2_dirent_rename(struct btree_trans *,
-		       subvol_inum, struct bch_hash_info *, u64 *,
-		       subvol_inum, struct bch_hash_info *, u64 *,
+		       subvol_inum, struct bch_hash_info *,
+		       subvol_inum, struct bch_hash_info *,
 		       const struct qstr *, subvol_inum *, u64 *,
 		       const struct qstr *, subvol_inum *, u64 *,
 		       enum bch_rename_mode);
--- a/fs/bcachefs/namei.c
+++ b/fs/bcachefs/namei.c
@@ -418,8 +418,8 @@ int bch2_rename_trans(struct btree_trans
 	}
 
 	ret = bch2_dirent_rename(trans,
-				 src_dir, &src_hash, &src_dir_u->bi_size,
-				 dst_dir, &dst_hash, &dst_dir_u->bi_size,
+				 src_dir, &src_hash,
+				 dst_dir, &dst_hash,
 				 src_name, &src_inum, &src_offset,
 				 dst_name, &dst_inum, &dst_offset,
 				 mode);


