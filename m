Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8131B1A00E7;
	Thu, 15 Aug 2024 13:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728886; cv=none; b=GHPy0HPX7WMl3q1WKDx+TaAdZ7d5f55Q8x1Cwv8sl3eERaR+KUrriN9pwW70ZgkXE/bbDH734Atf3f/Vd30S/tGFWORMYA9xJ2vlWf0k851/rmLXkby3L7AoXps4XRJb5paKu2F7E/aaPTVJgXVikcm+5TsvfwmcYftlQeB9I8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728886; c=relaxed/simple;
	bh=+3O1vMtn1pWOdFH9DTx87wNlOHlLDEMyiyaO1q+F9Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P274osUT5wUNLYacOzZs6w2KCDJmuT30/Wkfoaq+FO3QNUO4Hh1mZhbNS+kO1US3ODhAvIYa5LFn5jxy2vp7i6/ZUg1yBgzU2oroDcgdFwEv3JiZp/GEA50Xt/KXiPGMVGUK9pHnMCPt/RjHNtKIBDDNIC64+AtLwmz26TAQy24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xG5+AVZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xG5+AVZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08542C32786;
	Thu, 15 Aug 2024 13:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728886;
	bh=+3O1vMtn1pWOdFH9DTx87wNlOHlLDEMyiyaO1q+F9Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xG5+AVZ5vnTnLsOIYOPVf1ilYG5KBFAiXdhPnme/+31nrqkddJ9ZMzj2Tb/sztWs1
	 gHv8YKJyDDRhOARJCpnTGTddUVSIhHDRaAlSKeYqBz8kN1XtgLvMxW7TnO3wM6pFnK
	 Sc17pGmXoniWcgHpR8M1vrprwyB2Hv0bR6ThPaHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 140/196] btrfs: fix bitmap leak when loading free space cache on duplicate entry
Date: Thu, 15 Aug 2024 15:24:17 +0200
Message-ID: <20240815131857.431226996@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b623e9f3b4c49..88f5775792597 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -787,6 +787,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				spin_unlock(&ctl->tree_lock);
 				btrfs_err(fs_info,
 					"Duplicate entries in free space cache, dumping");
+				kmem_cache_free(btrfs_free_space_bitmap_cachep, e->bitmap);
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-- 
2.43.0



