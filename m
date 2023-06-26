Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D6C134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3591C433C0;
	Mon, 26 Jun 2023 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803818;
	bh=wt89E2zvd//pr6N38PwZsdGNGiF/Mbbhvn6+II2neb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp7QYQfUzRaL05dpJf+93IY1QZdqP2hiivBR/39si8j9GyDnw8nqoNNFAqSPziG+w
	 eom9Ih6V7pJ0PKJmLeUR2lO3tBmFV3EHQZB1he6gIbJBEy8e/Ggi83wGfwgoZiORPU
	 CezjgVn7/Tp+XnK2PFGi/nIRXbAozIjk6lnyrJLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	k2ci <kernel-bot@kylinos.cn>,
	Anand Jain <anand.jain@oracle.com>,
	Shida Zhang <zhangshida@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 159/199] btrfs: fix an uninitialized variable warning in btrfs_log_inode
Date: Mon, 26 Jun 2023 20:11:05 +0200
Message-ID: <20230626180812.626914610@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

[ Upstream commit 8fd9f4232d8152c650fd15127f533a0f6d0a4b2b ]

This fixes the following warning reported by gcc 10.2.1 under x86_64:

../fs/btrfs/tree-log.c: In function ‘btrfs_log_inode’:
../fs/btrfs/tree-log.c:6211:9: error: ‘last_range_start’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
 6211 |   ret = insert_dir_log_key(trans, log, path, key.objectid,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 6212 |       first_dir_index, last_dir_index);
      |       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../fs/btrfs/tree-log.c:6161:6: note: ‘last_range_start’ was declared here
 6161 |  u64 last_range_start;
      |      ^~~~~~~~~~~~~~~~

This might be a false positive fixed in later compiler versions but we
want to have it fixed.

Reported-by: k2ci <kernel-bot@kylinos.cn>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 200cea6e49e51..b91fa398b8141 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6163,7 +6163,7 @@ static int log_delayed_deletions_incremental(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *log = inode->root->log_root;
 	const struct btrfs_delayed_item *curr;
-	u64 last_range_start;
+	u64 last_range_start = 0;
 	u64 last_range_end = 0;
 	struct btrfs_key key;
 
-- 
2.39.2



