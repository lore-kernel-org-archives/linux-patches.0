Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAA2471425;
	Tue, 21 Jul 2026 17:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656293; cv=none; b=kSG+uC4uvmMq0TJ7OUvxPbWueonZJsY95am8bfT83gPFRUlOrLF/WdPCU5/8mW9yJ8TAVfoaEAU7KH9Ryg9e6HcrgLJDlivvJwpjPqM0uuhjdbgdCMxBkweefWPg+etKoe0I+HS/tSxjxjVjGGbKcKq/7U1MFa5ZktqFGV2z9M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656293; c=relaxed/simple;
	bh=6heqSt60QlIxjHKWJsV3w+0RYgnztZyP2HFLJGLcbGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNe9DFDhT5UlwPZfivLr0QKSFPGnXws+7aPgdxcsmtgHbnyIEywGiewx5Y2KJGaJNWOn/iJerwgKy6iVy0Yx3RGIC7pkhjWm7RnT/mB8ZSNN9Zvhl2RYMCdFxPUhwQ4ND6uNTd9iPbCVtgWj6esX/hqJZH91kV7KkMi9R83HBtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpM7WI/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpM7WI/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830B71F000E9;
	Tue, 21 Jul 2026 17:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656292;
	bh=lI4Fb72NIpDzaCOQxdU1ENJgSIME3lJ7+AOsNxrbu54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpM7WI/Wl7jJAUUhSA0fki93Yc7ZOqP2tT6LoREXBuE/sg4bUdEYCUZElJFrPZU6a
	 CYFS6yXnJoqFuhiTdvARnX70Z9TooKCYigZs8BVzxsPwFTcZKnDgcLX34Aj3dGQYIR
	 fESjTnTeuC/DYrRr+M/LJujCLIHzMVT6Bsu3iVsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0289/1611] ext4: fix LOGFLUSH shutdown ordering to allow ordered-mode data writeback
Date: Tue, 21 Jul 2026 17:06:45 +0200
Message-ID: <20260721152521.563335302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit d99748ef1695ce17eaf51c64b7a06952fa7cddab ]

In EXT4_GOING_FLAGS_LOGFLUSH mode, the EXT4_FLAGS_SHUTDOWN flag was set
before calling ext4_force_commit().  This caused ordered-mode data
writeback (triggered by journal commit) to fail with -EIO, since
ext4_do_writepages() checks for the shutdown flag.  The journal would
then be aborted prematurely before the commit could succeed.

Fix this by calling ext4_force_commit() first, then setting the
shutdown flag, so that pending data can be written back correctly.

Note that moving ext4_force_commit() before setting the shutdown flag
creates a small window in which new writes may occur and generate new
journal transactions.  When the journal is subsequently aborted, the
new transactions will not be able to write to disk.  This is intentional
because LOGFLUSH's semantics are to flush pre-existing journal entries
before shutdown, not to guarantee atomicity for writes that race with
the ioctl.

Fixes: 783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260424104201.1930823-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index acc28aa5744b1d..fbf5771eca9937 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -829,11 +829,17 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
 		bdev_thaw(sb->s_bdev);
 		break;
 	case EXT4_GOING_FLAGS_LOGFLUSH:
+		/*
+		 * Call ext4_force_commit() before setting EXT4_FLAGS_SHUTDOWN.
+		 * This is because in data=ordered mode, journal commit
+		 * triggers data writeback which fails if shutdown is already
+		 * set, causing the journal to be aborted prematurely before
+		 * the commit succeeds.
+		 */
+		(void) ext4_force_commit(sb);
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
-		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal)) {
-			(void) ext4_force_commit(sb);
+		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal))
 			jbd2_journal_abort(sbi->s_journal, -ESHUTDOWN);
-		}
 		break;
 	case EXT4_GOING_FLAGS_NOLOGFLUSH:
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
-- 
2.53.0



