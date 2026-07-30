Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA4B4052DC;
	Thu, 30 Jul 2026 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423842; cv=none; b=DZ3J+uVH0ApV/yPFqCoYLRCoLGCpPMrHovwK35T+Xx2mQ7ODpnmldaHukIvE9WFTTfJfqFWqYXX1iBwpyGtSuOUSJwTiA+PkWqgVyYmVVMs2/k0QlXHJjMgrBv3no5EiZo2kBDJgK48QzliviW+a1dYp7+yyr5RORayizb18E+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423842; c=relaxed/simple;
	bh=FWU7xJoi7rChKIbvkAAl0udkr3qcPj3JAiYPT2nYf4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcI1zmSlYa4g88XpTvRb5UylrutQzxQPN7lIsCkPvrR0MjlSSAvjnImC70Jk0Ow5U0fd2D9sjq8ydOwiiXyhMlaj9OLuu+x8iVxYt2YwRsx8OdOOJK1btNSLjK6fxCffJMhle8pg3O434fkpxxppFOOErBrLqR50hZVs7ZBB/eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2cvXUHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2cvXUHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0A31F000E9;
	Thu, 30 Jul 2026 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423841;
	bh=4KqyeEvOClIwigsI13W2bUTq260TxFRhw3E9xxszy6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2cvXUHq0qFyeDo3wgAXoZWOrCoNEFNEA/HkpcO/fxH23Tvif7iJHG+zqG/Dtk/2m
	 /rirVvh88vqlSbr96OfQpcD6LmQxpZs+fnBzwSHBeqkj9gDxK95+J4Rwn8ku7YmIhu
	 pONtMlM+Rkfkv699b5skxQRfzlXMkuCTYtLfUlM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Leo Martins <loemra.dev@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 186/675] btrfs: dont propagate EXTENT_FLAG_LOGGING to split extent maps
Date: Thu, 30 Jul 2026 16:08:36 +0200
Message-ID: <20260730141449.095391934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Martins <loemra.dev@gmail.com>

[ Upstream commit 5eff4d5b17fa1950e80bfd1ba43dc0699e61a644 ]

When btrfs_drop_extent_map_range() splits an extent map, the new split
maps inherit the original map's flags through a local 'flags' variable.
Commit f86f7a75e2fb ("btrfs: use the flags of an extent map to identify
the compression type") changed the EXTENT_FLAG_LOGGING clearing to
operate on em->flags instead of that local 'flags' copy, so a split of
an extent map that is currently being logged wrongly inherits
EXTENT_FLAG_LOGGING.

The flag is then never cleared on the split, and when it is freed while
still on the inode's modified_extents list (for example by the extent
map shrinker) it trips the WARN_ON(!list_empty(&em->list)) in
btrfs_free_extent_map() and leads to a use-after-free.

Clear EXTENT_FLAG_LOGGING from the local 'flags' copy used for the
splits and only clear EXTENT_FLAG_PINNED from em->flags, restoring the
behaviour prior to f86f7a75e2fb.

CC: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/all/20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org/
Fixes: f86f7a75e2fb ("btrfs: use the flags of an extent map to identify the compression type")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7e38c23a0c1cb6..21eb104ee2aefb 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -854,13 +854,13 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 			goto next;
 		}
 
-		flags = em->flags;
 		/*
 		 * In case we split the extent map, we want to preserve the
 		 * EXTENT_FLAG_LOGGING flag on our extent map, but we don't want
 		 * it on the new extent maps.
 		 */
-		em->flags &= ~(EXTENT_FLAG_PINNED | EXTENT_FLAG_LOGGING);
+		flags = em->flags & ~EXTENT_FLAG_LOGGING;
+		em->flags &= ~EXTENT_FLAG_PINNED;
 		modified = !list_empty(&em->list);
 
 		/*
-- 
2.53.0



