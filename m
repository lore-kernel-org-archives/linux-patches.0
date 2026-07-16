Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B43305678;
	Thu, 16 Jul 2026 13:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209543; cv=none; b=oEmgcU0NRjvvijtB7DDZOW5YwTV0gL6hZNe5JXZZY3L6iJwDH04ypumRcq2S33ZC/iVLJF3SG1BPug2pMrD37S2ijfg0TfSkKh1Fx5Z5H1f9wLEu3JAb9Z70+BXhm+02cE2l59OE0Te2YnzhsmiZ2CqJJkeRxoEA+HbSWg8Nznw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209543; c=relaxed/simple;
	bh=/+UzQv0ErmGr9XfIjwAxSQH6vxuGQP/nYeiQMKDv0z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvV+wvdJdJpSYm73vJ1WI3yTWmFprQNTDnD5pV8XRS5IReX2YZ6oDdXqmGC6dpDnp3lxiSOz5zb8moLLvCDbb2oRl5EuX69c2tKsFbzNRTGzlFS6Scv1mKWar6d1RZ0suq0w3ZArQBpizNynupGqxr8lXm3RycLl//hAWj6H6U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MR2qb1F2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MR2qb1F2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96351F000E9;
	Thu, 16 Jul 2026 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209542;
	bh=7spOJZuZs6FYROpG7jpXO2+VEBApx8FR+fDK/MMvpHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MR2qb1F2P8WxvLiYHFZFJmR6yVmAMlNHfFkGcZuN0tiv2mr+KpXHJllwwha6Ish0P
	 kTgG1lijo1rTv59qE+qvnNZKGGSV5/sLGaR5LiDmRbb5d/Hq+xzGvdTmAjfaV60Wqv
	 ZVXX5ICRzTESgdFL5xAq3cOQ0Fg94CUuZKGCMe9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 226/518] ksmbd: use opener credentials for delete-on-close
Date: Thu, 16 Jul 2026 15:28:14 +0200
Message-ID: <20260716133052.764880531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1009,13 +1009,15 @@ int ksmbd_vfs_remove_xattr(struct mnt_id
 
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
 	dentry = start_removing_dentry(dir, dentry);
@@ -1034,7 +1036,8 @@ int ksmbd_vfs_unlink(struct file *filp)
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
@@ -385,10 +385,14 @@ static void __ksmbd_inode_close(struct k
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


