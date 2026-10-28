Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207125;
	b=erTrGS6UY+CZkVqpba1bC5zJRiaSqjtDbL3va6RmbpslloPT2IkQ/LfSeKDdjOghbpYP
	 td6zdGSQsjKZ2Qm2HuBZJVokO+Ch/WMYdgtyD3J4dg14Yqpo6Q8YvlIkIR6oXv9y3j8Jh
	 gik/IB0ZOc4NicfwRpYARz4PIxFAGH7WkMHt6RQ9COAovCprAJBsJCfw0xAfhM14r4t+3
	 aOqckT11ErLq28XNaJPNdIWt/YRn3nkdMcNX2/DwoWQrBmqqrJvTyneyw8+K0X4jY6m/v
	 kLpoebnI7Us3zFPwnyvknVM86LBnAS4PxJyLvpbhYaIPeefbA/ljUVtHrMROjE1kL7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SNJCkW8hB+JZUkPA5B2Ul9Ku/VIpc+obKCfpSw39GtE=;
	b=Xr6Sed5LkVOFLH49Qq1dn4ij67UYSzmQmrHH444h6cir0oN1JuV3TetcSLKMBuF5TcDw
	 zyAjCH1IFM76PQkRqXrPECspdpLmuY8vAZB4hgqmAsuw6UHc/9RRR2QJc1UN8NTMrOSZ2
	 QlpkdYFdlYncIDN7VZ5zpquJHcqOxs8Ccn9VDDx7WYy7JpvuS5WkbkRDv9Q+4V+DODWK1
	 xrFSTKSDKqpe8rpi+u3BGnVvY6pGclmIO6HPt3nwgFw+Gp4qeitl5HkGXo2axnzLhppbK
	 R2reEw8Ox+uwUDyrySR9oRJnJlT3WckJBiaNJGrZ6P+UNmleg6SAcxfShqEn2YJkx5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNFd4DFo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C731606A31A;
	Wed, 28 Oct 2026 17:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNFd4DFo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E59D1F01825;
	Wed, 28 Oct 2026 17:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207125;
	bh=SNJCkW8hB+JZUkPA5B2Ul9Ku/VIpc+obKCfpSw39GtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNFd4DFoGLixjwBt7ylnZT3nQObQamvzWaHgTCR9k3SL6jg5mFtKjyiipGU8LnHsH
	 GErlwr7Uwz+w74o+uM0TWhzgeG6pCUbMbWRP6Eqxx/FFjtET2AK+IW+IjvFW12BVmJ
	 WPauMG8l0IKdVzFKL8FL9XPkgjHDoOAf3XK4ELIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 33/38] ptrace: refuse to change the signal mask of a user worker
Date: Wed, 28 Oct 2026 18:00:20 +0100
Message-ID: <20261028165941.238493111@linuxfoundation.org>
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

commit cabc249e6560bee7bdfee9fbcb7ce4e951dcfd41 upstream.

A user worker is created with every signal other than SIGKILL and
SIGSTOP blocked. It never runs user code and that mask is what keeps
get_signal() from dequeuing anything else for it. complete_signal()
never picks a thread that blocks the signal, tkill() queues on the
worker but nothing dequeues it. ptrace_signal() requeues an injected
signal that the tracee blocks.

PTRACE_SETSIGMASK is the only way to change that mask from the outside.
A tracer that clears it makes the worker eligible for every signal.
Whatever the worker then dequeues it can only act on by leaving.

Refuse PTRACE_SETSIGMASK for a user worker with -EPERM, the way
ptrace_attach() refuses a kernel thread. A worker is guaranteed to only
ever dequeue SIGKILL or SIGSTOP and an injected signal stays pending on
it, which is what already happens when the mask isn't touched.

Taking the request and quietly leaving the mask alone was the other
option, the way set_current_blocked() keeps SIGKILL and SIGSTOP
unblocked whatever userspace asks for. But then a tracer gets success
back with nothing changed and no way to tell that apart from a mask that
took effect.

Fixes: e8b33b8cfafc ("Revert "kernel: treat PF_IO_WORKER like PF_KTHREAD for ptrace/signals"")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-9-8e4adb1619e6@kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/ptrace.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1227,6 +1227,12 @@ int ptrace_request(struct task_struct *c
 	case PTRACE_SETSIGMASK: {
 		sigset_t new_set;
 
+		/* A user worker only ever takes SIGKILL and SIGSTOP. */
+		if (child->flags & PF_USER_WORKER) {
+			ret = -EPERM;
+			break;
+		}
+
 		if (addr != sizeof(sigset_t)) {
 			ret = -EINVAL;
 			break;


