Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF152159570;
	Mon, 29 Jan 2024 17:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548176; cv=none; b=QnNR/1rZBhkL3qrM1RqexDI1NR3RFf19JU7Vc/Ke/UosXtL2RmL9Ke8GTNQ+yTrEVWhGnkSca/o+pFeG9KIMUBqPjTDwtxSAoBqmz4omJGsy6C8GZ6VM4jBVpZBCE8+E0RmkJ3glxaUtvF3bOlpbVIm0GwvOmDPOpd7WMfUfKa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548176; c=relaxed/simple;
	bh=+YicPiqY0Dm1JnjLD/huLSyYbyu2z6KVTYYsuVPNAqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rjnpx9pT7okmCHIx3ZtcGl/EPagZy5vlPE2aKzoMUDFGwLyN1Ln+NSLwUdrCc7tqlu+07XS30ZsWM0ht1v3VyzyZwE7m9ID7wSyTYhrvmLJmwqeqbWtN5btrdUn13cyYrjPm/w80inayWopJoulDOyiZ6LrTJ6vRAyQeReujBOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7ltQvYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7ltQvYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D6AC433C7;
	Mon, 29 Jan 2024 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548176;
	bh=+YicPiqY0Dm1JnjLD/huLSyYbyu2z6KVTYYsuVPNAqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7ltQvYwQAhgD77x7BdEUaFajizp8h8qCHcrGcTwo0fRqLxOW+kAzvbIsT13ryS2t
	 jXBIEMLO8qdT1X0zCMl4Gfj48+wPaigfl6A76CgMsC9JUPp2eBbNTxO/LtUA2NHteG
	 SRC864nstbAELLA+4z6pRtk5upncOs06+SQ0pn3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 222/346] btrfs: zoned: fix lock ordering in btrfs_zone_activate()
Date: Mon, 29 Jan 2024 09:04:13 -0800
Message-ID: <20240129170022.913230594@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit b18f3b60b35a8c01c9a2a0f0d6424c6d73971dc3 upstream.

The btrfs CI reported a lockdep warning as follows by running generic
generic/129.

   WARNING: possible circular locking dependency detected
   6.7.0-rc5+ #1 Not tainted
   ------------------------------------------------------
   kworker/u5:5/793427 is trying to acquire lock:
   ffff88813256d028 (&cache->lock){+.+.}-{2:2}, at: btrfs_zone_finish_one_bg+0x5e/0x130
   but task is already holding lock:
   ffff88810a23a318 (&fs_info->zone_active_bgs_lock){+.+.}-{2:2}, at: btrfs_zone_finish_one_bg+0x34/0x130
   which lock already depends on the new lock.

   the existing dependency chain (in reverse order) is:
   -> #1 (&fs_info->zone_active_bgs_lock){+.+.}-{2:2}:
   ...
   -> #0 (&cache->lock){+.+.}-{2:2}:
   ...

This is because we take fs_info->zone_active_bgs_lock after a block_group's
lock in btrfs_zone_activate() while doing the opposite in other places.

Fix the issue by expanding the fs_info->zone_active_bgs_lock's critical
section and taking it before a block_group's lock.

Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
CC: stable@vger.kernel.org # 6.6
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2094,6 +2094,7 @@ bool btrfs_zone_activate(struct btrfs_bl
 
 	map = block_group->physical_map;
 
+	spin_lock(&fs_info->zone_active_bgs_lock);
 	spin_lock(&block_group->lock);
 	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags)) {
 		ret = true;
@@ -2106,7 +2107,6 @@ bool btrfs_zone_activate(struct btrfs_bl
 		goto out_unlock;
 	}
 
-	spin_lock(&fs_info->zone_active_bgs_lock);
 	for (i = 0; i < map->num_stripes; i++) {
 		struct btrfs_zoned_device_info *zinfo;
 		int reserved = 0;
@@ -2126,20 +2126,17 @@ bool btrfs_zone_activate(struct btrfs_bl
 		 */
 		if (atomic_read(&zinfo->active_zones_left) <= reserved) {
 			ret = false;
-			spin_unlock(&fs_info->zone_active_bgs_lock);
 			goto out_unlock;
 		}
 
 		if (!btrfs_dev_set_active_zone(device, physical)) {
 			/* Cannot activate the zone */
 			ret = false;
-			spin_unlock(&fs_info->zone_active_bgs_lock);
 			goto out_unlock;
 		}
 		if (!is_data)
 			zinfo->reserved_active_zones--;
 	}
-	spin_unlock(&fs_info->zone_active_bgs_lock);
 
 	/* Successfully activated all the zones */
 	set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags);
@@ -2147,8 +2144,6 @@ bool btrfs_zone_activate(struct btrfs_bl
 
 	/* For the active block group list */
 	btrfs_get_block_group(block_group);
-
-	spin_lock(&fs_info->zone_active_bgs_lock);
 	list_add_tail(&block_group->active_bg_list, &fs_info->zone_active_bgs);
 	spin_unlock(&fs_info->zone_active_bgs_lock);
 
@@ -2156,6 +2151,7 @@ bool btrfs_zone_activate(struct btrfs_bl
 
 out_unlock:
 	spin_unlock(&block_group->lock);
+	spin_unlock(&fs_info->zone_active_bgs_lock);
 	return ret;
 }
 


