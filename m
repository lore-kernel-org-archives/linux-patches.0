Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB381AF0A9;
	Tue, 15 Oct 2024 13:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997653; cv=none; b=SlZNKMBLmSaUENgixJ6lr2cK+SXFdMNDER+8+Mjih7/cL58HkHMVcZJz2PlRjVPkhwumoRmh7DIwXGGg+/7z75l2HOC696WmGjNpF7yNzV79jLaDuWv0MWhji2xHcHBhNsjcrwHa+9bL35LT+FVSve+NXilgPMV6l8QEQZSLpH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997653; c=relaxed/simple;
	bh=dI/cLFkWqDlbxefYWf8lx0rKkxJ8P8vXF4Fy8kuuYJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jqEiixPhS7/ubROgLoRx2zCBuoaSJU6iNf+JrS0M6xtwsz2yMh4eeq6in3KLNwORxU1IbPG8rj60q6csW7ARIBHCq9gRkcFWovYmhOekdCjnw+YR1BoZPZ6AyGWZ5VNowxGM8SpuU0ML9nKV1iBp755D+pzFoZyblMoLinmq7yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNn6gapA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNn6gapA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356ECC4CEC6;
	Tue, 15 Oct 2024 13:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997653;
	bh=dI/cLFkWqDlbxefYWf8lx0rKkxJ8P8vXF4Fy8kuuYJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNn6gapAd4bjxuqiWb1zX51ZjT1UdNuD3782heBanrXeHMyTAyB8owx3m5DNk9Q8P
	 qBMg2e0RNncbXzSjaB/sK9cP1lNZMOjrui2elAa3op62AYRl1sRFuuDLiQPZsZU7ru
	 OmPM4ZbBkaeKtIbE/nVqbqWXjI+i5XxJBU0elsr4=
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
Subject: [PATCH 5.10 246/518] fs: Fix file_set_fowner LSM hook inconsistencies
Date: Tue, 15 Oct 2024 14:42:30 +0200
Message-ID: <20241015123926.485442043@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -84,8 +84,8 @@ static int setfl(int fd, struct file * f
 	return error;
 }
 
-static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
-                     int force)
+void __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
+		int force)
 {
 	write_lock_irq(&filp->f_owner.lock);
 	if (force || !filp->f_owner.pid) {
@@ -95,19 +95,13 @@ static void f_modown(struct file *filp,
 
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
@@ -143,7 +137,7 @@ EXPORT_SYMBOL(f_setown);
 
 void f_delown(struct file *filp)
 {
-	f_modown(filp, NULL, PIDTYPE_TGID, 1);
+	__f_setown(filp, NULL, PIDTYPE_TGID, 1);
 }
 
 pid_t f_getown(struct file *filp)


