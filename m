Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32B41E1E19;
	Wed, 17 Sep 2025 12:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112600; cv=none; b=jhPLIysrbBnZlngvzFEMceCLgqNh8NOiM4vxS5jLEBJY7BL///zbCvjTerUncPmpOHaPZs87bKM1NAzr82VhdBxVs+CgJ8V+lbWZsPnRDXib0ERNd29PoNnkefsABYAaoCWxhCX3SFzmJqzddnDwFr3LdqGF1QtZEQFN1a++F88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112600; c=relaxed/simple;
	bh=SZ1wsK41XEO0M3rJy5fV02hO8vmUAMAzGcBGZD8UNuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT1NKgh4aUmqBdQnIOFE1Ow2cfZDQzDt1WT3ygKrqb27+ym8Ss8SyAPersfi8wvfx6FfAeJOCinnB9wL5XHVkOnuiOtN79z+0wiJYAgOfRTRGJJbQ7FQ11Svdw0QKq7Vhv0ZsNIWdtLebzBAsQ64ZQpARk2nwGrYH2GsERGFuk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvUn2vPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvUn2vPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D72FC4CEF0;
	Wed, 17 Sep 2025 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112599;
	bh=SZ1wsK41XEO0M3rJy5fV02hO8vmUAMAzGcBGZD8UNuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvUn2vPG1iKtIRC7fsPbSfS9ubBJTNUFRBj26zlfnbc5CF7hVJgSW7jXFeK0RQ59J
	 jl6M+c0JkFHGWdlknvwg0v3kFztTvmrHrKGDphEKwdBPsNJl6Ib3JQAHXg9k4EPG7n
	 Xhen3e5CklnC59uAg9titVvbF6oejZR8zAZ6gEpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 020/189] md: keep recovery_cp in mdp_superblock_s
Date: Wed, 17 Sep 2025 14:32:10 +0200
Message-ID: <20250917123352.347937089@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Ni <xni@redhat.com>

[ Upstream commit c27973211ffcdf0a092eec265d5993e64b89adaf ]

commit 907a99c314a5 ("md: rename recovery_cp to resync_offset") replaces
recovery_cp with resync_offset in mdp_superblock_s which is in md_p.h.
md_p.h is used in userspace too. So mdadm building fails because of this.
This patch revert this change.

Fixes: 907a99c314a5 ("md: rename recovery_cp to resync_offset")
Signed-off-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/linux-raid/20250815040028.18085-1-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c                | 6 +++---
 include/uapi/linux/raid/md_p.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3f355bb85797f..0f41573fa9f5e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1406,7 +1406,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 		else {
 			if (sb->events_hi == sb->cp_events_hi &&
 				sb->events_lo == sb->cp_events_lo) {
-				mddev->resync_offset = sb->resync_offset;
+				mddev->resync_offset = sb->recovery_cp;
 			} else
 				mddev->resync_offset = 0;
 		}
@@ -1534,13 +1534,13 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	mddev->minor_version = sb->minor_version;
 	if (mddev->in_sync)
 	{
-		sb->resync_offset = mddev->resync_offset;
+		sb->recovery_cp = mddev->resync_offset;
 		sb->cp_events_hi = (mddev->events>>32);
 		sb->cp_events_lo = (u32)mddev->events;
 		if (mddev->resync_offset == MaxSector)
 			sb->state = (1<< MD_SB_CLEAN);
 	} else
-		sb->resync_offset = 0;
+		sb->recovery_cp = 0;
 
 	sb->layout = mddev->layout;
 	sb->chunk_size = mddev->chunk_sectors << 9;
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index b139462872775..ac74133a47688 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -173,7 +173,7 @@ typedef struct mdp_superblock_s {
 #else
 #error unspecified endianness
 #endif
-	__u32 resync_offset;	/* 11 resync checkpoint sector count	      */
+	__u32 recovery_cp;	/* 11 resync checkpoint sector count	      */
 	/* There are only valid for minor_version > 90 */
 	__u64 reshape_position;	/* 12,13 next address in array-space for reshape */
 	__u32 new_level;	/* 14 new level we are reshaping to	      */
-- 
2.51.0



