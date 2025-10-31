Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A0821FF25;
	Fri, 31 Oct 2025 14:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919442; cv=none; b=rotIc3le0HdjQ+tF1hmBxveY9zhkHdUAVWkItD1vmPpnGnS8W0L1SgFFyfm8srlL877pmq67AIiZyvIpLxL5MZa97TG9B3yASB5+h2iNYtXlJFoWFxnN73okSF/i4KNSbhPGPvzPD/4fbQDAl+9KDiw2nfCiNc0NG158z4WKeBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919442; c=relaxed/simple;
	bh=MEN8pV6a8uTUku9XL67685tza0r/sODoklai6f+XHSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOPtVrBZ1YaP4WV35jRKmNzxdOFaNltEfl0wrxat+y+L0BVKGDe9+ZJbcYnG//qMbeUmNAxxNggsJMii/k+xalLPyqpWr70q77daInNQ8QCWbxdS+isZW1ZejxUn2KSSMCaKYRaJ2n9aE340Gcd6zbhYDrHpE7i9uJgEM4UMQOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt+toTg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt+toTg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42C6C4CEE7;
	Fri, 31 Oct 2025 14:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919442;
	bh=MEN8pV6a8uTUku9XL67685tza0r/sODoklai6f+XHSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dt+toTg6pbtzHdB05DCoTTQknmC0vhq2XMX7apMqPFVFSUJXprvzHn1a6Xdc67UeG
	 FOUbi6g6oByGfBU+cWlhjVCTj2HVB1ZoYgZAiHG6jcMBb6zZp41EPBe5ydqi1M2ltL
	 qk7j3EoIAF/GFv1BZu6cR4jyMSUPdw6ug0NysFjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 20/40] btrfs: tree-checker: add inode extref checks
Date: Fri, 31 Oct 2025 15:01:13 +0100
Message-ID: <20251031140044.497195031@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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
index 14f96d217e6e1..986b1612d5b04 100644
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
@@ -1770,6 +1771,39 @@ static int check_inode_ref(struct extent_buffer *leaf,
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
@@ -1881,6 +1915,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
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



