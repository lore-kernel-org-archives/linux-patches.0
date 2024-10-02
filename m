Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FE41974F4;
	Wed,  2 Oct 2024 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879142; cv=none; b=COhsnbmLWn8Gid47gOM+/iadfm4kKtA7QNWEfWhTrw0XGk2f2Khm8gtMG4gsvuCG3g6XqNOYvukxVHw2gl5cvWAor0cjgi9neQYz/1Fw/3yjiPYpzse+xyH48V0ZEHqdpEJH3oa/P6lVncmISXq28zZg7qs48RFAoZ3cNba71Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879142; c=relaxed/simple;
	bh=7FKeW/rhC3UUV2Qjn93iLvCjZhu0Hzuz+KdowheLKjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJIOQJqJk4Z4zDTBbg5DGUvP7eztM/8BiHwpFdANqDGfV1JMeVFkyj88Hw5Y7KkpeAyFh1F+igEsUhK2u9ULaLbDq6nHiBuI73MiLpdOF3DgFxXOuEhogEMwfC9rDheMl8hyIT9KRDHBwLOBh+qbtJvLZ6gZuNsRVSIpkQFmoIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+XUHJrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+XUHJrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D29C4CEC2;
	Wed,  2 Oct 2024 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879142;
	bh=7FKeW/rhC3UUV2Qjn93iLvCjZhu0Hzuz+KdowheLKjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+XUHJrQeZ1DjUrl0Z0OjW88U06NqOH3gHMw8JEbFjle+iIRd9GjNXAu0p14qeCOO
	 anE5g9QLqxWzGKaCdUXWM4Og0+J+aOcNx5bhiLb8MTVDlD/DmoEUUxWndAFCkgCicN
	 XHP85MbNys8UmBEMUEGvyE62gV8tZnaJBrhVt7JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Hering <olaf@aepfle.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/538] mount: handle OOM on mnt_warn_timestamp_expiry
Date: Wed,  2 Oct 2024 14:54:17 +0200
Message-ID: <20241002125752.724885100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e6c61d4997ccf..b4385e2413d59 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2796,8 +2796,15 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
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
@@ -2805,8 +2812,9 @@ static void mnt_warn_timestamp_expiry(struct path *mountpoint, struct vfsmount *
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



