Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A081DE8AA;
	Tue,  8 Oct 2024 12:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391535; cv=none; b=UmGZHLgCii3ebER4Jycy75buuLA4AWoGm/ExPHD7u+z0BVWvam1JlRXoi5uICsDnD9OqF6Wmfx9kwbnuH/VrS0Mo+oYh/cOQfwY6wv7kRYX0Q210OYU5lc4GwwwLhHb2NJ01XFOJmaJ6BZSFHCs2y2muL2zKPPZnkfYmTLoYqpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391535; c=relaxed/simple;
	bh=5S7l9E+bkPYqLqjUcba8+1U+7k2awX0pO0X+EsnhFIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI491iMWMT6xTMMD3xtXr2DJ2oQfxuKQE4IP/Vzm+Gq6mGLdUcvwIl94qkNtsXRUnyGMRI+jt4V5LqXuq2//z1kBhvD5UNVI3WpHnOTrxFKo5aIIK+zsz/ODe2G5KtYPbFcXILQYdfHrcMlwmgV/OQbcDZPDHFQbUJGzMdzckdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYiMmD/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYiMmD/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA34C4CEC7;
	Tue,  8 Oct 2024 12:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391535;
	bh=5S7l9E+bkPYqLqjUcba8+1U+7k2awX0pO0X+EsnhFIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYiMmD/Y/91PW0w2fWtrHbMkhPA220i+85XPaE1/RfMCyeU6Ru7ffGquBLX3adute
	 L9JmNlQhk3GpUwJth6f7BNZVZKFaOOPY4rTmGkAmRt8Z3AhPGx2jXBv8xAEV1Rbl6B
	 DWj7tIz0N1+vINqq/QonUutXQGwEY6A1qtnsKkIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 103/558] exec: dont WARN for racy path_noexec check
Date: Tue,  8 Oct 2024 14:02:13 +0200
Message-ID: <20241008115706.421224381@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit 0d196e7589cefe207d5d41f37a0a28a1fdeeb7c6 ]

Both i_mode and noexec checks wrapped in WARN_ON stem from an artifact
of the previous implementation. They used to legitimately check for the
condition, but that got moved up in two commits:
633fb6ac3980 ("exec: move S_ISREG() check earlier")
0fd338b2d2cd ("exec: move path_noexec() check earlier")

Instead of being removed said checks are WARN_ON'ed instead, which
has some debug value.

However, the spurious path_noexec check is racy, resulting in
unwarranted warnings should someone race with setting the noexec flag.

One can note there is more to perm-checking whether execve is allowed
and none of the conditions are guaranteed to still hold after they were
tested for.

Additionally this does not validate whether the code path did any perm
checking to begin with -- it will pass if the inode happens to be
regular.

Keep the redundant path_noexec() check even though it's mindless
nonsense checking for guarantee that isn't given so drop the WARN.

Reword the commentary and do small tidy ups while here.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/r/20240805131721.765484-1-mjguzik@gmail.com
[brauner: keep redundant path_noexec() check]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 50e76cc633c4b..caae051c5a956 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -145,13 +145,11 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 		goto out;
 
 	/*
-	 * may_open() has already checked for this, so it should be
-	 * impossible to trip now. But we need to be extra cautious
-	 * and check again at the very end too.
+	 * Check do_open_execat() for an explanation.
 	 */
 	error = -EACCES;
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
-			 path_noexec(&file->f_path)))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)) ||
+	    path_noexec(&file->f_path))
 		goto exit;
 
 	error = -ENOEXEC;
@@ -954,7 +952,6 @@ EXPORT_SYMBOL(transfer_args_to_stack);
 static struct file *do_open_execat(int fd, struct filename *name, int flags)
 {
 	struct file *file;
-	int err;
 	struct open_flags open_exec_flags = {
 		.open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
 		.acc_mode = MAY_EXEC,
@@ -971,24 +968,20 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 
 	file = do_filp_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
-		goto out;
+		return file;
 
 	/*
-	 * may_open() has already checked for this, so it should be
-	 * impossible to trip now. But we need to be extra cautious
-	 * and check again at the very end too.
+	 * In the past the regular type check was here. It moved to may_open() in
+	 * 633fb6ac3980 ("exec: move S_ISREG() check earlier"). Since then it is
+	 * an invariant that all non-regular files error out before we get here.
 	 */
-	err = -EACCES;
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
-			 path_noexec(&file->f_path)))
-		goto exit;
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)) ||
+	    path_noexec(&file->f_path)) {
+		fput(file);
+		return ERR_PTR(-EACCES);
+	}
 
-out:
 	return file;
-
-exit:
-	fput(file);
-	return ERR_PTR(err);
 }
 
 /**
-- 
2.43.0



