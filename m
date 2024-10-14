Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448251B85CD;
	Mon, 14 Oct 2024 15:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919730; cv=none; b=Tt4Cmf7ZJIXNELWBreqaaoaF6aNz5X+N5yEswFlpSnjUI2HMpa3DFKJwJ78gC1K5pcQGmr2K35H01v0H53UjWx2Vrv/DlPc6QTjJzvd9WOlH16aEp5hE+tlhOA41J/ZW/AT0sFBWb14Ig/PgeiPM8mP0eypbx9zT+pGbx4iaiY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919730; c=relaxed/simple;
	bh=uCVScCKgRhHd0mvvXl0Qr1D1ru4OpSrurPXRgZB1lks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEIyKjWzHSDmGhUF5GfSjbDY0ropI77PGlMsjkAZr4sSsuPatdTDcHC3FUblyezv2aldQWj6B6AFRma8PgqZhWI9JReQbXHs/aqzs7RzUJGSRR97uPtnW008JpeTVuwUDPB5g9/91FUH0rWzfYlPFWg+mrAzNGUY9xTgJ0xXf4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2NWtCtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2NWtCtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95F2C4CED0;
	Mon, 14 Oct 2024 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919730;
	bh=uCVScCKgRhHd0mvvXl0Qr1D1ru4OpSrurPXRgZB1lks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2NWtCtwqztud8jSP7lzA6DQ6HGNkFMjkOW1TwYW0aUn5cRIDXT7X4HK3Y7rzMdi9
	 4QoNf9/8Vk9alXNvEpaLeBSsi3JDvqXx0djYUD4f2F1olc2AfC/NVKM2qIAHNxNQL1
	 HZeZcSNLmW660C3lekYgSvXUDyxTxeHdeMtb1hGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 691/798] ext4: dont set SB_RDONLY after filesystem errors
Date: Mon, 14 Oct 2024 16:20:45 +0200
Message-ID: <20241014141245.217528727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3db39758486e9..3bf214d4afef5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -692,11 +692,12 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 
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
 
 static void flush_stashed_error_work(struct work_struct *work)
-- 
2.43.0



