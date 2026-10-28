Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208084;
	b=TZaWdRNbcWiicB7B2yEkotWv9m2q6lVEG5A4JKwbc0fSs91+uIYtYMlB32s1vx28Tslk
	 sPzSLhdT03sT+7iFefeqsb7J4kcS9Dq71bruxuswy7KGgkBWAad3qzl0qY1Srt5v8++YM
	 S+yYnGHHZ2k+L3vk9b+F7Cjs8gfCAjMB5MrpiVpdTQlLFGfns93Vcq7YrHnBlLfsBGBDq
	 938VlvYW9is6ld1Xnxzy7A93yNYCIGM1PUpMzQxB4MoZ0kDiI7jFy6k3/64KaPF7JI6G9
	 Z2WlqRWYHWTyeyuE9MdMT48fWaqhCajjShRwZX0YN00Dh9t9+HVNe7xwL5BeTQwAwGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5EbMWu4LR8lIx2MtRhx9d0nJmsFgnTzBdeBasMx5+pI=;
	b=P21A7l9UkyJkkUaBJed6pLA0fFHc7fLJPsdaAnxh80k4sEbjsn3QGnY/xwvyiHYjVmPO
	 lq8cHKKvMl/XCKpTbUYuy4MrZvwT9/QmXZoXUlO/WZFrp34Y8m7y0rYyxoztk2ENJXV56
	 NYHO4BTFDOj/j5rVExi8IMtiqW6BWtCeZxWDOdhRgqLVX9cir89wklJJKPHld2GYO3iJN
	 6i3iDhYwKv1W0LcYYYuxdnaAUd2MMHm3BjmLJyrGmFOKfYrtwKXWAkTiRHeME0RjHqY54
	 qOYxh7jnmGQW3hFTTMthmv7q2EDMZkaBIOZd5VrkCh2vOrQWvuhL3KpU5ys+Z0Idvxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0deJebTi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5975606A31C;
	Wed, 28 Oct 2026 17:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0deJebTi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CD71F01828;
	Wed, 28 Oct 2026 17:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208083;
	bh=5EbMWu4LR8lIx2MtRhx9d0nJmsFgnTzBdeBasMx5+pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0deJebTiWpTNRdUoUpDdtLY8ja96wLnP9tDvc15UoqjHVhDoRqHlTXf6TdIFTxLZX
	 OhYo19+HCzHmPrqZjputAkyFQ4FgrQqaeHqEzq6fQ/33wW8EkFKc22adlz3+DfmULH
	 LopCsbiFayHbnt6JI6mJAF3ju9YPqWBjkztWQMPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 243/247] ptrace: refuse to change the signal mask of a user worker
Date: Wed, 28 Oct 2026 18:00:46 +0100
Message-ID: <20261028165953.176951774@linuxfoundation.org>
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
@@ -1086,6 +1086,12 @@ int ptrace_request(struct task_struct *c
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


