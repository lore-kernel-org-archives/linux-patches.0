Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3621422A8;
	Mon, 12 Aug 2024 16:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478773; cv=none; b=XO2+tlQJGxHY+FqpCBmSgdYJZvUP4SE2xZO43OgV+3zMsMR9EuBdw6xR3L0mcaw8J/sBdM4ZzSatg3FGwo7UZ0YI3HQVhQx6CEzb2hf8gOREPP5iGLI2hTGbRsDWWAb/HY9xQZNhvqqW8cch183cIxqYM46zKvHzH05o1MD+HQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478773; c=relaxed/simple;
	bh=6d/siQZvcx9leu0zxTk1TuHMOY7PnoCX1Ijl3HlgqOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfKMs3BmP4KXwB2FOehXmHoB7SCEEDbRgf3FvYFv7cL2Orq+74HvljpTrr1huHDqGkaNl2zkn2dNhNDFCoOoZoUqkXpMJ4FzaJFeO5n6NmzfPhx4N8UN6hLPLO0bB91yqijA6aT+5I4kA6fJAZ4GN5LuDfbwd5W/zh0QytAXDNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipvTUDc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipvTUDc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48587C32782;
	Mon, 12 Aug 2024 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478773;
	bh=6d/siQZvcx9leu0zxTk1TuHMOY7PnoCX1Ijl3HlgqOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipvTUDc1so1VqgFoZkXZ3XECgBgDQDn8YR3eFgQPOjUACXKyyyfrHMgPJy8hJVZ8r
	 gtwzjpCZIxGz0+GJMkZsqCChkF0bJnBF6LyisiJjR3gyqG0CnCbNJZuFw55LMH8188
	 5z3K7WuKB96ZLTpt7ui88RnxblMJv1BpMuXq1iOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/150] btrfs: fix bitmap leak when loading free space cache on duplicate entry
Date: Mon, 12 Aug 2024 18:01:54 +0200
Message-ID: <20240812160126.444277146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

[ Upstream commit 320d8dc612660da84c3b70a28658bb38069e5a9a ]

If we failed to link a free space entry because there's already a
conflicting entry for the same offset, we free the free space entry but
we don't free the associated bitmap that we had just allocated before.
Fix that by freeing the bitmap before freeing the entry.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 76d52d682b3b0..21d262da386d5 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -865,6 +865,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				spin_unlock(&ctl->tree_lock);
 				btrfs_err(fs_info,
 					"Duplicate entries in free space cache, dumping");
+				kmem_cache_free(btrfs_free_space_bitmap_cachep, e->bitmap);
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-- 
2.43.0



