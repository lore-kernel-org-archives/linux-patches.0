Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29D51DDA36;
	Tue,  8 Oct 2024 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393527; cv=none; b=Qn2kbb0V8A6xYiuRxz7trX9NEzpzqSH8lZ9BXfvCU6BnyyG3NQ2/02cXlptRut6i3rWTswLIs+EST/B3py/630lI3vsPuIC6a39jZiAhEXhTPNGXWx6YDgf5W306uVY3g4fYbinNpElhOqkaW73eXuL5eKDN6yQs8JQbhNsxXX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393527; c=relaxed/simple;
	bh=XqYmYSerTssG/jj7DWUWO9TZzS6hzZkp9eD/FrMGgro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFXMGKFaMFmVV7lTdlJmG87NZ+8hIh+pvqrmmPddyN4n317JERjVUnz+XvQRiLEFWqzAvrTsxlgdQdunAHD0PTHPD72vmTQnXmji3i9xnOKo9bHcwmY9jYrSzmwQ1EyPAbsT1k3HaEMLwMUVT7LC2XTSntM2ZlX5wADA85OqcdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MT7M+Zr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MT7M+Zr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E629BC4CEC7;
	Tue,  8 Oct 2024 13:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393527;
	bh=XqYmYSerTssG/jj7DWUWO9TZzS6hzZkp9eD/FrMGgro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT7M+Zr4dF1nSYBomoUNRVjkCqwub+k7Zc0j5i5gvi+QLF0aB55/X6iKZAKYm5/9+
	 HOpufSGJkgEhQAFQliKVqCcMlzHeS0qxaqDfjotk09PT7oWXiUsb0XjMyjhGXauaWR
	 qJSUHjtd3bKEt3ay56x3ss9pL+AzFRTGRPBEjT9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/386] ext4: dont set SB_RDONLY after filesystem errors
Date: Tue,  8 Oct 2024 14:07:03 +0200
Message-ID: <20241008115636.420517677@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 46c4f75049791..53ead0650fc8a 100644
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



