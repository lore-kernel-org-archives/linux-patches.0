Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84FC14C585;
	Tue, 20 Feb 2024 20:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462704; cv=none; b=sg5IPuejA8EEQbHCSw+StCaEqEuJXFM9ggKd8ClRqnkvpW2PmLtLxxe6joQ0emUgr6gKPEZaxyCDO8fb2ohVTA3F896LgjqLXXVcRhWRBD0iDo0q79fk3ckvd/qd2hV6hKrjZ9B5Ojlt+QysCGvoM9Afr4jumTU0WIfC2LKzZVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462704; c=relaxed/simple;
	bh=98RKdkAekN7G9NcnGUWPLlxSbbaUlV0uKpwolJZsHBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/uMZvA88hvQsl90rGnYYPnYkuTv9Xu7QbnrxjDLE875zKGLl5LHvGnDwpDydd4TP0jS56vJe74uSc7bfkj4pEvtGYo3Ps99elE4Eex+bVexp3CjXmlqtZAHJmHJ4FaJyqgIpBX1B+zX5qcHgjzjD2JqbDyyADX7dqACVa4t8Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmdlcpxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmdlcpxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5C3C43390;
	Tue, 20 Feb 2024 20:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462703;
	bh=98RKdkAekN7G9NcnGUWPLlxSbbaUlV0uKpwolJZsHBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmdlcpxdcNj5Edu0f7t4AuCZt8+M/b+iDHm/TGT2eTqMDPK7dRt3OLsQci0D7lJcs
	 5tESUdkMT742BfhykhYoTT0RIGJnaY397z/RjSaqhxVdzHC7kfnkw3PC2igO1MjRA9
	 PpZwwVT/3AeZE8NwB+Wz0+/QgtjfV6T+8yObnfEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 003/197] btrfs: add and use helper to check if block group is used
Date: Tue, 20 Feb 2024 21:49:22 +0100
Message-ID: <20240220204841.179851346@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 1693d5442c458ae8d5b0d58463b873cd879569ed upstream.

Add a helper function to determine if a block group is being used and make
use of it at btrfs_delete_unused_bgs(). This helper will also be used in
future code changes.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    3 +--
 fs/btrfs/block-group.h |    7 +++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1375,8 +1375,7 @@ void btrfs_delete_unused_bgs(struct btrf
 		}
 
 		spin_lock(&block_group->lock);
-		if (block_group->reserved || block_group->pinned ||
-		    block_group->used || block_group->ro ||
+		if (btrfs_is_block_group_used(block_group) || block_group->ro ||
 		    list_is_singular(&block_group->list)) {
 			/*
 			 * We want to bail if we made new allocations or have
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -241,6 +241,13 @@ static inline u64 btrfs_block_group_end(
 	return (block_group->start + block_group->length);
 }
 
+static inline bool btrfs_is_block_group_used(const struct btrfs_block_group *bg)
+{
+	lockdep_assert_held(&bg->lock);
+
+	return (bg->used > 0 || bg->reserved > 0 || bg->pinned > 0);
+}
+
 static inline bool btrfs_is_block_group_data_only(
 					struct btrfs_block_group *block_group)
 {


