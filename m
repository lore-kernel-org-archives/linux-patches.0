Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623172;
	b=hKRMkWH0dvGtZ2ljuf6OknaCeUysghY4KRXkpX2nQUq4Viq74neTsASuZjQUqOmmclUX
	 CReWdWq8/VSIinKEv9DKPqmypjmscpilQnJ4d1y6qCwaji97liFsYcf01v04drLoelLlJ
	 LBXC6CuvU6qBlWjAEAMympOvubTTV1vFkprlTT6sjPyUNWM+TWYyx50SxTM4S8OKFdHS1
	 eybgLjv4jzYBpRL0EGg1g4qltMKmx6Un46qghYIV5D2W1NiOvg9u9pYJ9oKmXKaZuxo71
	 dcH3e3Pc+a91vl7YyJ7GgwhwtGYUZlQqRVI8Jo7gjgloDis+iMJ/WZn9N3r99g+5euQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b+GUvTglXAVHwOqqxYL0IOL0wu85AdN7Fjy7FK0fexc=;
	b=wqFzw4unwlr9O/OJp0bk9koJWsegv4UIaoQJkADXfa4BubvHMf5prFeMGp5uPXyRkbX7
	 AkaXepuipCFxQRNZdOYSAhkETXQY4Maj30Dk3VVzR07mvzwuJkL9kZ7o7l1lm1Cs4IUkJ
	 QOLzGfpych6tgMwDFk6qHe9ET967iUzRgCZ6dAQZ1MELJM6AIca+tR2x7RKPU0Tj0cR6E
	 c9FoquUxy7soLij1xb34L96TIfH87mll0ynPCLplO7XIGtasbs7XnReAhIRIyw/ON7v/Q
	 w17A2pDTBwTuHM/ZT5JgdOGNg6lpJoz6NOe/6ZSA7Ba6FHWRJ6ja7FUCghbagGh3FTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lxq7wFaV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA29606A31E;
	Wed, 25 Nov 2026 16:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lxq7wFaV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85601F000D2;
	Wed, 25 Nov 2026 16:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623172;
	bh=b+GUvTglXAVHwOqqxYL0IOL0wu85AdN7Fjy7FK0fexc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lxq7wFaVC+RXYY8VIwBwgOXXGGmcnU9pYMQNjZP5uHQ+rSfatJayk2+E8xAaDSXiq
	 FHlr6KADhT+2jeTafKHTGT/dPja1M+hBI7YeiHsvJexKLDkelbEGLBIyk7lRIvNtrU
	 Yz4yxjCY8Nh07W8DIQqJp9uVpcPXfmT+7OI1NBiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.18 773/990] xen/privcmd: fix double free when an irqfd is shut down twice
Date: Wed, 25 Nov 2026 15:35:40 +0100
Message-ID: <20261125143840.159207148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

commit 72a900c666adb97df77b05cf8540c4117f9c83ba upstream.

irqfd_deactivate() takes the irqfd off irqfds_list and queues
irqfd_shutdown().  queue_work() is not a once-only gate: it refuses to
enqueue a work item only while WORK_STRUCT_PENDING is set, and
process_one_work() clears that bit before it calls the work function.  So
nothing records that the shutdown work has already been queued, and
nothing protects the window between the start of irqfd_shutdown() and the
kfree() at its end.

Two paths call irqfd_deactivate() for the same irqfd:

  - privcmd_irqfd_deassign(), from the PRIVCMD_IRQFD_FLAG_DEASSIGN ioctl;

  - irqfd_wakeup(), with EPOLLHUP set, when the last reference to the
    eventfd file goes away, which runs wake_up_poll(&ctx->wqh, EPOLLHUP)
    from eventfd_release().

irqfds_lock serialises the two calls, but it does not make the second one
a no-op, and eventfd_ctx_fdget() takes a reference to the eventfd_ctx,
not to the struct file, so the last fd can still be closed while the
ioctl is running:

  CPU0                                 CPU1

  eventfd_ctx_fdget()
  spin_lock(irqfds_lock)
  list_del_init(&kirqfd->list)
  queue_work(&kirqfd->shutdown)        close(fd)
                                         eventfd_release()
                                           wake_up_poll(EPOLLHUP)
                                         irqfd_wakeup()
                                         spin_lock(irqfds_lock)
                                         irqfd_deactivate() again

If the work item has already started by then, its pending bit has been
cleared and the second queue_work() succeeds.  irqfd_shutdown() then runs
twice, so eventfd_ctx_remove_wait_queue(), eventfd_ctx_put() and kfree()
each hit the same object a second time; and when the second queue_work()
lands after the irqfd has been freed, the workqueue list operations write
to freed memory.

virt/kvm/eventfd.c has the same two callers and has had this guard since
the original irqfd support (721eecbf4fe99): irqfd_wakeup() calls
irqfd_deactivate() only if irqfd_is_active().  The comment there explains
why that is enough: the other side deactivates the irqfd before it takes
it off the waitqueue, and irqfd_shutdown() needs the waitqueue lock,
which this callback holds, so the irqfd cannot be freed under it.

Do the same here.  list_del_init() leaves the list head empty and the
irqfd stays off the list until kfree(), so it serves as a one-way
"active" flag.  The test is in irqfd_deactivate() rather than in
irqfd_wakeup() because privcmd_irqfd_deassign() walks irqfds_list and can
therefore never reach an inactive irqfd; only the wakeup path can, and a
single test covers both callers.

Fixes: f8941e6c4c712 ("xen: privcmd: Add support for irqfd")
Cc: stable@vger.kernel.org
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261101163251.55099-1-q.h.hack.winter@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/privcmd.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -901,10 +901,25 @@ struct privcmd_kernel_irqfd {
 	poll_table pt;
 };
 
+static bool irqfd_is_active(struct privcmd_kernel_irqfd *kirqfd)
+{
+	lockdep_assert_held(&irqfds_lock);
+
+	return !list_empty(&kirqfd->list);
+}
+
 static void irqfd_deactivate(struct privcmd_kernel_irqfd *kirqfd)
 {
 	lockdep_assert_held(&irqfds_lock);
 
+	/*
+	 * Both the deassign ioctl and the eventfd wakeup path can reach
+	 * this function.  list_del_init() marks the irqfd inactive, so
+	 * only the first caller may queue the shutdown work.
+	 */
+	if (!irqfd_is_active(kirqfd))
+		return;
+
 	list_del_init(&kirqfd->list);
 	queue_work(irqfd_cleanup_wq, &kirqfd->shutdown);
 }


