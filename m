Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207372;
	b=eSh53CoAaJ5lFku3gNf8r007yIKAvG5Df89Iq4dVADR/0rPSyM9mc4UFqzBJ2gN6R21M
	 ZehbH8h3RwvN52MMvxO2hoWV7EYb4piID6vKdA5SCLO8ej44gIx+1bf1lRgogB3DqG3gC
	 BlO2CW0ixn9IrGWEBuAiRMZ/uJrX/D6lIzX2QAcdCx/Up6d7btVdL5QSv2hZAAtfOC9dA
	 cfkz/xeZuahuRtJBks91vZLHH/uV2qgIDUUMEJMdcP3dW02t+JTNiMygedEsbtS1AhcCe
	 tcX00mv9s8LbtnZVuA/c+pN1UNp52bmImB8SXW4nOETQPPMVHXjtsl2kjUGlJ5Mvh+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0i+6DK7NGczJjNuwmVcQ08skDFcuKkpVc/u6/DpP6Dw=;
	b=L8nMzv9970rUFNZ+s4WUXQdynqWGhp3xhi+pYdXJO+tL5OWjD7ndFRalCARelmHBQUod
	 KxOFD1CcoEixo+q6N/hhZ0GStmTN/HrU+i6zo/vpbVfX/O1lq6E8JiT423BFwCHo0olw6
	 vcFnrPpNAwu4KOCewfcN23E1zonBOqy0g52WV5XrKJNySZAkPsjE8ngSHtYTGcK+7WNla
	 k2kgzQwu320JP71CT5trNgcdqrWZag4IuzM8GA//BtWM+Q/UJmRRpKfCANOYs+NidmfD5
	 q4D4kofrJCjBn0B32uXo1uXHXpk6PlTflg/wCTAF0aEpsK1HmPt/815XUv54vxQNs3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2eSBKhgA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D99606A31D;
	Wed, 28 Oct 2026 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2eSBKhgA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010651F01829;
	Wed, 28 Oct 2026 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207371;
	bh=0i+6DK7NGczJjNuwmVcQ08skDFcuKkpVc/u6/DpP6Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2eSBKhgADESPvP3ziUGH6AfTcmE1hUQO0yzZesoCYr21dp+ncbelElHrNEV3vE16t
	 PD8P8piHm/JNf+kXRSgAPcYbOzO3670YCrH7X5rVA+yCpOKUZrYr4JgQXl+v8t8iZ2
	 I/c8wIa2eblkRiB5uf3NuCg9KZX7mKMaEU5vyiWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 83/88] ptrace: refuse to change the signal mask of a user worker
Date: Wed, 28 Oct 2026 18:00:31 +0100
Message-ID: <20261028165944.067513994@linuxfoundation.org>
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


