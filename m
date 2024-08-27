Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A931DDEA;
	Tue, 27 Aug 2024 15:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771726; cv=none; b=Ap9mYAHI0bO0jXkM9zZ73GcKZc7AokI/KvXlEEegM2xotBl4TzDwMymISkR9uzhWAsQefvgWhRhglqxqiQZedGnTmm0drCPX95vL5oDjuJ5lYEogvd2TRC585B5u8d2GjvalbGO5h+w7a2VOlcnxLa4Gzyt+rAJg2H2rahNwRPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771726; c=relaxed/simple;
	bh=PkugcM2B1c8cPpnAEy8Fb1nyYuk0CvMU7Fa1PDFVEVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgLx/Gkn3sm8lHk8n+w+A7BSsNgqsZvbSDOyUjY4mP8poVO3D2kw8sSDATsrxC4X+DANk0mtaITJ3NpLckb/d3RN1vCxmRgFelkoSxzi3hIy+0QVmtvwqOheNfBYzp/PVPAjSwtY7OwHb3DKqc7aZX+jG4Y3uiOKA2RjUjXqWCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iyg53KK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iyg53KK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B66C4DDFF;
	Tue, 27 Aug 2024 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771726;
	bh=PkugcM2B1c8cPpnAEy8Fb1nyYuk0CvMU7Fa1PDFVEVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iyg53KK3n3dw/3H+XcRV0uT8WEL7PoLrNs5EMujUWi7aRndqwngUIo+iHNbciWnSF
	 bd/zKb6x7HWPSU2kTolYuJnnC0pQJTg/bC6jIRDRRbgaq3sMYxrIHj44614OgJvrwk
	 Q1pS8ZSBn1J2rKuIVbPBJ2HBa7xA4SpG3dp8cPI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.10 268/273] Revert "pidfd: prevent creation of pidfds for kthreads"
Date: Tue, 27 Aug 2024 16:39:52 +0200
Message-ID: <20240827143843.598137619@linuxfoundation.org>
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

commit 232590ea7fc125986a526e03081b98e5783f70d2 upstream.

This reverts commit 3b5bbe798b2451820e74243b738268f51901e7d0.

Eric reported that systemd-shutdown gets broken by blocking the creating
of pidfds for kthreads as older versions seems to rely on being able to
create a pidfd for any process in /proc.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20240818035818.GA1929@sol.localdomain
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |   25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2069,23 +2069,10 @@ static int __pidfd_prepare(struct pid *p
  */
 int pidfd_prepare(struct pid *pid, unsigned int flags, struct file **ret)
 {
-	if (!pid)
-		return -EINVAL;
-
-	scoped_guard(rcu) {
-		struct task_struct *tsk;
+	bool thread = flags & PIDFD_THREAD;
 
-		if (flags & PIDFD_THREAD)
-			tsk = pid_task(pid, PIDTYPE_PID);
-		else
-			tsk = pid_task(pid, PIDTYPE_TGID);
-		if (!tsk)
-			return -EINVAL;
-
-		/* Don't create pidfds for kernel threads for now. */
-		if (tsk->flags & PF_KTHREAD)
-			return -EINVAL;
-	}
+	if (!pid || !pid_has_task(pid, thread ? PIDTYPE_PID : PIDTYPE_TGID))
+		return -EINVAL;
 
 	return __pidfd_prepare(pid, flags, ret);
 }
@@ -2432,12 +2419,6 @@ __latent_entropy struct task_struct *cop
 	if (clone_flags & CLONE_PIDFD) {
 		int flags = (clone_flags & CLONE_THREAD) ? PIDFD_THREAD : 0;
 
-		/* Don't create pidfds for kernel threads for now. */
-		if (args->kthread) {
-			retval = -EINVAL;
-			goto bad_fork_free_pid;
-		}
-
 		/* Note that no task has been attached to @pid yet. */
 		retval = __pidfd_prepare(pid, flags, &pidfile);
 		if (retval < 0)


