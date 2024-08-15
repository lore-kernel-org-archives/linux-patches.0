Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B711A1AC8AE;
	Thu, 15 Aug 2024 14:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731851; cv=none; b=YlEijXY/96L5tv2MIrBhnWJKvEICroN7gdIzggTsXFhdaeDlvjEpV/N5zba8zCYFolJ23e/MZcywg/QDxTcXwk16lI/Aq+lIJiGGFvxRFSHzZTth9bbFHES5cOVFkV3FZZ8c4BXtUmQQAmpG67QYIhTPWNtXUD7GGBQlxaxiIHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731851; c=relaxed/simple;
	bh=lQuaHL472LI6+tuiilSrxysUfIB5nl2TSaPqhudn0HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8ntSd/BdTuaIzFLX57zDDON0a3lVDv80ShazzqCtB+/JtWMnNR0lISknvpWwsJpbpiQ9Br3PCZC04nwP92hqGIPjmappMuVk1CfaeiR3Svc/keeIeJocXUSGKohQjr2QTTxVARu7yFLLuftFM361n7e4TnMG51hWGwwc95twDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1z8eqktL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1z8eqktL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2849BC32786;
	Thu, 15 Aug 2024 14:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731851;
	bh=lQuaHL472LI6+tuiilSrxysUfIB5nl2TSaPqhudn0HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1z8eqktL/E7nAdUwypOy650aMsh1Vz2uZn/3uv9pKlg8OdTaqX9fNuB//9Q77o5o3
	 6dJMrGpuTNNt7YE0XcYxsock8iuZPfi2aGYixeaCP40h9NEXKSREMeP86EDdVe3G8O
	 IxoSjxiROPiYWLgfscVDOdZTYdSFRYNlu2jPbyvc=
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
Subject: [PATCH 5.4 257/259] exec: Fix ToCToU between perm check and set-uid/gid usage
Date: Thu, 15 Aug 2024 15:26:30 +0200
Message-ID: <20240815131912.796994851@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1558,6 +1558,7 @@ static void bprm_fill_uid(struct linux_b
 	unsigned int mode;
 	kuid_t uid;
 	kgid_t gid;
+	int err;
 
 	/*
 	 * Since this can be called multiple times (via prepare_binprm),
@@ -1582,12 +1583,17 @@ static void bprm_fill_uid(struct linux_b
 	/* Be careful if suid/sgid is set */
 	inode_lock(inode);
 
-	/* reload atomically mode/uid/gid now that lock held */
+	/* Atomically reload and check mode/uid/gid now that lock held. */
 	mode = inode->i_mode;
 	uid = inode->i_uid;
 	gid = inode->i_gid;
+	err = inode_permission(inode, MAY_EXEC);
 	inode_unlock(inode);
 
+	/* Did the exec bit vanish out from under us? Give up. */
+	if (err)
+		return;
+
 	/* We ignore suid/sgid if there are no mappings for them in the ns */
 	if (!kuid_has_mapping(bprm->cred->user_ns, uid) ||
 		 !kgid_has_mapping(bprm->cred->user_ns, gid))


