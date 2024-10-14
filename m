Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9501A76A5;
	Mon, 14 Oct 2024 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916777; cv=none; b=HKZXGjsk+kFGEepceF1tQKDg/jezFvTfY20tPJqJA4ELtx4y+WHr9KEAip96jXlrxZ07HMlyiGyVizbxBxWN2+0sd069bPtDkc+SEvdHBgFNiFPMy9lH/i4pPDV058yXQ6SzK2UHsF6Oa7S9d9UzkUsWqqNjFCjs3nJajSfrBKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916777; c=relaxed/simple;
	bh=gy/zzEoRAcGBDtDyf2UUw2m7gWEZMFylIa9sMy+7dY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig6u9G+crX1fUXg7v8wwxDzQBOuC8LOy618CyJaDoIkO+8xBgWcSGXuBzKrKIIDEaaMes6SmcRNXgayYpFtnee3hfH+p7qdxY4q9gIpiqPrJL+g0PEDv0titV4YJ9zN67lwhR3xE7oDuG8v2BJP1OGJheJA1ofql3pta74mOwsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6l0GUS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6l0GUS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4E4C4CEC3;
	Mon, 14 Oct 2024 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916777;
	bh=gy/zzEoRAcGBDtDyf2UUw2m7gWEZMFylIa9sMy+7dY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6l0GUS9kL9/1KjWGGGMepsytFqSBYKAq7SoorMnWstL3kCc9BRO/io2w+PuiRn3P
	 OD5JgTidMfcxzPQS1/dgGBhIa9yWvithoR5v4WavmSdL5+h8xEMLekAOXmOzwumgAI
	 XR0SYE1M8jMKa+7NVCvqpCADPNxhsSNdEryZ3Hv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/213] ext4: dont set SB_RDONLY after filesystem errors
Date: Mon, 14 Oct 2024 16:19:28 +0200
Message-ID: <20241014141045.407482412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ed0dc4cc1d28e..1d14a38017a7f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -744,11 +744,12 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 
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



