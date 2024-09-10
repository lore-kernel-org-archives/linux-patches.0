Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21111891A5;
	Tue, 10 Sep 2024 09:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961362; cv=none; b=GNCtojn571rmVmg2FN25qJMqjDy5bDijbX5bTOhlfVowLGIiT4PoG2Vn6pcwM2wjIoL+Ijvw1iy6qxh0vSdwiWOA6H20IvVIXOAvp6MjUt7sCuuFhCmOOLUinYCrm4pOPjeuKwZ3a7TbHR2zRFLg5eVhSatjeq6J1kdwnPYJW2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961362; c=relaxed/simple;
	bh=UpAvPjLeWO4OSaF5vJ0vLFtmJPD0yrSAvzehgXQeeOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JeolgBpgOiKFyw+ZPiaaOlrxoy/S4EjXU5NFLtd4XvenJhlqe1215taCldDhWVZjKMkXxAyblJwc/oM+k8XYPEUFf6QDbWwYt0VVOw5td79wE7evB1U0IvtKJyCd6ZhwqxlJcJLLiIJd5RZfPC9p2JGUVS/BYf3O+a2z+XMXVBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvXYN1Vz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvXYN1Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6145DC4CEC3;
	Tue, 10 Sep 2024 09:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961361;
	bh=UpAvPjLeWO4OSaF5vJ0vLFtmJPD0yrSAvzehgXQeeOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvXYN1Vzq0NnY7svMRRojNlzTjPkgBaHqtXjRhNTBIuyCr8qmLVoXEK0mepMLGYKr
	 5uY2ZbcCMLCSxbz7yy7yPcWwEX6nTEit9l7JPGryjALO+4cdjqeB/k2B6leN2rmeTP
	 x1jtqctGor7Pglnxqm7rZ1MDNenQBcKAmC/6psgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetika Moolchandani <geetika@linux.ibm.com>,
	Vaishnavi Bhat <vaish123@in.ibm.com>,
	Jijo Varghese <vargjijo@in.ibm.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.10 016/375] powerpc/qspinlock: Fix deadlock in MCS queue
Date: Tue, 10 Sep 2024 11:26:53 +0200
Message-ID: <20240910092622.812650327@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nysal Jan K.A. <nysal@linux.ibm.com>

commit 734ad0af3609464f8f93e00b6c0de1e112f44559 upstream.

If an interrupt occurs in queued_spin_lock_slowpath() after we increment
qnodesp->count and before node->lock is initialized, another CPU might
see stale lock values in get_tail_qnode(). If the stale lock value happens
to match the lock on that CPU, then we write to the "next" pointer of
the wrong qnode. This causes a deadlock as the former CPU, once it becomes
the head of the MCS queue, will spin indefinitely until it's "next" pointer
is set by its successor in the queue.

Running stress-ng on a 16 core (16EC/16VP) shared LPAR, results in
occasional lockups similar to the following:

   $ stress-ng --all 128 --vm-bytes 80% --aggressive \
               --maximize --oomable --verify  --syslog \
               --metrics  --times  --timeout 5m

   watchdog: CPU 15 Hard LOCKUP
   ......
   NIP [c0000000000b78f4] queued_spin_lock_slowpath+0x1184/0x1490
   LR [c000000001037c5c] _raw_spin_lock+0x6c/0x90
   Call Trace:
    0xc000002cfffa3bf0 (unreliable)
    _raw_spin_lock+0x6c/0x90
    raw_spin_rq_lock_nested.part.135+0x4c/0xd0
    sched_ttwu_pending+0x60/0x1f0
    __flush_smp_call_function_queue+0x1dc/0x670
    smp_ipi_demux_relaxed+0xa4/0x100
    xive_muxed_ipi_action+0x20/0x40
    __handle_irq_event_percpu+0x80/0x240
    handle_irq_event_percpu+0x2c/0x80
    handle_percpu_irq+0x84/0xd0
    generic_handle_irq+0x54/0x80
    __do_irq+0xac/0x210
    __do_IRQ+0x74/0xd0
    0x0
    do_IRQ+0x8c/0x170
    hardware_interrupt_common_virt+0x29c/0x2a0
   --- interrupt: 500 at queued_spin_lock_slowpath+0x4b8/0x1490
   ......
   NIP [c0000000000b6c28] queued_spin_lock_slowpath+0x4b8/0x1490
   LR [c000000001037c5c] _raw_spin_lock+0x6c/0x90
   --- interrupt: 500
    0xc0000029c1a41d00 (unreliable)
    _raw_spin_lock+0x6c/0x90
    futex_wake+0x100/0x260
    do_futex+0x21c/0x2a0
    sys_futex+0x98/0x270
    system_call_exception+0x14c/0x2f0
    system_call_vectored_common+0x15c/0x2ec

The following code flow illustrates how the deadlock occurs.
For the sake of brevity, assume that both locks (A and B) are
contended and we call the queued_spin_lock_slowpath() function.

        CPU0                                   CPU1
        ----                                   ----
  spin_lock_irqsave(A)                          |
  spin_unlock_irqrestore(A)                     |
    spin_lock(B)                                |
         |                                      |
         ▼                                      |
   id = qnodesp->count++;                       |
  (Note that nodes[0].lock == A)                |
         |                                      |
         ▼                                      |
      Interrupt                                 |
  (happens before "nodes[0].lock = B")          |
         |                                      |
         ▼                                      |
  spin_lock_irqsave(A)                          |
         |                                      |
         ▼                                      |
   id = qnodesp->count++                        |
   nodes[1].lock = A                            |
         |                                      |
         ▼                                      |
  Tail of MCS queue                             |
         |                             spin_lock_irqsave(A)
         ▼                                      |
  Head of MCS queue                             ▼
         |                             CPU0 is previous tail
         ▼                                      |
   Spin indefinitely                            ▼
  (until "nodes[1].next != NULL")      prev = get_tail_qnode(A, CPU0)
                                                |
                                                ▼
                                       prev == &qnodes[CPU0].nodes[0]
                                     (as qnodes[CPU0].nodes[0].lock == A)
                                                |
                                                ▼
                                       WRITE_ONCE(prev->next, node)
                                                |
                                                ▼
                                        Spin indefinitely
                                     (until nodes[0].locked == 1)

Thanks to Saket Kumar Bhaskar for help with recreating the issue

Fixes: 84990b169557 ("powerpc/qspinlock: add mcs queueing for contended waiters")
Cc: stable@vger.kernel.org # v6.2+
Reported-by: Geetika Moolchandani <geetika@linux.ibm.com>
Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
Reported-by: Jijo Varghese <vargjijo@in.ibm.com>
Signed-off-by: Nysal Jan K.A. <nysal@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240829022830.1164355-1-nysal@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/qspinlock.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/powerpc/lib/qspinlock.c
+++ b/arch/powerpc/lib/qspinlock.c
@@ -697,7 +697,15 @@ again:
 	}
 
 release:
-	qnodesp->count--; /* release the node */
+	/*
+	 * Clear the lock before releasing the node, as another CPU might see stale
+	 * values if an interrupt occurs after we increment qnodesp->count
+	 * but before node->lock is initialized. The barrier ensures that
+	 * there are no further stores to the node after it has been released.
+	 */
+	node->lock = NULL;
+	barrier();
+	qnodesp->count--;
 }
 
 void queued_spin_lock_slowpath(struct qspinlock *lock)


