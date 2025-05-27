Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC5B27FD4C;
	Tue, 27 May 2025 16:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364734; cv=none; b=ZiOOKgaXlvmz7GWYYU8ZrxHXVRjVLklhg7pnXBmIZgKq/eVAqf47sr/VKoXFLEcfoPoyMslWmgp13SMQhIW2abHVjkAAuBIL86EBWzyVBIJogNModbMyNH7ryEbFKoT4f11PLKBieVrh9lo18r5J4FQ/w73X4W8/5IjIP/+6Bsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364734; c=relaxed/simple;
	bh=p45DmdHmDWKhYVOS2Ifj89waf3GKiR/aXJfjFm1nTj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkrzmFm6GGzvS1DKbe1/5j8wvJb+j1EVRRAXnh4tHFyEbBgol9Slif5hXONmbe8zKtpYDDaa4A9LrvwxyeAjbVkZOBOpyJt029nez2usia3T90eruvdkkxaRXW65FnXb/Ywc4aHVejrteiJG3Bbcjimrkh2ibxXBhqX1qwoSvBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CACdPcV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CACdPcV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3467C4CEEB;
	Tue, 27 May 2025 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364734;
	bh=p45DmdHmDWKhYVOS2Ifj89waf3GKiR/aXJfjFm1nTj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CACdPcV3oJpoDBgVF6mX3I5AifJCFk72ie2nkUyW/5L8/kEKzrKwxWiMH2IWVraQh
	 58sSsloqBBrsbh8Eqo/vMZ/b+Po8qsTRUNEwWh+dmHH7BA3d19ftyDPqPsQdhAynT1
	 msU5Xycm8GsYuNB8/ZDDJjkXytQ3ZMophnFlTcnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/626] btrfs: get zone unusable bytes while holding lock at btrfs_reclaim_bgs_work()
Date: Tue, 27 May 2025 18:20:11 +0200
Message-ID: <20250527162449.827421764@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4423d8b716a58..aa8656c8b7e7e 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1891,6 +1891,17 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
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
 		spin_unlock(&space_info->lock);
 
@@ -1907,13 +1918,6 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
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



