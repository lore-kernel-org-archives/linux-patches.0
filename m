Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230791BA294;
	Tue, 27 Aug 2024 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771116; cv=none; b=tgGLmzZBSZe4LFxkegU0jROTg87/5l9EI7j0XnOkadaEfBttTGddSGIcKXFw70iQ2NwJsattzxkPkFiAN7jleW4cMc9qLQVi7pW3DFkyqtG7LooKt3Sk22uVVOVI0dts8pLMye1Ek3SStSWyGDeJOt3OYEW93NMVGfamcEuX+3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771116; c=relaxed/simple;
	bh=vrlwP9XK9ILTKB2DcVdaawN08KRlqSW85V5I5G/Pn40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch0HfmmIZC/XUg998SSw1b2AeLm5Py8K6q2Q+Vzt/Hu8aF9AXqZgZGQeIJFWltVlNWsUnnAUNQZhmfiCH1WNUPQ1SUEJylWf9+WfsWfgJo3kWmuwdn8NkjU4CA+mcYI0T4WIKwvlyznTNqN4xsild0c4s70AszTFAbwgCwqF9L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlXa8lzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlXa8lzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880DFC61060;
	Tue, 27 Aug 2024 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771116;
	bh=vrlwP9XK9ILTKB2DcVdaawN08KRlqSW85V5I5G/Pn40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlXa8lzQ0Bmy58zL1B7XUaDUWDZp2vrnruh1IF1BAkW5VDaNdBwZLNhWcrGGWQY1q
	 e8VRprxLQ0L/P3UUyYcdL51GRyi6uZ7NRdn/bCKzkGRlUSf5eIupwDziHRO31/KfKW
	 y2mz5fzTqwfDOrnex+WLlZTyw4yNmpxejNc1UoT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 064/273] btrfs: zoned: properly take lock to read/update block groups zoned variables
Date: Tue, 27 Aug 2024 16:36:28 +0200
Message-ID: <20240827143835.844768219@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

commit e30729d4bd4001881be4d1ad4332a5d4985398f8 upstream.

__btrfs_add_free_space_zoned() references and modifies bg's alloc_offset,
ro, and zone_unusable, but without taking the lock. It is mostly safe
because they monotonically increase (at least for now) and this function is
mostly called by a transaction commit, which is serialized by itself.

Still, taking the lock is a safer and correct option and I'm going to add a
change to reset zone_unusable while a block group is still alive. So, add
locking around the operations.

Fixes: 169e0da91a21 ("btrfs: zoned: track unusable bytes for zones")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-cache.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2698,15 +2698,16 @@ static int __btrfs_add_free_space_zoned(
 	u64 offset = bytenr - block_group->start;
 	u64 to_free, to_unusable;
 	int bg_reclaim_threshold = 0;
-	bool initial = ((size == block_group->length) && (block_group->alloc_offset == 0));
+	bool initial;
 	u64 reclaimable_unusable;
 
-	WARN_ON(!initial && offset + size > block_group->zone_capacity);
+	spin_lock(&block_group->lock);
 
+	initial = ((size == block_group->length) && (block_group->alloc_offset == 0));
+	WARN_ON(!initial && offset + size > block_group->zone_capacity);
 	if (!initial)
 		bg_reclaim_threshold = READ_ONCE(sinfo->bg_reclaim_threshold);
 
-	spin_lock(&ctl->tree_lock);
 	if (!used)
 		to_free = size;
 	else if (initial)
@@ -2719,7 +2720,9 @@ static int __btrfs_add_free_space_zoned(
 		to_free = offset + size - block_group->alloc_offset;
 	to_unusable = size - to_free;
 
+	spin_lock(&ctl->tree_lock);
 	ctl->free_space += to_free;
+	spin_unlock(&ctl->tree_lock);
 	/*
 	 * If the block group is read-only, we should account freed space into
 	 * bytes_readonly.
@@ -2728,11 +2731,8 @@ static int __btrfs_add_free_space_zoned(
 		block_group->zone_unusable += to_unusable;
 		WARN_ON(block_group->zone_unusable > block_group->length);
 	}
-	spin_unlock(&ctl->tree_lock);
 	if (!used) {
-		spin_lock(&block_group->lock);
 		block_group->alloc_offset -= size;
-		spin_unlock(&block_group->lock);
 	}
 
 	reclaimable_unusable = block_group->zone_unusable -
@@ -2746,6 +2746,8 @@ static int __btrfs_add_free_space_zoned(
 		btrfs_mark_bg_to_reclaim(block_group);
 	}
 
+	spin_unlock(&block_group->lock);
+
 	return 0;
 }
 


