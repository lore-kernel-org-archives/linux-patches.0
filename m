Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F8138837F;
	Tue, 16 Jun 2026 15:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624021; cv=none; b=AtHKsm/LNsUT1LIwJGpIfUgk8TM/Tl++/d0ziVL0PKA6kvHv7EWtxiJTQB0L3l3hUCFVoYPuAbZBbGW4JUY0Ut6iUNqaYRhOJzjeH4rng1OvBJGfuSZJYs5jsXOFcKnI/UJQRnFc/h5RnQFtrpvySoLhl7NnS9HVY+h6d4PF0bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624021; c=relaxed/simple;
	bh=CjgPnMW71Q4gHGPWkjSva7yKrIoN0IKmg0dXowjQ1cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkCvHidm0/FGS1t9/ykcJLtU3GJuKOBEtLtMhUVImuD6ZleliLkp8r8ZZ/XSYUA5QrG2NZnffWzTfo1ugYoE/Fj2K+fNikgguVf698sTmwCJVFDOyDKKGMYaKRA2pV12MjagrVh8mcAeTcaH0A+oFB4U/7DBGggSLuXrngyqpEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGmMH6h7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGmMH6h7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5DF1F000E9;
	Tue, 16 Jun 2026 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624020;
	bh=X9BPs0/KkGn3pPKoqQc9QubUXcyH+bxpjzjIEG6VwSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGmMH6h752J2H7nnx/YoShLZxmLubFP4XYPNT0bcUh/Kwee/15wpmp4UH9V70PQNs
	 wzOHFAECla9A9F/MpIho4P2km/gCV3njuwJyef/wLLZ3Ied7uYYULsCzMZ0XsefK/S
	 /jI+yUqfzp2O0F4rsUbXbi0YJdt9T8PUTCNGMnYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.0 257/378] pidfd: refuse access to tasks that have started exiting harder
Date: Tue, 16 Jun 2026 20:28:08 +0530
Message-ID: <20260616145123.649831527@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -878,10 +878,12 @@ static struct file *__pidfd_fget(struct
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
 


