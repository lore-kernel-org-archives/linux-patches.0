Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209874;
	b=FzRSLi2QknCnU6Qsw9uhFA6V9MmmQrsKmpIYdpYKyNduuDFyQBmLHRqmuy9lDPZ/dHP7
	 YvOnmnZIOChv362Aw+bFZS6MIEMN3jWAqDlV5nyazSZ1TjH96JhGeUB338rw1KRw8ApWv
	 o/U66Wet7wFWZez10Szdl8EiCn/CcBS9bXqrkpJW7TNExwXkn3KaUrd1/iXge2ncPLGvJ
	 MBEpcYLNtbx7ZuealgAtSDB5chofqjLRuQiR3XmZ4htVQpOfiFNgQXhs56/PM1M+dJUQI
	 sxLnXq9nkXL0zDsKgru+A4Pqtg9DPE8EEwF6QDzlkDoN4Lnxcl8RNQceqeVrCE96WuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mIW5ljyzbi4w9vx6hffHfu6+S3VY6wVnG3on4hJTHhk=;
	b=txDGA0dkpXjkg4u0bnGFXdHlR/sZY4qO9gcc2nEtUCQmsgEM/47YaOH50qDkA/zpJ884
	 gHDhNVRv+UQi9uPtSvzmumDQFrrYkMMrzUAFUa8wlROjqt2HFQW5NWahAwtj4kRdbVlWi
	 xWC0D+/ZmCIlfNo2jFLKFCHkmU/gleCUYiFoNDgNcbg+6FvIUXuawCG/RnhAeFotTCTq0
	 E+n4EnV5QsWZH+XFZSqmZ+H9iPvRFH3c5IvRgo9FTCmFomYUEcY4kKxPObdVL/ep91aek
	 wtDLcUIy5BdRKD6DSTiyJXTz5flpGNflToLSla3LRJPIw/1PGlxPjhwyE1n9iM+KnNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYJpPVbQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DE2606A31F;
	Wed, 28 Oct 2026 17:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYJpPVbQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766111F01825;
	Wed, 28 Oct 2026 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209874;
	bh=mIW5ljyzbi4w9vx6hffHfu6+S3VY6wVnG3on4hJTHhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYJpPVbQiSyjfzYDJd1YSTG1sKW9ROgjWWW4rmu4V7AmboKlH1O2xSHVSHWs2HrWI
	 vdn+87UUQ4oIJbG7HSgYXO4QGKh3ZNrG0NE8FtsgnE27MWEfirfP7tsgMiXPxWkr89
	 /frsa+ZFFN65RnNmaF78v3mWfo/hGkNVZwuZqfpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 107/109] pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper
Date: Wed, 28 Oct 2026 18:01:31 +0100
Message-ID: <20261028165944.873935690@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -238,9 +238,10 @@ void zap_pid_ns_processes(struct pid_nam
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
 


