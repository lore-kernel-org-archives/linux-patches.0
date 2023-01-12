Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7C079CE
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC30CC433F0;
	Thu, 12 Jan 2023 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533704;
	bh=p4kp86KIyUfMP+bB6fcVuZ4QnmRE18fuZ7/pMbiJ3dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4aoI2YGfqotTWnp/3I1cviyUk7DYZi7SzizyRl3qMZvARVNzokx6ezyF9eIwqqR3
	 7yXBYdG9jkZh2iGWs2Hc+uDp3vd3UnS43jpni0Qbnrj0KxlgnrsNujtE+GJS4NAtXX
	 5F5SG2f8EOnWI2szWYe1zZGw81yvtvlE5T0yl7V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Mahoney <jeffm@suse.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 563/783] reiserfs: Add missing calls to reiserfs_security_free()
Date: Thu, 12 Jan 2023 14:54:39 +0100
Message-Id: <20230112135550.347483696@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 572302af1258459e124437b8f3369357447afac7 upstream.

Commit 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes
during inode creation") defined reiserfs_security_free() to free the name
and value of a security xattr allocated by the active LSM through
security_old_inode_init_security(). However, this function is not called
in the reiserfs code.

Thus, add a call to reiserfs_security_free() whenever
reiserfs_security_init() is called, and initialize value to NULL, to avoid
to call kfree() on an uninitialized pointer.

Finally, remove the kfree() for the xattr name, as it is not allocated
anymore.

Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes during inode creation")
Cc: stable@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Mimi Zohar <zohar@linux.ibm.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/reiserfs/namei.c          |    4 ++++
 fs/reiserfs/xattr_security.c |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -695,6 +695,7 @@ static int reiserfs_create(struct inode
 
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -778,6 +779,7 @@ static int reiserfs_mknod(struct inode *
 
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -876,6 +878,7 @@ static int reiserfs_mkdir(struct inode *
 	retval = journal_end(&th);
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -1191,6 +1194,7 @@ static int reiserfs_symlink(struct inode
 	retval = journal_end(&th);
 out_failed:
 	reiserfs_write_unlock(parent_dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -49,6 +49,7 @@ int reiserfs_security_init(struct inode
 	int error;
 
 	sec->name = NULL;
+	sec->value = NULL;
 
 	/* Don't add selinux attributes on xattrs - they'll never get used */
 	if (IS_PRIVATE(dir))
@@ -94,7 +95,6 @@ int reiserfs_security_write(struct reise
 
 void reiserfs_security_free(struct reiserfs_security_handle *sec)
 {
-	kfree(sec->name);
 	kfree(sec->value);
 	sec->name = NULL;
 	sec->value = NULL;


