Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8731993B9;
	Thu, 15 Aug 2024 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732992; cv=none; b=ZCJM3VhJhOg2zbL7zFQyb7pfhCvlHvNOoTf4ux3StxUNQVjcJKZI/YnkLcF0i2rBL6lO/WVb+C8Gb4FhvkvCpRP2Q0eU5eyAefljj1eIYIKPDL8HRVv4/aCmW0ldbiX6kfkcTfpSj8Vuns4lAaffDb/JXXcOJL8YNC+ATOv0wtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732992; c=relaxed/simple;
	bh=UpyyWvpxPE+Zb8zWah/K4zVea0KdmTai1/Ia26hIdYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPxCkfYv8EVkq5y6vB54GwBWZUBbY6TK57bKLrtu3ZIV1W1si5febXuVtHRWq49tw6rNqZ7rV35B5VxYFLo+H722E1FLHBDj9prGUwyQ8ra8BLpOWeahYx2YJp/gJBEJ5+ENFLTkUl6YVn4haoCT/Eh8OmgEGc4wxi46Vin0WLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwAyh5LL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwAyh5LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A00C4AF0E;
	Thu, 15 Aug 2024 14:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732992;
	bh=UpyyWvpxPE+Zb8zWah/K4zVea0KdmTai1/Ia26hIdYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwAyh5LL7xoy/gdyyITDESKlakI7OW285MvhM4YKk4FTV3wY/8dhSFN+4iXFyqKd6
	 BpAfSo4+X2zJQz97o9T7MUMfQXgTP4yXMoEc5i+F2g1ojGJPpZUXyotd8BACorKk9N
	 K1toK94eW9y33hqVJCf5PyPksLuSDeotO9qlYGlU=
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
Subject: [PATCH 5.10 347/352] exec: Fix ToCToU between perm check and set-uid/gid usage
Date: Thu, 15 Aug 2024 15:26:53 +0200
Message-ID: <20240815131932.881700541@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1588,6 +1588,7 @@ static void bprm_fill_uid(struct linux_b
 	unsigned int mode;
 	kuid_t uid;
 	kgid_t gid;
+	int err;
 
 	if (!mnt_may_suid(file->f_path.mnt))
 		return;
@@ -1603,12 +1604,17 @@ static void bprm_fill_uid(struct linux_b
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


