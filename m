Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C35271A94;
	Mon, 13 Apr 2026 16:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096223; cv=none; b=EvFlU+FH9AusqSq6J1+skL/aqdZuA94MtzyhqrwZ1R4jedccl2AnCUoDneS0p3YMZQqqsGvLTLY2IwsutskbAPst3xwQ6Rr7kNwtqtlFGN2TNPvVnN7DycJuOvomZOfBpaJqMg7PuU04ZjtjltB4EVI/koX9rhzCyHQofUeS1MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096223; c=relaxed/simple;
	bh=9XlocKg4MdcCsMbGzTTrbjzYJvCusPeAPeVBfbgAYbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFgEE3DwGUgRQ/D69MHOG1+mQ8jtwYq2qtqwgL0BE3ok08owIE6aTWfXpXQ+HyKXcdMV+mpZHBcNNYdyd8AB62Hn7juMf6F971nSMd/L9pSWXOvB+1KLf5f/HZ06BpQOvd0iVdSO98nebefLzwYDHj2ACl5Cs0hG0MRz7YBnw38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xfnt9atO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xfnt9atO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0ADC2BCB4;
	Mon, 13 Apr 2026 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096222;
	bh=9XlocKg4MdcCsMbGzTTrbjzYJvCusPeAPeVBfbgAYbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xfnt9atOaObqZ/JfBkUt6ZwNIZgFX43lGWXUX03FDWebPLWPE5hfCxlSF2rEj2LjG
	 03xnjY1gQ0FenStEJYZ2Y9C3dok5btFiZcncqQTQWkO83RFh1By9TF2BpRpKTAvizp
	 58mfxyeBKfjNwwV+8dG4irhIfJmjJiAj/56R5HW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 15/86] btrfs: remove pointless out labels from extent-tree.c
Date: Mon, 13 Apr 2026 17:59:22 +0200
Message-ID: <20260413155732.143600390@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ea8f9210050136bdd14f5e32b04cd01c8bd5c0ca ]

Some functions (lookup_extent_data_ref(), __btrfs_mod_ref() and
btrfs_free_tree_block()) have an 'out' label that does nothing but
return, making it pointless. Simplify this by removing the label and
returning instead of gotos plus setting the 'ret' variable.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 316fb1b3169e ("btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bc0db6593f329..f2b1bc2107539 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -476,7 +476,7 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		if (key.objectid != bytenr ||
 		    key.type != BTRFS_EXTENT_DATA_REF_KEY)
-			goto fail;
+			return ret;
 
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_data_ref);
@@ -487,12 +487,11 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 				btrfs_release_path(path);
 				goto again;
 			}
-			ret = 0;
-			break;
+			return 0;
 		}
 		path->slots[0]++;
 	}
-fail:
+
 	return ret;
 }
 
@@ -2474,7 +2473,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int i;
 	int action;
 	int level;
-	int ret = 0;
+	int ret;
 
 	if (btrfs_is_testing(fs_info))
 		return 0;
@@ -2526,7 +2525,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			else
 				ret = btrfs_free_extent(trans, &ref);
 			if (ret)
-				goto fail;
+				return ret;
 		} else {
 			/* We don't know the owning_root, leave as 0. */
 			ref.bytenr = btrfs_node_blockptr(buf, i);
@@ -2539,12 +2538,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			else
 				ret = btrfs_free_extent(trans, &ref);
 			if (ret)
-				goto fail;
+				return ret;
 		}
 	}
 	return 0;
-fail:
-	return ret;
 }
 
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -3466,12 +3463,12 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		return 0;
 
 	if (btrfs_header_generation(buf) != trans->transid)
-		goto out;
+		return 0;
 
 	if (root_id != BTRFS_TREE_LOG_OBJECTID) {
 		ret = check_ref_cleanup(trans, buf->start);
 		if (!ret)
-			goto out;
+			return 0;
 	}
 
 	bg = btrfs_lookup_block_group(fs_info, buf->start);
@@ -3479,7 +3476,7 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, true);
 		btrfs_put_block_group(bg);
-		goto out;
+		return 0;
 	}
 
 	/*
@@ -3503,7 +3500,7 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		     || btrfs_is_zoned(fs_info)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, true);
 		btrfs_put_block_group(bg);
-		goto out;
+		return 0;
 	}
 
 	WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
@@ -3513,7 +3510,6 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_put_block_group(bg);
 	trace_btrfs_reserved_extent_free(fs_info, buf->start, buf->len);
 
-out:
 	return 0;
 }
 
-- 
2.53.0



