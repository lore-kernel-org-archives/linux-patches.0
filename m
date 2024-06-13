Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A9F145B1E;
	Thu, 13 Jun 2024 12:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280159; cv=none; b=NGFHiEpxG3L65KMW87ZHrpt7vjwNBPlMzkOpBdmzqiuLKhU6Vd5O3ZnwELAG+FYOyZP3TExez62Iev6Utdw2XJVHq6KoyFe3Z20MRaQYC7NU2pp8rEjGGz1fiFQs+pmIcWHe+iTtB88PSYAvkGBmT2lIwMER2/9gs67FwJos2uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280159; c=relaxed/simple;
	bh=DxNnnJ3Q63yUOMdU452SRUOqsjTbI/fyqR/HfwvZCOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYKpjNkadRgXFop7o8UgBIbmbIKzgMNMu/vQPLA3TGN4TXsqxSBOCrC1Qz9qp5de+1cT/xiJpJKM/ghmElvIjOtVW5/rg89QGlcLCE2ZzpGHHrD2Mbqz/G6dmXix664q4e+zYW2oBL3Ykm11ETU7YgnRM4E3KR0XNC1oaemY00k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jG/OJV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jG/OJV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA02C2BBFC;
	Thu, 13 Jun 2024 12:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280159;
	bh=DxNnnJ3Q63yUOMdU452SRUOqsjTbI/fyqR/HfwvZCOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jG/OJV+BsLWFX7Ju6rrkcfQQyLpXNL5MBa3OHxeXE0L9mOj1SPRvwLqM33E5HTRK
	 rkSD7sxBF+zyFkZSc4gtkgzWEe7hnjloMsJLUrEOU5MSwFAR2N2+8tG6QgiGbcbvLF
	 axYQHMFhJvV0rbdn+zM7/BXERofMzuSdoJdSvCmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 163/202] genirq/cpuhotplug, x86/vector: Prevent vector leak during CPU offline
Date: Thu, 13 Jun 2024 13:34:21 +0200
Message-ID: <20240613113234.040006767@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongli Zhang <dongli.zhang@oracle.com>

commit a6c11c0a5235fb144a65e0cb2ffd360ddc1f6c32 upstream.

The absence of IRQD_MOVE_PCNTXT prevents immediate effectiveness of
interrupt affinity reconfiguration via procfs. Instead, the change is
deferred until the next instance of the interrupt being triggered on the
original CPU.

When the interrupt next triggers on the original CPU, the new affinity is
enforced within __irq_move_irq(). A vector is allocated from the new CPU,
but the old vector on the original CPU remains and is not immediately
reclaimed. Instead, apicd->move_in_progress is flagged, and the reclaiming
process is delayed until the next trigger of the interrupt on the new CPU.

Upon the subsequent triggering of the interrupt on the new CPU,
irq_complete_move() adds a task to the old CPU's vector_cleanup list if it
remains online. Subsequently, the timer on the old CPU iterates over its
vector_cleanup list, reclaiming old vectors.

However, a rare scenario arises if the old CPU is outgoing before the
interrupt triggers again on the new CPU.

In that case irq_force_complete_move() is not invoked on the outgoing CPU
to reclaim the old apicd->prev_vector because the interrupt isn't currently
affine to the outgoing CPU, and irq_needs_fixup() returns false. Even
though __vector_schedule_cleanup() is later called on the new CPU, it
doesn't reclaim apicd->prev_vector; instead, it simply resets both
apicd->move_in_progress and apicd->prev_vector to 0.

As a result, the vector remains unreclaimed in vector_matrix, leading to a
CPU vector leak.

To address this issue, move the invocation of irq_force_complete_move()
before the irq_needs_fixup() call to reclaim apicd->prev_vector, if the
interrupt is currently or used to be affine to the outgoing CPU.

Additionally, reclaim the vector in __vector_schedule_cleanup() as well,
following a warning message, although theoretically it should never see
apicd->move_in_progress with apicd->prev_cpu pointing to an offline CPU.

Fixes: f0383c24b485 ("genirq/cpuhotplug: Add support for cleaning up move in progress")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240522220218.162423-1-dongli.zhang@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/vector.c |    9 ++++++---
 kernel/irq/cpuhotplug.c       |   16 ++++++++--------
 2 files changed, 14 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -913,7 +913,8 @@ static void __send_cleanup_vector(struct
 		hlist_add_head(&apicd->clist, per_cpu_ptr(&cleanup_list, cpu));
 		apic->send_IPI(cpu, IRQ_MOVE_CLEANUP_VECTOR);
 	} else {
-		apicd->prev_vector = 0;
+		pr_warn("IRQ %u schedule cleanup for offline CPU %u\n", apicd->irq, cpu);
+		free_moved_vector(apicd);
 	}
 	raw_spin_unlock(&vector_lock);
 }
@@ -949,6 +950,7 @@ void irq_complete_move(struct irq_cfg *c
  */
 void irq_force_complete_move(struct irq_desc *desc)
 {
+	unsigned int cpu = smp_processor_id();
 	struct apic_chip_data *apicd;
 	struct irq_data *irqd;
 	unsigned int vector;
@@ -973,10 +975,11 @@ void irq_force_complete_move(struct irq_
 		goto unlock;
 
 	/*
-	 * If prev_vector is empty, no action required.
+	 * If prev_vector is empty or the descriptor is neither currently
+	 * nor previously on the outgoing CPU no action required.
 	 */
 	vector = apicd->prev_vector;
-	if (!vector)
+	if (!vector || (apicd->cpu != cpu && apicd->prev_cpu != cpu))
 		goto unlock;
 
 	/*
--- a/kernel/irq/cpuhotplug.c
+++ b/kernel/irq/cpuhotplug.c
@@ -69,6 +69,14 @@ static bool migrate_one_irq(struct irq_d
 	}
 
 	/*
+	 * Complete an eventually pending irq move cleanup. If this
+	 * interrupt was moved in hard irq context, then the vectors need
+	 * to be cleaned up. It can't wait until this interrupt actually
+	 * happens and this CPU was involved.
+	 */
+	irq_force_complete_move(desc);
+
+	/*
 	 * No move required, if:
 	 * - Interrupt is per cpu
 	 * - Interrupt is not started
@@ -87,14 +95,6 @@ static bool migrate_one_irq(struct irq_d
 	}
 
 	/*
-	 * Complete an eventually pending irq move cleanup. If this
-	 * interrupt was moved in hard irq context, then the vectors need
-	 * to be cleaned up. It can't wait until this interrupt actually
-	 * happens and this CPU was involved.
-	 */
-	irq_force_complete_move(desc);
-
-	/*
 	 * If there is a setaffinity pending, then try to reuse the pending
 	 * mask, so the last change of the affinity does not get lost. If
 	 * there is no move pending or the pending mask does not contain


