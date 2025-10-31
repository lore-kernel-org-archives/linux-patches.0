Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8436722A4D6;
	Fri, 31 Oct 2025 14:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919620; cv=none; b=Hp/Bauebd4uaxs0Rn3R5/qkfMbc6TOgsUGSdLqQYhKAYb0Smxi9D2IJgRSdBqeOKVjPesFj8f+ExZHevtN9HoJpN3t4/oQll4Ltu8NhwLYDsIy59bymlD+I8ZzNartf6RHoxI2hAaw6gLKg+73mVCIrfqHBoyji5H+w9Wo+ppfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919620; c=relaxed/simple;
	bh=gMg42MuVlW8bz9vDlJCLtmP8F0OG/KwjMkdNSfs55rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYylRN5Y5hbiykt8rVk6+JV2+QREg42MOiUmZuDVPXymjuyug2I9KowZdUAoo+NKb7WNhi5XinyteyjLbWgAupgy/iNSzI7Ue0Zz6rDYTd2nxP2ZXrIm4wrqD4ezWMkZk93KX0j+Sxpvc9AxL47FKzFdpqFNw93NUwpOZLlpf9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a57dNk8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a57dNk8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44E9C4CEE7;
	Fri, 31 Oct 2025 14:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919620;
	bh=gMg42MuVlW8bz9vDlJCLtmP8F0OG/KwjMkdNSfs55rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a57dNk8QGM58GaNQpCLPJY5U4bGtRY5qCkXuR9vrKC5f8plZBjvd8pJJyjX1m6C9I
	 M+rHhGp6oo+eAnOY49JZ5qkLOc2HaGduw7zauFO3pGmyf1XsVXZW2PwV3VmMKmyosV
	 L0c/w4c7iwUIkAZkIlVYaSo3ii+mUpOijW4uZUHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 32/35] btrfs: tree-checker: add inode extref checks
Date: Fri, 31 Oct 2025 15:01:40 +0100
Message-ID: <20251031140044.407416705@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit aab9458b9f0019e97fae394c2d6d9d1a03addfb3 ]

Like inode refs, inode extrefs have a variable length name, which means
we have to do a proper check to make sure no header nor name can exceed
the item limits.

The check itself is very similar to check_inode_ref(), just a different
structure (btrfs_inode_extref vs btrfs_inode_ref).

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index a997c7cc35a26..a83e455f813bf 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -183,6 +183,7 @@ static bool check_prev_ino(struct extent_buffer *leaf,
 	/* Only these key->types needs to be checked */
 	ASSERT(key->type == BTRFS_XATTR_ITEM_KEY ||
 	       key->type == BTRFS_INODE_REF_KEY ||
+	       key->type == BTRFS_INODE_EXTREF_KEY ||
 	       key->type == BTRFS_DIR_INDEX_KEY ||
 	       key->type == BTRFS_DIR_ITEM_KEY ||
 	       key->type == BTRFS_EXTENT_DATA_KEY);
@@ -1782,6 +1783,39 @@ static int check_inode_ref(struct extent_buffer *leaf,
 	return 0;
 }
 
+static int check_inode_extref(struct extent_buffer *leaf,
+			      struct btrfs_key *key, struct btrfs_key *prev_key,
+			      int slot)
+{
+	unsigned long ptr = btrfs_item_ptr_offset(leaf, slot);
+	unsigned long end = ptr + btrfs_item_size(leaf, slot);
+
+	if (unlikely(!check_prev_ino(leaf, key, slot, prev_key)))
+		return -EUCLEAN;
+
+	while (ptr < end) {
+		struct btrfs_inode_extref *extref = (struct btrfs_inode_extref *)ptr;
+		u16 namelen;
+
+		if (unlikely(ptr + sizeof(*extref)) > end) {
+			inode_ref_err(leaf, slot,
+			"inode extref overflow, ptr %lu end %lu inode_extref size %zu",
+				      ptr, end, sizeof(*extref));
+			return -EUCLEAN;
+		}
+
+		namelen = btrfs_inode_extref_name_len(leaf, extref);
+		if (unlikely(ptr + sizeof(*extref) + namelen > end)) {
+			inode_ref_err(leaf, slot,
+				"inode extref overflow, ptr %lu end %lu namelen %u",
+				ptr, end, namelen);
+			return -EUCLEAN;
+		}
+		ptr += sizeof(*extref) + namelen;
+	}
+	return 0;
+}
+
 static int check_raid_stripe_extent(const struct extent_buffer *leaf,
 				    const struct btrfs_key *key, int slot)
 {
@@ -1893,6 +1927,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_INODE_REF_KEY:
 		ret = check_inode_ref(leaf, key, prev_key, slot);
 		break;
+	case BTRFS_INODE_EXTREF_KEY:
+		ret = check_inode_extref(leaf, key, prev_key, slot);
+		break;
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
 		ret = check_block_group_item(leaf, key, slot);
 		break;
-- 
2.51.0



