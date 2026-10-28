Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207383;
	b=kaZ240njCK6UH6xcYFSmpaSk4vd2MZY8M2mol++xXjCjdIhIriFU+l2Uh5gIpzuCp/dk
	 UabPmkS2Ijvl77g2868fuNvx0Pp97/SVYjRd0VecO788wtxdVeSYWq+aeqPnDHI3wilwh
	 LauGSF+vnk3YT4DrI049ZCgrZ9rfOX+V9DU370PliIicr3m7zZc9+xM89f2pzdhirJMWr
	 denxdSeETUli7gFaU8nb/Urp3/s3JyiZSg7F1vcpNP0PYfMAEQ6R0AlGHSd/XmpYsp8mm
	 XX4dtOjhfUNGraJtMHg++/jOtX/Iir6HOAMqrJByRrH6XJNLOlkDFolUvcRm03dKTdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CoZ2GjoIfL+it/u29m7JfCHckja/EXj3kLO14A9ISjY=;
	b=Uhb85QySLTfacdtgl9cScK3dP9Co1JL83vwM6gP8pglvcJ7Df8EnzSKzoPF73gXhYVX6
	 icLxH0DIvrlmCjFdU4kXaOj5p/mfsdqX6bznIWtBYC6FZsS9vgSqCrfAmkLxr+Wa5IpDU
	 nBPCuUfqcfncKSayHfkIngc2QmfFESKtL8GN8P/Rozb6XgpA6KEeGFumP5uH3deUbQ08t
	 mClJcS/SM3WK+liGGFfa90DBBdGCGoCwmdqh0jIwdqn8vJSbYq5fGcBr4Tc5t10nWhea0
	 XFjfO45ECmTUcxnjVLRHiDV3x1BywGJ2oV5Aql/w074LS0Kd7elAxfhnag1xgeudQzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRDMgM37;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6E606A31D;
	Wed, 28 Oct 2026 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRDMgM37
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557AA1F01825;
	Wed, 28 Oct 2026 17:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207382;
	bh=CoZ2GjoIfL+it/u29m7JfCHckja/EXj3kLO14A9ISjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRDMgM37gZdBg+3bgNNtoYMIZ+ZyVMiZsPoro560LHWM4JPlnL/Ui100DOUENP1fj
	 98l+5ypdFXhRpVhgZd3IQKrBxT18zWCgj+ldd6vS9xtYbKRZDj9nPBDiVXNpqfWATA
	 JjTf7P/QsVdLD5M1CWSoZgGP/U+/4L/xzRNzRkWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 86/88] coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
Date: Wed, 28 Oct 2026 18:00:34 +0100
Message-ID: <20261028165944.138103750@linuxfoundation.org>
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
@@ -1196,6 +1196,8 @@ void vfs_coredump(const kernel_siginfo_t
 	if (coredump_wait(siginfo->si_signo, &core_state) < 0)
 		return;
 
+	/* Task work must not cut the dump short, see signal_pending(). */
+	guard(no_notify_signal)();
 	scoped_with_creds(cred)
 		do_coredump(&cn, &cprm, &argv, &argc, binfmt);
 	coredump_cleanup(&cn, &cprm);


