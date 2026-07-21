Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF42DA76C;
	Tue, 21 Jul 2026 20:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665133; cv=none; b=uH6cyJ6I0axeKfWUwZO+JRnLAhO5OZBK69z/7t1oB06kDJacILffHeooMU0aysLfLhZHrGYb+XXOVvCO2o40pJ8fyUU90RwAoWGeZmrIfGvhe+nj7+Ytyw0BiQ1H/PtELpnVDMALhzEkQFxY7OSR0Rn5DqeWMS4qO14CCaYo9T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665133; c=relaxed/simple;
	bh=ROWvxR/zGvGmAyufotiR7A+dloNF0+ZsgpmEK65qKho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN29S6CdKy3mh5Xftmq/SfVv+yLypz5himB1KknlC4q56DZxoODcGc+8ZjY+95jjgUe2bEyt4yVv29Vq5XKSZqkXGNcmNIIOLopw/+ONpaYueSIkjv72NjHEyntKoEZA5daHO4lsvSnb+MQIpSMStfZL2DRyekES/sKJfqVP9XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0U47ZZnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0U47ZZnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3076B1F000E9;
	Tue, 21 Jul 2026 20:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665132;
	bh=4Ahwb6Og88vWVRWoky5DHo/Hid25Ckrv1moxYNdHOXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0U47ZZnvfjx+k/ZRWNlKE+luhuMi3XCmEjXXny6ReapfJsQbQ9CJ9IG+ubcaCK09d
	 4TbejkSlsO2HUPndFsFTNPh6LPI9YGCUCIu3FNa0EOVZkRNVSeCVOATlbd9g1OepuB
	 0YxyqL4GypJhvHlDK8jucGJ228VlKgBT8jumihok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0190/1266] ksmbd: use opener credentials for delete-on-close
Date: Tue, 21 Jul 2026 17:10:27 +0200
Message-ID: <20260721152446.056211583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 52e2f21911158ec961cd5aae19c56460db382af0 upstream.

Delete-on-close can be completed by deferred or durable handle teardown,
where no request work is available. Both the base-file unlink and the ADS
xattr removal consequently run with the ksmbd worker credentials and can
bypass filesystem permission checks.

Run both operations with the credentials captured in struct file when the
handle was opened. This preserves the authenticated user's fsuid, fsgid,
supplementary groups and capability restrictions at final close.

Cc: stable@vger.kernel.org
Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c       |    7 +++++--
 fs/smb/server/vfs_cache.c |    4 ++++
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1084,13 +1084,15 @@ int ksmbd_vfs_remove_xattr(struct mnt_id
 
 int ksmbd_vfs_unlink(struct file *filp)
 {
+	const struct cred *saved_cred;
 	int err = 0;
 	struct dentry *dir, *dentry = filp->f_path.dentry;
 	struct mnt_idmap *idmap = file_mnt_idmap(filp);
 
+	saved_cred = override_creds(filp->f_cred);
 	err = mnt_want_write(filp->f_path.mnt);
 	if (err)
-		return err;
+		goto out_revert;
 
 	dir = dget_parent(dentry);
 	err = ksmbd_vfs_lock_parent(dir, dentry);
@@ -1110,7 +1112,8 @@ int ksmbd_vfs_unlink(struct file *filp)
 out:
 	dput(dir);
 	mnt_drop_write(filp->f_path.mnt);
-
+out_revert:
+	revert_creds(saved_cred);
 	return err;
 }
 
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -292,10 +292,14 @@ static void __ksmbd_inode_close(struct k
 		up_write(&ci->m_lock);
 
 		if (remove_stream_xattr) {
+			const struct cred *saved_cred;
+
+			saved_cred = override_creds(filp->f_cred);
 			err = ksmbd_vfs_remove_xattr(file_mnt_idmap(filp),
 						     &filp->f_path,
 						     fp->stream.name,
 						     true);
+			revert_creds(saved_cred);
 			if (err)
 				pr_err("remove xattr failed : %s\n",
 				       fp->stream.name);


