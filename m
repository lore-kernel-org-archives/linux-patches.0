Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9558C1CFECF;
	Wed,  2 Oct 2024 13:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877262; cv=none; b=ZkpC7csMRw4i4EpVLwclR3ZD2fgkig18/8Fp7Y0C7ZjoyD4KzVZkXMOevdtYwAPqlpt7hsO1DoVpyk/ERYeqNEvlM3tE9UHqWErLscOrRKVikYG7gZ+71B2xiBf9wcGosKJ0FXl+G25yrHF+XkdtpSGwro6LQoq07mH/6ckJYVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877262; c=relaxed/simple;
	bh=3on5HHU7qOcfEs+MCp2ov+1iyztjd4+Y6nt2EhjRrN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkeGiE49p/p/8uEEHEooxpFci0cdELeWgB6HMB1nUb6IacVd5Ijus0A0HfYsC8CBI8j3cTRiBAwgjJgDXF8nuq+JWIFpPm4JKTKRUssnZi8mwAlTqbdmRfxxmWmgsLa2kINS3Tg5pRWK9j2Kh0fw3znQJ94EeagG1XwhfL/RamI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhqnV7p1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhqnV7p1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A10FC4CEED;
	Wed,  2 Oct 2024 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877262;
	bh=3on5HHU7qOcfEs+MCp2ov+1iyztjd4+Y6nt2EhjRrN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhqnV7p1PbEZdYeGahTHznAmpNNbV5TwEBnu8OV0w9WfinDiUsLaWQg9EP60SaI4J
	 gymKcCwqWefqnEpUR9POtX2ttWmByqVOYNvSly45bO2Jg8/znSwunQT6M6l4O1t5Xf
	 W8bKgHFG+alWvDCvm5/leVrqeJSjGGecpRCSj5Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Hering <olaf@aepfle.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 023/634] mount: handle OOM on mnt_warn_timestamp_expiry
Date: Wed,  2 Oct 2024 14:52:03 +0200
Message-ID: <20241002125812.011225839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <olaf@aepfle.de>

[ Upstream commit 4bcda1eaf184e308f07f9c61d3a535f9ce477ce8 ]

If no page could be allocated, an error pointer was used as format
string in pr_warn.

Rearrange the code to return early in case of OOM. Also add a check
for the return value of d_path.

Fixes: f8b92ba67c5d ("mount: Add mount warning for impending timestamp expiry")
Signed-off-by: Olaf Hering <olaf@aepfle.de>
Link: https://lore.kernel.org/r/20240730085856.32385-1-olaf@aepfle.de
[brauner: rewrite commit and commit message]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e1ced589d8357..a6675c2a23839 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2801,8 +2801,15 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 	if (!__mnt_is_readonly(mnt) &&
 	   (!(sb->s_iflags & SB_I_TS_EXPIRY_WARNED)) &&
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
-		char *buf = (char *)__get_free_page(GFP_KERNEL);
-		char *mntpath = buf ? d_path(mountpoint, buf, PAGE_SIZE) : ERR_PTR(-ENOMEM);
+		char *buf, *mntpath;
+
+		buf = (char *)__get_free_page(GFP_KERNEL);
+		if (buf)
+			mntpath = d_path(mountpoint, buf, PAGE_SIZE);
+		else
+			mntpath = ERR_PTR(-ENOMEM);
+		if (IS_ERR(mntpath))
+			mntpath = "(unknown)";
 
 		pr_warn("%s filesystem being %s at %s supports timestamps until %ptTd (0x%llx)\n",
 			sb->s_type->name,
@@ -2810,8 +2817,9 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
 			mntpath, &sb->s_time_max,
 			(unsigned long long)sb->s_time_max);
 
-		free_page((unsigned long)buf);
 		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
+		if (buf)
+			free_page((unsigned long)buf);
 	}
 }
 
-- 
2.43.0



