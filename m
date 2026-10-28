Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217186;
	b=NXsdnqFAghnTSoTAlc9W+g2Opcb1DQEP1IA/PyY7i94y+1yqYI3lX8KzRq/zBZqXBq2A
	 xXLZsOZeREGTG30LrzuaM8GIE/s9M7yZpVWj5aPvnzBj4pclwcHnkEB9/svqO7fmClUJA
	 UXROFoI72bueBFnunn5u3jsGoncI0eZXReZDBowM3J6ZuZP4SWUOAcXyMmz3MbHdbvc0c
	 N5zMHtqrOhl/Z/SRfEdbQkqxzB9wpyR1k0+Rf5oh/m9caBjMzh45DCQiYIJmnsbkx7XBk
	 BQtoN6qFgLdQbfi9zx4ksvKOgKs9Y9pWusDjKAwjVQ+UeEJGFfjj0gvN//hQHtpIvWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s5nLG+EFazdhNLthZuil4aMDWI4qMeVSGDr0fdkHZzQ=;
	b=FnGxsDmk7Rn7Ut2lr45+feGa7XngHbARwsba3ljwzaKtkgIoeN/IMaowHFDFoXxFCays
	 sWsaBuynf03nmCJyN/4+2falSneRaZaxXwjfBixE5XYTbz/S3KArpnjVNdI9Yb3Fg1hvk
	 tZwXAqLYQUqAHNkXOVAxg7s8hDCGGFs4uxRfcz9QaoMayHg1aJ20G/ccKUupHOUmqPerh
	 HaVWGe4swXeHRZI0+QQdUT2xRnDl9S+s/3wamk5TR6SUrhh0QBaGK3W4CD1lxGXPyFKNU
	 e6qSBTObAyWVSUCDSY0u3lX5v/t1kCJiv0/pXxj1O4RYX/NKXAPaNDm2Ehl0QD3ccNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOahbodK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4016606A31A;
	Wed, 28 Oct 2026 19:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOahbodK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4752A1F01825;
	Wed, 28 Oct 2026 19:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217185;
	bh=s5nLG+EFazdhNLthZuil4aMDWI4qMeVSGDr0fdkHZzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOahbodK2QCj4s95m7elHQxsWtUqjr7X3L7QiuhfCYfuDpbfnrY7ZbkC36FD9Z0rg
	 7GwQZCWFSlMXTldSomRPtdhhFDB4pkjzl5dKCp9WNhG2f5lQ77n3uqJihENLYOqwjy
	 KvkfIJlbmRMj65PEkXdREq9ZosJBWFsGbwyUG8rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 1817/1887] signal: dont retarget shared signals in a dying thread group
Date: Wed, 28 Oct 2026 18:05:13 +0100
Message-ID: <20261028170540.791728942@linuxfoundation.org>
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
@@ -2942,6 +2942,10 @@ static void retarget_shared_pending(stru
 	sigset_t retarget;
 	struct task_struct *t;
 
+	/* Nobody dequeues them in a dying group, see get_signal(). */
+	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
+		return;
+
 	sigandsets(&retarget, &tsk->signal->shared_pending.signal, which);
 	if (sigisemptyset(&retarget))
 		return;


