Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026241;
	b=rGYi91W7U6qYbogwnokfh/l+7BTVeKxpM8cVljc1IfoBu4Ak1CXJdeASwuSazhhQNi3Y
	 +jWZ0T4A87gwo/nj37bwuQ171yo7/KZQPrJNm+Qk12JXkRQhtrzxtY5MdQpVevGpOSgkY
	 866/rhE5sI33lItXecDH3fQ63WiqqhxrNgBFR9NMkYp+XqbRz7/O0wn0UKPgU+vDtMhxI
	 p3nfr6tvzc0KNMpgcw4cF4ZO6FoDMoMBPZhe7tCv8hQtWO2vUEA8JIcsagTEGCyzFuVFy
	 a8MH1uakVVmvcsx120eEWoksX18hH9G8yN9g4G6a2tsQ83AxdcS8MbdA0BgRb0j/Lvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Trn3Xn7hZYR2aPhov2L1v5Ao5qwqoQrk6P2vYiZnhI=;
	b=mo+1FHCRVls9PUVZP3S1c/q+yhxQPBg6REHJiRep0G1Uf265isXhwIgRIV3k4AR5Xi5D
	 cJ999NeRKChUh+TJpNUW832Lxh9F3sz0DMfxwHju5JIA3dDdH2FKv662rWQVjkl+iK6SG
	 +EO7FpY+N8WCUMvGg5qa/vFVpI+ZbiYxkf6We7HZoplhFJKe7onuDEFmZ/1zMw6yWR/id
	 VIlNvghPkc8F28nob1iYaid2GoKVaYefOLMk+wNwTU/cjnORr5hgxKHjUg1CD5uM18Zz5
	 Lpo6k7pjqkOLeCITN0nMM21ILL6RPNGtwTXKfB2yrevVr2eAplPBn2JLIlj3UIVLYTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toXhqmpD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E70606A339;
	Wed, 18 Nov 2026 18:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toXhqmpD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12C61F000C4;
	Wed, 18 Nov 2026 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026241;
	bh=7Trn3Xn7hZYR2aPhov2L1v5Ao5qwqoQrk6P2vYiZnhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=toXhqmpDb6PcJ/YYe8DEJCiJf0kWS8fW/Ew4o09R0VeyMgkMVO7DA86p3yncD+XSi
	 E4bqbr3+LfD/0YjIwFbdsvdqw7ozhwChAzasc6fUoMJhMOoBYsyWEu0z9Iz2H8Z6Vx
	 mgPB8M440VgccbhHDeN9Y2Co4AyyJ/Xly8I3adug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1364/2151] btrfs: defrag: fix check to see if next extent can be defragged too
Date: Wed, 18 Nov 2026 15:51:39 +0100
Message-ID: <20261118150211.710699195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c59548a0b9c53..8b9766b67c333 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -818,7 +818,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em,
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



