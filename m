Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137D3DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86851C433D2;
	Mon, 15 May 2023 16:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168607;
	bh=p+6hsCOim05Ss+KpqZ3HcYA6pnCbUGaDC4YDrfXKZWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dt9z96GeuH4adyxa7ru44vydBF3Qau3RtJJV8yY8YdgknPZYFMqVuN/QtlL/OJjfx
	 XSY9nk80HgxYe9iu2K+6oYU+tRwXqQv8TMzYGnIX8AUxmujJMa+SNJ+45rrugK0Gh2
	 nsnRZdKaB9ySNiNJidU5MfkqoOqSAExt+BX6Feno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 106/116] ext4: improve error recovery code paths in __ext4_remount()
Date: Mon, 15 May 2023 18:26:43 +0200
Message-Id: <20230515161701.765305256@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

commit 4c0b4818b1f636bc96359f7817a2d8bab6370162 upstream.

If there are failures while changing the mount options in
__ext4_remount(), we need to restore the old mount options.

This commit fixes two problem.  The first is there is a chance that we
will free the old quota file names before a potential failure leading
to a use-after-free.  The second problem addressed in this commit is
if there is a failed read/write to read-only transition, if the quota
has already been suspended, we need to renable quota handling.

Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20230506142419.984260-2-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5390,9 +5390,6 @@ static int ext4_remount(struct super_blo
 		ext4_commit_super(sb, 1);
 
 #ifdef CONFIG_QUOTA
-	/* Release old quota file names */
-	for (i = 0; i < EXT4_MAXQUOTAS; i++)
-		kfree(old_opts.s_qf_names[i]);
 	if (enable_quota) {
 		if (sb_any_quota_suspended(sb))
 			dquot_resume(sb, -1);
@@ -5402,6 +5399,9 @@ static int ext4_remount(struct super_blo
 				goto restore_opts;
 		}
 	}
+	/* Release old quota file names */
+	for (i = 0; i < EXT4_MAXQUOTAS; i++)
+		kfree(old_opts.s_qf_names[i]);
 #endif
 
 	*flags = (*flags & ~MS_LAZYTIME) | (sb->s_flags & MS_LAZYTIME);
@@ -5410,6 +5410,13 @@ static int ext4_remount(struct super_blo
 	return 0;
 
 restore_opts:
+	/*
+	 * If there was a failing r/w to ro transition, we may need to
+	 * re-enable quota
+	 */
+	if ((sb->s_flags & SB_RDONLY) && !(old_sb_flags & SB_RDONLY) &&
+	    sb_any_quota_suspended(sb))
+		dquot_resume(sb, -1);
 	sb->s_flags = old_sb_flags;
 	sbi->s_mount_opt = old_opts.s_mount_opt;
 	sbi->s_mount_opt2 = old_opts.s_mount_opt2;


