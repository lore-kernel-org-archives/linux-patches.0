Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BA21CAA66;
	Wed, 19 Feb 2025 08:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955431; cv=none; b=sxwp6lAelwxxrY4uthB8hLyPlINpqm5i/TbvaeCpHkJPbkmXMCas5AzUz9WeCgOkpnkYNIBfCU8l+mdIxqg21a9eY6faZjFjAZtyP2m9Lhef6eXr7wpK0h7wtKxlB7qSjKkFFezdTsLoHpLAUA2KEtLFgmxROOttlS2o1E7uo1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955431; c=relaxed/simple;
	bh=M2o0H/4yOf/xDFKHJb/DElf8860PFMZB5R6Sfaq329Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIY5RwggzlEp7/8gSTvGt2hak0vmZu0/RElEaonKxZv0IBoojl4MKxWXco7opaXQUXbSH5AMCHjtfm2/Red99cZFIYyJBjZzp78dGLXtFKUb9oZXZWSMAbx5JtmL9wQFPHfZAZmEAhUDsFFLoXgE1Q6nfCGHJvFTLfdYlhpa8u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQ8NL+jX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQ8NL+jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CC4C4CEE6;
	Wed, 19 Feb 2025 08:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955431;
	bh=M2o0H/4yOf/xDFKHJb/DElf8860PFMZB5R6Sfaq329Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQ8NL+jX8fr5xCKIBZ1PQvVwWkyeSOHiglMZpKP1RU5BD9KkBILbvD39S7pa5693r
	 MGbWKRlDz0AeF/aRmnt3y5HheXmxHafCMdO0L/VUgGMoVLew451YWreRlN33lRQHBf
	 jNSnsDpXAvqxfIx/QVThFPG3ZkTWSV2BRn3zz8Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/230] btrfs: rename __get_extent_map() and pass btrfs_inode
Date: Wed, 19 Feb 2025 09:28:39 +0100
Message-ID: <20250219082609.596747273@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 06de96faf795b5c276a3be612da6b08c6112e747 ]

The double underscore naming scheme does not apply here, there's only
only get_extent_map(). As the definition is changed also pass the struct
btrfs_inode.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: acc18e1c1d8c ("btrfs: fix stale page cache after race between readahead and direct IO write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 42c9899d9241c..e6e6c4dc53c48 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -901,9 +901,9 @@ void clear_folio_extent_mapped(struct folio *folio)
 	folio_detach_private(folio);
 }
 
-static struct extent_map *__get_extent_map(struct inode *inode,
-					   struct folio *folio, u64 start,
-					   u64 len, struct extent_map **em_cached)
+static struct extent_map *get_extent_map(struct btrfs_inode *inode,
+					 struct folio *folio, u64 start,
+					 u64 len, struct extent_map **em_cached)
 {
 	struct extent_map *em;
 	struct extent_state *cached_state = NULL;
@@ -922,14 +922,14 @@ static struct extent_map *__get_extent_map(struct inode *inode,
 		*em_cached = NULL;
 	}
 
-	btrfs_lock_and_flush_ordered_range(BTRFS_I(inode), start, start + len - 1, &cached_state);
-	em = btrfs_get_extent(BTRFS_I(inode), folio, start, len);
+	btrfs_lock_and_flush_ordered_range(inode, start, start + len - 1, &cached_state);
+	em = btrfs_get_extent(inode, folio, start, len);
 	if (!IS_ERR(em)) {
 		BUG_ON(*em_cached);
 		refcount_inc(&em->refs);
 		*em_cached = em;
 	}
-	unlock_extent(&BTRFS_I(inode)->io_tree, start, start + len - 1, &cached_state);
+	unlock_extent(&inode->io_tree, start, start + len - 1, &cached_state);
 
 	return em;
 }
@@ -985,8 +985,7 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 			end_folio_read(folio, true, cur, iosize);
 			break;
 		}
-		em = __get_extent_map(inode, folio, cur, end - cur + 1,
-				      em_cached);
+		em = get_extent_map(BTRFS_I(inode), folio, cur, end - cur + 1, em_cached);
 		if (IS_ERR(em)) {
 			end_folio_read(folio, false, cur, end + 1 - cur);
 			return PTR_ERR(em);
-- 
2.39.5



