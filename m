Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CF415218A;
	Tue,  2 Jul 2024 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941119; cv=none; b=QjR5DJoNqNPtArSOM7vHJB9pOkpQWXzIA6vVB1r85FbyJUJ5JH1OmvtkQYa9XZdKco7r/jooFa1CreOMkBXdNvn4RMXP2epYIr0jApZqiyP0TvDTTsMF0g1sMpzvuZLjxOw+hJoz+4Hr0OKE5Z2f+94wu8dr1vsZrRppr6abvgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941119; c=relaxed/simple;
	bh=CuZlntJWmHl1LHvOAD3obo3UOVO4Tdf96RsCCWX3NJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1xiPHKksoiQsrHjbqY3qEoFicoYGAjRO/1fHI0BVzrU1tyW77C2uq2kGAM5Txl2D/XsmahsZpGpmPlZz6+vKElxfVtbnOuayRGu3Zlo/JtxvQkNa7EN5yI5mtdnbhntXbvEiPAqR+BLAdnxNdhq17hOxK1Af1pg2Mwqv9sC0fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKT7iTaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKT7iTaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB6FC116B1;
	Tue,  2 Jul 2024 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941119;
	bh=CuZlntJWmHl1LHvOAD3obo3UOVO4Tdf96RsCCWX3NJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKT7iTaBg18RT+9KUIHRR95evbrR6ytV0nGkjxMBJl42mEe1JP9FA26+X31RCAyCn
	 TsR1GEF2k4iND0sU6yRk+jezIBdl2xNIb6NRd9EMwAXToXy60Fjnoo3gpZhZJ3kou+
	 uyAjPSrfywPub4BA/McRXBjHvnGu0k/jBwoNX/+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 132/163] btrfs: zoned: fix initial free space detection
Date: Tue,  2 Jul 2024 19:04:06 +0200
Message-ID: <20240702170238.050105415@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
@@ -2695,7 +2695,7 @@ static int __btrfs_add_free_space_zoned(
 	u64 offset = bytenr - block_group->start;
 	u64 to_free, to_unusable;
 	int bg_reclaim_threshold = 0;
-	bool initial = (size == block_group->length);
+	bool initial = ((size == block_group->length) && (block_group->alloc_offset == 0));
 	u64 reclaimable_unusable;
 
 	WARN_ON(!initial && offset + size > block_group->zone_capacity);


