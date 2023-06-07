Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016EE37325
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AD4C433D2;
	Wed,  7 Jun 2023 20:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170981;
	bh=gi57VE8HShBGzoCwTXQeiGyYC8zzlX16SLlWVrQPRgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lI6VjX0xzvhIOZRyHw1dsGrZ5cEPzFSsHMjaWg1gEDj+/eMSlfkD5YFO14ucOk+XU
	 gW3VGeGs0BTFavw5DtMZK8pQQLY2zpesqSBtHMQKpYQn8EDSimiYms+MxIkUNewH6U
	 m3grUR/CLDC/SCfBzhKefqA83HT+i+uHTF/PzRA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/120] btrfs: abort transaction when sibling keys check fails for leaves
Date: Wed,  7 Jun 2023 22:15:52 +0200
Message-ID: <20230607200902.043324139@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
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

[ Upstream commit 9ae5afd02a03d4e22a17a9609b19400b77c36273 ]

If the sibling keys check fails before we move keys from one sibling
leaf to another, we are not aborting the transaction - we leave that to
some higher level caller of btrfs_search_slot() (or anything else that
uses it to insert items into a b+tree).

This means that the transaction abort will provide a stack trace that
omits the b+tree modification call chain. So change this to immediately
abort the transaction and therefore get a more useful stack trace that
shows us the call chain in the bt+tree modification code.

It's also important to immediately abort the transaction just in case
some higher level caller is not doing it, as this indicates a very
serious corruption and we should stop the possibility of doing further
damage.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3e55245e54e7c..41a7ace9998e4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3872,6 +3872,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	if (check_sibling_keys(left, right)) {
 		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
 		btrfs_tree_unlock(right);
 		free_extent_buffer(right);
 		return ret;
@@ -4116,6 +4117,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	if (check_sibling_keys(left, right)) {
 		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
 	return __push_leaf_left(path, min_data_size,
-- 
2.39.2



