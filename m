Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215273;
	b=HfTrDcNJ2OhBziMyUFW6zMwa5YL8uiXN7Vf/uYUqvXjuxHCKGbCfVeqXlgOXivJ5S4Wb
	 neaG1IYzu7+Xa0hKUtdslmXRR2zvjmrQAnuSQrIH4KFKBkOQ2sBcYr4eoTQ7yVTxA3ssI
	 wGAPlVlER5jl1V8CYRLZrDfeTeU5D/Qk0TDM8GY/pQ27LJyyDQuVXqkkb/b+hScZ71iTN
	 1G2RJvbvEiM+y7vtYAg5XP5wPI45R6qeXusIMXZEdlTYRpexKfH/t5hOu1RTlqupEotJ9
	 KtQ+2YAZk1Qk6+C35M9EZjEBzB0oy602WOFqNBNZ3naaSMnwf6uhj7uuHN7L80dD87A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XFl3zsGrWTd31ATM0WtHBHweZGs2UZxATx7qRL5hc8I=;
	b=idMmtHja71sw36pi3iHkFJti1ZspfPpazBoIm6ijUw/CmpeS4N+fY5d4UVVrpcOupoeD
	 tbcpRwQLogzOpIjnHgVSeRg/llq7eHy71vohXPtE56qYgAlv/Uifk/7XdTNJqnZGVyMEe
	 xETjg/NSxc4lmlKezyoChLnd+ilQctUT89DdOnzzT9qj6Kl25hEImyyR5TJ9kZb/ZC703
	 VHb3iJ31pbZArER+UozPY0NXZG9DokD4x4YotZpPd/M3/jPEywfSvplDud4p0ugD1cH9R
	 6ekXh9rPemIwa1rKlPk0r88Rew3N0xcELiUGG0aT7KKW45c8pwZbcPvW/c4RiNZqdzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQ7Ub0bq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB362606A31F;
	Wed, 28 Oct 2026 19:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQ7Ub0bq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D4C1F01828;
	Wed, 28 Oct 2026 19:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215272;
	bh=XFl3zsGrWTd31ATM0WtHBHweZGs2UZxATx7qRL5hc8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQ7Ub0bqOAGWLP0qUwICUnHFnqG/ZdKACj3lbBj8z9Jwjb2gwyj/mUfjCScw8ICdN
	 a+qee+oyFQl35WTx8z3vs5/JM8t87X32AdYBxHfjN2budW58BGLpDXuV0pWjNmEd1s
	 pQoFeOvUCkdlccYRx1+UmEHY6Lzi4UU+BoCn841I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1153/1887] ksmbd: use opener credentials for ADS I/O
Date: Wed, 28 Oct 2026 17:54:09 +0100
Message-ID: <20261028170525.644186265@linuxfoundation.org>
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

[ Upstream commit baa5e094886fffa7e6272edcb5e08be5ce28262c ]

Alternate data streams are stored as xattrs. Unlike regular file I/O,
their read and write paths therefore call VFS xattr helpers which recheck
inode permissions and LSM policy using the current task credentials.

Run ADS I/O with the credentials captured when the SMB handle was opened.

Cc: stable@vger.kernel.org
Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 1da397999941a..bb5ca68f1701f 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -285,17 +285,20 @@ static ssize_t ksmbd_vfs_getcasexattr(struct user_namespace *user_ns,
 static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				 size_t count)
 {
+	const struct cred *saved_cred;
 	ssize_t v_len;
 	char *stream_buf = NULL;
 
 	ksmbd_debug(VFS, "read stream data pos : %llu, count : %zd\n",
 		    *pos, count);
 
+	saved_cred = override_creds(fp->filp->f_cred);
 	v_len = ksmbd_vfs_getcasexattr(file_mnt_user_ns(fp->filp),
 				       fp->filp->f_path.dentry,
 				       fp->stream.name,
 				       fp->stream.size,
 				       &stream_buf);
+	revert_creds(saved_cred);
 	if ((int)v_len <= 0)
 		return (int)v_len;
 
@@ -414,6 +417,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				  size_t count)
 {
+	const struct cred *saved_cred;
 	char *stream_buf = NULL, *wbuf;
 	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
 	size_t size;
@@ -434,6 +438,7 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 		count = XATTR_SIZE_MAX - *pos;
 	}
 
+	saved_cred = override_creds(fp->filp->f_cred);
 	v_len = ksmbd_vfs_getcasexattr(user_ns,
 				       fp->filp->f_path.dentry,
 				       fp->stream.name,
@@ -442,14 +447,14 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	if (v_len < 0) {
 		pr_err("not found stream in xattr : %zd\n", v_len);
 		err = v_len;
-		goto out;
+		goto out_revert;
 	}
 
 	if (v_len < size) {
 		wbuf = kvzalloc(size, GFP_KERNEL);
 		if (!wbuf) {
 			err = -ENOMEM;
-			goto out;
+			goto out_revert;
 		}
 
 		if (v_len > 0)
@@ -467,6 +472,8 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				 size,
 				 0,
 				 true);
+out_revert:
+	revert_creds(saved_cred);
 	if (err < 0)
 		goto out;
 
-- 
2.53.0



