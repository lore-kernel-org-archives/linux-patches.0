Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02B51C4EF9;
	Tue, 27 Aug 2024 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769808; cv=none; b=YJ+1kmUfWDrJN72gABaw3FKVEsrtJvjQPBh+kfZOonZ2QVtjspp1r+DJJ8iTIdk7bsE+8SgrGRJvwSbyzBYPlhtyDByvcxHEOuxut35WY7TJ3qz9xmOa5vMQ3PLfGVThVZ4qX8v/1VWG7rEKD+zYCDAvthSZgsdktUrJ0rBbwPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769808; c=relaxed/simple;
	bh=pzDHxjvmilqVgrkfeg2DjaBBkgLaU3mGc3Xar36wZ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DD0+hEIK1mQFqpf/jA0iaOGHtI7tYtC9rVpTYQcvQfxgTeJ5xBtZ6axgHJ6I8EgVHpIzii399wmKz5V0JNqcmAMkD71qXS0egC63htIUanIJOUMC+Y4DtjAzXPXjr9EOmdTvCWVcaVNUlqfPPBtWUa+cmzQLKITthcsYN0rVSWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fF8QsUzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fF8QsUzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76092C61053;
	Tue, 27 Aug 2024 14:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769807;
	bh=pzDHxjvmilqVgrkfeg2DjaBBkgLaU3mGc3Xar36wZ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fF8QsUzmiWhpe5LGSqScY7THcXWSeswHt2hoW/VkZ3glTyFYlUvzIOMp5DFOMIBni
	 CdmUipXG7Xo7D7liEzZG7jWKn4gQW/VpRCUXF3Qw2ajDfE+Ex5G8wR2MMh1swOOs8Z
	 hs9iXaKVh8waFxDBF5zsdqaS0ScMQZwVrJmK05VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 041/341] btrfs: zoned: properly take lock to read/update block groups zoned variables
Date: Tue, 27 Aug 2024 16:34:32 +0200
Message-ID: <20240827143844.977521416@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
@@ -2696,15 +2696,16 @@ static int __btrfs_add_free_space_zoned(
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
@@ -2717,7 +2718,9 @@ static int __btrfs_add_free_space_zoned(
 		to_free = offset + size - block_group->alloc_offset;
 	to_unusable = size - to_free;
 
+	spin_lock(&ctl->tree_lock);
 	ctl->free_space += to_free;
+	spin_unlock(&ctl->tree_lock);
 	/*
 	 * If the block group is read-only, we should account freed space into
 	 * bytes_readonly.
@@ -2726,11 +2729,8 @@ static int __btrfs_add_free_space_zoned(
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
@@ -2744,6 +2744,8 @@ static int __btrfs_add_free_space_zoned(
 		btrfs_mark_bg_to_reclaim(block_group);
 	}
 
+	spin_unlock(&block_group->lock);
+
 	return 0;
 }
 


