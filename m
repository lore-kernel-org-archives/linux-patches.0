Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFA136AB6B;
	Sat, 17 Oct 2026 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253846; cv=none; b=uP+4Yh6cEv6gc1JqOBUSDT/bvg6ApvQvQKMRtiDtwuguUt3CtL92dySAjdMbN7vr1x3p6Wzxd5BDJcP+B3gZWWll6ssiFT5vDJCy0/T17047/ARB6TFB3OogVE9i03kHlMCIuh3jCxN/r4bqvRxep7hkejOjDJIDtD4+YkwbbYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253846; c=relaxed/simple;
	bh=jTLLRKivmVhvZT8YwmyRWSvSs1HWh9Y/a5LSA4BshhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTPD7cRue5p65rKMIVXEOsSiV/9ga476C0nv4erEmaD21WzEEig/JbdBTx+j55c5tQuMW0d9ADnTabKps6kNM/oT2pw3c+ERU7Kpk10mh5Bo5S8XK9kx5bUP3OhWxAF2yEhZfBma5kDF+uYje/67zKe5VL08CuAW86hzzrJtSUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rz7l0GWn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rz7l0GWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D871F000C4;
	Sat, 17 Oct 2026 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253844;
	bh=UtwygEtAUwnoCks+TsqILFGAu0P1f0ludAz5Ctd5TDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rz7l0GWnKAhylv0YLu7f6KomQi3uAF0Qf9m7Te1bREKVpOkxmbhCHJnYtladrFaqE
	 +t1BhGSxbDMonnf11O5+9ZbFsGO1YpT3OkzWoJLn23NEpsQgJBCJKU+AHRglmOJfNt
	 kmhRpeW4UzYwkRI0SavFZVMjyQ1+bD84CW3GuR/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/869] btrfs: dont BUG() on unexpected delayed ref type in run_one_delayed_ref()
Date: Sat, 17 Oct 2026 17:51:34 +0200
Message-ID: <20261017160043.544136867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit c7d1d4ff56744074e005771aff193b927392d51f ]

There is no need to BUG(), we can just return an error and log an error
message.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1e760331272a0..a821ea34674f3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1750,32 +1750,36 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       bool insert_reserved)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 
 	if (TRANS_ABORTED(trans)) {
 		if (insert_reserved) {
 			btrfs_pin_extent(trans, node->bytenr, node->num_bytes);
-			free_head_ref_squota_rsv(trans->fs_info, href);
+			free_head_ref_squota_rsv(fs_info, href);
 		}
 		return 0;
 	}
 
 	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
-	    node->type == BTRFS_SHARED_BLOCK_REF_KEY)
+	    node->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		ret = run_delayed_tree_ref(trans, href, node, extent_op,
 					   insert_reserved);
-	else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
-		 node->type == BTRFS_SHARED_DATA_REF_KEY)
+	} else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
+		   node->type == BTRFS_SHARED_DATA_REF_KEY) {
 		ret = run_delayed_data_ref(trans, href, node, extent_op,
 					   insert_reserved);
-	else if (node->type == BTRFS_EXTENT_OWNER_REF_KEY)
+	} else if (node->type == BTRFS_EXTENT_OWNER_REF_KEY) {
 		ret = 0;
-	else
-		BUG();
+	} else {
+		ret = -EUCLEAN;
+		btrfs_err(fs_info, "unexpected delayed ref node type: %u", node->type);
+	}
+
 	if (ret && insert_reserved)
 		btrfs_pin_extent(trans, node->bytenr, node->num_bytes);
 	if (ret < 0)
-		btrfs_err(trans->fs_info,
+		btrfs_err(fs_info,
 "failed to run delayed ref for logical %llu num_bytes %llu type %u action %u ref_mod %d: %d",
 			  node->bytenr, node->num_bytes, node->type,
 			  node->action, node->ref_mod, ret);
-- 
2.53.0



