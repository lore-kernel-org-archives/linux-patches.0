Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22094335BB7;
	Mon, 18 Aug 2025 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524453; cv=none; b=M8SIzkTfYtIXKrvG72K7/02jnCu3+TWj6s7e6U/IQ2YFwxoDFfW7G2TrTKrdI0Nq27cl2+SwNNQ/F9/s7V6+YcZK3k3jYv3KcKzeYM3cWIyMrPb28cEFTQvp3EW+nm6uIyuSu0mzIg1C/mi1FEKImipXj6ZvVig50oJCv7o0PSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524453; c=relaxed/simple;
	bh=xVOXYV+xmgBvYvlEdB2dq5KCHia/AdyOds7N9ZR3s5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCn8Q6CabdzxbKXyKnxGyIxFwmF59QGbsAYLPA7NAfOWUNRuJTW1Q+ChL0VsRKM4ymfNAHZZOq21xmKy5rMAnT3k2NCrMcsSBul5O8pN+iZPx68pZS1z7uZLLTh3fWU6VdA6GPVcYbagqnIPLGYM/Q4d25ZfP5xpD+vh+Y5QnDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oABdzeER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oABdzeER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE16C4CEF1;
	Mon, 18 Aug 2025 13:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524452;
	bh=xVOXYV+xmgBvYvlEdB2dq5KCHia/AdyOds7N9ZR3s5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oABdzeERUL0FlAcc9QSZLSdAPiiDI8d7TRukxN6J5TDUZsMOxrgkBY3PRNSKxG/Et
	 LCjhoaJp7evPep+pKe/8wVmP6QpY7zgY3w7n/3Rg5ZfSVyWYkO03Zl00+CR2a+fjVh
	 yBpL7bDwxwB1L0EU/zV7LeUjTYpKXSaXbvXCnAKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 477/515] btrfs: error on missing block group when unaccounting log tree extent buffers
Date: Mon, 18 Aug 2025 14:47:43 +0200
Message-ID: <20250818124516.784092357@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit fc5799986fbca957e2e3c0480027f249951b7bcf upstream.

Currently we only log an error message if we can't find the block group
for a log tree extent buffer when unaccounting it (while freeing a log
tree). A missing block group means something is seriously wrong and we
end up leaking space from the metadata space info. So return -ENOENT in
case we don't find the block group.

CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2571,14 +2571,14 @@ static int replay_one_buffer(struct btrf
 /*
  * Correctly adjust the reserved bytes occupied by a log tree extent buffer
  */
-static void unaccount_log_buffer(struct btrfs_fs_info *fs_info, u64 start)
+static int unaccount_log_buffer(struct btrfs_fs_info *fs_info, u64 start)
 {
 	struct btrfs_block_group *cache;
 
 	cache = btrfs_lookup_block_group(fs_info, start);
 	if (!cache) {
 		btrfs_err(fs_info, "unable to find block group for %llu", start);
-		return;
+		return -ENOENT;
 	}
 
 	spin_lock(&cache->space_info->lock);
@@ -2589,27 +2589,22 @@ static void unaccount_log_buffer(struct
 	spin_unlock(&cache->space_info->lock);
 
 	btrfs_put_block_group(cache);
+
+	return 0;
 }
 
 static int clean_log_buffer(struct btrfs_trans_handle *trans,
 			    struct extent_buffer *eb)
 {
-	int ret;
-
 	btrfs_tree_lock(eb);
 	btrfs_clear_buffer_dirty(trans, eb);
 	wait_on_extent_buffer_writeback(eb);
 	btrfs_tree_unlock(eb);
 
-	if (trans) {
-		ret = btrfs_pin_reserved_extent(trans, eb);
-		if (ret)
-			return ret;
-	} else {
-		unaccount_log_buffer(eb->fs_info, eb->start);
-	}
+	if (trans)
+		return btrfs_pin_reserved_extent(trans, eb);
 
-	return 0;
+	return unaccount_log_buffer(eb->fs_info, eb->start);
 }
 
 static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,


