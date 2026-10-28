Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216049;
	b=2LSMs79OmUNDyXNLOCrbcB3sDW9IsiCx5c7Jr2aozoBKaDEwzoVbhYtB6sXkLwZuRIU+
	 JMlK23DXjx9B0xMXjKWS2nCyysBPOMucDqY4cGg4I4PBSL2H6pz0MS9agg3V+HZ8IxLuq
	 Rh/zZwbH3j8RyZsdGf+sZM4aEH5Jn7xlXpqp7fI/YLq7VfmKGZxk+e7nooq6+mbFqLviA
	 TYVn9J4ZQ7+4Gryi/e9Xmt81FbwrfyzOxKGOfTAre74QgpLOY6LwAppk1eH5d+araXS0J
	 SxCWLRrBfJcPLiERofIlqeQkFhOWqG3s9Aj0Qq/JnX95atRxFRnltKn/+yjXjHnqISg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FbriIhIYvEWXv3+GKpNiU1MlCkmUWY91ukyqDwjLviQ=;
	b=Cxw+1zeKF+FxVaLJUKIT2lmnO983k5wxRw1W5rltC2/UVUddIN8GNhDXUHhV5xazSwI+
	 BhpCC1xROgUsaPH7nOxghA2CkxiU2Siz/2gR48xx9qLX8q2dcYic5GwhwCpGzCoax7S6C
	 4Szt6nWH6kijLKQBz+azU0gWAGzTcqxxVD04REMrIbwUxFFsBHpWyal02SfZ1LHrZQF7E
	 T/sQnaZBOIH0vrikyUZ/j0OXMEoGxopc9+AD0Q4juQiNpJELTbT/MX6bpCPwkHlEIGvdz
	 q9Pixz8+I9gd4X8NLZAFQ0SsoOPLDGTcwbT82t453jUW/rb2qMrdmSHRGMozVtLIsQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BpDbU/gl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4D8606A31C;
	Wed, 28 Oct 2026 19:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpDbU/gl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0B61F01825;
	Wed, 28 Oct 2026 19:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216049;
	bh=FbriIhIYvEWXv3+GKpNiU1MlCkmUWY91ukyqDwjLviQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpDbU/glifZ2rx2SDf+lSrgqND1zvjBbxeu/JDPXqI5N4ZJtpZij1SSvJRUaQ1Udh
	 Z1yoQXV0PXPsRP5S7/uWt7hSCI/d/AOZ2aI6AJjA60cgE+ORusnWUlO6D4lOpFWXsJ
	 znoeUFP+4RcRZbOeNIndiwhIX/njqcvuDveVW+fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1424/1887] btrfs: drop recovered reloc root refs on recovery failure
Date: Wed, 28 Oct 2026 17:58:40 +0100
Message-ID: <20261028170531.863283617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit 6d8ba4572922e336f0b59a80751b018e1e135164 ]

During relocation recovery, each fs root gets a reference to its relocation
root. If loading or adding a later root fails, or if the first transaction
commit fails, btrfs_recover_relocation() jumps to out_unset before
merge_reloc_roots() and clean_dirty_subvols().

put_reloc_control() drops the list-owned relocation root references, but it
does not clear fs_root->reloc_root or drop the references owned by those
pointers. Mount cleanup only drops them when BTRFS_FS_ERROR is set, so an
error such as -ENOMEM while processing a later root can leave references
behind.

Keep temporary references to the fs roots associated during recovery. On
failure, clear their reloc_root pointers and drop the corresponding
references. Once the first transaction commit succeeds, drop only the
temporary fs root references and let the normal merge and cleanup paths
handle the relocation roots.

Fault injection on a pending-relocation image confirmed the cleanup gap.
With an injected first-commit failure, 25 fs roots had reloc_root set with
fs_error=0. With this fix, the same failure path drops that count to 0
before mount fails.

Fixes: f44deb7442ed ("btrfs: hold a ref on the root->reloc_root")
CC: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f3e597d5eb6e3..6b81a41c4a532 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4228,6 +4228,24 @@ static noinline_for_stack int mark_garbage_root(struct btrfs_root *root)
 	return ret;
 }
 
+static void release_recovered_fs_roots(struct list_head *roots, bool drop_reloc_refs)
+{
+	struct btrfs_root *root;
+	struct btrfs_root *next;
+
+	list_for_each_entry_safe(root, next, roots, reloc_dirty_list) {
+		list_del_init(&root->reloc_dirty_list);
+		if (drop_reloc_refs) {
+			struct btrfs_root *reloc_root = root->reloc_root;
+
+			ASSERT(reloc_root);
+			root->reloc_root = NULL;
+			btrfs_put_root(reloc_root);
+		}
+		btrfs_put_root(root);
+	}
+}
+
 /*
  * recover relocation interrupted by system crash.
  *
@@ -4237,6 +4255,7 @@ static noinline_for_stack int mark_garbage_root(struct btrfs_root *root)
 int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 {
 	LIST_HEAD(reloc_roots);
+	LIST_HEAD(recovered_roots);
 	struct btrfs_key key;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *reloc_root;
@@ -4349,7 +4368,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 			ret = PTR_ERR(fs_root);
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			btrfs_end_transaction(trans);
-			goto out_unset;
+			goto out_drop_reloc_refs;
 		}
 
 		ret = __add_reloc_root(reloc_root);
@@ -4358,15 +4377,17 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			btrfs_put_root(fs_root);
 			btrfs_end_transaction(trans);
-			goto out_unset;
+			goto out_drop_reloc_refs;
 		}
+		ASSERT(list_empty(&fs_root->reloc_dirty_list));
 		fs_root->reloc_root = btrfs_grab_root(reloc_root);
-		btrfs_put_root(fs_root);
+		list_add_tail(&fs_root->reloc_dirty_list, &recovered_roots);
 	}
 
 	ret = btrfs_commit_transaction(trans);
 	if (ret)
-		goto out_unset;
+		goto out_drop_reloc_refs;
+	release_recovered_fs_roots(&recovered_roots, false);
 
 	merge_reloc_roots(rc);
 
@@ -4382,6 +4403,8 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	ret2 = clean_dirty_subvols(rc);
 	if (ret2 < 0 && !ret)
 		ret = ret2;
+out_drop_reloc_refs:
+	release_recovered_fs_roots(&recovered_roots, true);
 out_unset:
 	unset_reloc_control(rc);
 	reloc_chunk_end(fs_info);
-- 
2.53.0



