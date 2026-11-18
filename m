Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041261;
	b=ZlZWZZ2kkr/uKgxPtSFd99SKvRFg52yfJXE+Pi7dgny+PhYUGHfWth+6jCDj2rjv4w5h
	 61piaYMUfsEV0SRhF8f5EP9v48ZupXU6jylLt4dTQMLfAKQkcObuUdcYS3LMke4/+LFZm
	 I54n6pjZySDrCQC1Jdn8ih1AglsoqF/8b1/3G+Uesfm6M6EqhFjqbjYkJdOY7ou8VOpbb
	 fyzU+8ZjyIgitDqu00H//bOWrXhaWEli1A1Rjz3wsFgGbklJ4+7kxWNdD8AWDPKCm/EWq
	 d/793fXhO3rwVxdz8uFH7eaaM3pUKmc1ha1Q2qEwQryrKRv011UEpsvw6VLy0OYsspQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bJCQn/tT+QdfPNnrtavcFZ4gQuSQjpm6GlBoay8cGSo=;
	b=WQdeYCDYzXu0sBeRnH+gTH64C1+QmUmReYp9dFZ1lTU0xjWrtNSdSIteBrfmzO3rsIsJ
	 GTflJfcYclzpXgUXIG6gIkyLTqxJiluZmC/mijgA4GovbQz0SugG58/URC03Wrjp1K5FC
	 NV1tNFcuQ03fquv3SUd9ATdIFcsY1+i0kMEzqJajtdzNbST4m+aMwbUn2lGiCz6AoCXeb
	 Nqt8BhZY9XGcXLzpFXNEmBzw4w7px+nJ22b2L72hmN2iZb9tJvIUNJyDagEj7rN+We3gj
	 XNXMqtff8xL5Ey6cZe7FS4RdsVb9j0XAlyWE99/kNMlF1W89VJnftuKChgKxAITgWtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mE7sy4W0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78781606A31C;
	Wed, 18 Nov 2026 22:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mE7sy4W0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1891F000C4;
	Wed, 18 Nov 2026 22:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041261;
	bh=bJCQn/tT+QdfPNnrtavcFZ4gQuSQjpm6GlBoay8cGSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mE7sy4W07fcOfw+9erBlc2RqLpoIvvwfXWqIiqaZTn3OC1aESLfXdcBa67iY2rVLI
	 g0VWm5yv818FWpbMEAuCSA7GayLIqOhgDs6Xe9N/TaGOmueMYiT5EatU6+NwFu9e22
	 /OQvvEuNv0hwiKOdL33PJvdJJn+RLAbYSQ39ZWus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2749/3318] btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info
Date: Wed, 18 Nov 2026 15:56:11 +0100
Message-ID: <20261118150443.234582822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 9bdef63e2b5d4a88810329a1cab3642d6378a895 ]

For DUP and RAID profiles with zones in a mismatching active state, i.e.
due to one of the zones of the block-group being on a conventional
zone, btrfs_zone_activate() has already put the block group on the list.

This leads to a double list add and refcounting problems.

Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 7f6d0d44e7513..20d752eaefc97 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1575,10 +1575,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
 		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
-			btrfs_get_block_group(cache);
 			spin_lock(&fs_info->zone_active_bgs_lock);
-			list_add_tail(&cache->active_bg_list,
-				      &fs_info->zone_active_bgs);
+			if (list_empty(&cache->active_bg_list)) {
+				btrfs_get_block_group(cache);
+				list_add_tail(&cache->active_bg_list,
+					      &fs_info->zone_active_bgs);
+			}
 			spin_unlock(&fs_info->zone_active_bgs_lock);
 		}
 	} else {
-- 
2.53.0



