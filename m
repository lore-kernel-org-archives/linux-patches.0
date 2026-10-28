Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207369;
	b=2kPy7nXraiKCh9zL1nJK0moTlXOuEB6npBAOQR6ZilObcnX23YJbGN1jFjgtYnUd5yOQ
	 t845LkmRt5ljKF6qQOCvv84XlJiTXqWbSk86kPDIpnsg44NgvTGPiq2Ivkhx3FBq6HuJA
	 +KsQ6a7K86oINKle8/FXYGZXNZQC4rH/u3P14eldiGHSrVzQ7FtasdssmQKCJeQISNW6B
	 6h3M4Ks3mEb6BgptSZcna7+Jph2r+VZitkYUePbm6iaUyNZPqBiq28V2M1UL+EFp0h1Jv
	 aERPIzbhbpnVqPGxvjYhg+Sf01M8HwmEeasUe2jv5XQCS03bQk0QDTPfTRdU0/f06PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YPDOxJ6VjyJcujCABYbe6YFlyRj/lRI2JuQmUw3EPok=;
	b=MB6tawr8BTbPIU14bGhIj47v+y79e4mTIhgn7GDjP+uELGar0FR/cdxIoKngD8m4J7IM
	 VZ+cW0Z2zRXMDnuJj4mtYzFfSvzHAvcpyj5ujMxb/QuIOJfeTUZM+MXez8TL0fethbPZq
	 9Ps4QgJCphsKEKG8vo3yPCpA3Yech/IjUDxgYo5UirVskEq9a0CiakQZqbSuBwWQKWA9E
	 AIEeDUarutwwPfthJShppCNh5HpCpKnMdH1YDk8AuSHBTWjr7uoMyBJ3Aq2qUHsMH1JEA
	 Allz+t1popIKMYzEgKKyoma/9duQtGP7sCA/sC8uWGahEq1odxTZTtJWD+rIaQyeI4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PypIo7O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9A4606A324;
	Wed, 28 Oct 2026 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PypIo7O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C851F031E0;
	Wed, 28 Oct 2026 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207368;
	bh=YPDOxJ6VjyJcujCABYbe6YFlyRj/lRI2JuQmUw3EPok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PypIo7OpmLiZBr7GYFPvULChFeaxtEZ+0/GhAQDRtFHw/xk9olwbSQD+MJmEbnNc
	 7Bo1hMxDVrzHp0DRKly7onQLdN8G18S9MyijOqe+ZRMucDlzdTVhGWadzbP/GeAEpx
	 O13F+yFqMRjxMlmGwjMVRyFr9KiI7Fu2X561DD/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 82/88] signal: dont retarget shared signals in a dying thread group
Date: Wed, 28 Oct 2026 18:00:30 +0100
Message-ID: <20261028165944.043921245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3181,6 +3181,10 @@ static void retarget_shared_pending(stru
 	sigset_t retarget;
 	struct task_struct *t;
 
+	/* Nobody dequeues them in a dying group, see get_signal(). */
+	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
+		return;
+
 	sigandsets(&retarget, &tsk->signal->shared_pending.signal, which);
 	if (sigisemptyset(&retarget))
 		return;


