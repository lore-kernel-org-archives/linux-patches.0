Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624975;
	b=WaJ5bdDpwuza51EkzmKWluGL16QDbDFcolMP1RMalMqV22x/is087nnmwY8Kt6JB1MC/
	 OdnoZc2D6E3pILA6+a8cC473SiaDFW27LyH2GR+D34C5m1pyQfN0AgAIlbphoHb8LdI3O
	 upOpjRhXIH7hGMAqOsblzTBHvE+7NI2doZIHugCNSxP+A/KyC4hVn981dtnhRBWkxHgJP
	 5CfLHKgVBLXG2EqRttPRG3ARu4r5qrbmPey9odXsB3C5sIvdl3x4FcDLdBd1cGlW7o3ul
	 /DBnzlcrehfUofgGumwE3ZtINJubie5T4YqT+59A0tXIzLgnETLaQyJDhSLXFmmtrjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FBHEbsucEp7vTpbz/DbwSHlefaaVpBPRnN1BemWxKqc=;
	b=a8m/NGsrbjs+84LY3lNMokX8JGtGHQOIt0MMaJBBZktjG9BdZzdc+gPoRbryfznWYHZe
	 IuP+3kWBE80XqnQu92swrSNg70XSFTkjwRTUbysrxzyb89giUgYwhIqGCZeIHrSNQv2ny
	 ZdAADDDWU9fyEgwVyVDzkBPpAUF9kSoTfdmRugWSDLH2dfj7caIUHYsiynojRZSthtUAx
	 bxS1U3C1beURKA+UPMbVkW/k+YKjZkCTtge41R+YOz/WvtHDYdnK+YAm1esE7BvL+Yb3w
	 EE+2jwBjixHqZ7OanlTpjd3/3RhCpb1YS+qsxZAk835v6zaPKcGYxOGRRtzn29Jf1rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TS7TNZ42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C77606A31E;
	Wed, 25 Nov 2026 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TS7TNZ42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B5E1F000CF;
	Wed, 25 Nov 2026 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624974;
	bh=FBHEbsucEp7vTpbz/DbwSHlefaaVpBPRnN1BemWxKqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TS7TNZ42376BGo/UVHXIVQmBUjuqTklxZXdM/ZOoK+S88qNf4697Tq+213mUFl0ew
	 RpzilfPL/n8dYgP9QaQ7BP+y95nkiFXvBy1ZZFr1MaluoVglhPbxG8MAHTeaioLPOc
	 CdW49b85gwvwMgQ/wAcPg51P5I25p1pS8yHi3YVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 363/816] coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
Date: Wed, 25 Nov 2026 15:31:51 +0100
Message-ID: <20261125143857.599874223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

[ Upstream commit a58d647acfdc62561f3570d114025b3bf38ae41b ]

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
[ sashal: Replaced the upstream guard(no_notify_signal)() in vfs_coredump() with explicit no_notify_signal_save()/no_notify_signal_restore() calls in the older monolithic do_coredump(), because its gotos would jump over a guard. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coredump.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index d23c57eb2e058..6d7b9b8b0a818 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -582,6 +582,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 	struct linux_binfmt * binfmt;
 	const struct cred *old_cred;
 	struct cred *cred;
+	unsigned int notify_flags;
 	int retval = 0;
 	int ispipe;
 	size_t *argv = NULL;
@@ -630,6 +631,9 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 	if (retval < 0)
 		goto fail_creds;
 
+	/* Task work must not cut the dump short, see signal_pending(). */
+	notify_flags = no_notify_signal_save();
+
 	old_cred = override_creds(cred);
 
 	ispipe = format_corename(&cn, &cprm, &argv, &argc);
@@ -836,6 +840,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 	kfree(cn.corename);
 	coredump_finish(core_dumped);
 	revert_creds(old_cred);
+	no_notify_signal_restore(notify_flags);
 fail_creds:
 	put_cred(cred);
 fail:
-- 
2.53.0



