Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887641F4CB8;
	Sat,  7 Jun 2025 10:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291045; cv=none; b=uIjnC8u3TbfuAl3dsWWNY5s6ul2c5O379eEzCGoTSguhmWSt1scgoOmEF96MgDdeYaDLH0Utkncflc/IVFDXbvykGKMtYFm4b3KVJsosHljcTVcmi5+atsvZqbqc3HVNgLVxvXYNQ5WkJ2ZlcQVMUmxTQRvv2vnZ1uLtlAFWIcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291045; c=relaxed/simple;
	bh=jAsRA6EjzmEHs/lgTajhGrn64ykA2x1hcUugwsyS24g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPddC9TcIPTV05nh4YYfOBcA6nW+fNEvTdfq6ZmM/DAr8Itvq5LszJx4PTNgdLp2sd3/QWT8aiIPLZALUQSqcWCOvPhyqVnTECyOzw11Cdk8nBQlc6TAcxXdWXM5MKGHEGQg1ezY85hHWO8WmJa0vGUR1LeVM4oWkvT8NyoKmdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLzdeBfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLzdeBfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92A4C4CEE4;
	Sat,  7 Jun 2025 10:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291045;
	bh=jAsRA6EjzmEHs/lgTajhGrn64ykA2x1hcUugwsyS24g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLzdeBfxMQBe0S8Xylejiu1tmPpBco210+zPba/aApaYVYEp93DnPJoYyDyvwxUu1
	 xUlwvGhaJQJyUdE/vcHrRsRpkYMGCWwWAuDJ6PGyfXFRgRVKF09PL5i8h6Ozjkj6Tm
	 B89qfiKgsyDwkFHRZpDpywjZPRL5WUuX6nVjAzFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.15 16/34] bcachefs: delete dead code from may_delete_deleted_inode()
Date: Sat,  7 Jun 2025 12:07:57 +0200
Message-ID: <20250607100720.355780066@linuxfoundation.org>
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

commit bb6689bbeebc6fb51f0f120b486bdcc9a38ffcf6 upstream.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/inode.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1342,10 +1342,7 @@ int bch2_inode_rm_snapshot(struct btree_
 		delete_ancestor_snapshot_inodes(trans, SPOS(0, inum, snapshot));
 }
 
-static int may_delete_deleted_inode(struct btree_trans *trans,
-				    struct btree_iter *iter,
-				    struct bpos pos,
-				    bool *need_another_pass)
+static int may_delete_deleted_inode(struct btree_trans *trans, struct bpos pos)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_iter inode_iter;
@@ -1434,9 +1431,8 @@ delete:
 int bch2_delete_dead_inodes(struct bch_fs *c)
 {
 	struct btree_trans *trans = bch2_trans_get(c);
-	bool need_another_pass;
 	int ret;
-again:
+
 	/*
 	 * if we ran check_inodes() unlinked inodes will have already been
 	 * cleaned up but the write buffer will be out of sync; therefore we
@@ -1446,8 +1442,6 @@ again:
 	if (ret)
 		goto err;
 
-	need_another_pass = false;
-
 	/*
 	 * Weird transaction restart handling here because on successful delete,
 	 * bch2_inode_rm_snapshot() will return a nested transaction restart,
@@ -1457,7 +1451,7 @@ again:
 	ret = for_each_btree_key_commit(trans, iter, BTREE_ID_deleted_inodes, POS_MIN,
 					BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
 					NULL, NULL, BCH_TRANS_COMMIT_no_enospc, ({
-		ret = may_delete_deleted_inode(trans, &iter, k.k->p, &need_another_pass);
+		ret = may_delete_deleted_inode(trans, k.k->p);
 		if (ret > 0) {
 			bch_verbose_ratelimited(c, "deleting unlinked inode %llu:%u",
 						k.k->p.offset, k.k->p.snapshot);
@@ -1478,9 +1472,6 @@ again:
 
 		ret;
 	}));
-
-	if (!ret && need_another_pass)
-		goto again;
 err:
 	bch2_trans_put(trans);
 	return ret;


