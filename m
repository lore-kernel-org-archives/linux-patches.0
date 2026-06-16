Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7501444CF40;
	Tue, 16 Jun 2026 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626005; cv=none; b=dI4Im2S/usv1t6WTYef6njlhU+KsRwUC4tBlIspQMlr7v1L6cA3yrekHbKf3sgaSF4PS2FEoskYvIPugIuir96jRtwowoks++c2kOvMrkSJktc2xt+C1mvi3ox43FpVM7mqsrlF5VSLyONzlhFHdTQLzETi3d4rynntiolDgr/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626005; c=relaxed/simple;
	bh=5e3yYdY1sCQuwcjndES5xtu3/cfXvk1sGGa5Gm9EWd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+kd0jzasKl4tjARqLKA+6dV4Vr0DJpbF8PyQjbTRQ5hxA6dpA4BVzbAmAmgTs5Wt90COLAKmqRubICKQjmaN9Xd3Hr08PERKIzlHTPh1ntl0FENQoMeNt0rve1rwoyoUxKk+dEY7fm4i0dYoBQjlvycWm6fQziRp2cr5LZpH3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmQFGcoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmQFGcoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F321F000E9;
	Tue, 16 Jun 2026 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626004;
	bh=4jpyX3AgvZqWFt+NwDTraPXsNxF/mpwb+L/Ep+stLkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmQFGcoC0gRdA+MrkXArt32ITH75n53IpfWZ/0IRhRquXyB2Yax9rp0YwUB+V+5XG
	 OZqGUlMNDUovS4pxaMKxoIFFC3y0JcNNbL0sLmKqiZOZlYPUyXD7pahiKgYpwxmwvk
	 Ub98fVKhdfCQbrZJZXk7ZXs2aYingj1DbYstsgWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 215/325] pidfd: refuse access to tasks that have started exiting harder
Date: Tue, 16 Jun 2026 20:30:11 +0530
Message-ID: <20260616145108.854395587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -836,10 +836,12 @@ static struct file *__pidfd_fget(struct
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
 


