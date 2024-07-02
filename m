Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BBF1C688B;
	Tue,  2 Jul 2024 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941672; cv=none; b=gLpJui4NnbehPPXpZUq5q6aymdpKldoOGKTnHnCZ+Twx5rOMsXwyR2QXCOYzHZ4AspodAODx7p5jRh78vtlikIXd+4p9bVZ16oqgdFaiaMuUNehBmImgqWtWaOaal64EP0QMLLQh/Vgs3bKG8iJsxyG+JPuFIaNzKQkaElVXMAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941672; c=relaxed/simple;
	bh=mmt1OK4ecAcYN9fQAtuqiARPecat9v176EDO/sPYcpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efwuLbzCwwOi9gC7jnTthKHLiAVyhhwCuzS8nvKML/ZoW1klxCU8m0cDzHRpYaKBbE4qS7Y8OQ3XYJuZpFmEXZqIUR3k7+NBUdYaxvdLM8pSPoVsjL3NSGB6J3u5JkRBNzwbdgMwvtLla7CVYdrFWNjfKZbLbNFTiinzfjb6Q/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmk2pqsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmk2pqsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C792FC116B1;
	Tue,  2 Jul 2024 17:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941672;
	bh=mmt1OK4ecAcYN9fQAtuqiARPecat9v176EDO/sPYcpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmk2pqsIiM+/8pVVWJPQd0ui2ULnCXUTpu/VDFcqkhWhJRYHYYxBddkVfsPMYOolj
	 Mic5Or2v3h2nx6NSAjjU0/Hupvab03QktaAWuwHKszOKlCNeC4I8oLWFUgWzUluiwq
	 Hryzt7FVOoA4u9OoEC9PzYLA+Oujr4a/JK3x1v7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 102/128] btrfs: zoned: fix initial free space detection
Date: Tue,  2 Jul 2024 19:05:03 +0200
Message-ID: <20240702170230.079918106@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

commit b9fd2affe4aa99a4ca14ee87e1f38fea22ece52a upstream.

When creating a new block group, it calls btrfs_add_new_free_space() to add
the entire block group range into the free space accounting.
__btrfs_add_free_space_zoned() checks if size == block_group->length to
detect the initial free space adding, and proceed that case properly.

However, if the zone_capacity == zone_size and the over-write speed is fast
enough, the entire zone can be over-written within one transaction. That
confuses __btrfs_add_free_space_zoned() to handle it as an initial free
space accounting. As a result, that block group becomes a strange state: 0
used bytes, 0 zone_unusable bytes, but alloc_offset == zone_capacity (no
allocation anymore).

The initial free space accounting can properly be checked by checking
alloc_offset too.

Fixes: 98173255bddd ("btrfs: zoned: calculate free space from zone capacity")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2676,7 +2676,7 @@ static int __btrfs_add_free_space_zoned(
 	u64 offset = bytenr - block_group->start;
 	u64 to_free, to_unusable;
 	int bg_reclaim_threshold = 0;
-	bool initial = (size == block_group->length);
+	bool initial = ((size == block_group->length) && (block_group->alloc_offset == 0));
 	u64 reclaimable_unusable;
 
 	WARN_ON(!initial && offset + size > block_group->zone_capacity);


