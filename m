Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5077237756C;
	Thu, 30 Jul 2026 14:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422905; cv=none; b=BrlM55sPe3eXQ7X3aJrgcjBNWT7FZAIC1zfSYmaiUg1aBowYaWsqr3A0lu7xp3iHIlBR8g2NNLI6L6yKQnIRVTwJYv4IhGeSATBJPLdGZ4AFs3eNtn5nEzAjFfQb7UKgQtl8e7uzN+foXTWlKjfIx8xW4lZDCz9Pc+Gx2C3CksQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422905; c=relaxed/simple;
	bh=dJdsQ4aEptnsUZgX1B4cZRybU8Jd74ky+CCDL2ydYfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZsb0JO/iQ7w0b1YfcZsm622u7p9iz8Zk3/KkPXmGaM9DgBJkpNKkgNRv+/s9eOgippycKsmxz/IcuTE+qN/Xycj5JnDkWYaKpXpVonSS7RvSYLyKvZXps1rYJUWBjah24HdcuVnQiRw2xDjKMuqKLvv8qVCw945/20l5SkU4yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xx/Lqkk+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xx/Lqkk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2791F000E9;
	Thu, 30 Jul 2026 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422904;
	bh=1/F7orJSHiJEI0ps/POya0o+PhE5qGAB0/IPF/2OWEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xx/Lqkk+NKIKrBXKNUZ/CO5rUQ6tLGYqebzAYYzq4oBrbFEoaZYtf3ghYYfZnzya8
	 6OlDEwAyjPuvTa6ew5Qj56WSmZ1Pa0q54zWCixSoA9gUdUkzmVJlK4ea3gkH+69Xs8
	 DCZvsBWcJifbcRjDspZpmNFShpdh8s7hTkLAJ6Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 595/744] tracing: perf: Fix stale head for perf syscall tracing
Date: Thu, 30 Jul 2026 16:14:28 +0200
Message-ID: <20260730141456.925631313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 2c2b322acdcc78575b8d6afa64a085cf92e03c12 upstream.

The code that can read the user space parameters of a system call may
enable preemption and migrate. The head of the per CPU perf events list
may be pointing to the wrong CPU event if the code migrates the task.

Reassign the head pointer if the system call event called the code that
may have caused a migration.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260724193210.03fae1d6@gandalf.local.home
Reported-by: Sashiko <>
Link: https://sashiko.dev/#/patchset/20260717173252.3431565-1-usama.arif%40linux.dev
Fixes: edca33a56297d ("tracing: Fix failure to read user space from system call trace events")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_syscalls.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1436,6 +1436,11 @@ static void perf_syscall_enter(void *ign
 		if (syscall_get_data(sys_data, args, &user_ptr,
 				     &size, user_sizes, &uargs, buf_size) < 0)
 			return;
+
+		/* The above may have caused a migration */
+		head = this_cpu_ptr(sys_data->enter_event->perf_events);
+		if (hlist_empty(head))
+			return;
 	}
 
 	head = this_cpu_ptr(sys_data->enter_event->perf_events);


