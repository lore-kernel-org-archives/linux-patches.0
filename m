Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F801183CD4;
	Mon, 12 Aug 2024 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480155; cv=none; b=ZDWQ9zGHjQrgKRizn8mxojytN4gNwdrqF0/oRQ+egL9mETLsZOcKZQ+74E29O62+TKLETPLvLHidk23zFN5SofyQ/sC8s6zed1kaHET9+a1BkH/Bcz/jNZjAQiPAXgEEE5JK62+S7SOjEF9H952yEjilF8Ra3rZtITJIq52axDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480155; c=relaxed/simple;
	bh=i/Zm5pJCZfihxifBf2KDHhBApuJ8aEcXPKRdkf2A/IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiXVFaxMD2WxrZsAr49k6msW4J2rPTZucpag286PqFTVczd9hqGyoXIoHf8bdbEMcYOs/xPHpYzSoIE8LLcul3gzUisceP81HrrbWAp7qrE7+US3g9OITvSC0NVeBYhj6uNbSkB9rXeYVJgcBmkI+O9EI5/nS8cIMuKWxINpwcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1ywFa/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1ywFa/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88884C32782;
	Mon, 12 Aug 2024 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480155;
	bh=i/Zm5pJCZfihxifBf2KDHhBApuJ8aEcXPKRdkf2A/IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1ywFa/k1gyv4DgaFa0oxi12dTQoRzxC1rlz9Xqa3UPPRJ++kw454lZXdrQNaRJEn
	 3yghQ0ul43CPx+HQ9HVgrg8DVMeWI1/+AEkb3i95PlaDifrqhw1+BZVHlwWxL3jchZ
	 Ai9YtN5aTvRZ7zmo2pAYtW3MR4vlZcUCZ4Cvsws8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 084/263] btrfs: fix bitmap leak when loading free space cache on duplicate entry
Date: Mon, 12 Aug 2024 18:01:25 +0200
Message-ID: <20240812160149.762462881@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d674f2106593a..62c3dea9572ab 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -858,6 +858,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				spin_unlock(&ctl->tree_lock);
 				btrfs_err(fs_info,
 					"Duplicate entries in free space cache, dumping");
+				kmem_cache_free(btrfs_free_space_bitmap_cachep, e->bitmap);
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-- 
2.43.0



