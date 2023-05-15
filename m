Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEA9FBFE
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D95C433EF;
	Mon, 15 May 2023 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170730;
	bh=gQq2xVRv8/8GryM5IcFKqgvF5LV4B+izOJUSd2yOJ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w//+3ZMA2U42hiaE5o78bKzVgipcmKC7S2OPiU58VE+VI7dxAj2WZXxglfLn1UjlB
	 DFTalMs+IQW47VNCqNWHIZHZUhBIQqCfsYUJr7M99vbcdciBJZuNZ7L5JpEPkvjQth
	 oRyrWOUT1SXFSwfCCS3TPk6EHcOqp+Dvv7XS46yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 224/239] ext4: improve error recovery code paths in __ext4_remount()
Date: Mon, 15 May 2023 18:28:07 +0200
Message-Id: <20230515161728.439765291@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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
@@ -6566,9 +6566,6 @@ static int __ext4_remount(struct fs_cont
 	}
 
 #ifdef CONFIG_QUOTA
-	/* Release old quota file names */
-	for (i = 0; i < EXT4_MAXQUOTAS; i++)
-		kfree(old_opts.s_qf_names[i]);
 	if (enable_quota) {
 		if (sb_any_quota_suspended(sb))
 			dquot_resume(sb, -1);
@@ -6578,6 +6575,9 @@ static int __ext4_remount(struct fs_cont
 				goto restore_opts;
 		}
 	}
+	/* Release old quota file names */
+	for (i = 0; i < EXT4_MAXQUOTAS; i++)
+		kfree(old_opts.s_qf_names[i]);
 #endif
 	if (!test_opt(sb, BLOCK_VALIDITY) && sbi->s_system_blks)
 		ext4_release_system_zone(sb);
@@ -6588,6 +6588,13 @@ static int __ext4_remount(struct fs_cont
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


