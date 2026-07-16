Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A900B3148C2;
	Thu, 16 Jul 2026 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210913; cv=none; b=ZEi7Y1pQV8C9lFI6MyGzmNgGEKmQMGyMZgqXNm2pe5rrSPEkXXRqk2YmbFnUrL3NW+aye5cIUfHs1GE+SXiHN0Ajtr4oLqKDjJpmGRLKy/jlhUqmEjZCLRodHJvtNdKTFLeoQOslq7jzWOyP+Yg++K7Xkc54XgWfKH5j7hCAUqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210913; c=relaxed/simple;
	bh=kequi8xMNNzbqop5pv0Dki4V37HanY7q9YtoKAsHXGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTOPsTpkipx+TqZ1eimwRsGsKAeEgGFnz5QL4HQ+vBKFppaZlsUyAdIli/oRhmZ/1ZC+z+kEpdlp7QR20hwHcWqFDd5Gf8MeyYd9vKg2tBoBiLDe1aKqa+zPJtuEaxHb7wULcgQTajsNTS3yuSePrWLNrflatXxW7OlVZwF8tk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRWFFljv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRWFFljv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188091F000E9;
	Thu, 16 Jul 2026 14:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210912;
	bh=KHgQGCi9rqN657kut1bHdf42Y8qKJi7jJVh+ssH8edY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRWFFljv4uj8m7WaBD7MUBUZwosRoVARAKlrQlJjJ/kQV/I0wie4SwozwbX1j0x9P
	 /deqcUhOPAwK4G3oVG0OzsR1XmJQlWlQ++3AsnaUPg3/RGkTn8mTYTKpJocJjKE1si
	 Nmpr+xy8liWQFvBnWV2I1G5gllfzO4pw6mDOQCbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 226/480] ksmbd: use opener credentials for delete-on-close
Date: Thu, 16 Jul 2026 15:29:33 +0200
Message-ID: <20260716133049.702076413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -1078,13 +1078,15 @@ int ksmbd_vfs_remove_xattr(struct mnt_id
 
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
@@ -1104,7 +1106,8 @@ int ksmbd_vfs_unlink(struct file *filp)
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


