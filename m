Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555271C57B1;
	Tue, 15 Oct 2024 12:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994074; cv=none; b=oChe91W+1R8P3uTFfXZexW3cdlrSfriJJbZXo14jqdvYKHlns7Cb82HdoT7huZ6Xy45RIxwvn8aofp7C1TGc+/SQnVom+FO+KPlmi+SMWRA2HFRsz2cWRTWpK8ND39iM8D4tZeiyTB9gqiJVyaU5D6Uv1AU8tcjMZQk9cSRmhAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994074; c=relaxed/simple;
	bh=5/bjb24GcTJlc/lY1T7Knv5oNsat4AhNMs0fTXzKBYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XM7K+R4C91guV1EzzuJh9rLiMJKYJmVR5PTtALZIFn9yDNDnF/kms1YvLtQenoNtsL/t3oFG/iUhXc1y1ZFnTQx3aBdcEfOxpj9WZ1PPZkF8Ani3WZ+tHl7p0xBNGQBHMFQpw/XVMzkmyyvrpgwfVxWA6V3lCN7yMCcPsqFhM3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SyfDVnvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyfDVnvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72990C4CEC6;
	Tue, 15 Oct 2024 12:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994073;
	bh=5/bjb24GcTJlc/lY1T7Knv5oNsat4AhNMs0fTXzKBYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyfDVnvmvE9x/1l32pJb5xJJZGl73Y4gMJA3mBGjk6JEbDuH1mkGvtE6NKLHJ7FM2
	 VvGwsbCgdASQ9t2Sv7tg6Tbcak1DZeMsw0gi1ZBy1pZlx2CsnbYM39itiUVDtH/qkr
	 i8AAPzgQwAoiVMdh4LRtik+DH3Aufl0lcEI1wIfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 600/691] ext4: dont set SB_RDONLY after filesystem errors
Date: Tue, 15 Oct 2024 13:29:08 +0200
Message-ID: <20241015112504.155727089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b09b7a6b7a154..93eb26c162422 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -674,11 +674,12 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 
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



