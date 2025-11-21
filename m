Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC1821E098;
	Fri, 21 Nov 2025 13:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731970; cv=none; b=t/kYkvSJyVCeBPdHwm16jLGtzDoEVoce+zu1IFhcmjj2JlpVl+hEEeMSjxBCIYFbli2XIstFV5whvJ1UppRIlaSA6O6YTOj4HGW1SPnl12D6hfoqn+V4dFRzN9NGJtBRy+ZjoRp7k35WomaG9Gy76Yyevg/5cYgViFW4K1FAYns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731970; c=relaxed/simple;
	bh=NjyCs3v2Wt7LXSCIBOFc0nltn4GxwL5nPheIwVGx/Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/rqcE7mmKnohOsL5gahf5cHB86gD4GMWBu/LgxKDd4GcMj2onDm/sxmzTepLZaMjlcNQt8b8odWh5+xHjTZ2fHJtr0UG1tmuL13HD8Gca0FaqrvfEw1tcetI1rRKhIVSRoiFermlHV0FflaZePedQ5G2gjE5y/y28WQGzmXf6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D76skDQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D76skDQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086F4C4CEF1;
	Fri, 21 Nov 2025 13:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731970;
	bh=NjyCs3v2Wt7LXSCIBOFc0nltn4GxwL5nPheIwVGx/Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D76skDQ5TSej+41EICs+xYBfvt1EgrDVsBOCknOGqKy5JcXZvtVRC14JmV/FNLJZ4
	 rz6vduTkW7dEWdCP+KAh5NQhp3oR/0MNPtvAp5MVrYhs7yvVFZuL6F91B4VMbyzKHt
	 64jdhASO6aj0YKjSnD6UrPXzip/KGxI10dO/JdW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 144/185] btrfs: zoned: fix conventional zone capacity calculation
Date: Fri, 21 Nov 2025 14:12:51 +0100
Message-ID: <20251121130149.073163199@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 94f54924b96d3565c6b559294b3401b5496c21ac upstream.

When a block group contains both conventional zone and sequential zone, the
capacity of the block group is wrongly set to the block group's full
length. The capacity should be calculated in btrfs_load_block_group_* using
the last allocation offset.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # v6.12+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1300,6 +1300,7 @@ static int btrfs_load_zone_info(struct b
 	if (!btrfs_dev_is_sequential(device, info->physical)) {
 		up_read(&dev_replace->rwsem);
 		info->alloc_offset = WP_CONVENTIONAL;
+		info->capacity = device->zone_info->zone_size;
 		return 0;
 	}
 
@@ -1598,8 +1599,6 @@ int btrfs_load_block_group_zone_info(str
 		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
 
 	if (num_conventional > 0) {
-		/* Zone capacity is always zone size in emulation */
-		cache->zone_capacity = cache->length;
 		ret = calculate_alloc_pointer(cache, &last_alloc, new);
 		if (ret) {
 			btrfs_err(fs_info,
@@ -1608,6 +1607,7 @@ int btrfs_load_block_group_zone_info(str
 			goto out;
 		} else if (map->num_stripes == num_conventional) {
 			cache->alloc_offset = last_alloc;
+			cache->zone_capacity = cache->length;
 			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags);
 			goto out;
 		}


