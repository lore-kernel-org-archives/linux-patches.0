Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55E0134AC;
	Mon, 12 Aug 2024 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480077; cv=none; b=RCS8k8VrFfYlvJzGd6GDExC4wXFolPdEk6E5Rr8SIzK1AEt2L24Kkk10GpWBq8em7s1aq6PVxvdNDTOmVYlRO1L7fVDvM0QVlM5LrQeXLgjhqVtTe5Ed2GujrhvIPDbOokj7X7T8Y3T8traXl/IIt5OF6OED/s4ussHyQWhDnog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480077; c=relaxed/simple;
	bh=PihX3XsMQKcUrYJiPYtlQC61Ooe9LspFpIaKn3jYfKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnYk3cQUhtFFmf62yBdI0wyTlM+e6E+MTWEGO0IJzcObWLj4wk5kXVqjvodqfnPTZDTe5KOzjhrBu6Rw5cvNCGZuxKnIiW6NVp/YKL4wBkTj3XfSM0q1nF5sCxrouXG700H/nQi1hMIf1ALSKx1dtYIbEn1LWWtKurDjzzeLeeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpOUwBUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpOUwBUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40369C32782;
	Mon, 12 Aug 2024 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480077;
	bh=PihX3XsMQKcUrYJiPYtlQC61Ooe9LspFpIaKn3jYfKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpOUwBUVFMqdI7qRwpkfs8qb3x3N7NsP8rEL0Njsmgg/L+HfA5OMr5GrCYd3CmUvU
	 3F9HeQ6Qq9PeoIgHnK7Ok/7YcOEfM4wv0FcDqAHduHOXVBe6F1YsdaXuRL8QrypY6M
	 4oTU4CUA2mbbKjXQvNompssLxOVsZ8golJorESrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 082/263] btrfs: reduce nesting for extent processing at btrfs_lookup_extent_info()
Date: Mon, 12 Aug 2024 18:01:23 +0200
Message-ID: <20240812160149.686265912@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5c83b3beaee06aa88d4015408ac2d8bb35380b06 ]

Instead of using an if-else statement when processing the extent item at
btrfs_lookup_extent_info(), use a single if statement for the error case
since it does a goto at the end and leave the success (expected) case
following the if statement, reducing indentation and making the logic a
bit easier to follow. Also make the if statement's condition as unlikely
since it's not expected to ever happen, as it signals some corruption,
making it clear and hint the compiler to generate more efficient code.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 153297cb97a4a..844b677d054ec 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -104,10 +104,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_head *head;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_path *path;
-	struct btrfs_extent_item *ei;
-	struct extent_buffer *leaf;
 	struct btrfs_key key;
-	u32 item_size;
 	u64 num_refs;
 	u64 extent_flags;
 	u64 owner = 0;
@@ -157,16 +154,11 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	}
 
 	if (ret == 0) {
-		leaf = path->nodes[0];
-		item_size = btrfs_item_size(leaf, path->slots[0]);
-		if (item_size >= sizeof(*ei)) {
-			ei = btrfs_item_ptr(leaf, path->slots[0],
-					    struct btrfs_extent_item);
-			num_refs = btrfs_extent_refs(leaf, ei);
-			extent_flags = btrfs_extent_flags(leaf, ei);
-			owner = btrfs_get_extent_owner_root(fs_info, leaf,
-							    path->slots[0]);
-		} else {
+		struct extent_buffer *leaf = path->nodes[0];
+		struct btrfs_extent_item *ei;
+		const u32 item_size = btrfs_item_size(leaf, path->slots[0]);
+
+		if (unlikely(item_size < sizeof(*ei))) {
 			ret = -EUCLEAN;
 			btrfs_err(fs_info,
 			"unexpected extent item size, has %u expect >= %zu",
@@ -179,6 +171,10 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			goto out_free;
 		}
 
+		ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
+		num_refs = btrfs_extent_refs(leaf, ei);
+		extent_flags = btrfs_extent_flags(leaf, ei);
+		owner = btrfs_get_extent_owner_root(fs_info, leaf, path->slots[0]);
 		BUG_ON(num_refs == 0);
 	} else {
 		num_refs = 0;
-- 
2.43.0



