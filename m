Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA253A8753;
	Sat, 17 Oct 2026 18:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260732; cv=none; b=V2Hr0HvsU79s2QeQPap0I428aHomg1DF7vU1G+XrS91WUbO+IkH2HIxDWWgS/OXq9tAdSMC8Rb4X+7ut30eBLfVVrUP6c0Y8C5e7cYARB4Rlz597sT+QiiN1dul7RvCJ4fPVKreCw0SaxaRHmJxY34uFx3GaMJ2cQ3XDzUjld9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260732; c=relaxed/simple;
	bh=a/mfrrqNIccqP9N6oniPut/47WAH7S0+Su3okMEHnQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYIRUDEwygygiOLGA2eVV/6nL58nwktnOP5hU5QLIpAkjnx6hR7HqG8gK4QVIvCSye3Ke5Jyez6BCT3vzGzmU3QFzJXKOrLIeMdJI89H0WAcd3PSoARDxzUXtEwG6sHsRF2mJgXpv1Hw7jcF9lRo0mktWfvRa/4wraCbGufG7zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbOjg1tn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbOjg1tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0148B1F000C4;
	Sat, 17 Oct 2026 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260731;
	bh=MF/4KL398fqyTQ8LngldRKkj2JHGFEZVVnaDd0ZWDkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KbOjg1tn16mngmWr/mN0Nv/F2J42MmU0uip1A+fKbdV7EI9nRcIMDt3IO9zh0N1/w
	 pyUhviRXrVN78iMbYWzoFESZ7p54s96jR323z4GvLJ/2kFjOhPVg5QmQWpWa4TiLae
	 gnHG/LufwLgz5i/jOcBnCxHqLluI4Z6UpxY+V+EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1643/1674] btrfs: zoned: finish active block group cleanup if call_zone_finish() fails
Date: Sat, 17 Oct 2026 18:05:15 +0200
Message-ID: <20261017160513.246176949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit a18a6b93a2843b9d103d3456bbd4b3f90282a379 ]

do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE before finishing
the zones. If call_zone_finish() then fails it returned early, leaving the
now inactive block group on fs_info->zone_active_bgs, leaking its
reference, the BTRFS_FS_NEED_ZONE_FINISH waiters are never woken, and as
its alloc_offset equals the zone capacity btrfs_zone_finish_one_bg() keeps
selecting it, spinning btrfs_zoned_activate_one_bg().

Fall through to the cleanup on failure too and return the error, but keep
the block group read-only as its zones are left inconsistent.

Fixes: d70cbdda75da ("btrfs: zoned: consolidate zone finish functions")
Link: https://sashiko.dev/#/patchset/20260818100037.1366563-1-johannes.thumshirn%40wdc.com
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 92ec2d91c41fe..7f6d0d44e7513 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2193,14 +2193,14 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 				       GFP_NOFS);
 
 		if (ret)
-			return ret;
+			break;
 
 		if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
 			zinfo->reserved_active_zones++;
 		btrfs_dev_clear_active_zone(device, physical);
 	}
 
-	if (!fully_written)
+	if (!ret && !fully_written)
 		btrfs_dec_block_group_ro(block_group);
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2213,7 +2213,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
 	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 
-	return 0;
+	return ret;
 }
 
 int btrfs_zone_finish(struct btrfs_block_group *block_group)
-- 
2.53.0



