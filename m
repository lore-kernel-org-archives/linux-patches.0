Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CD81DE89A;
	Tue,  8 Oct 2024 12:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390297; cv=none; b=BPL4PBixk2Usex/NFCXyM+xgTJlJr6pd/xgVR1UHrhLiB3NRJkM3qgVKNfUaGRola0AMgAED8BR0/NFEc93QCAW0OUpOhDQuIjjwi6jGbkjkLlObj3a1zF5u3CTbU+UhSQKojqq5dREYWj9OkvX6haIpbPzq5WT1ikuunLTseKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390297; c=relaxed/simple;
	bh=soYqjmR5rDWWGq+N1p8X4deAQOqe59uVAg9kez8eR5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUATp1EOopxZQq3o/xj/dVSZ7sz0roBlbraoaHZDxBXBgPRKKg0LX+5x0cBGWKfQDc16sMqE0kbXyFpqa+tyYvdY+nJ+WZCLeYHmKiHn6RSIHIe9pMhUuWpImrY+8lzSc5KmKUoZIUDby6uBrVZw9sFOCCFJIH0GpQ9ZOGZj4zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGhzWKI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGhzWKI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5BCC4CEC7;
	Tue,  8 Oct 2024 12:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390297;
	bh=soYqjmR5rDWWGq+N1p8X4deAQOqe59uVAg9kez8eR5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGhzWKI3W8o9/j6VGez2D/PdTS/dTM7ommxS4PolxGo9iwpDRsdNBJHk74foQNu//
	 OTo6aDbWPmlFIHXGVhoIfv1pAl0TWf03A3VXTeovmUk6iXo9BKxeKT9KZF8f9DoBn4
	 B5cpjH8wuZ7BqCOO1G/ljBRG7cwyytUKiB4MikAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 249/482] ext4: dont set SB_RDONLY after filesystem errors
Date: Tue,  8 Oct 2024 14:05:12 +0200
Message-ID: <20241008115658.091520614@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index edc692984404d..04b78c479fd7a 100644
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



