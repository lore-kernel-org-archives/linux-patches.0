Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5247513FD86;
	Wed, 19 Feb 2025 09:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956243; cv=none; b=bfg7OyVzHyjPHkoIMvLSCZomE02+V62YVLHvrz/BeyOPyfX+5lhdlBimx+LDW93WP28emmI+MoAL/jRgNyGzbFXQBAYrMcRBu7WZECLsu0mnDIoArwN/iYB7bu+DZ5XJNKGAA91fVRWiwAdPB4os67tgbJaZYn7Rejw3qDG/d/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956243; c=relaxed/simple;
	bh=HPKhV0Kk4TF32VPT2JEDLd9RBAdHucCbd1Hz7dkZKKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5xYFmUcIi5JwT0Hlvpp1gjWaPH7jGvSFYWPuT3m5Mpfe4GWdKS9zayaVQ553XFu/ulXOSunFkPtM7780td3FyDtnvPzBf/Zr+dptJNKw1LNjvnWHbP4KFvoKvAjVYgHkpNu3Y5xaZJyVRoyli2djdYORWF7K+lrZxwvVQDdnuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZS/719fe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZS/719fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A25C4CED1;
	Wed, 19 Feb 2025 09:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956243;
	bh=HPKhV0Kk4TF32VPT2JEDLd9RBAdHucCbd1Hz7dkZKKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZS/719fe1smE7IgU1T7F3CwnyS8yqvuXT6CunF8DcK2fSSBtRfng4615bmx1C5QD9
	 IFmLpHVGL8dwof5RMelxpu8z8GYNn389NJNDxoRr+jVfYAGgb9xTFrLU2E8QhyYwiF
	 wLJYAIKdQwZqb8tQpub7X13bELx7WJvW3YI/Jm/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <david@fromorbit.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Paul Moore <paul@paul-moore.com>,
	syzbot+34b68f850391452207df@syzkaller.appspotmail.com,
	syzbot+360866a59e3c80510a62@syzkaller.appspotmail.com,
	Ubisectech Sirius <bugreport@ubisectech.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/578] landlock: Handle weird files
Date: Wed, 19 Feb 2025 09:21:26 +0100
Message-ID: <20250219082656.187882113@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 49440290a0935f428a1e43a5ac8dc275a647ff80 ]

A corrupted filesystem (e.g. bcachefs) might return weird files.
Instead of throwing a warning and allowing access to such file, treat
them as regular files.

Cc: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Paul Moore <paul@paul-moore.com>
Reported-by: syzbot+34b68f850391452207df@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/000000000000a65b35061cffca61@google.com
Reported-by: syzbot+360866a59e3c80510a62@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/67379b3f.050a0220.85a0.0001.GAE@google.com
Reported-by: Ubisectech Sirius <bugreport@ubisectech.com>
Closes: https://lore.kernel.org/r/c426821d-8380-46c4-a494-7008bbd7dd13.bugreport@ubisectech.com
Fixes: cb2c7d1a1776 ("landlock: Support filesystem access-control")
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20250110153918.241810-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/fs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 7b0e5976113c2..7b95afcc6b437 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -669,10 +669,6 @@ static inline access_mask_t get_mode_access(const umode_t mode)
 	switch (mode & S_IFMT) {
 	case S_IFLNK:
 		return LANDLOCK_ACCESS_FS_MAKE_SYM;
-	case 0:
-		/* A zero mode translates to S_IFREG. */
-	case S_IFREG:
-		return LANDLOCK_ACCESS_FS_MAKE_REG;
 	case S_IFDIR:
 		return LANDLOCK_ACCESS_FS_MAKE_DIR;
 	case S_IFCHR:
@@ -683,9 +679,12 @@ static inline access_mask_t get_mode_access(const umode_t mode)
 		return LANDLOCK_ACCESS_FS_MAKE_FIFO;
 	case S_IFSOCK:
 		return LANDLOCK_ACCESS_FS_MAKE_SOCK;
+	case S_IFREG:
+	case 0:
+		/* A zero mode translates to S_IFREG. */
 	default:
-		WARN_ON_ONCE(1);
-		return 0;
+		/* Treats weird files as regular files. */
+		return LANDLOCK_ACCESS_FS_MAKE_REG;
 	}
 }
 
-- 
2.39.5



