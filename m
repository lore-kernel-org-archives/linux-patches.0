Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9159C1F4CB8;
	Sat,  7 Jun 2025 10:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291042; cv=none; b=IK9h+S+DTmRWlvL7fzkujjIAZx2QOFgeoibXgel+dcySbvPy5DcOXOprObZpkP5RLdl+HvRO+Y1GXqiSwqI1cuRf+jTs/BaaxcEUeq5VQ/rSNn0TbWcv5vmNCYhj63JHkWaZ+Ojeu+FnSBuattL5Ss3KZmhR6BvpeLrNqFQBE0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291042; c=relaxed/simple;
	bh=aNeJfn5mzfXpsSTTeC7/4VptP7dvFlDELZYzZ0E5K4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKBhAT5QSLutAqDAycmLApf40DHaU1ctzJDJ60gy8fHRcngELzgIULLLcl7zLBD+dyb1oGvay2E+Pfy4AdVhH2NYCfY3Zkt0r0mZigICAZtGgCB8clbaGYwhLxtgHPNAWS/IuhNwb/XPCqblRY53K8uUz8IcFzRM8HmRyJugYc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZ3g0mwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZ3g0mwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BFDC4CEE4;
	Sat,  7 Jun 2025 10:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291042;
	bh=aNeJfn5mzfXpsSTTeC7/4VptP7dvFlDELZYzZ0E5K4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZ3g0mwJ5u3OJ9W/VIbix65n7dhDa5f+SEKQ+5kXJnrLohZG9pAOD10fkjP9GFkt4
	 LGfCIC+jeBj/8HN8iT7CHCXFinXVReXmlMLtIkStByojafKoHkTJK1NQA5VlPEz297
	 7MGwc/nEKBrMm/OL+8ffRTjaadwLTh+65RCq8AY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.15 15/34] bcachefs: Repair code for directory i_size
Date: Sat,  7 Jun 2025 12:07:56 +0200
Message-ID: <20250607100720.316849061@linuxfoundation.org>
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

commit 36a2fdf7c5c1ccae6ca16cd14067567096cebe17 upstream.

We had a bug due due to an incomplete revert of the patch implementing
directory i_size (summing up the size of the dirents), leading to
completely screwy i_size values that underflow.

Most userspace programs don't seem to care (e.g. du ignores it), but it
turns out this broke sshfs, so needs to be repaired.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/fsck.c             |    8 ++++++++
 fs/bcachefs/sb-errors_format.h |    3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1183,6 +1183,14 @@ static int check_inode(struct btree_tran
 		ret = 0;
 	}
 
+	if (fsck_err_on(S_ISDIR(u.bi_mode) && u.bi_size,
+			trans, inode_dir_has_nonzero_i_size,
+			"directory %llu:%u with nonzero i_size %lli",
+			u.bi_inum, u.bi_snapshot, u.bi_size)) {
+		u.bi_size = 0;
+		do_update = true;
+	}
+
 	ret = bch2_inode_has_child_snapshots(trans, k.k->p);
 	if (ret < 0)
 		goto err;
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -232,6 +232,7 @@ enum bch_fsck_flags {
 	x(inode_dir_multiple_links,				206,	FSCK_AUTOFIX)	\
 	x(inode_dir_missing_backpointer,			284,	FSCK_AUTOFIX)	\
 	x(inode_dir_unlinked_but_not_empty,			286,	FSCK_AUTOFIX)	\
+	x(inode_dir_has_nonzero_i_size,				319,	FSCK_AUTOFIX)	\
 	x(inode_multiple_links_but_nlink_0,			207,	FSCK_AUTOFIX)	\
 	x(inode_wrong_backpointer,				208,	FSCK_AUTOFIX)	\
 	x(inode_wrong_nlink,					209,	FSCK_AUTOFIX)	\
@@ -328,7 +329,7 @@ enum bch_fsck_flags {
 	x(dirent_stray_data_after_cf_name,			305,	0)		\
 	x(rebalance_work_incorrectly_set,			309,	FSCK_AUTOFIX)	\
 	x(rebalance_work_incorrectly_unset,			310,	FSCK_AUTOFIX)	\
-	x(MAX,							319,	0)
+	x(MAX,							320,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,


