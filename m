Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50F74431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE12C433D2;
	Wed, 15 Mar 2023 12:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883679;
	bh=5Az9MQT7h2KkgqAunpXfQvzj1OVRTEVwGFsJtPZTkz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnyOY3uLBsxydZPAeZLNTD7o+nOV9/ckhcn7E48PDs6D1jN6Hoc3Q1nf7Ohs3WtMm
	 QxIg7WU8mOFvNxR2GBU351uDjN0+LD+y0EXwFPE4Otwh6VJEaL1VdiKIfGwbXhuB08
	 tgNJlAsVxsXeIJnoJi6uDp/7tnTG8GjRBaIS8lm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/143] btrfs: fix extent map logging bit not cleared for split maps after dropping range
Date: Wed, 15 Mar 2023 13:12:57 +0100
Message-Id: <20230315115743.287504971@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

[ Upstream commit e4cc1483f35940c9288c332dd275f6fad485f8d2 ]

At btrfs_drop_extent_map_range() we are clearing the EXTENT_FLAG_LOGGING
bit on a 'flags' variable that was not initialized. This makes static
checkers complain about it, so initialize the 'flags' variable before
clearing the bit.

In practice this has no consequences, because EXTENT_FLAG_LOGGING should
not be set when btrfs_drop_extent_map_range() is called, as an fsync locks
the inode in exclusive mode, locks the inode's mmap semaphore in exclusive
mode too and it always flushes all delalloc.

Also add a comment about why we clear EXTENT_FLAG_LOGGING on a copy of the
flags of the split extent map.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/Y%2FyipSVozUDEZKow@kili/
Fixes: db21370bffbc ("btrfs: drop extent map range more efficiently")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6092a4eedc923..b8ae02aa632e3 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -760,7 +760,13 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 			goto next;
 		}
 
+		flags = em->flags;
 		clear_bit(EXTENT_FLAG_PINNED, &em->flags);
+		/*
+		 * In case we split the extent map, we want to preserve the
+		 * EXTENT_FLAG_LOGGING flag on our extent map, but we don't want
+		 * it on the new extent maps.
+		 */
 		clear_bit(EXTENT_FLAG_LOGGING, &flags);
 		modified = !list_empty(&em->list);
 
@@ -771,7 +777,6 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 		if (em->start >= start && em_end <= end)
 			goto remove_em;
 
-		flags = em->flags;
 		gen = em->generation;
 		compressed = test_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 
-- 
2.39.2



