Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7144A8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4D5C433C8;
	Sun, 16 Jul 2023 20:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539313;
	bh=kJJU+sMSmCtJ1s8/7v0u20ughp1MwB84aOpCY8bf4l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMhSSQLCHBhZY9ZxHZy8UdL5TQdZkRnWkB/5fUhda+pkQICDstJ0x2oECoWKjqTXC
	 L4mjKghSgv0wA0370zdU8WoRVVEXJgF7wdaNp7RbvZMkmArkpunEikfdKOvJpVS097
	 oP4FoS876HLVvYbsipzyqoqSHzlXuwVCc8FMEpzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 764/800] btrfs: fix extent buffer leak after tree mod log failure at split_node()
Date: Sun, 16 Jul 2023 21:50:17 +0200
Message-ID: <20230716195006.895915887@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

commit ede600e497b1461d06d22a7d17703d9096868bc3 upstream.

At split_node(), if we fail to log the tree mod log copy operation, we
return without unlocking the split extent buffer we just allocated and
without decrementing the reference we own on it. Fix this by unlocking
it and decrementing the ref count before returning.

Fixes: 5de865eebb83 ("Btrfs: fix tree mod logging")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2982,6 +2982,8 @@ static noinline int split_node(struct bt
 
 	ret = btrfs_tree_mod_log_eb_copy(split, c, 0, mid, c_nritems - mid);
 	if (ret) {
+		btrfs_tree_unlock(split);
+		free_extent_buffer(split);
 		btrfs_abort_transaction(trans, ret);
 		return ret;
 	}


