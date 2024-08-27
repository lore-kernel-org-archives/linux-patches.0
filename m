Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DA71C2DB1;
	Tue, 27 Aug 2024 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771062; cv=none; b=E7yykW3tVfSkhySPK/WZBmKbROASQaYx/kpVwg6ykER1iPE1OSiAWj4vOHHTWs/RInR4WYdnQVvXEFWZtT8kMAxTlx1GMFYjF/uIE7rv80hJifUwbi7npDH0EefxbRI+nCdYQyUSB55GXFrD+alDU5LFV3pVrHgML5lToR89r2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771062; c=relaxed/simple;
	bh=TMCsF+WWv8j93AjIfIB/RnrFpFPEv/895Fd2DIN9tao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akk+o+BbBGgb6uLDMABSCGVczAgOZG9kouzb270jSasqQEdPnxgp1c/gmkcnXTQFrzE889r9jEz6eMFz/BR/QfVln8IzsY70/doSiLxMAx90TetrP76kx/ejpqmNhn81xAAw1U5+RaWIFtLWl1ThdXdEhG0TGHwPzS5Z5kPXXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kT7oK5qB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kT7oK5qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0EBC6105B;
	Tue, 27 Aug 2024 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771062;
	bh=TMCsF+WWv8j93AjIfIB/RnrFpFPEv/895Fd2DIN9tao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kT7oK5qBJWf6Xmd0iXktS16kXFfOedOwrBw37XzngExfsG4xyjm8zCCo99lffxVAO
	 Ezcno+FsTxI7lY6zvQM0uJvFHQn7mfGwMKZm6PvXwdnKI+liDny8ZxogCuoEP4niFE
	 PLS4zcjNiJpoR3OE0OM4E0ru40qhknwJ9KJLbd0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.10 076/273] pidfd: prevent creation of pidfds for kthreads
Date: Tue, 27 Aug 2024 16:36:40 +0200
Message-ID: <20240827143836.306470810@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 3b5bbe798b2451820e74243b738268f51901e7d0 upstream.

It's currently possible to create pidfds for kthreads but it is unclear
what that is supposed to mean. Until we have use-cases for it and we
figured out what behavior we want block the creation of pidfds for
kthreads.

Link: https://lore.kernel.org/r/20240731-gleis-mehreinnahmen-6bbadd128383@brauner
Fixes: 32fcb426ec00 ("pid: add pidfd_open()")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2069,11 +2069,24 @@ static int __pidfd_prepare(struct pid *p
  */
 int pidfd_prepare(struct pid *pid, unsigned int flags, struct file **ret)
 {
-	bool thread = flags & PIDFD_THREAD;
-
-	if (!pid || !pid_has_task(pid, thread ? PIDTYPE_PID : PIDTYPE_TGID))
+	if (!pid)
 		return -EINVAL;
 
+	scoped_guard(rcu) {
+		struct task_struct *tsk;
+
+		if (flags & PIDFD_THREAD)
+			tsk = pid_task(pid, PIDTYPE_PID);
+		else
+			tsk = pid_task(pid, PIDTYPE_TGID);
+		if (!tsk)
+			return -EINVAL;
+
+		/* Don't create pidfds for kernel threads for now. */
+		if (tsk->flags & PF_KTHREAD)
+			return -EINVAL;
+	}
+
 	return __pidfd_prepare(pid, flags, ret);
 }
 
@@ -2419,6 +2432,12 @@ __latent_entropy struct task_struct *cop
 	if (clone_flags & CLONE_PIDFD) {
 		int flags = (clone_flags & CLONE_THREAD) ? PIDFD_THREAD : 0;
 
+		/* Don't create pidfds for kernel threads for now. */
+		if (args->kthread) {
+			retval = -EINVAL;
+			goto bad_fork_free_pid;
+		}
+
 		/* Note that no task has been attached to @pid yet. */
 		retval = __pidfd_prepare(pid, flags, &pidfile);
 		if (retval < 0)


