Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E20C47CC81;
	Tue, 16 Jun 2026 17:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631821; cv=none; b=YsxsLhlJaYL9+fyqmd7NjZ3aNL6+UZTnsxYeiNNrDWCavgU5j6LsZl+Mjfe6igg3fs2PrStA+h+B7cdxPsvQVdWwEX1detKm0ZV0KPCMnBZxCnDSMATKZ0pnsAYNRDlVgG6pe4yuYkfK3sRQYVxlBsZuyIHuT/zK/xpPSuTvvZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631821; c=relaxed/simple;
	bh=01LvV7b3RjHgCTwtmSzY1bdPYOcwmJACFyGQVhH3yDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFHI+YtgW2oZdToumWKMI2tIk0J9JfIXcEzVDVIESsRL2qrwcR20F3QFsYqyd3jYcJzKmFcIJAKNvixBWJX7amYLeMyldbfOSF7WR4fl3K7qBw0M1RInTN7fxO5g86YJFCrTcYc5NASSmFJNZwJ3bg9wpU+oXPQ4OuHg/nytbkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwCMv6eN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwCMv6eN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBAB1F00A3A;
	Tue, 16 Jun 2026 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631816;
	bh=gn/gm2l5bkOnZc93slyAq78ivQm8+F2ktrMFJvVKpao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwCMv6eNs42+DpwBqsCLXwlh7fxLRvi3xRUpz853bnZyZ35IPkc9X0Q0dVqQbifyc
	 8uTtpGCV1ouMVntB/uaWfEGxMOpELK0V83pFT3NfWRVc88X0yRV6WDqBvP9nm6YHbh
	 jGuNpaEpsoBMqo+Qlbi+WQQqt7ynq2u3LD2J5NG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 293/522] pidfd: refuse access to tasks that have started exiting harder
Date: Tue, 16 Jun 2026 20:27:20 +0530
Message-ID: <20260616145139.634451079@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -672,10 +672,12 @@ static struct file *__pidfd_fget(struct
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
 


