Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210355;
	b=MhDnA0LDQHSA6Jnl4ErUc9jSYPdMXC3ulXqYkzPavCBClGM8mDU1U3T5XR/sXpARa44i
	 wCIteyAumR4fTkJvzJkwXBUp/DUufnOvKjFURoHw7EnBXBkw4MtSlfPexR0F7dgTarpPK
	 1bB/WNj/CjIoGBnPWCVnP9dTd5Nzwl5BQzVPB8VQ5UHb3hKsWU//oZ7s1yRPGWHa643H6
	 TL+J2vxDu/lZHCno/JZvDxXdCSfeouvhtKvi16BXTT1IhkVSHrskzqb8gMtLAuUMeWTjY
	 oSaORdgKxMhW2JqNT04UNEPhwQuebN3z84N8i47LxeL96yN73Drh3oKr19z53FcNfKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yNZN295fnbDlehiyTFmRwuunko0sKLjbmWBKGrUrA68=;
	b=ahBMMCklEZjvFYFuHGgC0V6yaH3OyOJrPiRLbQ6c272fRDgWArljTf9V9Fwly0+mu8CF
	 DzK1lQ+b/9ara97qzu2dUu8mXePvR8lgVuZgB1qzqx29QbdrBrT8IBJzWWYcSfStBBMQp
	 El6kISm7KKnct9xVcM6BAr0HZc5CFFScJFLamF1qefXG4oenNzlJmWJZH2i+ZlzuyVJGj
	 hCYjNxB2kyYhekUc2iVgJ6HwieUf+CHZp2tahAVLj+spuWLXZbroCgUIw+IlFjacD1A7J
	 00esrQWoNRBTw4j8Iz8XIgcDurQTM86WxAN6OcAtUkFOmmZ5jRl3YWMcB3qdTcBGcxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOknpOb4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C20F606A31D;
	Wed, 28 Oct 2026 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOknpOb4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2061F01828;
	Wed, 28 Oct 2026 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210355;
	bh=yNZN295fnbDlehiyTFmRwuunko0sKLjbmWBKGrUrA68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOknpOb4zSHWrJ8Rt6p9iuWWyLFZRQkGEw62bLj6cHT77BnjpYiJOQKrPsNz5l38P
	 5a/3am+jAmlQzai4a7nRoPNDqOOyICY8rhYtFF2uRhwNC+IFuhKhjkjsHPZKuYDQQ4
	 JY60VD//BLTT0iLAZWAIf5XORyICK2o+V8zVMWKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 166/168] ptrace: refuse to change the signal mask of a user worker
Date: Wed, 28 Oct 2026 18:01:42 +0100
Message-ID: <20261028165947.016775930@linuxfoundation.org>
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
@@ -1100,6 +1100,12 @@ int ptrace_request(struct task_struct *c
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


