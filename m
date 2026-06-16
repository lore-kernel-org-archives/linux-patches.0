Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AC644DB64;
	Tue, 16 Jun 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627431; cv=none; b=B0IlVce+7zX+qOaBar7pukk/18ZJeOCZy3+mrs3J+TmsKgJ7A6tyzxAlu04ohTBmaPDYq0U9AbjYP1iU4Owy6m2DbVPyGvXwKEwYp4iv8azHwmxo9kbIQxUfcEDemKg8v7rmgWEMc4mC2a1Id2AmbftYxw0fMV/JkOCQY7pWbOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627431; c=relaxed/simple;
	bh=hl4h0bnrt76QXDyP3bwReIxfEt1z+7B3XrrsSS6vvaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7ka0MwkUhhmOHda8naICoq0bPyp+3UF7z2sLD5W+kNdeLKPFGHnazf8AvCepeGPlyWKdibDuJfmU8QNc6XCRL5ZqsZSdmRJATyjykv+dZyMHVMRrHJ9DLEocD+TeM/NjF+mb1yHvixNWQNcaxdogSs0yILjoErEg+Y4Q6Ll4HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNGGuyGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNGGuyGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0157B1F000E9;
	Tue, 16 Jun 2026 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627430;
	bh=G+7lNwwYAp2lCGzVBop2FHXYZTZkNl9f58M/ulB7PZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNGGuyGnX6IXgvFzUm351cl78hqWrp1gxO5Fc6KH5n+rM2L9/oTm0SiQ6+BKIRyjE
	 3bOPtn7QGY71edCbTHrwwFof2/saoyNbN32wCUudPLaoDEBUrccwyFSj+4T/DJF9dM
	 f/OPlp3eIhG/BA3HDC0j4Nnd050SQkV3L1dTUnO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 169/261] pidfd: refuse access to tasks that have started exiting harder
Date: Tue, 16 Jun 2026 20:30:07 +0530
Message-ID: <20260616145052.904014255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -674,10 +674,12 @@ static struct file *__pidfd_fget(struct
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
 


