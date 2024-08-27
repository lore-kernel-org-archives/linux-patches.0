Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DFE1C4EF9;
	Tue, 27 Aug 2024 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769811; cv=none; b=fMX4SuvWGeWbzAIY/WvqVdMZk8YHLG9srreTjAQ6i170XxsCY1XciwQsNS6xXC70w91d4wn6Enc7XyrDd5ySNO2Bza97cdVPrRladmd9mxPKXqfYK3hbEWTG17uKqnDMkF9lQEiv2B/9/GAxkyRRtpK8LWbzHNFc2OPRq+H1t4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769811; c=relaxed/simple;
	bh=tnTUf04CFNS4frfamKscz+zMVnw9LmVfFcAKPjvsDSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffUDHnGJWUEXIZyFC8ebPfew+AkmzUGkNLh5FlHdNJJwlo1MIniaRS0b+DqDW7O7bBSvtgFLhbCYvlJbTA+oQ/QZIOiCN9Zat+ZBY6ddX0YnXMJTh2LR9KnLUwQsUYPKWG7v2LQEpKxEfuboktWPcIsEWdkXTxTtZSKu6lzoFac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0oVzQel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0oVzQel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC459C61055;
	Tue, 27 Aug 2024 14:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769811;
	bh=tnTUf04CFNS4frfamKscz+zMVnw9LmVfFcAKPjvsDSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0oVzQel/V3QIwUUzMvNfRzspnliqPXJqDk+GRAZHoxrIz4emfI9rJyenfyb4RMEF
	 7R1V/ZDpCeSTvsGd+EVgQh+lIalbgJLLvZXBxEK7h33qGR0Zl0HiW3E4eEGJQFa2C3
	 wmd1bh+FOmytHsnYkI/K+3bbA0BrpNkxhjhFhVVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 042/341] btrfs: tree-checker: add dev extent item checks
Date: Tue, 27 Aug 2024 16:34:33 +0200
Message-ID: <20240827143845.016650156@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1671,6 +1671,72 @@ static int check_inode_ref(struct extent
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
@@ -1707,6 +1773,9 @@ static enum btrfs_tree_block_status chec
 	case BTRFS_DEV_ITEM_KEY:
 		ret = check_dev_item(leaf, key, slot);
 		break;
+	case BTRFS_DEV_EXTENT_KEY:
+		ret = check_dev_extent_item(leaf, key, slot, prev_key);
+		break;
 	case BTRFS_INODE_ITEM_KEY:
 		ret = check_inode_item(leaf, key, slot);
 		break;


