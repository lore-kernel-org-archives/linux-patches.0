Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026221;
	b=Br66DpItnreIB2CFLZQ/J230ovNXqJN9b8uQLyqtL4QSxvXhOu9PXTT2giNPxECzYtS0
	 T2aUE0KRGETQZJnTQCz68PUf6qxVgqCZubEK0ukKdxlRzuJH2SGXYJEWjH9deItZ5rjKP
	 t0bTkcelQmx9YT1ksFKmM8MOwO+sbFfvXvGrCpkeu/wwL5R5kRuNaudRIiOHX+D6XDF3Q
	 dEOPPfWTPXt3qNc/hlCY+DOuavgomkkqcAa6p7lk0hfE+ocXS8gvL0UA2aqTYBqWTe8vg
	 NCFkTsDcHnKdXbhnvkpJxVfX4dGFB1VkfftKITMIU0B8rsmy26Lk9TO7CzcD3fXdY8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WEkAq/DbmnJTgWl1915RGNCanFJ6Z2rLnbrGfS7e1fs=;
	b=CxbvPHyKGD811nDE7KvL2pt/rUIyOeHVtPSgFGywhMJm6d7MnfKvTikWxXxb3eGBGl9W
	 BhgfglvUbDa9kGfBEFADOTKbIc0fLvmhV40IdGXBZEo5L9FwdPkQhIwVYlIZj83nRqS9u
	 gY1GHEgU8pITEGl2ltJvB/rxe95PFgacASowlHOxGmriI4mRaZjbOYv0GG7MaAZ61RIim
	 9TPjKNA5+03ZciTpnBCzyKorjrBM/UNLhfHAuhRtvmUVc5Dh9Ih9OVE4AQ5anhRqXvypt
	 yeOxY02NK62fNB2wuf108Gl8RlCHLJSbP5yeY7NmHm3sx7kCUqpIWTIroX8Q3G6Lwhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iwqD4DJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FDD606A330;
	Wed, 18 Nov 2026 18:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iwqD4DJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6A91F000C4;
	Wed, 18 Nov 2026 18:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026221;
	bh=WEkAq/DbmnJTgWl1915RGNCanFJ6Z2rLnbrGfS7e1fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwqD4DJ/awXjcM+Pnr5FasLPUhg7mXyMkZIrO3gMhXCNmI4y2JigV9GZyJ4wtQg/H
	 lWIGevJf9GVBbr8Lc+0Pk3JzlexPZdB1TDmWiLQntFpM5VMty1w6A23kCQ4guXQRTc
	 3bmZ9XftQvWazA9DMAO4Bgzi4NMEKSE2bCmM5aEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1358/2151] btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info
Date: Wed, 18 Nov 2026 15:51:33 +0100
Message-ID: <20261118150211.497782307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 36c09492e0bd4..88559307bac7d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1982,10 +1982,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
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



