Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D538228EA72;
	Tue, 26 Aug 2025 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213786; cv=none; b=IKLYoOYb99BLGZoJ9miBaEgn617BShwQGHHgcm03KDSInnidvSfmAftWo2Km3MYbx8UInb0nPwEJXW2/sMXXnncZn5GHbrOi83GM3M+sEp+S7UVLm8RQ4vQU40eJQ+eyvsj1G3XCAjx6Wfh++le5FNcXtlptZs45raGi7tFRMWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213786; c=relaxed/simple;
	bh=uPf0c4QDHBYfc0OwByfZQZTqk32KBKL/TaDN2t/jRbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdLpsGM8RpoMHPvjoD0mzgQgMWuK5IXg1JbOmRUCq15Wb3wl1NA1z83lxF5aI+ha6WXQYujMvuRrB1G+0jW/taT659U76KCZPYafct11yxfU0DaU4yG2Qv6nlMWsBZ7OUmYQDjoAjQVtoGkZkpmd/IsjjZtCy1mE4gqGFmVRaPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t94cR1ZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t94cR1ZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660DAC4CEF1;
	Tue, 26 Aug 2025 13:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213785;
	bh=uPf0c4QDHBYfc0OwByfZQZTqk32KBKL/TaDN2t/jRbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t94cR1ZTw4kaxfdCWUOpiKq+3cDCfLFcFtVag/iYc7JH/EFOdSBSiFrR0yN7BXRqj
	 L7mQBKwm5GaNFETnOlHFbperTqXKZkotVMpN/lzwk1SOuHRI5lCzU5BgO7AR6E+Rys
	 HUrYY0k2TyOAR3djkuZZtxZHylnpdwJ6X7avDPyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 447/587] btrfs: always abort transaction on failure to add block group to free space tree
Date: Tue, 26 Aug 2025 13:09:56 +0200
Message-ID: <20250826111004.327606225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1f06c942aa709d397cf6bed577a0d10a61509667 ]

Only one of the callers of __add_block_group_free_space() aborts the
transaction if the call fails, while the others don't do it and it's
either never done up the call chain or much higher in the call chain.

So make sure we abort the transaction at __add_block_group_free_space()
if it fails, which brings a couple benefits:

1) If some call chain never aborts the transaction, we avoid having some
   metadata inconsistency because BLOCK_GROUP_FLAG_NEEDS_FREE_SPACE is
   cleared when we enter __add_block_group_free_space() and therefore
   __add_block_group_free_space() is never called again to add the block
   group items to the free space tree, since the function is only called
   when that flag is set in a block group;

2) If the call chain already aborts the transaction, then we get a better
   trace that points to the exact step from __add_block_group_free_space()
   which failed, which is better for analysis.

So abort the transaction at __add_block_group_free_space() if any of its
steps fails.

CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-tree.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1371,12 +1371,17 @@ static int __add_block_group_free_space(
 	clear_bit(BLOCK_GROUP_FLAG_NEEDS_FREE_SPACE, &block_group->runtime_flags);
 
 	ret = add_new_free_space_info(trans, block_group, path);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 
-	return __add_to_free_space_tree(trans, block_group, path,
-					block_group->start,
-					block_group->length);
+	ret = __add_to_free_space_tree(trans, block_group, path,
+				       block_group->start, block_group->length);
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
+
+	return 0;
 }
 
 int add_block_group_free_space(struct btrfs_trans_handle *trans,
@@ -1401,9 +1406,6 @@ int add_block_group_free_space(struct bt
 	}
 
 	ret = __add_block_group_free_space(trans, block_group, path);
-	if (ret)
-		btrfs_abort_transaction(trans, ret);
-
 out:
 	btrfs_free_path(path);
 	mutex_unlock(&block_group->free_space_lock);


