Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E933921FB;
	Sat, 17 Oct 2026 17:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258716; cv=none; b=Da82n9G36wjdUzVRM7KuJajzClbRBE2y84Ulfm/x2m31cT+QheWOiEkNWVaN0D0EQshRiHtEU46d/C95fNUYQ4T0P+/Gqi7spw61iRiMW0FVZyLL4DX7mT34q2nO96sKqoBuFpmYhjuj9hirFmzx1de/NjWR/+HHwT+EbN5O/ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258716; c=relaxed/simple;
	bh=1sQjdeNXIK1IqavmGRadcXNy6J9MYa9NAljQTowt3S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR1RzAniOjtgXxz6s/Ju9yCnyItC1xOhLEBbTnzNCFdPMXgPLsFB6z9sc/pz2xn4pB/qGydvXaDFNeUXnbTF0GUDboco+HzaK8XVKqROrkozpIO+hwB0Qh8Lf5bOEYjosYG6r299q1Sq9GmEr5wNIir/+r4yVZb8UeTsZZ0gVQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPSHkBw6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPSHkBw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD55B1F000C4;
	Sat, 17 Oct 2026 17:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258715;
	bh=0OySWrQeOeN5NrQ15Qd/jGPOKZXOY4sC+cVgKoaxSL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPSHkBw6EMc2XN7/nABthHmCu1FhIFLpsPiI4O6mc4SMV6y5SjytBLyawZwG7tCwz
	 D2NflDom5yIFMQ0NMUR2hX3SHgYtGng4KFAxe97ec3Pcbog/nc+3ygahq+WOmtvO2+
	 rXvYVKpJhhKxXMEWklP4L87rqXwMhKoPEBA1PFZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0935/1674] btrfs: dont BUG() on unexpected delayed ref type in run_one_delayed_ref()
Date: Sat, 17 Oct 2026 17:53:27 +0200
Message-ID: <20261017160455.130692556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 fs/btrfs/extent-tree.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7c4e3b87f608e..b23864330b2be 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1766,6 +1766,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       bool insert_reserved)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 
 	if (TRANS_ABORTED(trans)) {
@@ -1775,19 +1776,22 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
-	    node->type == BTRFS_SHARED_BLOCK_REF_KEY)
+	    node->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		ret = run_delayed_tree_ref(trans, node, extent_op,
 					   insert_reserved);
-	else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
-		 node->type == BTRFS_SHARED_DATA_REF_KEY)
+	} else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
+		   node->type == BTRFS_SHARED_DATA_REF_KEY) {
 		ret = run_delayed_data_ref(trans, node, extent_op,
 					   insert_reserved);
-	else
-		BUG();
+	} else {
+		ret = -EUCLEAN;
+		btrfs_err(fs_info, "unexpected delayed ref node type: %u", node->type);
+	}
+
 	if (ret && insert_reserved)
 		btrfs_pin_extent(trans, node->bytenr, node->num_bytes, 1);
 	if (ret < 0)
-		btrfs_err(trans->fs_info,
+		btrfs_err(fs_info,
 "failed to run delayed ref for logical %llu num_bytes %llu type %u action %u ref_mod %d: %d",
 			  node->bytenr, node->num_bytes, node->type,
 			  node->action, node->ref_mod, ret);
-- 
2.53.0



