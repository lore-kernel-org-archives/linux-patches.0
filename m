Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9410C19F473;
	Thu, 15 Aug 2024 14:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730813; cv=none; b=tJErcPvigGjOGZW/ZceZEGsvVdC33zSc3bw3F9QNdzO+uS0xIa3YWAfQBQAoIYnvbTCmgLnvA8EjX2ZWpxm831P+cO1o7x7U77wWRlF/9RmG+kmooiCqgZdLRG6Db6Ur/TZiGks0U31mhn5rHgHY/qPWXH0uPR2QYEo731Fm6RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730813; c=relaxed/simple;
	bh=i7UNYnHnV9n+dH6qi8BfTR5yIxB4k2EbBInW++rTkP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3VfkWUDw/DR/z0WHdv21lJjtcWQzlo4KtT10YDGGiBYJtnx9w71YI/aeZ8S8bb9oYTaoK29iCCInf7MQR7PbkF5WZgTgDZV4NLjcSXQRswJvJK7RMZOL4WVW+lwcENSdE/W7f5sXZebVRTtPJnfEvBNcdH861s4qPew+UTr9FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qlurq4rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qlurq4rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE01AC4AF0A;
	Thu, 15 Aug 2024 14:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730813;
	bh=i7UNYnHnV9n+dH6qi8BfTR5yIxB4k2EbBInW++rTkP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qlurq4rqJT8eSi8JxdHRwH2tLjSNZX4opP2sJiC636voOQ/yMiXLwP1Ib1nlyxel3
	 BPrcHv9xjy7C5oia3RxH9A1QGI1aoN+U0FA/+DwrLGsEduCkMFSVGXz7AAZEBC+g9t
	 X9nkHY1zFKJ2EZWTGwH8UD+sdTBNthtnPXEiQxX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Vanotti <mvanotti@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.1 08/38] exec: Fix ToCToU between perm check and set-uid/gid usage
Date: Thu, 15 Aug 2024 15:25:42 +0200
Message-ID: <20240815131833.274695720@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

commit f50733b45d865f91db90919f8311e2127ce5a0cb upstream.

When opening a file for exec via do_filp_open(), permission checking is
done against the file's metadata at that moment, and on success, a file
pointer is passed back. Much later in the execve() code path, the file
metadata (specifically mode, uid, and gid) is used to determine if/how
to set the uid and gid. However, those values may have changed since the
permissions check, meaning the execution may gain unintended privileges.

For example, if a file could change permissions from executable and not
set-id:

---------x 1 root root 16048 Aug  7 13:16 target

to set-id and non-executable:

---S------ 1 root root 16048 Aug  7 13:16 target

it is possible to gain root privileges when execution should have been
disallowed.

While this race condition is rare in real-world scenarios, it has been
observed (and proven exploitable) when package managers are updating
the setuid bits of installed programs. Such files start with being
world-executable but then are adjusted to be group-exec with a set-uid
bit. For example, "chmod o-x,u+s target" makes "target" executable only
by uid "root" and gid "cdrom", while also becoming setuid-root:

-rwxr-xr-x 1 root cdrom 16048 Aug  7 13:16 target

becomes:

-rwsr-xr-- 1 root cdrom 16048 Aug  7 13:16 target

But racing the chmod means users without group "cdrom" membership can
get the permission to execute "target" just before the chmod, and when
the chmod finishes, the exec reaches brpm_fill_uid(), and performs the
setuid to root, violating the expressed authorization of "only cdrom
group members can setuid to root".

Re-check that we still have execute permissions in case the metadata
has changed. It would be better to keep a copy from the perm-check time,
but until we can do that refactoring, the least-bad option is to do a
full inode_permission() call (under inode lock). It is understood that
this is safe against dead-locks, but hardly optimal.

Reported-by: Marco Vanotti <mvanotti@google.com>
Tested-by: Marco Vanotti <mvanotti@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1603,6 +1603,7 @@ static void bprm_fill_uid(struct linux_b
 	unsigned int mode;
 	kuid_t uid;
 	kgid_t gid;
+	int err;
 
 	if (!mnt_may_suid(file->f_path.mnt))
 		return;
@@ -1619,12 +1620,17 @@ static void bprm_fill_uid(struct linux_b
 	/* Be careful if suid/sgid is set */
 	inode_lock(inode);
 
-	/* reload atomically mode/uid/gid now that lock held */
+	/* Atomically reload and check mode/uid/gid now that lock held. */
 	mode = inode->i_mode;
 	uid = i_uid_into_mnt(mnt_userns, inode);
 	gid = i_gid_into_mnt(mnt_userns, inode);
+	err = inode_permission(mnt_userns, inode, MAY_EXEC);
 	inode_unlock(inode);
 
+	/* Did the exec bit vanish out from under us? Give up. */
+	if (err)
+		return;
+
 	/* We ignore suid/sgid if there are no mappings for them in the ns */
 	if (!kuid_has_mapping(bprm->cred->user_ns, uid) ||
 		 !kgid_has_mapping(bprm->cred->user_ns, gid))


