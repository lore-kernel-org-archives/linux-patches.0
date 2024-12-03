Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC5213B5B6;
	Tue,  3 Dec 2024 14:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237762; cv=none; b=gAFEt39UWDCXOBvBEwcH5985zRVJc4ddfAqbFi6fVT0ye+LMmCbmwovRy32IWKV4LVKayC0IRO7+MzsBgccGDD3SFkaD+uMwjWN5YIJpUpP6QAslzw25nOMqeowvMyKI8hyzWXdW/42POWCDe0+LZE6x/Dz91dK7kdwcavEVJVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237762; c=relaxed/simple;
	bh=aHvCJv7hmX7tWn4G3Gv0IkuRmmAcl39+Juuy/sZoqvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZXY0Y0RAlzBYIIATt7kao9ScSx5flZqFBkAUaOC4Wt97RBBdDPQFUx2RVv969lKZmnZAN9BL6XovBdS7i+c2OuGGa0AqzSpIes5qT5Hmu5jb9qUa5SmIMFyc8vumuy6G9PH+3aszzLJcAd2ksqUaQM+Q7mYlUERrXAx3JVELK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvxcGOH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvxcGOH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0352DC4CECF;
	Tue,  3 Dec 2024 14:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237762;
	bh=aHvCJv7hmX7tWn4G3Gv0IkuRmmAcl39+Juuy/sZoqvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvxcGOH54uG8uL/fqwm16yQpcB5gFwHMgjt/qNz/GIlyh+a6mFBEMOt7IAOhDBCCT
	 nzK2Zjkla4eJ6oB8ivZOr0XG4hVGjYb3SaTvm7gh8bR3WhBpMRPn07OgXeWia3aVI3
	 KzxPBdNj27bbwGlvN7zGXaCmoa+nP5JOcDvR6+bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 062/817] ext4: avoid remount errors with abort mount option
Date: Tue,  3 Dec 2024 15:33:54 +0100
Message-ID: <20241203143958.105530590@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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
index cd3328b031534..42b1acac88e78 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6518,9 +6518,6 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 		goto restore_opts;
 	}
 
-	if (test_opt2(sb, ABORT))
-		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
-
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
 
@@ -6689,6 +6686,14 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
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



