Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B807B2D879E;
	Wed, 20 May 2026 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298263; cv=none; b=ANBgZiY3ipXMaEmlsJV7M41uCDIVBDRGTx4Edw+ZR9Rd+MPYPUln1zkW6azq1wZtd62tV4NryhjxXsnom+29LdM0pD2sS0PhdJz0npsk+hsLW++NhpfaEUUHOjklpGJ6aopmLZxCunsj2SE6qX+1OtddkhTXoiWpUL8+krTdcxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298263; c=relaxed/simple;
	bh=qTcdzUpvKy58cbVVlb56VM8vqqxdXgx+zEmXuddj2lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQ8U8jYmMqb5bvGeAwYdPr/a56V5sbzldwp6Z5nSu4gWIZWUld8IP9YtyeeL1VISwB/ArUJBDHLx/iKdtHG55ekJNJCWhlPpFVtcuNV93clJ56dk2o4Eoa4egWmf6rbqMKH9911qrpSAj4pvyBjL2y0vudN6hsSv1GEDsJL0A44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1TfcWce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1TfcWce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EF51F000E9;
	Wed, 20 May 2026 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298262;
	bh=hgQeIrVNruSydDJe0C5JYijtcekYB3S3REEgNNA9KGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h1TfcWcekQe2ABu6f25Of64kNr2Dr7xDCQByRL7wT0COTAETVNP99zvunWkwhUgZy
	 JBL7hLpCeVNBXp2KVUAWJ/6Ddq4ffB/J2MotM7FrjT2ZMnuiG0hMK1HKWpY1cp9mh5
	 szgkF6jzuzSPh0AGc+Srw+iYkKBVDSJRxauY7WtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/957] fanotify: call fanotify_events_supported() before path_permission() and security_path_notify()
Date: Wed, 20 May 2026 18:13:46 +0200
Message-ID: <20260520162141.970617700@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1c05c11e3cb25..5c30f4d8c7c16 100644
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
 
@@ -2074,6 +2060,15 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
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



