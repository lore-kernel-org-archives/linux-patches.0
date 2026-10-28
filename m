Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216165;
	b=QOtT7eGoSaaroiy+3v0W+CWFfncz2qAVDOYgyrX80zSs8J5eRdJvcz27GD6xbdH88Cl6
	 RqYKBDJYi7T8EOnZpd5qFJ74ueHto1UsinkDQTD6pBZ6X6KJfhvBnx0GKakFD2sWo4FVL
	 Mg6jGkhSILxIj7qlvNROLWOjfcbjMtk4Uzr9OJtdEBSkFFtQteYYbE8GvbZ6B969A7XmM
	 7/vOw1Aa0arMZGiN3oiFKf309XLDCHjJkLoxJIadsGvwD2hUcoVywnOQvjTtGjwajsaDN
	 JWRb1eWuVCP2G9NCuxp/UOlxepli/yVQKJDzCUvXVqZ41C/CHY2A7lGdZaDRf0/eBZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w31YmUV4r4dbAR3M9J5KQwNi0jhtHQfky7FdZDh6hjo=;
	b=hGXQRxvyJkZXbNgAy8i5Tz1EEDqeC8yoNyN76+KYhoLxB2NbaeCYi3TkzbTSsSZjnpcf
	 o1P1UR72oaytR31X/ek4YGET0Xq7SXcr4w2aGPbBR3AhMi5b68HHU1YUUh5Z1tsfHi4ic
	 +D7PTqtmz5Jq58B94aaxXwzMkjXVcwtFJ6L+ltOcQypfwedBw6g+WL/4tjmYKnl0n8XIE
	 r/QDBc+PlEj3X4PGORStYhIt2BR2ND+XJQtX7HzrzEuDxvCfY2UmUiPrO8O0QqvwWFQaJ
	 G4l+x682imOc9PLXCP6TfQ+TPL2yKF296q/GRRQxOdodDsIBHrESGKHuXbhEfiBy15A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yV2zt1X8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFCB606A31A;
	Wed, 28 Oct 2026 19:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yV2zt1X8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6FA1F01825;
	Wed, 28 Oct 2026 19:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216164;
	bh=w31YmUV4r4dbAR3M9J5KQwNi0jhtHQfky7FdZDh6hjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yV2zt1X8+t2zPVUxdt0KDqyraqR3QSDfIKNotuaLwuLcsE4L3TeJ4L5Pm7a+4wa9E
	 Nw4CMlpWWBAiAp8R2cPh3EtrXUT61aBX7MwhKn2RPH4udFXCbbEGdb6mA+eqInuZi1
	 eYecUPig2KFvwZMQEMKCe1roGLCWmw+OJfdS9cxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1420/1887] btrfs: fix extent map leak in NOCOW direct I/O write
Date: Wed, 28 Oct 2026 17:58:36 +0100
Message-ID: <20261028170531.771897395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit 3f950867c307c5413d628a153ac44915bd117ffd ]

btrfs_dio_iomap_begin() calls btrfs_get_extent(), which returns an
extent map reference that must be dropped on all exit paths.

For direct writes into a NOCOW range, btrfs_get_blocks_direct_write()
keeps using that extent map and asks btrfs_create_dio_extent() to
allocate the ordered extent. If that fails, for example because
btrfs_alloc_ordered_extent() fails, the function returns the error
without dropping the input extent map. The PREALLOC path avoided this by
dropping the input extent map before replacing it with the newly created
one.

Check the error from btrfs_create_dio_extent() before replacing the
map and drop the input extent map on failure.

Fixes: 5f9a8a51d8b9 ("Btrfs: add semaphore to synchronize direct IO writes with fsync")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7d1eab71f17b4..976aad24ae0a3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7695,17 +7695,24 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 					      len, orig_block_len,
 					      ram_bytes, type);
 		btrfs_dec_nocow_writers(bg);
-		if (type == BTRFS_ORDERED_PREALLOC) {
-			free_extent_map(em);
-			*map = em2;
-			em = em2;
-		}
-
 		if (IS_ERR(em2)) {
 			ret = PTR_ERR(em2);
+			free_extent_map(em);
+			*map = NULL;
 			goto out;
 		}
 
+		/*
+		 * True NOCOW writes don't need to create a new extent map,
+		 * while PREALLOC writes must replace the existing one.
+		 */
+		if (em2) {
+			ASSERT(type == BTRFS_ORDERED_PREALLOC);
+			free_extent_map(em);
+			*map = em2;
+			em = em2;
+		}
+
 		dio_data->nocow_done = true;
 	} else {
 		/* Our caller expects us to free the input extent map. */
-- 
2.53.0



