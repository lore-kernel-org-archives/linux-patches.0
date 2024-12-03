Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729EE1F4276;
	Tue,  3 Dec 2024 15:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240082; cv=none; b=lIbP7IDACrTciuXkcCJ7k6g7SiCJIN6RgzTR1ESmezCMmuyKu5MKUzxpBA8+7/VNz3YJQImTqII47U6swQeylVvhzbdJf3x8Hy0su8Sy+r40pUK4twQKtZoRocJStZcCuALKeortcJeuCeInG8aZTo3oJXipDzqZC+5u9yw5JlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240082; c=relaxed/simple;
	bh=YOBZBYJDlnNRIdaWm/92MQDR9Ta648h3poi3nWrtKRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U75dakAvom7l+oIXaVNNZ/pQJ3Zet6WKkhE5GHNOVDHOkAB2OXkUOo2X779uJ07PkOKurVEGIg0t1QWs/r8JWjwv9Y4Apg/s5tQHUm0HLiGQmtKygxLzHfHauAEpJol2Xwi38w8pO1rRreLuNsNY9TfkefGYydA2Bkbe7lo+2Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bs0moJHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bs0moJHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E983DC4CECF;
	Tue,  3 Dec 2024 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240082;
	bh=YOBZBYJDlnNRIdaWm/92MQDR9Ta648h3poi3nWrtKRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bs0moJHH7Icj1rma4bBhtEu5oUZGCX1mN4q+auseGFD3z+cSRDAWWLddU2/6BiR/I
	 gdZhGUKMRvOnG9TBRTlY3C88hurmOXO/NoC0iiIVuydxxdDtuH5tsdvVMPmJJVfOCO
	 sOw/WfRtJ+bjJp/EfveYT03ToQoajxBhhoJ+dJFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/826] ext4: avoid remount errors with abort mount option
Date: Tue,  3 Dec 2024 15:35:44 +0100
Message-ID: <20241203144744.128025404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 16a4ce704460e..4645f16296732 100644
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



