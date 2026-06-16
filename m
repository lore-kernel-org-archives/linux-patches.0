Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464FF47CC7E;
	Tue, 16 Jun 2026 18:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636326; cv=none; b=lZHJlQCDa+PXI18kcXpElpL1Mevk4r4xPDj3R7ZCE+GUoV/gVk/BsLE9HncNJuUaAxrWmjMXklZCzPyiRGltD7MX4VC/vr65V1uEYYbPfSj9VG8wzlmT8pMyLhX0oHwjXrwHnc2m1Yy1MnUNmc9DbGugOtPlKeLm+BBJgAsbs7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636326; c=relaxed/simple;
	bh=SUOPQJBXUqQQg+E4L3Qg1eZ6frOIzNoSmZSPY7F3Nm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOm4I8GdgYTe2hJOH5QaMMmKKFJp+Z5WS2MvHclYnJIaRFYsAZBptdFSJ3ouzSAMrKq54QmoxojXxEVPFHsCYMau0ejJFbW5W5eu6j0oR6WnlD6Pa4FDjix2xE70yjffe75OfN/+Ss9rYuI6QeKdpcsdlTVCTsIedp5cK8GY0R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztRm0uu/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztRm0uu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0960A1F000E9;
	Tue, 16 Jun 2026 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636324;
	bh=ytp8n3kisDVNucRaYTGzpqraKRaTTfInIDvp4hmfNQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztRm0uu/rCCwVX/0KvbSgSrutR/jlupUC5ZMPz9tjgR1tYw25QvENRw3TJAAula+e
	 gZbyorE1UJJYAKrWdtblNI2J+JK94MWSjeAsOpe/uyANHwPiW6b5JcXvmf7/6F1Wvy
	 vqzEklFVSS4K1N3MGSLWQE8vx3JodAIm2TTO0EqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 192/342] pidfd: refuse access to tasks that have started exiting harder
Date: Tue, 16 Jun 2026 20:28:08 +0530
Message-ID: <20260616145057.121158054@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


