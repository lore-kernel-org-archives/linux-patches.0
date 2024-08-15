Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E8519F49B;
	Thu, 15 Aug 2024 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730927; cv=none; b=X/mXMR8FJiKS7QGhNUTQqeF4yt5xPdXZtoDGjp2uJZaeEC5lLZDWeW94Knz/MvsbnrFA8WYT2cg2HwJU64ASye/0xelgWH91s/QYkKG4OINTG4R6RxiIlw8nSi+kqNqQoQ4pmxwdqQjrOVPybDeLKmoEfUtowmG2pXcpiuiiAsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730927; c=relaxed/simple;
	bh=uJS12TQZxTvxBieztMSj+uoatkTe8LQ4O+Dw6otxEWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dX8iQlDm+Ikn/L7/pXPtvOcyQy763S/4Z3zWR7GzImg/cb/CuoUxYNRcKHod3V6bHFf63OHvtCtUS2AUkrxQm6LrdbuKSbLWti7HRgXgksEGITdktt0sZ3ZwbgojOiDYxJLI3r2G6N5g2rOVGT2bqQSN2hysuHgPBUMUTABaoCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYs+eypa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYs+eypa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D76C32786;
	Thu, 15 Aug 2024 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730927;
	bh=uJS12TQZxTvxBieztMSj+uoatkTe8LQ4O+Dw6otxEWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYs+eyparGduc1Gs1dJdfcuON0LP/TgaXU/K6k1U2hbfnBbCl/xvGKYM4LRWRdRCN
	 n192bSn6B2S+YJ5gEOfKwTB56O001Y9W30oPiRTqcdrtnCkDOoKwBB6/RLI/QqysWa
	 FP2a7jmef8BK/0Ux+ml4kR4BSTfMztDqzYa8jpqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Stevens <stevensd@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6.6 19/67] genirq/cpuhotplug: Skip suspended interrupts when restoring affinity
Date: Thu, 15 Aug 2024 15:25:33 +0200
Message-ID: <20240815131839.073104291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Stevens <stevensd@chromium.org>

commit a60dd06af674d3bb76b40da5d722e4a0ecefe650 upstream.

irq_restore_affinity_of_irq() restarts managed interrupts unconditionally
when the first CPU in the affinity mask comes online. That's correct during
normal hotplug operations, but not when resuming from S3 because the
drivers are not resumed yet and interrupt delivery is not expected by them.

Skip the startup of suspended interrupts and let resume_device_irqs() deal
with restoring them. This ensures that irqs are not delivered to drivers
during the noirq phase of resuming from S3, after non-boot CPUs are brought
back online.

Signed-off-by: David Stevens <stevensd@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240424090341.72236-1-stevensd@chromium.org
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/cpuhotplug.c |   11 ++++++++---
 kernel/irq/manage.c     |   12 ++++++++----
 2 files changed, 16 insertions(+), 7 deletions(-)

--- a/kernel/irq/cpuhotplug.c
+++ b/kernel/irq/cpuhotplug.c
@@ -195,10 +195,15 @@ static void irq_restore_affinity_of_irq(
 	    !irq_data_get_irq_chip(data) || !cpumask_test_cpu(cpu, affinity))
 		return;
 
-	if (irqd_is_managed_and_shutdown(data)) {
-		irq_startup(desc, IRQ_RESEND, IRQ_START_COND);
+	/*
+	 * Don't restore suspended interrupts here when a system comes back
+	 * from S3. They are reenabled via resume_device_irqs().
+	 */
+	if (desc->istate & IRQS_SUSPENDED)
 		return;
-	}
+
+	if (irqd_is_managed_and_shutdown(data))
+		irq_startup(desc, IRQ_RESEND, IRQ_START_COND);
 
 	/*
 	 * If the interrupt can only be directed to a single target
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -796,10 +796,14 @@ void __enable_irq(struct irq_desc *desc)
 		irq_settings_set_noprobe(desc);
 		/*
 		 * Call irq_startup() not irq_enable() here because the
-		 * interrupt might be marked NOAUTOEN. So irq_startup()
-		 * needs to be invoked when it gets enabled the first
-		 * time. If it was already started up, then irq_startup()
-		 * will invoke irq_enable() under the hood.
+		 * interrupt might be marked NOAUTOEN so irq_startup()
+		 * needs to be invoked when it gets enabled the first time.
+		 * This is also required when __enable_irq() is invoked for
+		 * a managed and shutdown interrupt from the S3 resume
+		 * path.
+		 *
+		 * If it was already started up, then irq_startup() will
+		 * invoke irq_enable() under the hood.
 		 */
 		irq_startup(desc, IRQ_RESEND, IRQ_START_FORCE);
 		break;


