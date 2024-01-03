Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E402E1BDEC;
	Wed,  3 Jan 2024 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCtBlHzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346B0C433C7;
	Wed,  3 Jan 2024 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301163;
	bh=XKWW1mA68MiITNszjVgpMhbG89QxduenAawTDP/wRPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCtBlHzCqvbqhE1guLlGGx09RIRKjUxjgK+OSWQYUuDA51y/ltJmWfzmyKMHMmMEz
	 EqteJ/N3iMBZRTsEju+ZwvjFX81upYP5h3teQHGkvL/R8ALzNCTYYWtQWLHorhr+E2
	 MqJl3e6Mn43L6llljGh9yNLBkrwwC5L/m6XzEhEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/100] ksmbd: fix recursive locking in vfs helpers
Date: Wed,  3 Jan 2024 17:54:44 +0100
Message-ID: <20240103164904.339806348@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 807252f028c59b9a3bac4d62ad84761548c10f11 ]

Running smb2.rename test from Samba smbtorture suite against a kernel built
with lockdep triggers a "possible recursive locking detected" warning.

This is because mnt_want_write() is called twice with no mnt_drop_write()
in between:
  -> ksmbd_vfs_mkdir()
    -> ksmbd_vfs_kern_path_create()
       -> kern_path_create()
          -> filename_create()
            -> mnt_want_write()
       -> mnt_want_write()

Fix this by removing the mnt_want_write/mnt_drop_write calls from vfs
helpers that call kern_path_create().

Full lockdep trace below:

============================================
WARNING: possible recursive locking detected
6.6.0-rc5 #775 Not tainted
--------------------------------------------
kworker/1:1/32 is trying to acquire lock:
ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: ksmbd_vfs_mkdir+0xe1/0x410

but task is already holding lock:
ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: filename_create+0xb6/0x260

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sb_writers#5);
  lock(sb_writers#5);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by kworker/1:1/32:
 #0: ffff8880064e4138 ((wq_completion)ksmbd-io){+.+.}-{0:0}, at: process_one_work+0x40e/0x980
 #1: ffff888005b0fdd0 ((work_completion)(&work->work)){+.+.}-{0:0}, at: process_one_work+0x40e/0x980
 #2: ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: filename_create+0xb6/0x260
 #3: ffff8880057ce760 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at: filename_create+0x123/0x260

Cc: stable@vger.kernel.org
Fixes: 40b268d384a2 ("ksmbd: add mnt_want_write to ksmbd vfs functions")
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 071c344dd0333..e2e454eba4095 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -174,10 +174,6 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
 		return err;
 	}
 
-	err = mnt_want_write(path.mnt);
-	if (err)
-		goto out_err;
-
 	mode |= S_IFREG;
 	err = vfs_create(mnt_user_ns(path.mnt), d_inode(path.dentry),
 			 dentry, mode, true);
@@ -187,9 +183,7 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
 	} else {
 		pr_err("File(%s): creation failed (err:%d)\n", name, err);
 	}
-	mnt_drop_write(path.mnt);
 
-out_err:
 	done_path_create(&path, dentry);
 	return err;
 }
@@ -220,10 +214,6 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 		return err;
 	}
 
-	err = mnt_want_write(path.mnt);
-	if (err)
-		goto out_err2;
-
 	user_ns = mnt_user_ns(path.mnt);
 	mode |= S_IFDIR;
 	err = vfs_mkdir(user_ns, d_inode(path.dentry), dentry, mode);
@@ -234,21 +224,19 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 			       dentry->d_name.len);
 		if (IS_ERR(d)) {
 			err = PTR_ERR(d);
-			goto out_err1;
+			goto out_err;
 		}
 		if (unlikely(d_is_negative(d))) {
 			dput(d);
 			err = -ENOENT;
-			goto out_err1;
+			goto out_err;
 		}
 
 		ksmbd_vfs_inherit_owner(work, d_inode(path.dentry), d_inode(d));
 		dput(d);
 	}
 
-out_err1:
-	mnt_drop_write(path.mnt);
-out_err2:
+out_err:
 	done_path_create(&path, dentry);
 	if (err)
 		pr_err("mkdir(%s): creation failed (err:%d)\n", name, err);
@@ -666,16 +654,11 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char *oldname,
 		goto out3;
 	}
 
-	err = mnt_want_write(newpath.mnt);
-	if (err)
-		goto out3;
-
 	err = vfs_link(oldpath.dentry, mnt_user_ns(newpath.mnt),
 		       d_inode(newpath.dentry),
 		       dentry, NULL);
 	if (err)
 		ksmbd_debug(VFS, "vfs_link failed err %d\n", err);
-	mnt_drop_write(newpath.mnt);
 
 out3:
 	done_path_create(&newpath, dentry);
-- 
2.43.0



