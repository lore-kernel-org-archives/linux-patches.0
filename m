Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E64343E490;
	Tue, 16 Jun 2026 17:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629648; cv=none; b=CjCHnV8ekU384x1ecFAATTKWVvLQhWryEzf/udkLVHnozBKywnoZeMMEm8G0wz8dICM8Qw0T6gAjF8CepODmLa4Y8uUto4EmIrBMt/i+F/b//cvGEe40bDQSalv4plu/3yp1sj+63D5n9amRRA4ODTggmEaHswoI608tCpR8Y2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629648; c=relaxed/simple;
	bh=AUwobskWwtJ3/Gz4Ax2dMOJCvdE2pjWknut6vfH4CJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCEq0eYb9MyIVMTG6LW9C49fURN9tI181QvNEFvmqtnwyAucygX80H3R/o+dky8F/M1uBBHEZE9EQga9sKzmzq1JF+Ucaw9+uUNr1e7u6Gsw8bAJAk5b2JyLtEI0T7WsWDElSwRp76QvpJkqEvbhc24GnErG+ed5F0OXY95EIIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oz98W71J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oz98W71J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F22A1F000E9;
	Tue, 16 Jun 2026 17:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629647;
	bh=2xkf9b0gHZENkT64/dhLz24xBnYI7gjlmVBCXueQBv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oz98W71J4jg+jrb8PcvA3Kdhu2vUOdXE2zX76JNHSqJ1RehxG1WF+h0mUBqraqxJV
	 aQHf2whFJIjpDaqXkOZnXVkUfXcnLsixklPMiv7yyd3mYoUsc54vLlLfYycZPKEQhh
	 oczW8tK9018guYwZ2p8x75vzYGqWp+Wawanwg+Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 325/452] pidfd: refuse access to tasks that have started exiting harder
Date: Tue, 16 Jun 2026 20:29:12 +0530
Message-ID: <20260616145134.486586197@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -675,10 +675,12 @@ static struct file *__pidfd_fget(struct
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
 


