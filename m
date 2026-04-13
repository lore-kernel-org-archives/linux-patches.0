Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319AD26CE32;
	Mon, 13 Apr 2026 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096759; cv=none; b=pR0bhd0yi/z5A2yWUDwQRhkZgGoHvkjZ77+nWZz0fBY4EOOwYYp1BRx6k43kfVfMMDvU4gRSDxG6a5kKQ8VTfQ7yVke3XLJETXAObEEKMR1LaN0bAA4x3yaPV7Ki4dWSayrS7OC2oO6/KlbYNwA/sXLQ1oNqt3gFWTNzleZDy80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096759; c=relaxed/simple;
	bh=uQi6nsIEyRnurXtGrXRpDI382b3zvhFf6adiD7weiS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCaBuvLcqVXlY1FfSaP6Xxo3RgLXK0LjhGYNSAH6anD9EtE57jHCZvdf3QSMSksaQhS6KecHJ8t/I6JY2XIIEao0NXT13vrxWxvK8gX+3BHq7nCN8ICHoCtF208bIt257DD1/m/ZIv4eDsnySbzHHpshqjWrtRF6rELskXPkqZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/KiYcim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/KiYcim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC87EC2BCAF;
	Mon, 13 Apr 2026 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096759;
	bh=uQi6nsIEyRnurXtGrXRpDI382b3zvhFf6adiD7weiS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/KiYcimo5SCB3QmZD9T0eMrcQ28a6aIfUnZGIoUZY+kjxnqi5YIR/lPU3G/ItA7T
	 M3MhQsJonFliWFjjBs5ToPJgR9+ayQqcPLoQYxhfR8HGEt+CHZ9AbAeTy5Quza4Vu2
	 7Jy2vrS9tGUII+bEwbPWJhUfMEAXvXxZSpkryxJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 19/70] btrfs: remove pointless out labels from extent-tree.c
Date: Mon, 13 Apr 2026 18:00:14 +0200
Message-ID: <20260413155728.903287164@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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
index 568fe9f702b74..28da7a7b42296 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -479,7 +479,7 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		if (key.objectid != bytenr ||
 		    key.type != BTRFS_EXTENT_DATA_REF_KEY)
-			goto fail;
+			return ret;
 
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_data_ref);
@@ -490,12 +490,11 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
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
 
@@ -2470,7 +2469,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int i;
 	int action;
 	int level;
-	int ret = 0;
+	int ret;
 
 	if (btrfs_is_testing(fs_info))
 		return 0;
@@ -2522,7 +2521,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			else
 				ret = btrfs_free_extent(trans, &ref);
 			if (ret)
-				goto fail;
+				return ret;
 		} else {
 			/* We don't know the owning_root, leave as 0. */
 			ref.bytenr = btrfs_node_blockptr(buf, i);
@@ -2535,12 +2534,10 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
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
@@ -3469,12 +3466,12 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
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
@@ -3482,7 +3479,7 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, 1);
 		btrfs_put_block_group(bg);
-		goto out;
+		return 0;
 	}
 
 	/*
@@ -3506,7 +3503,7 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		     || btrfs_is_zoned(fs_info)) {
 		pin_down_extent(trans, bg, buf->start, buf->len, 1);
 		btrfs_put_block_group(bg);
-		goto out;
+		return 0;
 	}
 
 	WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
@@ -3516,7 +3513,6 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_put_block_group(bg);
 	trace_btrfs_reserved_extent_free(fs_info, buf->start, buf->len);
 
-out:
 	return 0;
 }
 
-- 
2.53.0



