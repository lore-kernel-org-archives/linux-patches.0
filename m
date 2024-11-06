Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10CB1DE4CA;
	Wed,  6 Nov 2024 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897947; cv=none; b=Nnea5zj47+GJCtKobfpE1Toi57djJFupBt6YBl0obPxjt2axHSY/AWQ4x3CZp6vSI0ueeuReH8HNSsx6sOIz5PBIfbrE60Ava1uDNY/9fdw/NxRmuFZwVoBB37YUCtu3csn+kWsLfsFPAUkJPB89Dfq+aKLrZ8ZtbcBGNy8xdEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897947; c=relaxed/simple;
	bh=MGM1I3O6NHlRJRseQs/CNFvxkrnNh+iOqFrb/loFEBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPk9NN43maBYG2hSgx3NVSckDVfeqFodW/4XiZ8Px4XL1AtpdYleIUmgKzxoHTevso3CkrYE9SS67She6GTFUFa/zrwZZLsXcNW3qRn5ST/M+2Md7+eP1uAAF/1QLdNUhLYrkqJonTD0zI7ZW9hAxbMC5crWFUPCyObMS2QDax4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehnntVl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehnntVl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67E0C4CED4;
	Wed,  6 Nov 2024 12:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897946;
	bh=MGM1I3O6NHlRJRseQs/CNFvxkrnNh+iOqFrb/loFEBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehnntVl0wiPfyCzP46h9zqEpznsooOiwKl4yXviVc3b6Q+E3zE7P04pxezYg6J9PG
	 ohqlrUOzcnVPnf4CTIazb79PgICEYbDosp77fdmwlGOfAusbB+0jKC+isq3+iuNVRm
	 5gxcD5sM9PYf2T6iAL5j0eGWo1uKs+OsTcldHnco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Deepa Dinamani <deepa.kernel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/462] mount: warn only once about timestamp range expiration
Date: Wed,  6 Nov 2024 12:58:49 +0100
Message-ID: <20241106120332.412614720@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit a128b054ce029554a4a52fc3abb8c1df8bafcaef ]

Commit f8b92ba67c5d ("mount: Add mount warning for impending timestamp
expiry") introduced a mount warning regarding filesystem timestamp
limits, that is printed upon each writable mount or remount.

This can result in a lot of unnecessary messages in the kernel log in
setups where filesystems are being frequently remounted (or mounted
multiple times).

Avoid this by setting a superblock flag which indicates that the warning
has been emitted at least once for any particular mount, as suggested in
[1].

Link: https://lore.kernel.org/CAHk-=wim6VGnxQmjfK_tDg6fbHYKL4EFkmnTjVr9QnRqjDBAeA@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20220119202934.26495-1-ailiop@suse.com
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 4bcda1eaf184 ("mount: handle OOM on mnt_warn_timestamp_expiry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c     | 2 ++
 include/linux/fs.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5782cd55dfdbb..3d8fbafc980ba 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2492,6 +2492,7 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 	struct super_block *sb = mnt->mnt_sb;
 
 	if (!__mnt_is_readonly(mnt) &&
+	   (!(sb->s_iflags & SB_I_TS_EXPIRY_WARNED)) &&
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
@@ -2506,6 +2507,7 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 			tm.tm_year+1900, (unsigned long long)sb->s_time_max);
 
 		free_page((unsigned long)buf);
+		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
 	}
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b21fdce37c37a..c0967df137152 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1408,6 +1408,7 @@ extern int send_sigurg(struct fown_struct *fown);
 
 #define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
 #define SB_I_PERSB_BDI	0x00000200	/* has a per-sb bdi */
+#define SB_I_TS_EXPIRY_WARNED 0x00000400 /* warned about timestamp range expiry */
 
 /* Possible states of 'frozen' field */
 enum {
-- 
2.43.0



