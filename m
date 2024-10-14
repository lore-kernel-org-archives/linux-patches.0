Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F74126296;
	Mon, 14 Oct 2024 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918481; cv=none; b=NkhoDeR8BuOvwUEyFQSm/s7P7I9RoXoSPXO+pqzFbUMIilUNP719pgOuBlOdrdkGSAiMvQo2zIWdqWhARq/mcIHDHS7ZzCUo70Eft+5RGVDYuMayg5MoiPpCiy+oCbC2u+XSA4wiFsaLgYxC6FMkHY1SFRuDrsoZGLxCJvNTZns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918481; c=relaxed/simple;
	bh=PLiXcQDXzfd5UPc6tQkEev4J4mFjuJqkSQdfIJa67Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YMF1T1YEl0Z6A4hb02dzG+Po/bEBZ52JRef5+/jMVFk0KEhHDI5M9tVBWyawWcnA9YAO0GiaKs9wRKTjnjIrh1Vb3amYEWTvBRyW1kuz6+1EtyFygw75luoTSwbjz3E2QqmKJ1CGL+lq0L5pkJcovjp85RNb4NJmd/L3jUo5RI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+Kel23l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+Kel23l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B1CC4CEC3;
	Mon, 14 Oct 2024 15:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918481;
	bh=PLiXcQDXzfd5UPc6tQkEev4J4mFjuJqkSQdfIJa67Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+Kel23lrOSYRIjhchVeyHL6YrROsFx68lpMNJ0j+yQtytVgO+ALJFeZfNgeA8HDc
	 yJHlZ+I/0FwKunpI6EHsTiVTXWIt0YupGzIV4KeKSEtyswSGFWisTR+f+OUN3ErdJN
	 M6Vq6O6XiB+dHdv9HeUFskRP4hTmTNHwEvl620ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <brauner@kernel.org>,
	James Morris <jmorris@namei.org>,
	Jann Horn <jannh@google.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.1 337/798] fs: Fix file_set_fowner LSM hook inconsistencies
Date: Mon, 14 Oct 2024 16:14:51 +0200
Message-ID: <20241014141231.186810807@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 26f204380a3c182e5adf1a798db0724d6111b597 upstream.

The fcntl's F_SETOWN command sets the process that handle SIGIO/SIGURG
for the related file descriptor.  Before this change, the
file_set_fowner LSM hook was always called, ignoring the VFS logic which
may not actually change the process that handles SIGIO (e.g. TUN, TTY,
dnotify), nor update the related UID/EUID.

Moreover, because security_file_set_fowner() was called without lock
(e.g. f_owner.lock), concurrent F_SETOWN commands could result to a race
condition and inconsistent LSM states (e.g. SELinux's fown_sid) compared
to struct fown_struct's UID/EUID.

This change makes sure the LSM states are always in sync with the VFS
state by moving the security_file_set_fowner() call close to the
UID/EUID updates and using the same f_owner.lock .

Rename f_modown() to __f_setown() to simplify code.

Cc: stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jann Horn <jannh@google.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fcntl.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -85,8 +85,8 @@ static int setfl(int fd, struct file * f
 	return error;
 }
 
-static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
-                     int force)
+void __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
+		int force)
 {
 	write_lock_irq(&filp->f_owner.lock);
 	if (force || !filp->f_owner.pid) {
@@ -96,19 +96,13 @@ static void f_modown(struct file *filp,
 
 		if (pid) {
 			const struct cred *cred = current_cred();
+			security_file_set_fowner(filp);
 			filp->f_owner.uid = cred->uid;
 			filp->f_owner.euid = cred->euid;
 		}
 	}
 	write_unlock_irq(&filp->f_owner.lock);
 }
-
-void __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
-		int force)
-{
-	security_file_set_fowner(filp);
-	f_modown(filp, pid, type, force);
-}
 EXPORT_SYMBOL(__f_setown);
 
 int f_setown(struct file *filp, unsigned long arg, int force)
@@ -144,7 +138,7 @@ EXPORT_SYMBOL(f_setown);
 
 void f_delown(struct file *filp)
 {
-	f_modown(filp, NULL, PIDTYPE_TGID, 1);
+	__f_setown(filp, NULL, PIDTYPE_TGID, 1);
 }
 
 pid_t f_getown(struct file *filp)


