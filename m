Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019610;
	b=X7uoK8SfihW70SNe5gmIr22hbHPwSvAiSxlq+fFDm7ZgfTcUJ3R3DE0gwy7M/obXjATS
	 vN/i9BwmHx95LyWTxw0kTemP0TZXu4lKIgoZ3vCydgI+LN5E3vfV0hQt+1o2hGCLYn5/M
	 BscrjlwgLXjzWSysH7ZIu9BhH1idjGq+rQHwwddkRpO+ZPbCy0l5w15kY/JD7G8LFoahF
	 MZ+FszdATp3ieGOKlgry7uOZ4HIbCi/wehUy6kgTDjh9HVqEGFufweKITJm+JssW0LTyN
	 AG8FBHCdMXdiHMjH6VNg4XWsj6t8++kL/5HN0rJOoN/EXhMVA3Qinkm/hMZ1475FUfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EQqT8Sn52nYZrkO1YIike1DfUsyVmnU3E/cPQTz1vN0=;
	b=JqgCdJJl8Xt5f5WiZcQmb6KPUJ9cX1oN07AZiSPQlXQe2Wg/4LtmX6yLmzwCBwTU4ZE8
	 tjpkviSGXz/G0hD9+Nsc+5ThMpHk+6Boa9I5eQ61lLCc5hXNNHIjyXlGwaUtPEtos062+
	 AqxYjMff5oD4iB1TDH5VAkYndPcv5iD7Rb8Ep3BR2dwIdo1qPxW2UeBUnSzc1RYg8bKJ2
	 ppb4I7GRrepj7FRjswMFiXodN9VbP8RXGytbAXhhsy/Sq5LyjTsNBomTbrH52OteA76m3
	 E4ulnbe79eRNVGXuiEJZYEJKTmDHDWrdUZKOEqffFziWrG6dkCyQahmYIxKS0MXjV+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a28tMEZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F40B606A33E;
	Wed, 18 Nov 2026 16:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a28tMEZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24AB1F000C4;
	Wed, 18 Nov 2026 16:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019610;
	bh=EQqT8Sn52nYZrkO1YIike1DfUsyVmnU3E/cPQTz1vN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a28tMEZjMboMGvkIuoGIlmYzt2+V6wpvKREjJ7jtjGObB0FwOZ/Vmh4mVzaaW1dgI
	 0OoYiYgeVK4zWdGjlfA5WW/tw7jeOosi0SsZpSKa5ojohfTte3vNYQSYhOY8lBdXmB
	 pnIGcicusRe/e4aVWdL7ZlCRuE5DKtCzxQr+Cim4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1655/2651] btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info
Date: Wed, 18 Nov 2026 15:48:15 +0100
Message-ID: <20261118150347.340312739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 08a15465a0877..3b41e964d2096 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2005,10 +2005,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
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



