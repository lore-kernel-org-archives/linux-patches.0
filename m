Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342C31C07C8;
	Tue, 15 Oct 2024 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997160; cv=none; b=ZYmA2X4APgmfhbIfN6muA/LIAT29q0lnJmxUAWJyKbFPsaaJDK5joTHDIeUB5NsDbuhgIBvSrCjvUS6oJfxg0lK78V0ZkiBg/BuZK0Jz3IYeXqZVL9V2TRI+uV08pvqndd5vaI6vMntFN+7vEFq5uqX8MOm08mh1GHsZhMrSN2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997160; c=relaxed/simple;
	bh=oJ0dLRDS3Wwx9DRLk1jT5nMI7RyjmjA4IQHFiE1nuEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtHPQzKBe0eOiKboUiNKJ5IWwHecoM2CG+DyC36xFJBkH2N8SwCNKZy3dLNAfUvcalMbp6aSSdJOPEal0csAyrXHAghjlBvWTFHEVrxggR1YdHchZ7kZ3JdE2a7E0XyoNMsZl86iFvr867LHsJ9EB78Z3xPWNrCo6/AzXTzyouQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQZGoMsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQZGoMsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B047EC4CEC6;
	Tue, 15 Oct 2024 12:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997160;
	bh=oJ0dLRDS3Wwx9DRLk1jT5nMI7RyjmjA4IQHFiE1nuEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQZGoMsmU0BQYkXI++aOOyzxumlaVyn57wRfmzEnwEf9/rRyay8edlyCojWNMiQtF
	 J5PAKY3WGRUFGKrrN4eTAbZ3Ex0DWBwRAHBrW1X20jKLiSqpqIDFqRYuFlB9YmLhbI
	 c3UAalcXTnk9qlYByAdQy7p8c8hCFsYCxM26Mgd8=
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
Subject: [PATCH 5.10 062/518] mount: warn only once about timestamp range expiration
Date: Tue, 15 Oct 2024 14:39:26 +0200
Message-ID: <20241015123919.401418010@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b020a12c53a2a..1665315e08e9a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2553,6 +2553,7 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 	struct super_block *sb = mnt->mnt_sb;
 
 	if (!__mnt_is_readonly(mnt) &&
+	   (!(sb->s_iflags & SB_I_TS_EXPIRY_WARNED)) &&
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
@@ -2567,6 +2568,7 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 			tm.tm_year+1900, (unsigned long long)sb->s_time_max);
 
 		free_page((unsigned long)buf);
+		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
 	}
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e92acc55fbd1d..a7d839b196069 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1428,6 +1428,7 @@ extern int send_sigurg(struct fown_struct *fown);
 
 #define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
 #define SB_I_PERSB_BDI	0x00000200	/* has a per-sb bdi */
+#define SB_I_TS_EXPIRY_WARNED 0x00000400 /* warned about timestamp range expiry */
 
 /* Possible states of 'frozen' field */
 enum {
-- 
2.43.0



