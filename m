Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D84E1DFE09;
	Wed, 19 Feb 2025 08:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954648; cv=none; b=QLRU9AR2OflVWnnTh54lTaeyayORnnCQYQC4vjO+5LsKPE9b9FqYz1/OdhpzjV16rhZCBFWJrEZsy1Hwx/GMUBlxaX9vn7h7BUIn0XMUKcWd4yJoNEuuHFAGW3IiJPgb3oJZzJblUQkY4/qa3lMlhorcpqgVAMdiAzqKUCHWAjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954648; c=relaxed/simple;
	bh=lkMThim6LIW0mH6IjnEE7kHCah3BE/YH6LysnczuB7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOukNuqM34JNKHXiPPCxivm0rFA3hcrdRaMnIC6F/BNHD7xUK/Wv1d2SOWlGs/d1kSYRk4uFViHjITjPFF6GnPwjYY9tjniJu2Z+a9qGRum5SQj808gYrpak1j2uk51bSbAY+DfzdPnvV7z5KWXl4sVt2y42rZv55vU+MrBddgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMfhyRXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMfhyRXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86048C4CED1;
	Wed, 19 Feb 2025 08:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954647;
	bh=lkMThim6LIW0mH6IjnEE7kHCah3BE/YH6LysnczuB7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMfhyRXzQOenCLLLbgXVeKhtnJGnwoaav3AMlRQgykp64OA+/1cWZGch5oYtmy0Ln
	 HJwAa9y3RtqEbZd4IQPBOsYB/SLWyLmRrF1I5K5Q1eaDunQ8sC//5IlbUUoc0PJaxp
	 DaQQEySk0dxZVNfNy1eSTikxbWdJbHzjPGeCF0BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 242/274] btrfs: rename __get_extent_map() and pass btrfs_inode
Date: Wed, 19 Feb 2025 09:28:16 +0100
Message-ID: <20250219082619.049369905@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index b923d0cec61c7..e23eb1bca4508 100644
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



