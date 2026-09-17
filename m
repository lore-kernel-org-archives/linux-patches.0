Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B824E5334;
	Thu, 17 Sep 2026 17:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665510; cv=none; b=STHATqfaL0Mi380nzbc22ZSbDnR+u1VZvYudU0S/kLNmQhxR9pF0I2Negj5M+pAyjdJarOge/EjwAFa1dxnSPl60aMwGhLZBdT1EbdPmtItPPOCKaZTutEGIWhHXx9rymK6/3yeCjEiW3gxT4+OS4WE8OYd8OC3f+KmM7l74E54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665510; c=relaxed/simple;
	bh=o6ffu6XnuAH9ZGMwo6DUAFSRKh0TuBBxHRgrsweH19c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbQaU0nfxww9PQmdw9OmZq2bOA9CTNzz+Zh+uQZrzHTsNWAxDA8PYNb3AqTTfrgRGbeB8/Y3t/CGIkzKfpdGhszjIDp6WaGT6V9jKkM5dBv1lGc0dh5bVmIJbJNVS3uga5qcGdDw/vg03kx9qD9e6aF9N31JroumfmcIyHGjSIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15yXkLf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15yXkLf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832CD1F000FF;
	Thu, 17 Sep 2026 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665509;
	bh=OIa2YNoWuZICVGVNcrSGSxzgFH0ww4pxyP8K0tsXc58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15yXkLf9aNp7sAlEAKGdX1CMshKDGAmhLg2YKdFNbEG72PJU6qhT+4hUOAITWqPSs
	 tnIuFxCpc9q0bWokkVCwu07cVHaqoSEaE3GYgDvp5xePNyRdeYTcQ73ppepfH2meBW
	 f2mLuiYqfzYL7PF1uu/1kIDW2cwjveOzfdxAdKI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0727/1250] btrfs: zoned: finish active block group cleanup if call_zone_finish() fails
Date: Thu, 17 Sep 2026 16:08:42 +0100
Message-ID: <20260917151611.594995624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 fs/btrfs/zoned.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0174c3f9cfb8e..862475ae49770 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2592,16 +2592,13 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 	down_read(&dev_replace->rwsem);
 	map = block_group->physical_map;
 	for (i = 0; i < map->num_stripes; i++) {
-
 		ret = call_zone_finish(block_group, &map->stripes[i]);
-		if (ret) {
-			up_read(&dev_replace->rwsem);
-			return ret;
-		}
+		if (ret)
+			break;
 	}
 	up_read(&dev_replace->rwsem);
 
-	if (!fully_written)
+	if (!ret && !fully_written)
 		btrfs_dec_block_group_ro(block_group);
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
@@ -2614,7 +2611,7 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
 	clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info->flags);
 
-	return 0;
+	return ret;
 }
 
 int btrfs_zone_finish(struct btrfs_block_group *block_group)
-- 
2.53.0



