Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207122;
	b=4KNEsfmTVPUY7Y2EytvXm7ZbsBKhdH0+y3mtd9A8lDX6b3XM7SDRBrFOcpDr09dlDgaq
	 R5JzA+BGS04i+mJt+CuU13QeYer6nP1t2HbEkL0+slpkBhjLdsPrIJPuBIkyNVbP7DOHl
	 iYaWnnXuZtzgYci0na7ipSAnAz0LuQGU8xR3h7PU9eHbBelg1UJWznSKpx7tHKD4/mil4
	 /OmjIMWm+J7EcwAI5uXSRHtYKLJl9iXB8EWgSv4h4gl+eKgHYC6RMBA5FTPURIBGopWvt
	 EbE3aLXeU8A3bDhsOzCvCrp1IyvchsGsqUVn57PQEDP8LDHEIDtAeHIq6kgHUYgY4fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bj16ipJ8+yFt7xaSMjlvHU2mH7Fqf0RgF6V6xw/qlOQ=;
	b=aGFRbP+aDUl8O2ddzHrDs5CvRIj74iT9HRl874pcugcl5dUQJL8siNmLbjNKN2YKwzhg
	 bBktbvqNO6cFgF/EEuXnzmW5qRrNy5NcimSM+GQoV7iI8Tl5t+ALEx7a5Y2jQdtPRXbah
	 b+Z8gF6+903gs/eWq3rF9L3qjrm28m631jPq+SvGjeI9hFb86jhqhPdcTtgH29bGoZL5N
	 6duz9IcuvbZQGD72+lWsvkmwc5ysEzxtXWHDAxX3sNzoGWCaxuMDbYGH0rMRx+UAQNm6T
	 jrCXqmNj3t1CmnNxh/hNT50Qcf22ZMrCBF6Li2xUlTmxQmjfJWx+XJUQlE8UbP662fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBaGZMOb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F19A606A31C;
	Wed, 28 Oct 2026 17:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBaGZMOb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D991A1F01825;
	Wed, 28 Oct 2026 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207122;
	bh=Bj16ipJ8+yFt7xaSMjlvHU2mH7Fqf0RgF6V6xw/qlOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBaGZMObCV4RmpDLgU2Wu5HyN4todM9befzC95XG+vQpKCfHNW71uVB3xANw5td3A
	 kzzoWCrCLnuB0OUAB8CHipjCvv7bjYj9cqVvgLyoOgPcxTJJdQOjfN8hr47ofKPxlZ
	 wTqjlW0fL16HK8einfXEC+FH9A9B/Csa3FIEZBbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 32/38] signal: dont retarget shared signals in a dying thread group
Date: Wed, 28 Oct 2026 18:00:19 +0100
Message-ID: <20261028165941.215770687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit c0e659511d4f49087da095a95799edb5b775a705 upstream.

If the calling thread has blocked a signal then
retarget_shared_pending() slingshots a shared pending signal to a
sibling thread. Today it only skips PF_EXITING threads but not a
coredumping thread.

But if SIGNAL_GROUP_EXIT is set no thread in the thread-group can
dequeue such signals anymore as get_signal() sends SIGKILL to every
thread and prepare_signal() drops any other signal.

exit_signals() also returns early on SIGNAL_GROUP_EXIT. But neither
sigprocmask() nor the mask restore in sigtimedwait() do.

Say a thread sleeps in sigtimedwait() and a sibling thread crashes. The
sleeping thread gets woken by the zap call. It restores its mask on the
way out and retargets a signal that was queued for the coredumping
process. That means TIF_SIGPENDING is set on the coredumping task which
zap_threads() had cleared. So a blocking write sees TIF_SIGPENDING and
truncates the dump.

Stop retargeting signals when SIGNAL_GROUP_EXIT is set and avoid
needlessly truncating coredumps.

Fixes: e6fa16ab9c1e ("signal: sigprocmask() should do retarget_shared_pending()")
Cc: stable@vger.kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-5-8e4adb1619e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3170,6 +3170,10 @@ static void retarget_shared_pending(stru
 	sigset_t retarget;
 	struct task_struct *t;
 
+	/* Nobody dequeues them in a dying group, see get_signal(). */
+	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
+		return;
+
 	sigandsets(&retarget, &tsk->signal->shared_pending.signal, which);
 	if (sigisemptyset(&retarget))
 		return;


