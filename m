Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E378445C0B;
	Fri, 17 Oct 2025 15:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713730; cv=none; b=fSSjuIhu0IXzp7Ei8VmPPYGsJ8HtvN1QxIUWUOck445rgMFKU/e99IU6srH5Qg9/Bh5TV81/DAUVCLFQ2kpLeKhZUubQJttpef9OSjVe2ocXq5PVWzgRU9k2cZLRf0roCG2OT5t0pWtx/s7r17dUzG1V+NGG3o8rwoTlmaPYyng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713730; c=relaxed/simple;
	bh=zlN5XZLx7Vy0hhYh1hsTGvuv8lqAIgQYqfKTEdE4cjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTuLY8XbggX2G4Eq8zXDhZKinWn+UOJT2VGMnVxkl03mQg17hqwXrVZm8MUrqjAdOSURjVi4WjLDgYUj3aQhwQBYTDiiRU5PhR2PuduYzqSPm2V/Toda9BzxCsYrk7FDP/movWY3Zu4ZGfzqtOUTPRgTamhjX7vL+HSsVsQYLLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZ9ip/mH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZ9ip/mH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE7FC4CEF9;
	Fri, 17 Oct 2025 15:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713729;
	bh=zlN5XZLx7Vy0hhYh1hsTGvuv8lqAIgQYqfKTEdE4cjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZ9ip/mHTjkzr4nX6lOQfWhxSrIHOu639R8G2OQoaZMok5aIEk6HkR21Xu0JzF8K2
	 kCZ5wqUqaM2AIZ02oC+NUkd82bONQlaD455wh+N4Wyzfr+wkCbEjDVgsSwRgkDD4sW
	 OsBjyNlnImDDiYRpThw2caslR201tGkRKFZALJ74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 099/201] kernel/sys.c: fix the racy usage of task_lock(tsk->group_leader) in sys_prlimit64() paths
Date: Fri, 17 Oct 2025 16:52:40 +0200
Message-ID: <20251017145138.386170973@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit a15f37a40145c986cdf289a4b88390f35efdecc4 upstream.

The usage of task_lock(tsk->group_leader) in sys_prlimit64()->do_prlimit()
path is very broken.

sys_prlimit64() does get_task_struct(tsk) but this only protects task_struct
itself. If tsk != current and tsk is not a leader, this process can exit/exec
and task_lock(tsk->group_leader) may use the already freed task_struct.

Another problem is that sys_prlimit64() can race with mt-exec which changes
->group_leader. In this case do_prlimit() may take the wrong lock, or (worse)
->group_leader may change between task_lock() and task_unlock().

Change sys_prlimit64() to take tasklist_lock when necessary. This is not
nice, but I don't see a better fix for -stable.

Link: https://lkml.kernel.org/r/20250915120917.GA27702@redhat.com
Fixes: 18c91bb2d872 ("prlimit: do not grab the tasklist_lock")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sys.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1689,6 +1689,7 @@ SYSCALL_DEFINE4(prlimit64, pid_t, pid, u
 	struct rlimit old, new;
 	struct task_struct *tsk;
 	unsigned int checkflags = 0;
+	bool need_tasklist;
 	int ret;
 
 	if (old_rlim)
@@ -1715,8 +1716,25 @@ SYSCALL_DEFINE4(prlimit64, pid_t, pid, u
 	get_task_struct(tsk);
 	rcu_read_unlock();
 
-	ret = do_prlimit(tsk, resource, new_rlim ? &new : NULL,
-			old_rlim ? &old : NULL);
+	need_tasklist = !same_thread_group(tsk, current);
+	if (need_tasklist) {
+		/*
+		 * Ensure we can't race with group exit or de_thread(),
+		 * so tsk->group_leader can't be freed or changed until
+		 * read_unlock(tasklist_lock) below.
+		 */
+		read_lock(&tasklist_lock);
+		if (!pid_alive(tsk))
+			ret = -ESRCH;
+	}
+
+	if (!ret) {
+		ret = do_prlimit(tsk, resource, new_rlim ? &new : NULL,
+				old_rlim ? &old : NULL);
+	}
+
+	if (need_tasklist)
+		read_unlock(&tasklist_lock);
 
 	if (!ret && old_rlim) {
 		rlim_to_rlim64(&old, &old64);


