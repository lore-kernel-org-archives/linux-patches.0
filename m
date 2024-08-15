Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6371A00F7;
	Thu, 15 Aug 2024 14:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730838; cv=none; b=HGVUeUAeUcU1clZgbjXumtC9h7BFkr9X0limDBpdS7302PhJc207QlgGFpLRaaP4pFkeTITJ7s9l9F4vMUhRc4K7C8nUwbEbZMz3BkEThjRIWhTpmnz2QUETSkiHrXgHE4hpZM9ed5eu5KiHtTUpiCbi9wV53PNz3vWpUGe3+zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730838; c=relaxed/simple;
	bh=gGhKbxHF8jpM4+ivOLkZ22lvlekodIET/rdPcGzXxyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dd06ozDTTlTefxs/UCP8xl/hyLYAf6/tiYZ2jwi6dxhoTVJjntXSJethLr/RSf6RLxFCj9ruW5wtlpVUHXcusXey940Yjld0xDfYgYE/5S6x+eiUlbYyil4WFGMP8pKScpE8m6C0ucFXicKPapFPVbW24mwnBmcRoDn1r0ayRIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCnHCkn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCnHCkn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D3FC32786;
	Thu, 15 Aug 2024 14:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730838;
	bh=gGhKbxHF8jpM4+ivOLkZ22lvlekodIET/rdPcGzXxyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCnHCkn4zZPSbUXYK7dgVFCT8QcGeQ/Kg4gKG40dhs/nky0NkNnLkdwMfAxmrUJeg
	 z+Rim5re2xjPVZp0Soor37TYOHPOHyCGDfHV7CKdBIQVDBBU2JpXkH9YgsmsHgQKGb
	 VqtPHF1/kIzAt8Ve774yONhKqpOYHblQTx6fSGAI=
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
Subject: [PATCH 6.6 01/67] exec: Fix ToCToU between perm check and set-uid/gid usage
Date: Thu, 15 Aug 2024 15:25:15 +0200
Message-ID: <20240815131838.370715616@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1609,6 +1609,7 @@ static void bprm_fill_uid(struct linux_b
 	unsigned int mode;
 	vfsuid_t vfsuid;
 	vfsgid_t vfsgid;
+	int err;
 
 	if (!mnt_may_suid(file->f_path.mnt))
 		return;
@@ -1625,12 +1626,17 @@ static void bprm_fill_uid(struct linux_b
 	/* Be careful if suid/sgid is set */
 	inode_lock(inode);
 
-	/* reload atomically mode/uid/gid now that lock held */
+	/* Atomically reload and check mode/uid/gid now that lock held. */
 	mode = inode->i_mode;
 	vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid = i_gid_into_vfsgid(idmap, inode);
+	err = inode_permission(idmap, inode, MAY_EXEC);
 	inode_unlock(inode);
 
+	/* Did the exec bit vanish out from under us? Give up. */
+	if (err)
+		return;
+
 	/* We ignore suid/sgid if there are no mappings for them in the ns */
 	if (!vfsuid_has_mapping(bprm->cred->user_ns, vfsuid) ||
 	    !vfsgid_has_mapping(bprm->cred->user_ns, vfsgid))


