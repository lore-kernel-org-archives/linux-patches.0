Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208089;
	b=L59JSeGygHb5lMmCVgAXqiaUV8gsDsd2wl1ObTatPfLWLM/gLqyExN80S0jKVys9tRHX
	 qBQCkvS3cSUXbHMSSbEAIVeytLGewzLRFnHULg6ROMapvSU7heU46bsZaeCcyPMtNBpZR
	 v2NN29CSuehSPiIQatnoAAHVxXANmAGQrXsxIGm0NxkD54RyHnvb4Qy3XTv6M+ymsZsOG
	 SK48L3Osyz9i1+Ps06gzxS3iEvKjzJk5OV6sEQVIjFJyLHCck5P1ac9VrwNzJLpwRrjDQ
	 ohfsZN7lQlNXGyIz7GVc/Bj79w37he37mAFaYPTyoRXaRe1+Aey0asDFif3jaf6U/RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FZGP+7ggx7YpbhOMOZQ9oa+khMEjfwJG+f7w3WXTDy8=;
	b=whjbWILTwqVX4w9D6OvxGIlVNSurI57J4RKRyc+9bd3yPyc6vDNLGDfKtjlJPMfgS0QU
	 xDxRafCKSZI02GKjAO1aGzgMu/nPLgNyXFZb/s3ZY6MPo3QYG40dN2KVNkRjaK4Th/R23
	 0kJ+YcHfoY+8tXn40na9AVNZmXX3yakFYl0jQ9UfSyuUlMBFLkQgQveNeGFo8n28iN7kT
	 +/85wlmxfQWBoVcEP8aZpCUYE38Yd+uioT6jrFLLPTnEjgxTzZCiArBkygTdkqgvFyGCo
	 /7J+uHwdrVNeg+DquOc+xCHPlxrQ/9B06HsS0kFy5h3CbCbWQ8n8dTzNElpR50he3NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMbqja+A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ACA606A321;
	Wed, 28 Oct 2026 17:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMbqja+A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A459F1F031E2;
	Wed, 28 Oct 2026 17:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208089;
	bh=FZGP+7ggx7YpbhOMOZQ9oa+khMEjfwJG+f7w3WXTDy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMbqja+AW0o0gYOgubaKI8OaXXYoifEOYPC16ycYed7gvUucCETpg8NWzKt8s/+Xn
	 yGqNuDGe8fVlMfBUn5y8gkTKUK75QymB9wywZE6Pbi+DRvCvYvQizVOZ7KnR7lLs87
	 IIQcjrabXr3hw+mebmx5dopPZoALWqGdXcsTd6ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 245/247] pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper
Date: Wed, 28 Oct 2026 18:00:48 +0100
Message-ID: <20261028165953.222758255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 5c0985dd3c32fc2bbd0e8beaf13cf52cd97376a2 upstream.

Since commit 7fea700e04bd ("zap_pid_ns_processes: clear
TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING") zap_pid_ns_processes()
clears TIF_NOTIFY_SIGNAL before every kernel_wait4() call. Otherwise
kernel_wait4() doesn't sleep and returns -ERESTARTSYS if
signal_pending() is true and the reaper busy-waits.

But clearing TIF_NOTIFY_SIGNAL doesn't fix it. It can get raised again.
For example, klp_send_signals() sets it raw against any task that hasn't
transitioned yet. And it keeps sending it until the livepatch finishes.

The sleep loop waiting for pid_allocated to drop has the same problem
and it doesn't even clear anything. So a schedule() in
TASK_INTERRUPTIBLE returns immediately.

Use a no_notify_signal guard. signal_pending() will ignore
TIF_NOTIFY_SIGNAL and the pid namespace reaper sleeps until a child
exits or free_pid() wakes it.

Link: https://patch.msgid.link/20260824-work-tif_notify_signal-v2-5-6609e42b3157@kernel.org
Fixes: 7fea700e04bd ("zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING")
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/pid_namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -216,9 +216,10 @@ void zap_pid_ns_processes(struct pid_nam
 	 * kernel_wait4() will also block until our children traced from the
 	 * parent namespace are detached and become EXIT_DEAD.
 	 */
+	/* Task work must not busy-loop the reaper, see signal_pending(). */
+	guard(no_notify_signal)();
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
-		clear_thread_flag(TIF_NOTIFY_SIGNAL);
 		rc = kernel_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 


