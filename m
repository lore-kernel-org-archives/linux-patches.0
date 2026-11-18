Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020850;
	b=SDin6dK+FZBnqrmLh4hfIfaVeRmDYcEgNNDD4atMeND2VEme5IE7EEiw6vhsqRXc5sfT
	 JA3yLILOHAxxXObF0gWyP9DKn0/KK42VIunlj8OUVDUSqvXZMrKA2PLPmXlYG2cNnaHPp
	 AazeHb33Y+XVbcxbIdj3z6sfgFCMZGtF5uWdON2Jnrkgo4O0yY5sDKDpvhWag4VF9szmk
	 cgw1mnpuu/n6+GNzEOMX8zuRqF+2JBAVbgxJKYI7d98OoBsaMgEV9RwJpn5oIwmMB5uSP
	 URwqyZHGl5yYzrSVHy0FBp3h8yfyy3M9pADVWggF7o2zlVMbuXeYP/Osy+zEWP6JZzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UPhDdtuo5C9GO3FDGOkVXMUAyTd54mc3As+Lt1W+usI=;
	b=YkJKhhC73qwahcUWSL9X9jc0cwht7UDZPooqHN9kXdnjf4rU4s2zq0awB4ejKM1lelgy
	 M3yrGqkX0OL5pxlceHavAle9sIbHo7cgKzTTZSgKCrEwyFYWW/SrdaNVCSNpTuMNva6dI
	 B9FLtXpE2fuINtjY2DHzYe5EDhfNTox9cYGnAY7OWs02R5tykhtVdIx9aErzsSKTTjGfo
	 hDS4RCObt010bkb6oBz7h2Mje9pCEiXNAv3zMP9lGfIYOsoQhhBmTYl58HKSnc/lIfKV7
	 4tp7QnI6WlxoshcrPs6viH/hHcc/wf9gmI5E0P4RKl30BQxc1c93KRKgzpYEbyGdcpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MH0j1v1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFFD606B589;
	Wed, 18 Nov 2026 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MH0j1v1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA69E1F000C4;
	Wed, 18 Nov 2026 16:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020850;
	bh=UPhDdtuo5C9GO3FDGOkVXMUAyTd54mc3As+Lt1W+usI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MH0j1v1R7pl9eBx/4+WdSND1xFJkSMzNwzD6C0U9GFYUl7ZaJlFas0RlINqO/KnlN
	 2F2lVMZ7sFjDfR06GpxTt8gJaDukKY8tTbOYxADxNyDZGmVW8umkAeiPbxGL/YcVIX
	 lGBUJZptB52OHvLY8pV9e+5jl/T1RvZ9Vq2WoIi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2056/2651] btrfs: drop the extent maps of the written part of a failed ordered extent
Date: Wed, 18 Nov 2026 15:54:56 +0100
Message-ID: <20261118150400.072006660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit bca2cf55a7331e6b0ff95ad47fc2a7e8ecc7dc74 ]

If a truncated ordered extent fails to complete, the extent maps for the
part that was written are kept while the extent itself is freed below.
A later read can follow them to blocks that have been reallocated.
Drop the maps for the whole range on error.

Fixes: 77cef2ec5484 ("Btrfs: allow partial ordered extent completion")
Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c2a720f74d56d..019e25f34416a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3387,6 +3387,8 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 
 		/*
 		 * Drop extent maps for the part of the extent we didn't write.
+		 * On error the written part is freed below as well, so drop
+		 * its maps too.
 		 *
 		 * We have an exception here for the free_space_inode, this is
 		 * because when we do btrfs_get_extent() on the free space inode
@@ -3402,7 +3404,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		if (!btrfs_is_free_space_inode(inode)) {
 			u64 unwritten_start = start;
 
-			if (truncated)
+			if (truncated && !ret)
 				unwritten_start += logical_len;
 
 			btrfs_drop_extent_map_range(inode, unwritten_start,
-- 
2.53.0



