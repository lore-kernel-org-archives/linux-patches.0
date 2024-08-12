Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A7118732A;
	Mon, 12 Aug 2024 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479312; cv=none; b=i5TsRUoEBs20VbW6EQkUePPtS6QiEYXG4QAxjHPgZIjqYGNn5TJbBTMHiNGnPLIxlrtEvnJsNnSC9j3qlzRmxIlQ+NwjKAh+2yOkcJW1nSA8bJMvN4TGHITe2Sg+IWtyu25ThyiX1j9LKPJI4EuevyLQTJP/kHdBxNnqSp0TalQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479312; c=relaxed/simple;
	bh=8iJWBKTBNy+eouaY03jXIV5oTv+rFyQWdGCHcztezFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9XrWU2/Vvh4FBDE+c9vGOwqouUf6pBTZLEfyydpKmTrG94rpxEtF74cYO0FU6izQbmLWdcyGdCZMGeKoNTrn5fH9SUrRBOe9K5z2tEarQHVb7D81D7lHRcOwRELj3WsZx84U0ZT+Qmjl6FgoBvFZys8gsEWK2Oom75lF0AoNTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dtyU3ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dtyU3ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F969C4AF0D;
	Mon, 12 Aug 2024 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479311;
	bh=8iJWBKTBNy+eouaY03jXIV5oTv+rFyQWdGCHcztezFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dtyU3kaFxgMpQlYmdV3XQOj4qS1EJfSPx4heMJCymIh7cXt59jFAofcsVSajzuW9
	 Qk9rXsSR/XKGB9Mg53n39VXlLwbqUanFfQkn+/V8IV8EmXF/mM6q+dEjvyVRxL1oqJ
	 akF9wztXIEd2Stb1vJdHzy80MI9DqAsY8V0WO1rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/189] btrfs: fix bitmap leak when loading free space cache on duplicate entry
Date: Mon, 12 Aug 2024 18:01:43 +0200
Message-ID: <20240812160133.956586519@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f59e599766662..3e141c4dd2630 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -855,6 +855,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				spin_unlock(&ctl->tree_lock);
 				btrfs_err(fs_info,
 					"Duplicate entries in free space cache, dumping");
+				kmem_cache_free(btrfs_free_space_bitmap_cachep, e->bitmap);
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-- 
2.43.0



