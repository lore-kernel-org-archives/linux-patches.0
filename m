Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215276;
	b=YldYBpoJNBfTTJQm7Bu4rEopMBVedF6030AhGD81LyCUVPlKMITgWnfiIywZ+r5uU7py
	 wOOrquT0VcIOQZxkDSiGN3cHs/640Ro/7BrGskl0yEza6r8zZUM58SCRTE0+1GCrvPs7B
	 AhrHMvCAT4EY8grfFznTW4ng7WwhvInfG3KuyRje1rZePHbmK4zUGlDs0gwXqYmIH0+vw
	 DvNvAcBJpQ4c9vnmu4HJT5NlJaTwh6JMWRw7FTFK5hqTjq8hcg5EQyNiFxxVNOYAx5DJ3
	 8pHFxQ7ajXt/MecxvrOMHCh0CXhi5Sf84EiHmqRmmnDr//uCnS0b9AtEv3MLtWf/bng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VMnuC5aOZB7zURIfS3+DnzxCwfij+H4RzBGRqhqGqLM=;
	b=u9SVBoosnk9tKjwR552Psa9w1XvX99f7axHzrtiq4V+Fa5A0YIHiRFiyH7qAfJ9q0gCh
	 IlKl6thOjkC+NyhlrHCRkSOj/crFto9RA5I+t5lK/wAHTJyQpiWRMl0JWMf/DJ2S7Rlkn
	 BKC/ToTBSv+29ul/KYtpKG49DGAzh+kh5KVOpSuUMfrKYnfoTKaQRlRKqt2DLcyHFgOCz
	 75ONXIxMftU4A09oCY9mpWYHUZhb53U9BkjAZA9n2LmhzD7A7fA8kGLoPZnn3c4+Vgvs8
	 KewF4EIeOR8yl5AuecToW84JNMihsIShRqzlRfFAIOOWjile4BJvG+bp6dFIhUt6Cnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwJilQQt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA326606A31A;
	Wed, 28 Oct 2026 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwJilQQt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029C31F01825;
	Wed, 28 Oct 2026 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215275;
	bh=VMnuC5aOZB7zURIfS3+DnzxCwfij+H4RzBGRqhqGqLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwJilQQtaYn5EmaFziyTBLcLwJJdxw97y3V0DuZij6mU9VTcY2LQrRYbVjBp4DA62
	 6TiETBkvQSLV+TH96kSJNXBc5uBafokVHxHLGL/JUIjKV3QCuJ1TW8vcbKgza8ZJvC
	 DFWheWmHmT9aP99nhxQC2EdjctlFSnMMbrK/g9cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1154/1887] ksmbd: use opener credentials for delete-on-close
Date: Wed, 28 Oct 2026 17:54:10 +0100
Message-ID: <20261028170525.668535129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 52e2f21911158ec961cd5aae19c56460db382af0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c       | 7 +++++--
 fs/smb/server/vfs_cache.c | 4 ++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index bb5ca68f1701f..992ead0759f7a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1086,13 +1086,15 @@ int ksmbd_vfs_remove_xattr(struct user_namespace *user_ns,
 
 int ksmbd_vfs_unlink(struct file *filp)
 {
+	const struct cred *saved_cred;
 	int err = 0;
 	struct dentry *dir, *dentry = filp->f_path.dentry;
 	struct user_namespace *user_ns = file_mnt_user_ns(filp);
 
+	saved_cred = override_creds(filp->f_cred);
 	err = mnt_want_write(filp->f_path.mnt);
 	if (err)
-		return err;
+		goto out_revert;
 
 	dir = dget_parent(dentry);
 	err = ksmbd_vfs_lock_parent(dir, dentry);
@@ -1112,7 +1114,8 @@ int ksmbd_vfs_unlink(struct file *filp)
 out:
 	dput(dir);
 	mnt_drop_write(filp->f_path.mnt);
-
+out_revert:
+	revert_creds(saved_cred);
 	return err;
 }
 
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index d10cd67d6793c..f59abc34bbfe2 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -283,9 +283,13 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 		write_unlock(&ci->m_lock);
 
 		if (remove_stream_xattr) {
+			const struct cred *saved_cred;
+
+			saved_cred = override_creds(filp->f_cred);
 			err = ksmbd_vfs_remove_xattr(file_mnt_user_ns(filp),
 						     &filp->f_path,
 						     fp->stream.name);
+			revert_creds(saved_cred);
 			if (err)
 				pr_err("remove xattr failed : %s\n",
 				       fp->stream.name);
-- 
2.53.0



