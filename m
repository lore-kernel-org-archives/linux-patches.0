Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019736;
	b=ifbd20coP8V8bwzaHEy/fX2dbUvM/HrjSBAAi8NG8U+OMViau+AD8fk6pLSui5c3iCwu
	 lUvFU3k/ticUTjfDfs0Xf2SDV5KrXavDATP9Ta0b8HBRPhrCnd0S9M9gBvzMovYtPApNj
	 r+/sdmkm4lcEzX4MduWcZHLXtGu9A60nz/M14iTWO9PrMgZP9EucBooJtD1cjaHZh7Isj
	 LU5X9wAKeve2d4LMq1IIsWdQnPjmRn8gpSO6QVzSqvImEZsNEd/BCygYHx4dgwNbyjAG9
	 bchL3O8mSF+csjcDa7XrPa3ojTmkrc3D1TAHpziSG6Y0XoOHyk7IWSQIYlu6QHtsivw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zvc1Q3k+JYHl/3ZZC1l4AGtWRpeXhlQA7toMGmaghKg=;
	b=rQyKy+IJoxmUbsGpRv37UBdrYt1RD41IpkvYOa64ozTdVrawxCU740M5ObTuzQTdhazm
	 4ayVVcy8kcqv5jSiCA/9GbNc7jOUhxZkF8OgBhAeszHFBUZ0tjKtQQ6G38Tr3hr96cGUO
	 mELFC+HvrPOo8BQMLEvoK9G/Tu9Q0+r+nRDN5gXLJe9gg7UwPrUGstoLaPUtwGcFqG4tn
	 D053UMl2861lTdSdsRXLsqYuUUXJRdSPpDrSiUpcA1cHtRBEu8BdzSD43NQaox1lovRoE
	 UJdPlJE+Sarffal3VW7ExP8gf3I/6SeQHmD39BTSoAaKO7a1WAPikXzYqWmoSRoBdIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p2WaUtRX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159A3606A32A;
	Wed, 18 Nov 2026 16:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p2WaUtRX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257FA1F000C4;
	Wed, 18 Nov 2026 16:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019735;
	bh=zvc1Q3k+JYHl/3ZZC1l4AGtWRpeXhlQA7toMGmaghKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2WaUtRXENlkxaLS5pVOV38JcxG2ZZ4134u4p8eHSYh1Oyr0I6WDYKfkndpHr22dM
	 ZWzTV4mVCy1u6mMWVxGZCn/n8lqOhWg4icE/ccHCn/mFM+3xvEM9fgm4X1qVUQxUFU
	 U3Nq9q1wkZ6Fne1QZWcK5kJO027gk0/XRowTcq2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1662/2651] btrfs: defrag: fix check to see if next extent can be defragged too
Date: Wed, 18 Nov 2026 15:48:22 +0100
Message-ID: <20261118150347.564830017@linuxfoundation.org>
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
index 6ec5dd760d429..70f1d7d78c437 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -815,7 +815,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em,
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



