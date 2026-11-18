Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041275;
	b=VrRpp9BVOs9LCe3Fm1hbkFkEHuqcbiT8Yxa6gejI2gVI/WDnkAXGYewmda3vFk9oXYOt
	 0B1QPnrjAPmYbm69ozAWdD5auChSEQy1OTMzaBtKGELOqw3Lg846DjP/am2/OLNNd05yT
	 SmtWRudRs8hY1ddg4Hl7Ji7soaKMJ3I7XgCqM1IRVNp/KuSdfPAeJ+wcWoLwBvgZWJ08t
	 MywgNBvgQT4T/JED7xjL5GHjlDQnd7/u7TsJgwpKjV4U23zQVuwk/F58dkb8b8KF636Fy
	 xL3MbZp9Dsj4Vm+szFSzK/dlRK3DEQNENqJEYUZqiFQS5UlqpwRNbmGm56kybJPzdGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9MdhB8L7A6adquhegDxEAHZmPPNzcrEGRGWAZrrHvls=;
	b=joQhhzwkxjwbP25D5KQiWdaTz2EwTl8+l365JUosN4asU7E7aE4RZqhsvaGESVkXXAsd
	 76gYUfBG0M3VoM9234NM7SMY5fSXPl0wt99j/NXYLRuHbIs1CPLtkQX3bB7ZfHN9q2qlI
	 s5hCSXc2RjocKeTO3Yt5OLhyrHfMJ+1dSwPzE8knroGgbKk9bmWd7lCtZDIePWA4hwV+1
	 jtJbg4o90MJK+iALkX/RX9y67zpGWq7zu0vORFv0FroxNolLHzDyyJfWjDz99+nDqX54Q
	 pdJ/Hyob5hxMEaQOehdh6GhkqCfs7D5v3yvTTIXeQi14UEnHeelHWYf5T00MEUUTiGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlxApQDs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FED0606A31C;
	Wed, 18 Nov 2026 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlxApQDs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F99A1F000C4;
	Wed, 18 Nov 2026 22:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041275;
	bh=9MdhB8L7A6adquhegDxEAHZmPPNzcrEGRGWAZrrHvls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlxApQDsg9vCsgwFrA5z+n+6dqxRbO0Bv0R5K+GxCXyeqTeFwnEQzPBy9uNdCbEZw
	 eZXFhKcIdjukOJgDLZT9USqmd/wNokVn1frHRNVhsMP6KnUOJHAzI0kkf6TAsWT3KO
	 vO+HgCQs/kioxS6LorCHwGznI+pfA9hMRA6cBEAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2753/3318] btrfs: defrag: fix check to see if next extent can be defragged too
Date: Wed, 18 Nov 2026 15:56:15 +0100
Message-ID: <20261118150443.341174982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit eb55bc2bfe204e6bfccfe179226d7fb5024cb010 ]

We want to check if the next extent is at maximum capacity but we are
passing the current extent map to get_extent_max_capacity() and not
the next extent map. For example if the current extent is compressed (its
maximum capacity is 128K) and the next extent is uncompressed (its
maximum capacity is 128M), then we can bail out and not defrag the next
extent too - when for example the next extent as a size of 128K, is
uncompressed, and the extent threshold is >= 256K.

Fixes: 979b25c300db ("btrfs: defrag: don't defrag extents which are already at max capacity")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/defrag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index c7b0582d14447..979f77624571c 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -690,7 +690,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em,
 	 * If the next extent is at its max capacity, defragging current extent
 	 * makes no sense, as the total number of extents won't change.
 	 */
-	if (next->len >= get_extent_max_capacity(fs_info, em))
+	if (next->len >= get_extent_max_capacity(fs_info, next))
 		goto out;
 	/* Skip older extent */
 	if (next->generation < newer_than)
-- 
2.53.0



