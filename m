Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210244;
	b=pq9vrArQ42L69Lt7Da5DeOc73fdpnPGySyzToos+Fa/a7n9fpyK64GvaGbk/FoygeuEe
	 eTtpFXpb0Q1tg+SWxOQcRVP1lq2REZt/0L1wpVlZ4VMz1vZm+BbQiZt8Xcbv0f4WEJhie
	 gAOVcF2weYI/WbVkewFkHvauZlx0IkkcLlMk/w7DryUjUCLaMuD+YuPOONXkPnYIpPdcJ
	 Yi6XF89Jq6hkgw7Vivzy1RcbXfrkpkXmL+5GtRr4WWgvb/e0S2YfLJXrx+EMKgbCW4S8u
	 /89h0esCaV+7GtrDVobOor36arQ9G8vW+TIN4kJeRgSleC2W+cqIk6roJKiiGfi/XJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z60EqaNBoS0143OBnxBFCoadIQquTbXq80E49gwIFFc=;
	b=PCyldzBPgF/hTzdzkwaaZzVitFnxes33w1W1oyJ1edfPpKzdRqRWxsfFvbBHJLZI7I++
	 mfHQPAzZGIVTFLooiMJevpK0e/596VjsQXfo7ayVOg6/1NgVuZ4SVhgspSoJ5dDJubJ2B
	 WCvvg0v2lWMR15rBY2wtzuidhGFSj39MMd41MH+wY/yLLjL4MqKu/IAReIjpWZLL8sCGo
	 QFBa/0IXQoCMlAyFwQKhxyceD4zuDcuVgR/I8ofRHe273IxLFe6SEnGJtfww7iyGoOXEU
	 K9aLrVtMfIh1dyV7VSZKV8LDts6t6tK+Nv45p2GWMqtqV12ig+U+AhpnZ2nhhf5uksg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/RPR4ms";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37600606A323;
	Wed, 28 Oct 2026 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/RPR4ms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892871F01825;
	Wed, 28 Oct 2026 17:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210244;
	bh=z60EqaNBoS0143OBnxBFCoadIQquTbXq80E49gwIFFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/RPR4msVUpT8aFbTZqkvzZEP/KnylkwiJKBebtye1EEk77lxPETCKGAMKtCSrxRp
	 Oh3dSPbkpz0kR6fITe8PUXN54FYDBeybBzTWwAGxmxAny9RYFoZQCcvttpFG1VZgk8
	 /mr1P/tcw2HXcvDWKJJ6suJR0AYQhFDNwUH5AObQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/168] exit: move core of do_wait() into helper
Date: Wed, 28 Oct 2026 18:00:36 +0100
Message-ID: <20261028165945.454652960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 06a101ca45b296fe951692620b0bc49abf90c368 ]

Rather than have a maze of gotos, put the actual logic in __do_wait()
and have do_wait() loop deal with waitqueue setup/teardown and whether
to call __do_wait() again.

No functional changes intended in this patch.

Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 81933038f5e2 ("pid_namespace: make zap_pid_ns_processes() freezable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c | 51 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 55a8aa868298f..07a17f0916107 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1590,16 +1590,10 @@ static int do_wait_pid(struct wait_opts *wo)
 	return 0;
 }
 
-static long do_wait(struct wait_opts *wo)
+static long __do_wait(struct wait_opts *wo)
 {
-	int retval;
-
-	trace_sched_process_wait(wo->wo_pid);
+	long retval;
 
-	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
-	wo->child_wait.private = current;
-	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
-repeat:
 	/*
 	 * If there is nothing that can match our criteria, just get out.
 	 * We will clear ->notask_error to zero if we see any child that
@@ -1611,24 +1605,23 @@ static long do_wait(struct wait_opts *wo)
 	   (!wo->wo_pid || !pid_has_task(wo->wo_pid, wo->wo_type)))
 		goto notask;
 
-	set_current_state(TASK_INTERRUPTIBLE);
 	read_lock(&tasklist_lock);
 
 	if (wo->wo_type == PIDTYPE_PID) {
 		retval = do_wait_pid(wo);
 		if (retval)
-			goto end;
+			return retval;
 	} else {
 		struct task_struct *tsk = current;
 
 		do {
 			retval = do_wait_thread(wo, tsk);
 			if (retval)
-				goto end;
+				return retval;
 
 			retval = ptrace_do_wait(wo, tsk);
 			if (retval)
-				goto end;
+				return retval;
 
 			if (wo->wo_flags & __WNOTHREAD)
 				break;
@@ -1638,14 +1631,32 @@ static long do_wait(struct wait_opts *wo)
 
 notask:
 	retval = wo->notask_error;
-	if (!retval && !(wo->wo_flags & WNOHANG)) {
-		retval = -ERESTARTSYS;
-		if (!signal_pending(current)) {
-			schedule();
-			goto repeat;
-		}
-	}
-end:
+	if (!retval && !(wo->wo_flags & WNOHANG))
+		return -ERESTARTSYS;
+
+	return retval;
+}
+
+static long do_wait(struct wait_opts *wo)
+{
+	int retval;
+
+	trace_sched_process_wait(wo->wo_pid);
+
+	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
+	wo->child_wait.private = current;
+	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
+
+	do {
+		set_current_state(TASK_INTERRUPTIBLE);
+		retval = __do_wait(wo);
+		if (retval != -ERESTARTSYS)
+			break;
+		if (signal_pending(current))
+			break;
+		schedule();
+	} while (1);
+
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 	return retval;
-- 
2.53.0



