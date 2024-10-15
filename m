Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5971EB9E8;
	Tue, 15 Oct 2024 11:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992393; cv=none; b=gdmfEsOKZYxG5Fi8MCgqIX7MJ02rsov2GnLFqvDmsfzorX/8jHAv6fPneaXSoCEm8pjs8nc1HErZby1377dlAV+eLXFThXQwtopC36Zi/6cjYUN7aKsOZviFTBRfCBKu4a1oA1lqS6ObSkP/8A0NZZGAveiAOj9oEr6FVa30Ndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992393; c=relaxed/simple;
	bh=i6859DlyNSsoLFB1WMR1VuWc/wlKyv1CkrQBdVYwoz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxgLoj7JKo1qfcZg5RnpuEx5tVBin3PGryMDEgZB9lIWkUgfKkdeHooVd1dMLphN9N7SyekxE78M7gxDFRqViUjGzFjgk1qpKlLyR208KviNPptzSdCH7827SNFHCWNW2SrPD7SlbVNPnr/21tYiIyWFlQl5tMEaECEa4JHNiwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcNHdCCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcNHdCCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D22C4CEC6;
	Tue, 15 Oct 2024 11:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992393;
	bh=i6859DlyNSsoLFB1WMR1VuWc/wlKyv1CkrQBdVYwoz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcNHdCCL7GJFJPLH7I+Jv6lF2oh8FahISZ80eTQhK9N1542gAlhRMPuRcQvkaj2x1
	 QQcsVLiKhzm4YCc4sPP9Yy0FE/mqTsl+bLOGtxW5jwn5k1V4MYExU5ThosMRCuK42K
	 4qbEIt8aLUCibOftWzEMYvw13P8cr2ZJ5K7p90zg=
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
Subject: [PATCH 5.15 103/691] mount: warn only once about timestamp range expiration
Date: Tue, 15 Oct 2024 13:20:51 +0200
Message-ID: <20241015112444.449036792@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 932986448a98a..04467a2a7888e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2567,6 +2567,7 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 	struct super_block *sb = mnt->mnt_sb;
 
 	if (!__mnt_is_readonly(mnt) &&
+	   (!(sb->s_iflags & SB_I_TS_EXPIRY_WARNED)) &&
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf = (char *)__get_free_page(GFP_KERNEL);
 		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
@@ -2581,6 +2582,7 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 			tm.tm_year+1900, (unsigned long long)sb->s_time_max);
 
 		free_page((unsigned long)buf);
+		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
 	}
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bf35cf9e312a5..6ff6ade229a07 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1477,6 +1477,7 @@ extern int send_sigurg(struct fown_struct *fown);
 
 #define SB_I_SKIP_SYNC	0x00000100	/* Skip superblock at global sync */
 #define SB_I_PERSB_BDI	0x00000200	/* has a per-sb bdi */
+#define SB_I_TS_EXPIRY_WARNED 0x00000400 /* warned about timestamp range expiry */
 
 /* Possible states of 'frozen' field */
 enum {
-- 
2.43.0



