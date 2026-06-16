Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8B93D8105;
	Tue, 16 Jun 2026 18:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634191; cv=none; b=A9kY5I0tLsAAn3Z+TtlLF7IKucA9zrZ12EAszJF+x5U2UfZRLhViK2tyhM4Y/k3237+3bSrh3hT3mN9pbra6Cm2BIQD1YWFZXG4D6XFdxeeStsXY73uqj2Dp25Gjssk+3xMqU4D2w/xOYaiDXpNzijugdC3vxc6W+mnmKxPUkPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634191; c=relaxed/simple;
	bh=Vmq4zf1SI4/HIwvnSUTypp7OY8lm2hT7Z7c1YvpMRas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYcXScC2BRI/bmni5jAPbKXKdO8p5RSTB73Rnw8irIld7XO02GHY3QwoOQm7AYR3rlS5LMPf2kIcGREwQMf+A5NK4QMvtDp06ww3oBon+1wd8/BWVUfchCSbzFyl0hbZqTCmalwSQBPi2nQNnqGzaw3WiebgZ0FfL6qyz5KeODA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8gYO+RD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8gYO+RD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3E61F000E9;
	Tue, 16 Jun 2026 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634190;
	bh=JLbNuH9bvx9coV8ir4pcg4M8aAuqYOBNr7zHNsK4pY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8gYO+RDnGQ3HeSoNI9BeWYkZl6G/d5LRqt+qt2mgJSp3+7cvKTQ2cWvICY77vbbC
	 5Oep0LpS6UTiIQAMVCQqLhf7KyEhVavrBliAz9ZxsH2GNFx6y+MfzmNu7MnpKJ9K8I
	 HCcJTQIpLhv0+waCwezxAii4X/IuQdG3y0axH8jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 219/411] pidfd: refuse access to tasks that have started exiting harder
Date: Tue, 16 Jun 2026 20:27:37 +0530
Message-ID: <20260616145112.425957126@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 62c4d31d78294bd61cf3403626b789e854357177 upstream.

The recent ptrace fix closed a hole where someone could rely on task->mm
becoming NULL during do_exit() to bypass dumpability checks. This api
here leans on on the very same check and so inherits the fix.

But there is no good reason to let it succeed at all once the target has
entered do_exit(). PF_EXITING is set by exit_signals() at the very top
of do_exit(), before exit_mm() and exit_files() run. Once we observe it,
the task is committed to dying and exit_files() will release the fdtable
shortly.

Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260518-obgleich-petersilie-2d77ccccf9b9@brauner
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/pid.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -637,10 +637,12 @@ static struct file *__pidfd_fget(struct
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS))
-		file = fget_task(task, fd);
-	else
+	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS))
 		file = ERR_PTR(-EPERM);
+	else if (task->flags & PF_EXITING)
+		file = ERR_PTR(-ESRCH);
+	else
+		file = fget_task(task, fd);
 
 	up_read(&task->signal->exec_update_lock);
 


