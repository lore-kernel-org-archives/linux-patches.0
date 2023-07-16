Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7CD8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED7CC433C8;
	Sun, 16 Jul 2023 20:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540996;
	bh=7GFPJhu90ftDjTmTinvvsXLYrv27eCZNYZX8jkLybLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cliHAYbHLcq96TymCeLJQyhU9/6tTfmjGK1VQNBivm4vHu/S/hLiYKzDOgXSsb5/Z
	 uZq2YAF8+8OaMv9HNaBCCnk0tWD6xlW73BDHNUJI4f3nmRa69jY58uPGxETBCLXxJ7
	 BcLC0VvSC7ZJQHUFrZ65y9ddBI/U0nvdx/2BB1zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 563/591] btrfs: do not BUG_ON() on tree mod log failure at __btrfs_cow_block()
Date: Sun, 16 Jul 2023 21:51:42 +0200
Message-ID: <20230716194938.425376459@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

commit 40b0a749388517de244643c09bdbb98f7dcb6ef1 upstream.

At __btrfs_cow_block(), instead of doing a BUG_ON() in case we fail to
record a tree mod log root insertion operation, do a transaction abort
instead. There's really no need for the BUG_ON(), we can properly
release all resources in this context and turn the filesystem to RO mode
and in an error state instead.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -475,9 +475,14 @@ static noinline int __btrfs_cow_block(st
 		    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
 			parent_start = buf->start;
 
-		atomic_inc(&cow->refs);
 		ret = btrfs_tree_mod_log_insert_root(root->node, cow, true);
-		BUG_ON(ret < 0);
+		if (ret < 0) {
+			btrfs_tree_unlock(cow);
+			free_extent_buffer(cow);
+			btrfs_abort_transaction(trans, ret);
+			return ret;
+		}
+		atomic_inc(&cow->refs);
 		rcu_assign_pointer(root->node, cow);
 
 		btrfs_free_tree_block(trans, btrfs_root_id(root), buf,


