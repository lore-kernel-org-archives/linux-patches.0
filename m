Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EDB237180;
	Tue, 21 Jul 2026 20:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665873; cv=none; b=DayH+0uUNvorCujvhK8r+lejE1iv/XqKMyPRsIZS8CunmRkADlpVeb2COgu31MM3pCeQQtDCbvbF7PNMQabJmLPgIfInVqhPvAKToayK99RH8p9R1Bum/r/Mkc0aDO8g0C8KKnJdDZroVtaDERG2iQLjtmgQJ1xGKFlFmxXUmY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665873; c=relaxed/simple;
	bh=2QYNEf0+0nMNOEqbjjqo/xQ5ABV9E0J+MJQ7Aw3IiEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcwiwbEiSYhhfIY3EWD2ALgnRDlFF6SiMbxstbrdpWQ8mz//AyGhK8oJL6HKsQ2O38CBfF/tjvhJtAbCUZgt1+VIvHEX1UJbQ9VgrCNkdzrKr5U0qLaZ7Mitb38HZEv5CU6qU8m87pW1F/M64Gn5fyZazfWQSFZEejCHTIC5CV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0C+apE4c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0C+apE4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FDA1F000E9;
	Tue, 21 Jul 2026 20:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665872;
	bh=Ak3SLv+7rG3QW/O8UTzzS5utfLUGNKvxGyiICX3AaGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0C+apE4cMGdz5Lzr5fSkLnkGxwnKk3yTnaJUMQf2OpNttC9DO7dEge6erEiu32mi9
	 zwKxB8mKOqCdFUrYAg8pIKUEHx3Q1X1dk5KdyQYEYoWkxr8ILdrWSD88CYnsXonwpn
	 P1usrGnHiCL9CKd+lNek+IJP/W3WfOrsd/1VaRlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0469/1266] ext4: fix LOGFLUSH shutdown ordering to allow ordered-mode data writeback
Date: Tue, 21 Jul 2026 17:15:06 +0200
Message-ID: <20260721152452.329175018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d34affd2075eb4..e27eae7f163dfd 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -826,11 +826,17 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
 		thaw_bdev(sb->s_bdev);
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



