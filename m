Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7485350A0F;
	Sat, 17 Oct 2026 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259728; cv=none; b=qxCEapGBYKbDcgwws0syaU5OWZ9t52OXhNLrL5wXMfRdbUBdgVST2Vy4BD6ny99Eqf/hBiY1iScf3K0W73Pkldk15x8X5I8sFQi0ldLIFH/lygT/nHkrbOtTtXuW3IA8rGBiBHEultSgeXZJxEaThf0i0fH/PkxWxsUgc6UTV1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259728; c=relaxed/simple;
	bh=qi1UdT2AdVlOkoBEiyzTTGTGZT5JB1JWgahV9HmnvmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj/sLGJlAGmBytr/KkgAz8XqFHWHCSfugotUmUJp0YDXEEnAE41CkoBtVRncV4+lEKuLeAFIRj30lrRru+nPY5iz1ttWcHdhdC09SZXsyx8aAgWfcwX0jjGUyo68GzsjKXsTq6XjPZLZovPjzutuK9ow98McaEjw1Bo896Tq3SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cd1tFnao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cd1tFnao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB771F000C4;
	Sat, 17 Oct 2026 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259727;
	bh=iIi2Zk2QSaOoOLMQFL9ui68KNE4k2XzASSi8sZ7yXZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cd1tFnaoVoPv394tdlRKOOTpp++hhEo3R01iUKIV2l9mIeM33KbsO0doLik8ozjKN
	 C2ssa+wBrJGVu72dM+Vwoc2453DLK0Yk+HO1XC5XtPYWmxzBOxV9rC7gU1k3rLGuTW
	 OQnbtsllvKVPNxFfLqjJH5/ndNt1TyJfoQInxTOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1309/1674] btrfs: fix extent map leak in NOCOW direct I/O write
Date: Sat, 17 Oct 2026 17:59:41 +0200
Message-ID: <20261017160504.742374642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ea41ded4c6843..c8034d86f844f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7555,17 +7555,24 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
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



