Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5CD1C68C;
	Sun,  1 Sep 2024 16:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209876; cv=none; b=N+WlFgINtcAQNEyuYqunivT51mzAHEbW1IhC7S+l4xsgIYZmWc8SathQmB3UhZHw+nJlYiEr1ZJCieFA3GyjDpEZ44TbzvT31xs4DiY0ZpWc+V2bZHXKoJVDSSFemV2MT4P59WmjW6RiBSZe5O6xfBrbZm+meAf2cUC6wCLNnTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209876; c=relaxed/simple;
	bh=K4YisogdL6inBfotFMdr12OF58l8w614Z5PWsA5AuZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mchZ8ZPJ9ccNETypMXpmyBo6k5+3ap9shRHQFHcMDBZzT1g2tHYP4zC9UEQJWLKV1S0Lattzh1gxC3J7VtVRFwUcv1Si2bZ4L54QaO8poRvUuRSIadhdcHW0cIaP7yk9h8NfgZ3OChHo38/1fYt1WpsYPze1MHFnyInHZHwxZa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCpz5ajb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCpz5ajb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4278FC4CEC3;
	Sun,  1 Sep 2024 16:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209876;
	bh=K4YisogdL6inBfotFMdr12OF58l8w614Z5PWsA5AuZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCpz5ajb28AE8aFGy78a8HxOg3OkcciR2yxs45iLUFwpklr6sUBKjQzF+hlPiqrQZ
	 UtFEdBBHqRsexbM/B/9HPEk6F3WJkZo8+3qwSSUPEsU8zX0xqOILeqXBrfoJSjj/ON
	 x5CUYLLWsm+kZg0OeZ2nEGf1DoxWXR7GEJH++dvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 020/215] btrfs: tree-checker: add dev extent item checks
Date: Sun,  1 Sep 2024 18:15:32 +0200
Message-ID: <20240901160824.023844245@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 008e2512dc5696ab2dc5bf264e98a9fe9ceb830e upstream.

[REPORT]
There is a corruption report that btrfs refused to mount a fs that has
overlapping dev extents:

  BTRFS error (device sdc): dev extent devid 4 physical offset 14263979671552 overlap with previous dev extent end 14263980982272
  BTRFS error (device sdc): failed to verify dev extents against chunks: -117
  BTRFS error (device sdc): open_ctree failed

[CAUSE]
The direct cause is very obvious, there is a bad dev extent item with
incorrect length.

With btrfs check reporting two overlapping extents, the second one shows
some clue on the cause:

  ERROR: dev extent devid 4 offset 14263979671552 len 6488064 overlap with previous dev extent end 14263980982272
  ERROR: dev extent devid 13 offset 2257707008000 len 6488064 overlap with previous dev extent end 2257707270144
  ERROR: errors found in extent allocation tree or chunk allocation

The second one looks like a bitflip happened during new chunk
allocation:
hex(2257707008000) = 0x20da9d30000
hex(2257707270144) = 0x20da9d70000
diff               = 0x00000040000

So it looks like a bitflip happened during new dev extent allocation,
resulting the second overlap.

Currently we only do the dev-extent verification at mount time, but if the
corruption is caused by memory bitflip, we really want to catch it before
writing the corruption to the storage.

Furthermore the dev extent items has the following key definition:

	(<device id> DEV_EXTENT <physical offset>)

Thus we can not just rely on the generic key order check to make sure
there is no overlapping.

[ENHANCEMENT]
Introduce dedicated dev extent checks, including:

- Fixed member checks
  * chunk_tree should always be BTRFS_CHUNK_TREE_OBJECTID (3)
  * chunk_objectid should always be
    BTRFS_FIRST_CHUNK_CHUNK_TREE_OBJECTID (256)

- Alignment checks
  * chunk_offset should be aligned to sectorsize
  * length should be aligned to sectorsize
  * key.offset should be aligned to sectorsize

- Overlap checks
  If the previous key is also a dev-extent item, with the same
  device id, make sure we do not overlap with the previous dev extent.

Reported: Stefan N <stefannnau@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CA+W5K0rSO3koYTo=nzxxTm1-Pdu1HYgVxEpgJ=aGc7d=E8mGEg@mail.gmail.com/
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1596,6 +1596,72 @@ static int check_inode_ref(struct extent
 	return 0;
 }
 
+static int check_dev_extent_item(const struct extent_buffer *leaf,
+				 const struct btrfs_key *key,
+				 int slot,
+				 struct btrfs_key *prev_key)
+{
+	struct btrfs_dev_extent *de;
+	const u32 sectorsize = leaf->fs_info->sectorsize;
+
+	de = btrfs_item_ptr(leaf, slot, struct btrfs_dev_extent);
+	/* Basic fixed member checks. */
+	if (unlikely(btrfs_dev_extent_chunk_tree(leaf, de) !=
+		     BTRFS_CHUNK_TREE_OBJECTID)) {
+		generic_err(leaf, slot,
+			    "invalid dev extent chunk tree id, has %llu expect %llu",
+			    btrfs_dev_extent_chunk_tree(leaf, de),
+			    BTRFS_CHUNK_TREE_OBJECTID);
+		return -EUCLEAN;
+	}
+	if (unlikely(btrfs_dev_extent_chunk_objectid(leaf, de) !=
+		     BTRFS_FIRST_CHUNK_TREE_OBJECTID)) {
+		generic_err(leaf, slot,
+			    "invalid dev extent chunk objectid, has %llu expect %llu",
+			    btrfs_dev_extent_chunk_objectid(leaf, de),
+			    BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+		return -EUCLEAN;
+	}
+	/* Alignment check. */
+	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
+		generic_err(leaf, slot,
+			    "invalid dev extent key.offset, has %llu not aligned to %u",
+			    key->offset, sectorsize);
+		return -EUCLEAN;
+	}
+	if (unlikely(!IS_ALIGNED(btrfs_dev_extent_chunk_offset(leaf, de),
+				 sectorsize))) {
+		generic_err(leaf, slot,
+			    "invalid dev extent chunk offset, has %llu not aligned to %u",
+			    btrfs_dev_extent_chunk_objectid(leaf, de),
+			    sectorsize);
+		return -EUCLEAN;
+	}
+	if (unlikely(!IS_ALIGNED(btrfs_dev_extent_length(leaf, de),
+				 sectorsize))) {
+		generic_err(leaf, slot,
+			    "invalid dev extent length, has %llu not aligned to %u",
+			    btrfs_dev_extent_length(leaf, de), sectorsize);
+		return -EUCLEAN;
+	}
+	/* Overlap check with previous dev extent. */
+	if (slot && prev_key->objectid == key->objectid &&
+	    prev_key->type == key->type) {
+		struct btrfs_dev_extent *prev_de;
+		u64 prev_len;
+
+		prev_de = btrfs_item_ptr(leaf, slot - 1, struct btrfs_dev_extent);
+		prev_len = btrfs_dev_extent_length(leaf, prev_de);
+		if (unlikely(prev_key->offset + prev_len > key->offset)) {
+			generic_err(leaf, slot,
+		"dev extent overlap, prev offset %llu len %llu current offset %llu",
+				    prev_key->objectid, prev_len, key->offset);
+			return -EUCLEAN;
+		}
+	}
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -1631,6 +1697,9 @@ static int check_leaf_item(struct extent
 	case BTRFS_DEV_ITEM_KEY:
 		ret = check_dev_item(leaf, key, slot);
 		break;
+	case BTRFS_DEV_EXTENT_KEY:
+		ret = check_dev_extent_item(leaf, key, slot, prev_key);
+		break;
 	case BTRFS_INODE_ITEM_KEY:
 		ret = check_inode_item(leaf, key, slot);
 		break;


