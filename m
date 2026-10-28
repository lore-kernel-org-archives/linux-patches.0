Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217189;
	b=gExkUy8B/LEMU9n0g+WdR75g45A9pfn4dnTwGz711YhbzT/zqSkF5A9Tp2Gs9NNvTj7h
	 ztdjqQbBYDULszLRsnysqz048aM8t616h9vqTdsngBUfWhv1tpP4rFUZ6CMEs9a081w+Z
	 517FykrOCqduh/1Y93M414JdJrup24IfUlXZFZc4jTn4bwIXpjlP2D7bfsEBBf+WIe5Kb
	 Geq8zRBUvuI6kcDnbSGtga8l3F3Qn1j65Ud9kbrh8OQJVSbcztWEssmct6upPMvXrGtET
	 s7nKIW5RJDIFCzeVtRyA1pTeDmlsojnvgFY5XtYX3qwkscdZmQLlKGeyjIzyfrDNsvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oeNE2bc1M759lGdiuBvfhJ34gya9ALS8o/5GQ+NWbQ0=;
	b=dIuNch5fl6jLlYy8aJfScEzziNbr4A50CA9bdJuMzY+BvQN9QwErWV0L/2b4DENLW/Kc
	 7ALDrze1mpcqHbZTnz1yUxDYbmVkC4UIezeRSDFD50qQdjPXgRQB7kGdfyc5hVpqNDqPc
	 +RYDvZb2rYuMPFDhdBS2soYT9o/LrKwspBC5ukPQIEqr8OWHPHOHeCBGfzhGIOoKda/LW
	 6f7O/h3nrdtlaH3mvzeBfD9JimyV3m3U21iexmYmEmsttD+kTQ8fsDUxKVBswDg29G8R8
	 P98DkALasrWsnhCgxAR+/3Av/zQs6yAH5S5lfLLK/H1L8t+HQBHRb80ehoE5q4Zoxhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YrSDKhxX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05813606A31C;
	Wed, 28 Oct 2026 19:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YrSDKhxX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4863B1F01825;
	Wed, 28 Oct 2026 19:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217188;
	bh=oeNE2bc1M759lGdiuBvfhJ34gya9ALS8o/5GQ+NWbQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YrSDKhxXrNyHf0D9YmHC4KPV7fw4s5qGAkWvmtmHoAbBYoTQhY+Kuc27pumd63CNJ
	 UXZqO/A4nalxeccWUG8vr2aDDU1iTUm3ZNABRKM2iia5lg0IkP91V7ULfAz0mykQht
	 c7XAPWdK9JOg4GghLu2xEUAhxj2v50FLTordsl38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 1818/1887] pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper
Date: Wed, 28 Oct 2026 18:05:14 +0100
Message-ID: <20261028170540.814154371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -212,9 +212,10 @@ void zap_pid_ns_processes(struct pid_nam
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
 


