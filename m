Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F117233D98;
	Mon, 10 Mar 2025 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628763; cv=none; b=swWfz7FcMSOffztLSncKdmnLYmobmf7SdpMrPlUmFfAAFT7ZsuEsrhaaSDuWzM9FoBSTWYbZIVHhVPXDhs0yeOGM8p43wvaLXyJrqqNqEmr+Z73a3yFeM61jzarLnN+Pz7XI6fT0euVH8+MFQT5EQS4RdU7GNHvOPCZPJkVO7EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628763; c=relaxed/simple;
	bh=uTkmPZsxYeHXt3H66JV35zUMhXrRNKL5qSSWpKzWVWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CZCadotdtiZr3cwjIvaajvu+Z57lRvQq59+HHxrZiyYqSPRm6v7C90bqOEaZvML46ZFtuoYKcSVFMUfP08dLE25PoCbuCKi32M23vs3Li4Q025JfU3vrxQ+QoX0qXwThLq6834bEVSHamo8HIOFd8aU2764pfRqa/1tpbUZAJc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0raCQgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0raCQgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ED1C4CEE5;
	Mon, 10 Mar 2025 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628763;
	bh=uTkmPZsxYeHXt3H66JV35zUMhXrRNKL5qSSWpKzWVWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0raCQgCva6ZRDF60+BAOxD1QhDZFht+jVg9/jmwb7imN3HfpfxeHhCSGn75yKbM8
	 ujkEL5i6drCfnlIUkCGgZVEJHBLazWxEkVbrjMTd/I7t1v8/PZWiUWoVEvv0/NqEfb
	 IMJ4WdTahXZ6I08uLwzklVMliOXV7iZ+83D5ocB4=
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
Subject: [PATCH 5.15 061/620] landlock: Handle weird files
Date: Mon, 10 Mar 2025 17:58:27 +0100
Message-ID: <20250310170547.993917891@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7b7860039a08b..a3d99bba5f1e7 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -370,10 +370,6 @@ static inline access_mask_t get_mode_access(const umode_t mode)
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
@@ -384,9 +380,12 @@ static inline access_mask_t get_mode_access(const umode_t mode)
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



