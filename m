Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0162A22A4DB;
	Mon,  2 Jun 2025 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876727; cv=none; b=Wqth9CNr1Lbbi6C94R4NAF9WLM6F9H4VZTRZFj05DyrdxyLWlybJpjJ0OsUJSrmcoDIHofV3w2CSUaXD8EM582Wm9b+J77XJECnWXOF7ZIqdp1OfZ69SmAiq0TtTAYoiB/kWrqRKxI1AWf0eCSMAkN5uMba0IIx2TPOAc1sQGdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876727; c=relaxed/simple;
	bh=lT8bJaWEMgt83BdUXZxig3/lBQXn25Gep093hFQf+cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZAO3JftltdTX2CvoTe4LBNHqoknvJfQkOWkTJhqNP5sQFOilAfZOwJ+1+81IHR8KLIKtOhNADZwym89LVl5WlQ562iA41X9bPRXXFkxecg+dFEnU/2SFGutZl2ytW7tCM1bQOTP+q2frzr0HLfpUNKZCtKwcK3aRJphTiAjOH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sr0bJp98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sr0bJp98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BF6C4CEEB;
	Mon,  2 Jun 2025 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876726;
	bh=lT8bJaWEMgt83BdUXZxig3/lBQXn25Gep093hFQf+cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sr0bJp98WYaI91tHOnAhzd3ivDf78RAh2xnR+aXJtIZRSNDN7Gac5wVcToIKpONFw
	 1PNOQM0Pz3c1+VX7+M53wZmSZbhswsFhZHN1s15+OFL1WauXSfp7WeC+ehZkaMG5oI
	 cXyC3u6Kdx1zPQsaUHbAd8yXeft13+XMzegm0mZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/325] btrfs: get zone unusable bytes while holding lock at btrfs_reclaim_bgs_work()
Date: Mon,  2 Jun 2025 15:45:31 +0200
Message-ID: <20250602134321.999764820@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1283b8c125a83bf7a7dbe90c33d3472b6d7bf612 ]

At btrfs_reclaim_bgs_work(), we are grabbing a block group's zone unusable
bytes while not under the protection of the block group's spinlock, so
this can trigger race reports from KCSAN (or similar tools) since that
field is typically updated while holding the lock, such as at
__btrfs_add_free_space_zoned() for example.

Fix this by grabbing the zone unusable bytes while we are still in the
critical section holding the block group's spinlock, which is right above
where we are currently grabbing it.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 0dcf7fecaf55b..91440ef79a26f 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1678,6 +1678,17 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 			up_write(&space_info->groups_sem);
 			goto next;
 		}
+
+		/*
+		 * Cache the zone_unusable value before turning the block group
+		 * to read only. As soon as the block group is read only it's
+		 * zone_unusable value gets moved to the block group's read-only
+		 * bytes and isn't available for calculations anymore. We also
+		 * cache it before unlocking the block group, to prevent races
+		 * (reports from KCSAN and such tools) with tasks updating it.
+		 */
+		zone_unusable = bg->zone_unusable;
+
 		spin_unlock(&bg->lock);
 
 		/*
@@ -1693,13 +1704,6 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 			goto next;
 		}
 
-		/*
-		 * Cache the zone_unusable value before turning the block group
-		 * to read only. As soon as the blog group is read only it's
-		 * zone_unusable value gets moved to the block group's read-only
-		 * bytes and isn't available for calculations anymore.
-		 */
-		zone_unusable = bg->zone_unusable;
 		ret = inc_block_group_ro(bg, 0);
 		up_write(&space_info->groups_sem);
 		if (ret < 0)
-- 
2.39.5



