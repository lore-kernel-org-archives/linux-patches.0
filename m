Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D3658B6AA;
	Wed,  9 Sep 2026 14:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964357; cv=none; b=Sj3G+vtO5zhXpWwxTX+PP3RfEcoNT+/TPjIkMMOkSqH/ilfRepP7cfDJ+0UMEfkos/KxwWmLH20za3w9a51rrZeil6TmnIUfy9quje4N4tzGEEIG6dm96g5kcPXW/X7qebHjOolaWngBUPmpwS5rlVLNJlouwJ6dDbrCJQ3bolc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964357; c=relaxed/simple;
	bh=N/GlE8UTM/rP0wv0DvEX7ar2ne4G6IGjW6ZyUVx5PeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4x8kXsHZbRBtwjHt8H6SdSDS1nI2DKleRe8AMfcLJNPpHc3GvKKcvVRnhnytqDzt5xGkI4GqqOfJx0P+simtEb+25eluHbsU8DdW1ddVbnkVwTtulBippJ0H17o+rLhbP7rK0oEI7lj999kZOPEmBucFkAt2HSHRPunlBALpRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eynpv9tB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eynpv9tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A4A1F00A3A;
	Wed,  9 Sep 2026 14:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964356;
	bh=4zApP4gX+MPeQbfomVM+FdQfH1RVhTzVvJwtW+0xVRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eynpv9tBIQhP1/UjZGFUmr1HU6n52yLwX9p122zhtZuCod9y/JM+6X2iuo46yQ/Z5
	 JX2ZTl6WMmI+nelcszMgeh0rdORo1ZJ2/OWxW9idawrYWbuZaR6lUjLeIYAWD/Q7cs
	 ZbamNz+GniYGPRfv7UyhSCmHhyk7ichxRxkg9mV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 362/583] f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()
Date: Wed,  9 Sep 2026 15:40:47 +0200
Message-ID: <20260909134250.534393361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit ce366bfa821ec81dd45bde547ee31e659306cc61 upstream.

There is potential deadloop in race condition:

Thread A				Thread B
- fsync
 - f2fs_do_sync_file
  - f2fs_fsync_node_pages
   - last_fsync_dnode
    - folio_get(last_folio)
					- f2fs_setattr
					 - f2fs_truncate
					  - f2fs_truncate_blocks
					   - f2fs_do_truncate_blocks
					    - f2fs_truncate_inode_blocks
					     - truncate_dnode
					      - truncate_node
					       - invalidate_mapping_pages
					        - folio->mapping = NULL
   - is_node_folio alwasy return false
   - atomic && !marked is always true,
     then goto retry

Cc: stable@kernel.org
Fixes: 608514deba38 ("f2fs: set fsync mark only for the last dnode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1986,6 +1986,11 @@ continue_unlock:
 		f2fs_debug(sbi, "Retry to write fsync mark: ino=%u, idx=%lx",
 			   ino, last_folio->index);
 		folio_lock(last_folio);
+		if (unlikely(!is_node_folio(last_folio))) {
+			f2fs_folio_put(last_folio, true);
+			ret = -EAGAIN;
+			goto out;
+		}
 		f2fs_folio_wait_writeback(last_folio, NODE, true, true);
 		folio_mark_dirty(last_folio);
 		folio_unlock(last_folio);


