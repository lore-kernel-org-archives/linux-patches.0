Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35671352016;
	Wed, 20 May 2026 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295504; cv=none; b=owjrHxqmu8fWXWUvTOk80nxmODPuJpfY/iym1UyMHtinmqBwjS7LuxINclW3Gv9ylYT87+sDZbO1cC/0lksplXIResC6OBg2HmGB9pn+gzWsCgp4+SYGUD8RHtp79KHUlPQG7tzkt+OrQKe6QO2KFPbypF5O4T9C+oLpjSaoVXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295504; c=relaxed/simple;
	bh=1gcqyFoQYOTt0Er6zuMajpL/ZsM5MqnAPitMMB35gHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKRGsBgJ7POiG13XzD2Xyg5XAtNBlzLlWv6Hyzc0vkaymKVGhxJACaPSZ8oKTF3Izy/x4p1/scFe0AkpXMmjArFbFa3fZ/HusdT6GV3k5BKUSdPHPB5hdWfVkC5ekybyjqd5Cb8e6Uhth/C2Jyk8wQUhZ4NpE8/r93hTqZYe3iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhTErNmp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhTErNmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C209F1F00893;
	Wed, 20 May 2026 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295503;
	bh=FF+nKnUpaxJ1I9G/2G1jjJmj186VKeGVwGDWZVYj4Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhTErNmpd9m+sUHsO7+8Q9aPWlV23UuFpKxrDHS+awObhdboUJKtxc2SDB1CGKDsi
	 pZjxiIUKZnQBp7abbLTSSb4+Sz+FrBos1szZQI1GAMuIIG/mlKikvZp19052p+qu86
	 yqzoR8F+40+yHqo3gqhhbPpSU1kljZlV0MYapZaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0445/1146] fanotify: call fanotify_events_supported() before path_permission() and security_path_notify()
Date: Wed, 20 May 2026 18:11:35 +0200
Message-ID: <20260520162158.270129836@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 66052a768d4726a31e939b5ac902f2b0b452c8d5 ]

The latter trigger LSM (e.g. SELinux) checks, which will log a denial
when permission is denied, so it's better to do them after validity
checks to avoid logging a denial when the operation would fail anyway.

Fixes: 0b3b094ac9a7 ("fanotify: Disallow permission events for proc filesystem")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20260216150625.793013-3-omosnace@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 5d030fbb2dffe..ae904451dfc09 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1210,6 +1210,7 @@ static int fanotify_find_path(int dfd, const char __user *filename,
 
 		*path = fd_file(f)->f_path;
 		path_get(path);
+		ret = 0;
 	} else {
 		unsigned int lookup_flags = 0;
 
@@ -1219,22 +1220,7 @@ static int fanotify_find_path(int dfd, const char __user *filename,
 			lookup_flags |= LOOKUP_DIRECTORY;
 
 		ret = user_path_at(dfd, filename, lookup_flags, path);
-		if (ret)
-			goto out;
 	}
-
-	/* you can only watch an inode if you have read permissions on it */
-	ret = path_permission(path, MAY_READ);
-	if (ret) {
-		path_put(path);
-		goto out;
-	}
-
-	ret = security_path_notify(path, mask, obj_type);
-	if (ret)
-		path_put(path);
-
-out:
 	return ret;
 }
 
@@ -2058,6 +2044,15 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 			goto path_put_and_out;
 	}
 
+	/* you can only watch an inode if you have read permissions on it */
+	ret = path_permission(&path, MAY_READ);
+	if (ret)
+		goto path_put_and_out;
+
+	ret = security_path_notify(&path, mask, obj_type);
+	if (ret)
+		goto path_put_and_out;
+
 	if (fid_mode) {
 		ret = fanotify_test_fsid(path.dentry, flags, &__fsid);
 		if (ret)
-- 
2.53.0



