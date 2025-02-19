Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C8F1E25E1;
	Wed, 19 Feb 2025 09:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956708; cv=none; b=qOkjM686WdKrRZxvYr0eCk9BRIPY6Hf4Zshj0WrmAjtuOf1ZM5KzAqdpnvtV5ubi6uqrfRMOJZBpbKyy2LQviGagAcMiz5NdpQWmFGNFX3dEjtfNDCoIUjBXV756i25MURiqaWPQ3hv2LLzhjIqhNmdlQEIT29tCieq3uFug5oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956708; c=relaxed/simple;
	bh=NBL1TIh/O68yVIgPqvGCi4uF7nB58A68OhOdXvDjvIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t6ga8hpSTzr7En7cLVNvK3zV03L7tYCAoWHi7nHtjabH1F5olMT7UY7QfjfoXHdKk0VD0p+UrPgIYE/9w+5d90F3g6o4UC9vRCsp+Q+Q5B4IzUA/wC8g2Ke4VMAuf2iqTS5WCxs8lsbVkLTboR2/PwnVyGWKUqVifmbVZktcHso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sleR66Jt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sleR66Jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E597C4CED1;
	Wed, 19 Feb 2025 09:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956708;
	bh=NBL1TIh/O68yVIgPqvGCi4uF7nB58A68OhOdXvDjvIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sleR66Jt5sffiEpEUwy1ClUHj1O7jQoP+Yj2+VWd7rkB9fXkNMNxjpdu2ms28Dhcp
	 HRzazbcnl8ppXte8hpkTkWMCGneoTkpyPYkiZnsSbJHlf7kmpa454SCbjKruADmhGt
	 8L6TMaOcckKfINKLj3wyvZGn/GIzjwDrwsO5LQfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Zbigniew=20J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
	Tycho Andersen <tandersen@netflix.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 272/578] exec: fix up /proc/pid/comm in the execveat(AT_EMPTY_PATH) case
Date: Wed, 19 Feb 2025 09:24:36 +0100
Message-ID: <20250219082703.722707495@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 543841d1806029889c2f69f040e88b247aba8e22 ]

Zbigniew mentioned at Linux Plumber's that systemd is interested in
switching to execveat() for service execution, but can't, because the
contents of /proc/pid/comm are the file descriptor which was used,
instead of the path to the binary[1]. This makes the output of tools like
top and ps useless, especially in a world where most fds are opened
CLOEXEC so the number is truly meaningless.

When the filename passed in is empty (e.g. with AT_EMPTY_PATH), use the
dentry's filename for "comm" instead of using the useless numeral from
the synthetic fdpath construction. This way the actual exec machinery
is unchanged, but cosmetically the comm looks reasonable to admins
investigating things.

Instead of adding TASK_COMM_LEN more bytes to bprm, use one of the unused
flag bits to indicate that we need to set "comm" from the dentry.

Suggested-by: Zbigniew Jędrzejewski-Szmek <zbyszek@in.waw.pl>
Suggested-by: Tycho Andersen <tandersen@netflix.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://github.com/uapi-group/kernel-features#set-comm-field-before-exec [1]
Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
Tested-by: Zbigniew Jędrzejewski-Szmek <zbyszek@in.waw.pl>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c               | 29 ++++++++++++++++++++++++++---
 include/linux/binfmts.h |  4 +++-
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a42c9b8b070d7..2039414cc6621 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1362,7 +1362,28 @@ int begin_new_exec(struct linux_binprm * bprm)
 		set_dumpable(current->mm, SUID_DUMP_USER);
 
 	perf_event_exec();
-	__set_task_comm(me, kbasename(bprm->filename), true);
+
+	/*
+	 * If the original filename was empty, alloc_bprm() made up a path
+	 * that will probably not be useful to admins running ps or similar.
+	 * Let's fix it up to be something reasonable.
+	 */
+	if (bprm->comm_from_dentry) {
+		/*
+		 * Hold RCU lock to keep the name from being freed behind our back.
+		 * Use acquire semantics to make sure the terminating NUL from
+		 * __d_alloc() is seen.
+		 *
+		 * Note, we're deliberately sloppy here. We don't need to care about
+		 * detecting a concurrent rename and just want a terminated name.
+		 */
+		rcu_read_lock();
+		__set_task_comm(me, smp_load_acquire(&bprm->file->f_path.dentry->d_name.name),
+				true);
+		rcu_read_unlock();
+	} else {
+		__set_task_comm(me, kbasename(bprm->filename), true);
+	}
 
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
@@ -1521,11 +1542,13 @@ static struct linux_binprm *alloc_bprm(int fd, struct filename *filename)
 	if (fd == AT_FDCWD || filename->name[0] == '/') {
 		bprm->filename = filename->name;
 	} else {
-		if (filename->name[0] == '\0')
+		if (filename->name[0] == '\0') {
 			bprm->fdpath = kasprintf(GFP_KERNEL, "/dev/fd/%d", fd);
-		else
+			bprm->comm_from_dentry = 1;
+		} else {
 			bprm->fdpath = kasprintf(GFP_KERNEL, "/dev/fd/%d/%s",
 						  fd, filename->name);
+		}
 		if (!bprm->fdpath)
 			goto out_free;
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 8d51f69f9f5ef..af9056d78fadf 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -42,7 +42,9 @@ struct linux_binprm {
 		 * Set when errors can no longer be returned to the
 		 * original userspace.
 		 */
-		point_of_no_return:1;
+		point_of_no_return:1,
+		/* Set when "comm" must come from the dentry. */
+		comm_from_dentry:1;
 	struct file *executable; /* Executable to pass to the interpreter */
 	struct file *interpreter;
 	struct file *file;
-- 
2.39.5



