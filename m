Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625789;
	b=TmBab6p+XgATpRa5mlw91vNELpqSeWBtPiItfkOvLR5Mu4rey1AKcvTKYCXzXUqwrBo8
	 n7RH8Qd69RDcNKtiHG/x5vHgY6AWhrjjPwM7ZwxZYaiksCbgD/XU7aE6IgnlNxxjgMgJq
	 bTOZZ8wCg4CHlSg2TD5DS19uki8+J3yTe4DE08KCh2d35RYS3t0n8OyLNi65+MoEOWS81
	 8IRsRSIIc7Neg+BYCwCT3groad6+euqboCoLeCTSaRGW1Q6pVWEJxel3ytNOvddCUgE5T
	 o/SHuM/1OPt0cQPktHCiIdJo/25bZL8JFm5Dpl0FRrblHuzUIh+mEP3hsrf8ZtFq7Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cgN9sLPGFolPzEGuUw0npxwMlb92gN9P5NGlf+7lGqE=;
	b=3uXyuJjCFnfDmnlrpEnFsdEkq9lPmUFg7EsWIn9cvG2IBifXpg/iI/85g1Z1DmTrlKF7
	 la44XCBpkoGuwizKmJE9gGAaGScm7tGTXtWgsPGP6NhP+wZZFovIKq8X/UEFe2YD7rQuB
	 IGWtauCizW8fuoIkaOAxbA4PuHAXGqqQS0rCOzqIqS8Ygj72BAj6Q2y1e34jMZErSPFnB
	 uwbYwU12/ZP3Y7HIL+dGaRpd8Zi9gZaun3eExen9HBtRAn1DuahHMnEuvJtTaJhd3tHfs
	 lPJ6iIpDvl9LNAiCdd220a2ayyGbVW5lauyjxnuu6/HzGUO7cCcqdBudjBy51ezXuyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4CV6ELB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0455606A326;
	Wed, 25 Nov 2026 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4CV6ELB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D3F1F000D8;
	Wed, 25 Nov 2026 16:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625788;
	bh=cgN9sLPGFolPzEGuUw0npxwMlb92gN9P5NGlf+7lGqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4CV6ELBhSCoFk97KgS9Cc1AJL0AmxgVrn+weSr55eDWi1+oGcv2T7Eb7uU7uAzbk
	 wUn4acjCQ1d0NmARia4MPk5fhJnHbMdyr2AQ4J3JfMPp1nF/naM41nNDkDEDIsnaaL
	 3C327n+2Pm27Vxi7u/d0LEKc0ytZXR634cnductI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.12 632/816] xen/privcmd: fix double free when an irqfd is shut down twice
Date: Wed, 25 Nov 2026 15:36:20 +0100
Message-ID: <20261125143903.813184550@linuxfoundation.org>
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
@@ -903,10 +903,25 @@ struct privcmd_kernel_irqfd {
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


