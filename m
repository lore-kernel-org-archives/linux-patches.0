Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1247020969B;
	Thu, 12 Dec 2024 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018853; cv=none; b=s6Zj0k1PnbtjGxNltOLD74cleRvUZ10Agpm+ObDbCneF4nTWHG53NHGeLX1bwmNIbCe02FLnRCAhH9berEiFWK3vRUZonafy2PC4uGtKElIRCSDnUck1wCBUjBK5HkU9tAmdrtzPN5SV52dv0izgkc98PDLPdC9RSXI/L2WUQ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018853; c=relaxed/simple;
	bh=Mzm67+hgrEN0RU7UbYTgt96KT/rHu3SQoUJ3LeVjS9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmnRb7WnVTGkAH0YtmpuEfa+u3/8jw9y4kKChzRabkrPm9gOYhFnOeCu8un1TvFftiz+UnG+lFhdlBZTPfxkNQzcRY1uK+tfCOyiJpWJ9YgeV3mfgpyU++ZK2RQuYnAaIWEUuTSG2VVQ5AimNNmQmCQqvTI0SUk5SjaYPTIDURs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTg7yx2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTg7yx2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CEDC4CECE;
	Thu, 12 Dec 2024 15:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018852;
	bh=Mzm67+hgrEN0RU7UbYTgt96KT/rHu3SQoUJ3LeVjS9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTg7yx2KAd2fpHuHNJBw+tFA5Xcd+1DN2uYaAyRFcHLm79NOsQ9YFUsCztknahlFq
	 sTJo4JYsvcnNrVD6lHQOccjd98rs4eoEg8il5uMJDiKifakOgk0Wfhf8DTETpFtQnK
	 COoHE/8UG6RXlxlkgtDxMbX0JkiEdX7jVUw9mRVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/772] ext4: avoid remount errors with abort mount option
Date: Thu, 12 Dec 2024 15:49:56 +0100
Message-ID: <20241212144352.057215794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index 6df7735744ac3..54f2ea2a8c9fc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6433,9 +6433,6 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 		goto restore_opts;
 	}
 
-	if (test_opt2(sb, ABORT))
-		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
-
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
 
@@ -6604,6 +6601,14 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
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



