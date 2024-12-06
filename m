Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456C132C8B;
	Fri,  6 Dec 2024 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496620; cv=none; b=qnUbkDQLzgs7XZviIv+kTrsAin9340XMFcBg299qn6h+cJ6XaeQQ60GRmeq2SPIrUgw6BoqOHQZr6ziDolnKGajiXFgT6yIcgYu31zeqiIbDyTgC+pe0y8mEVulqDBLLGZWk48FwuTAgsvDpvDKbM9XbZCxKLOapRFuaXyA9vm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496620; c=relaxed/simple;
	bh=bsfqfPN0efE5oMzG6hozV47os6pU7EHnyJUpeJQV1CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnYhWurKXa+JEUXla0NUsh8rHBRhH20Z5qToTDLcMH7ajkJl1bFlpOE9KPL98gtyOwshduszxsvtgc0nxOw+3VBMiplafX95ixjOnkbcoTtR0RSpgvE+T2Lh62so8VKeURssk/oZoW/kNYJzcC6bmrpaki84oaIR7PAnUKIdj20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJ75P+8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJ75P+8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A761FC4CED1;
	Fri,  6 Dec 2024 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496620;
	bh=bsfqfPN0efE5oMzG6hozV47os6pU7EHnyJUpeJQV1CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJ75P+8iejS41FFRvmcT/noLw7Y2n1Ehg+ERMW8TnWxQtMeDeFgP2e+UBQqJFAJs5
	 ld8Y3NbTliNyVFiUqb5bkerbUKLwS5Rx9U6wYhJlCNtvEW5aCzKNVNbElI95pP1l8B
	 zfvMOzPMBQdkEb72w+4bMV8/KWVCMfdN0HY3xt7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/676] ext4: avoid remount errors with abort mount option
Date: Fri,  6 Dec 2024 15:27:56 +0100
Message-ID: <20241206143655.587494405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

[ Upstream commit 76486b104168ae59703190566e372badf433314b ]

When we remount filesystem with 'abort' mount option while changing
other mount options as well (as is LTP test doing), we can return error
from the system call after commit d3476f3dad4a ("ext4: don't set
SB_RDONLY after filesystem errors") because the application of mount
option changes detects shutdown filesystem and refuses to do anything.
The behavior of application of other mount options in presence of
'abort' mount option is currently rather arbitary as some mount option
changes are handled before 'abort' and some after it.

Move aborting of the filesystem to the end of remount handling so all
requested changes are properly applied before the filesystem is shutdown
to have a reasonably consistent behavior.

Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
Reported-by: Jan Stancek <jstancek@redhat.com>
Link: https://lore.kernel.org/all/Zvp6L+oFnfASaoHl@t14s
Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Jan Stancek <jstancek@redhat.com>
Link: https://patch.msgid.link/20241004221556.19222-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1d14a38017a7f..c7dc14af6438a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6544,9 +6544,6 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 		goto restore_opts;
 	}
 
-	if (test_opt2(sb, ABORT))
-		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
-
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
 
@@ -6715,6 +6712,14 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 	if (!ext4_has_feature_mmp(sb) || sb_rdonly(sb))
 		ext4_stop_mmpd(sbi);
 
+	/*
+	 * Handle aborting the filesystem as the last thing during remount to
+	 * avoid obsure errors during remount when some option changes fail to
+	 * apply due to shutdown filesystem.
+	 */
+	if (test_opt2(sb, ABORT))
+		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
+
 	return 0;
 
 restore_opts:
-- 
2.43.0



