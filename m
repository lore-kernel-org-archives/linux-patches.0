Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207159;
	b=lHxOWQhhH1BS4Boe50nZuKINQpr77v3togwDU8GBxT2VOif8HHAwL4CxH9CJhwatsSSv
	 0999wFX3ZIaM6NboKgUmBF0rOvrgzY+1yfjgGNx5E5T1GyIryUHBiuWATeSxfGDkj7ncA
	 mrYewUka6hMpamIZMxJibdIJZ8fS9dufYJmgh2X3QRmUKdoQqa2e2boKxoLu+DYIf8jdB
	 H2pdtWx7r487nKqfK8U31mv7XXZ1Q1BriIg4BXFZ6OAiBdlhDe7+SyKCxTTLWurHMDybo
	 7c+K5reLSYInS8fYwqxZEoL+LdZNDtr0/LS9FleWOepiPhqnveOBX34c/cRadjNU7dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jdznxU7g4kqW1IBbLMxQwY22NoQsIMHVfJjXDhvfRTQ=;
	b=vRcOiAKgdBGfZzy6RquzvGJ3K9eErYvYT+oBgEvayjHuwREN24QBoRtRzK8larhAmsGL
	 Ef1jDorKdUiWQtkVcXw0JqMTZVxAFdntKXaW5OMn4iG8JQxe0CL1gSqyP/JSFoOWXOKQm
	 z+u3kEjjqkeAXFDJVtRkFlqekKfIu0MuVDMOuJtjGN4ipl71syW6K0jKPaBPixbHZ0EGo
	 Nsy3Pq4l2iK1q6C/jPmqqpgu7o5GxYl5IQt295PDJU4ax1pWom3ZgAuuOYiJJ0AFS4aLV
	 AUA8jqoq14RK5yJtMKIS9NaDbjcO5Lhtb12qkflOBbRIkoyexHrsqvAO6qakMV2+Ihg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TOAYYL+x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF6B606A321;
	Wed, 28 Oct 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TOAYYL+x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED9B1F01828;
	Wed, 28 Oct 2026 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207159;
	bh=jdznxU7g4kqW1IBbLMxQwY22NoQsIMHVfJjXDhvfRTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOAYYL+xu6nU4Id0jKiPcDrAAN/n2NZGJkuGVtsD3B5hW3MfLwdNjeumfoHjzfjNF
	 Hs9gpOWC5CTtUxK6ah/3IKs6gmoRntKnfdIJVxCZKM/iWLZZ4Pod1hAVN6Xq63i/7L
	 MdVt8Gos4s+x6xJMKvBPd20fSTd6PDfy/tgs9sFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 36/38] coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
Date: Wed, 28 Oct 2026 18:00:23 +0100
Message-ID: <20261028165941.310306412@linuxfoundation.org>
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

commit a58d647acfdc62561f3570d114025b3bf38ae41b upstream.

TIF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
return to userspace and run task work and then go back to sleep. This
mechanism works well but breaks coredumps. dump_interrupted() only
allows fatal signals to interrupt a coredump and the whole regular write
path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
well.

However, both the usermodehelper pipe and the coredump socket will bail
early on TIF_NOTIFY_SIGNAL. This affects the following codepaths:

- coredump_sock_recv() -> unix_stream_read_generic()
  The request/ack handshake is abandoned before any coredump data is
  sent.

- anon_pipe_write() returning -ERESTARTSYS
  Once the pipe is full this truncates the coredump.

- unix_stream_sendmsg() returning -ERESTARTSYS
  Once the send buffer is full this truncates the coredump.

- coredump_sock_wait() -> __kernel_read()
  This reports a failure that didn't happen.

- wait_for_dump_helpers() -> wait_event_interruptible()
  This stops waiting for the coredump helpers.

Such truncation is entirely invisible to userspace and all uapi bits
still indicate that a successful coredump happened. A crashing process
with a bunch of file backed mappings and io_uring thrown in loses most
of the coredump data. If the NT_FILE note goes past PAGE_SIZE mappings
it's gonzo.

TIF_NOTIFY_SIGNAL is sent by io_uring for the common case. And it uses
poll without sleeping so a completion callback runs task_work_add() from
interrupt context against the task that submitted the request. This is
the task that is running the coredump. Since that task hasn't set
work_exited (it hasn't exited yet after all) TIF_NOTIFY_SIGNAL keeps
reappearing.

A coredumping task doesn't return to userspace. The task work is run at
exit. So interrupting it doesn't buy anything and just loses the
coredump which is quite valuable.

Note that this isn't specific to io_uring. There's also
klp_send_signals(), bpf_task_work_schedule_signal(), landlock's tsync
and then  technically, kthread_stop() and the printk kunit test set the
bit raw.

Link: https://patch.msgid.link/20260824-work-tif_notify_signal-v2-2-6609e42b3157@kernel.org
Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1191,6 +1191,8 @@ void vfs_coredump(const kernel_siginfo_t
 	if (coredump_wait(siginfo->si_signo, &core_state) < 0)
 		return;
 
+	/* Task work must not cut the dump short, see signal_pending(). */
+	guard(no_notify_signal)();
 	scoped_with_creds(cred)
 		do_coredump(&cn, &cprm, &argv, &argc, binfmt);
 	coredump_cleanup(&cn, &cprm);


