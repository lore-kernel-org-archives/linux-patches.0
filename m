Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB27B6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7648DC340EC;
	Tue, 22 Mar 2022 21:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985163;
	bh=CSiPFmisQO0zSb6xFEMkzK913NpWiS9pxubMf+egv5w=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=01IZSxORs2gMHaLw8epFkj1j/leSGM7AwrVZfSJIe80qajj+0BOTCe9w3PD0q8dwR
	 RvVKDLcN3tuJyzmmp1NSX1OU5Ozsvfo6YBLKeXViPRqxPsZvEQNKJHXuvD5d4bz0W2
	 qXGa9nAsOyNFjffUl21ysZg8KOsVA1HrkdErFKVc=
Date: Tue, 22 Mar 2022 14:39:22 -0700
To: viro@zeniv.linux.org.uk,hch@lst.de,djwong@kernel.org,deepa.kernel@gmail.com,christian.brauner@ubuntu.com,ailiop@suse.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 017/227] mount: warn only once about timestamp range expiration
Message-Id: <20220322213923.7648DC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Anthony Iliopoulos <ailiop@suse.com>
Subject: mount: warn only once about timestamp range expiration

Commit f8b92ba67c5d ("mount: Add mount warning for impending timestamp
expiry") introduced a mount warning regarding filesystem timestamp limits,
that is printed upon each writable mount or remount.

This can result in a lot of unnecessary messages in the kernel log in
setups where filesystems are being frequently remounted (or mounted
multiple times).

Avoid this by setting a superblock flag which indicates that the warning
has been emitted at least once for any particular mount, as suggested in
[1].

[1] https://lore.kernel.org/CAHk-=wim6VGnxQmjfK_tDg6fbHYKL4EFkmnTjVr9QnRqjDBAeA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20220119202934.26495-1-ailiop@suse.com
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c     |    2 ++
 include/linux/fs.h |    1 +
 2 files changed, 3 insertions(+)

--- a/fs/namespace.c~mount-warn-only-once-about-timestamp-range-expiration
+++ a/fs/namespace.c
@@ -2597,6 +2597,7 @@ static void mnt_warn_timestamp_expiry(st
 	struct super_block *sb = mnt->mnt_sb;
 
 	if (!__mnt_is_readonly(mnt) &&
+	   (!(sb->s_iflags & SB_I_TS_EXPIRY_WARNED)) &&
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
@@ -2611,6 +2612,7 @@ static void mnt_warn_timestamp_expiry(st
 			tm.tm_year+1900, (unsigned long long)sb->s_time_max);
 
 		free_page((unsigned long)buf);
+		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
 	}
 }
 
--- a/include/linux/fs.h~mount-warn-only-once-about-timestamp-range-expiration
+++ a/include/linux/fs.h
@@ -1440,6 +1440,7 @@ extern int send_sigurg(struct fown_struc
 
 #define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
 #define SB_I_PERSB_BDI	0x00000200	/* has a per-sb bdi */
+#define SB_I_TS_EXPIRY_WARNED 0x00000400 /* warned about timestamp range expiry */
 
 /* Possible states of 'frozen' field */
 enum {
_
