Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AACB51597D;
	Wed, 30 Sep 2026 17:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788825; cv=none; b=n9kSuf9gCWnqgDyuQYq1VEmeCUJ7MZxwO/QSHazP/3r54nr7/tHwHYVu4jq38vwJLQubjTBcJeZ9ZtJ/xjryt3XjyvBllNcJVco04Ba7Luz9fx5FZvBJT5a7BECI+WPmZsIODp1W0wwPyAOr3NmUv/YUQwSBGLRcqH8W4PVvhgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788825; c=relaxed/simple;
	bh=+sJsmxlz8RLzS/ksz0dPY2Pi92eOf7piOA5eq3DEi6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObE3bKm5NwUuH9NlMZh0uk5YnHFYCQTpgIddu70gBzk7xvLFF2v3fTt3pjoDW7aJVzj4Dg+LUgwiyiHFS61DVrPq0EN5c8g5hfz1lzTTSmk+4QzZF9zJMarYNdEVIQgwctGEsxXxjJOntcqZ5elvEKS0w0i6r4fwk3WzJZxh/no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjbOlPBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjbOlPBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CC91F000FF;
	Wed, 30 Sep 2026 17:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788824;
	bh=BulVHPH4q+5bAsPa1jHuj0/lmPJEYskwYOZ9PcZnwLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjbOlPBranD9ZRa8I15Laj3x/4ujMy9CFTT84UY71a9mxrFEBNNpyYXeddK+ua6mc
	 9+sNOjW00Lk1yZ1GIDdUDlHyIDnMDNPwmPEu9VtZbT9hOcgAaDegQXDlVnKvZYSmqC
	 ikibhuE4lV0XoVJPccQ0eaVgoVU/uymmTbXrL5H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 215/877] selinux: preserve user SID across nested backing files
Date: Wed, 30 Sep 2026 17:18:46 +0200
Message-ID: <20260930152419.369994267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 8c0c602202b9a4909b00bc3354e3c0355bc69e65 upstream.

SELinux saves the user file SID in a backing-file security blob so it
remains available after mmap() replaces vma->vm_file with a backing file.

For nested backing files (overlayfs over overlayfs, or FUSE passthrough
backed by overlayfs), user_file may itself be a backing file.  Its
fsec->sid is the SID of the mounter that opened it, rather than the user
that opened the top-level file.  mprotect() then checks fd { use } against
the mounter SID.  This can incorrectly deny access without a domain
transition, or check the wrong target SID after one.

Copy the saved user SID when user_file is a backing file.  Keep using the
regular file SID for the first backing layer.

With two nested overlayfs mounts and SELinux enforcing,
mprotect(PROT_READ) returns EACCES with an fd { use } denial against the
mounter SID.  With this change, mprotect() succeeds.

Tested on arm64 QEMU with a small BusyBox initramfs and a purpose-built
SELinux policy.  The original test was also repeated with Fedora Cloud
Base 44 userspace and gave the same result.

Cc: stable@vger.kernel.org
Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access checks")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c          |    9 ++++++++-
 security/selinux/include/objsec.h |    2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3676,13 +3676,20 @@ static int selinux_file_alloc_security(s
 	return 0;
 }
 
+static inline u32 selinux_file_user_sid(const struct file *file)
+{
+	if (unlikely(file->f_mode & FMODE_BACKING))
+		return selinux_backing_file(file)->uf_sid;
+	return selinux_file(file)->sid;
+}
+
 static int selinux_backing_file_alloc(struct file *backing_file,
 				      const struct file *user_file)
 {
 	struct backing_file_security_struct *bfsec;
 
 	bfsec = selinux_backing_file(backing_file);
-	bfsec->uf_sid = selinux_file(user_file)->sid;
+	bfsec->uf_sid = selinux_file_user_sid(user_file);
 
 	return 0;
 }
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -62,7 +62,7 @@ struct file_security_struct {
 };
 
 struct backing_file_security_struct {
-	u32 uf_sid; /* associated user file fsec->sid */
+	u32 uf_sid; /* top-level user file fsec->sid */
 };
 
 struct superblock_security_struct {


