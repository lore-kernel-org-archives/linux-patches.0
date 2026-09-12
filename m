Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5483B418A43;
	Sat, 12 Sep 2026 08:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202620; cv=none; b=IGbAZaKifvx+lh45tGAIOqqW715dP3WsioDTrrrsQ83kyN0Xs9UNn4csHa/En+crjRt1lLY4U8Ke9+imtzDMVWfziQNUa/jXlZw4VUuDxssLcRTQdnYoLR7gy61wiSt8Pz3cGMIY2aZCecl1ydLL8uHRfuPKvE79rvVhxmgZXjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202620; c=relaxed/simple;
	bh=p8nyLZBo1y89SnJ2bDCJa525uGfyW79/vKuChl6Vnuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUye48I18H55Cg+79h7fbSpH/LRA6q200BG0PKbHFrS0QYyqzNGYQFAGfEoqD61L0hGyoEXQ/3Qul04Mt4iboSm81fvc4sZ8M3/Hx/EByKtGdcSpDBA3hmKMDt8r67NAvjSOmlarU5hRs4cfOoXEalDsxPxuQSlUxh98Uk6zKac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdpE11+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdpE11+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF30A1F000FF;
	Sat, 12 Sep 2026 08:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202618;
	bh=AO2yM9W3R20dJ7nzE4jhzpOy+3DoueIt2/O39pGncKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdpE11+3TOcjtY48h5t03CZ6EcVEgFogIxRIS4h0lzB/4KPeuefhfWnBCv4Fmc81/
	 MKclk/275dcgbQ2mavPRSyZlED8cBXTH4oH96tztkwhE4kEYbjMYwd6t2GL0+3Jjt1
	 jgGAQJpq+4rgaNUgfFRqxj1LGGvBMm1RDoKMGiYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1233/1815] btrfs: use aligned range for locking in extent_fiemap()
Date: Sat, 12 Sep 2026 08:49:43 +0200
Message-ID: <20260912065717.957894835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 681e073614515b892cacef0eeec0c761a2c2ab87 ]

The @end parameter for all extent io tree helpers is inclusive, but
the call site in extent_fiemap() is passing an exclusive end into
btrfs_lock_extent(), which will step into the next block unexpectedly.

Pass the inclusive end into btrfs_lock_extent() and
btrfs_unlock_extent().

Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate reporting extent sharedness")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/fiemap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index 6263e837093e4..929e978702c35 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -660,7 +660,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
 	range_end = round_up(start + len, sectorsize);
 	prev_extent_end = range_start;
 
-	btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached_state);
+	btrfs_lock_extent(&inode->io_tree, range_start, range_end - 1, &cached_state);
 
 	ret = fiemap_find_last_extent_offset(inode, path, &last_extent_end);
 	if (ret < 0)
@@ -840,7 +840,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
 	}
 
 out_unlock:
-	btrfs_unlock_extent(&inode->io_tree, range_start, range_end, &cached_state);
+	btrfs_unlock_extent(&inode->io_tree, range_start, range_end - 1, &cached_state);
 
 	if (ret == BTRFS_FIEMAP_FLUSH_CACHE) {
 		btrfs_release_path(path);
-- 
2.53.0



