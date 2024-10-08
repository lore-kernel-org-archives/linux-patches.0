Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3B61D31A0;
	Tue,  8 Oct 2024 12:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392066; cv=none; b=h5ACVvBEdDtCycA4KfBYROL/sx3J6dO1ktllKRlfamCHErg9zZN4hjjLwEDWAI4TgT9hvekWQSuhAMlGE3820wTs+oGQCTvxA9O7hZI3B0HqJxh8/8ZL0tb2tUGlyre4B8PqHvL9XjNIfwrn/aQLHopPXGQVZf8FWgFQiV7hYsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392066; c=relaxed/simple;
	bh=HjrsSPZKBuUEZw46eIZODT5ZLGS4wojTTxCx8Wlpook=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQkeIr3x9RsKvRvISr38GomgiWj9GhDfRDTEuw5DXQysqwCNbysP1JhMDQNR9SFVtVcqHvXMkg9LJuKguP3IGDX3sJ7vX+YMQuWet6mWm0xLES4NS9rwhv5KOwtcLQZBnu/rqgwMogxCXY589VwLp7OXIyvssqypTJ0b9yF4XR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxW2ZGwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxW2ZGwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E6AC4CEC7;
	Tue,  8 Oct 2024 12:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392065;
	bh=HjrsSPZKBuUEZw46eIZODT5ZLGS4wojTTxCx8Wlpook=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxW2ZGwe6bFnfvy9Wy4IM2dh3eaApER+VNb+a9ly5Rhz63AgB7rsEed3K3wqyZomG
	 tL0mne72O+DbML7nuXYeuhHrr2x1CI6PgCYIIwOR3I8beCS9DUSmH3quN0AC9UZ3Zu
	 /MBMfSJjRrMPmfU2W3SwLnMYTfbI8x2wWgnp0ryI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 305/558] ext4: dont set SB_RDONLY after filesystem errors
Date: Tue,  8 Oct 2024 14:05:35 +0200
Message-ID: <20241008115714.319739584@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit d3476f3dad4ad68ae5f6b008ea6591d1520da5d8 ]

When the filesystem is mounted with errors=remount-ro, we were setting
SB_RDONLY flag to stop all filesystem modifications. We knew this misses
proper locking (sb->s_umount) and does not go through proper filesystem
remount procedure but it has been the way this worked since early ext2
days and it was good enough for catastrophic situation damage
mitigation. Recently, syzbot has found a way (see link) to trigger
warnings in filesystem freezing because the code got confused by
SB_RDONLY changing under its hands. Since these days we set
EXT4_FLAGS_SHUTDOWN on the superblock which is enough to stop all
filesystem modifications, modifying SB_RDONLY shouldn't be needed. So
stop doing that.

Link: https://lore.kernel.org/all/000000000000b90a8e061e21d12f@google.com
Reported-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Link: https://patch.msgid.link/20240805201241.27286-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cecea19908109..b3f47d6879ebf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -735,11 +735,12 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 
 	ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 	/*
-	 * Make sure updated value of ->s_mount_flags will be visible before
-	 * ->s_flags update
+	 * EXT4_FLAGS_SHUTDOWN was set which stops all filesystem
+	 * modifications. We don't set SB_RDONLY because that requires
+	 * sb->s_umount semaphore and setting it without proper remount
+	 * procedure is confusing code such as freeze_super() leading to
+	 * deadlocks and other problems.
 	 */
-	smp_wmb();
-	sb->s_flags |= SB_RDONLY;
 }
 
 static void update_super_work(struct work_struct *work)
-- 
2.43.0



