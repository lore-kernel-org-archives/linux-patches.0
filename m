Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031458;
	b=jV5Hhbu+I+WEJZT6pMDEJINtSmcjGJ3vKpoSPJNufMkk9eHdTRAifWFnpHAvZ9cZFQf8
	 umkb9IfcXA0PK7+hSE2UrogqQBfquS67nRvQmCgP93D9wUT8TtNePCX+oZW73S6D4poYr
	 zCnyoB+B0q4kZARMjJqtHE16JXhF50v/UXJ+wO/SwnPZAkZDagVhvshlH7bG495T9OEW+
	 z+QXgHkxl2AN6L0cUXhlAIWZeM21th3HN/0XXe0FV5Ye4UzaVuI19a0hojnLFXujwx1d2
	 kVSSkJN851BS037he4K+VMDmI0DuWp2+e1IYJxZGysMFwFXZ2vEpe6LXHgzi/SV42dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0RX58iqNHmyfRiJJd431+F/XXiANiXjmHbSo1gy4aw=;
	b=rD6VR+yQljxR5iKrTon6MPy6Ip/f7nkn7bBmqdd1ef/ObHCaH6HdasaWWVGQ+qCF73qZ
	 LyJAd/oMU7DwoQNksgDlswKsY+SKmB+z6DG/puoStdbWOZf1/zamjqiiiRDjSEoBjyvLf
	 5Khz80ZWtD+oxj0SKZGrXp4VLcwIpH9G2DcaExzKNB0WefKOjNroAwQdjvqPSA8Cd5ovR
	 tKXJEaEjVimgqmcMnqBmQ/5CKeIVKJH9Tz+CqCtXRA3b05xmZdsDvuYw1EJoB6UXsNM71
	 xhwT/40oSMmjeXlp112/FDtATZgrFvQFznsmgA8nmWxAUYCW/IFH4fyp38VY5b2FLQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDDxnZdR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA49A606A325;
	Wed, 18 Nov 2026 19:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDDxnZdR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDBA1F000C5;
	Wed, 18 Nov 2026 19:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031458;
	bh=B0RX58iqNHmyfRiJJd431+F/XXiANiXjmHbSo1gy4aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDDxnZdRmeiwWhXTg1ywFBoRy8LUTBEgxpznbvIj5AChS213xHIbFWMb0AUf/dOeh
	 QD87Rc5MuGHDzQ7dQTxJGqiGPB7RYdoFQxhXNEZEkBomQQD+8jBObx075ocoiwHejV
	 V3oyNEs8w8/l6qJ5VpXIcxgrSP40NTbrRp9shU3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1067/1756] btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info
Date: Wed, 18 Nov 2026 15:53:14 +0100
Message-ID: <20261118150052.737872908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f8120f54d624b..e417613ca9c60 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1937,10 +1937,12 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
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



