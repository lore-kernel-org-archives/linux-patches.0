Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA253A9D90;
	Thu, 17 Sep 2026 19:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671711; cv=none; b=KhIYVZ2YdG59VnTOTHuvnTH/EPAhNzZ9MnRH0YryrnYfdRHeww77mmaptklX2CimK9CfhD4fo9SmBcIXIis72rYX2Yp+Kf20UJT/tfbeqMcGHaQIEVyXyJIbuUFcGj5BsJDir2or88ugeTjbkCh8WOxWCbhZ5M791yOpyxKSPyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671711; c=relaxed/simple;
	bh=tv5U2x+k8ReRt68xDlVrP776c4JCJ6hK0SBOK7o2YuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KP3QEDLNd4Aojra/MTdDfnRl7hGv/UX/6UajVfaXQxe7UatOSsAvNm+yvDVxIzNX81kl+p625P1MpTK121+9opV9e1QZhKvJmrZMqyfN5oy+9V+EhTzaDfEIBWlIIWX3465HhmaQn82zh5rIotl7b174ARoSv3dZ2zScNcA/NyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOlp9Kq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOlp9Kq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B141F000FF;
	Thu, 17 Sep 2026 19:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671710;
	bh=mdtOykCA3/2FJmUYzSinJ7ar3PBdyoH2+aaqy8JaXO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOlp9Kq+HPKP6n8FWJRxx0X8d3Yjm91YtEsZv7OGCSWf0txRHIdVqSCW4BAsR+ni+
	 0XevOjQvkS6zao5MokjIqOygxCOwCUIlhENlnmNewzs9bO0GqjCSMz18e4Eft053fB
	 NVjo61ANlwOWf5Iuh5XmShlSw+nsxR+QRIccqh3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko@linuxfoundation.org>,
	Terry Bowman <terry.bowman@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1065/1102] acpi/apei/ghes: Use raw_spinlock_t for CXL CPER work locks
Date: Thu, 17 Sep 2026 16:16:48 +0100
Message-ID: <20260917151607.556522524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Bowman <terry.bowman@amd.com>

[ Upstream commit 6625ca499c3131ef63be3215f8f942d7a097ea3a ]

The CXL CPER work registration and unregistration helpers acquire
cxl_cper_work_lock and cxl_cper_prot_err_work_lock with a spinlock
guard(), which leaves local interrupts enabled. The corresponding post
paths (cxl_cper_post_event(), cxl_cper_post_prot_err()) execute in hard
IRQ context (they are called from the GHES error notification path) and
acquire the same locks with an irqsave guard().

If a CPU is holding one of these locks via a spinlock guard() when a GHES
interrupt arrives on the same CPU, the IRQ handler spins on the held lock
waiting for it to release, while the lock holder is preempted by the IRQ.
The result is a deadlock.

Convert both locks from spinlock_t to raw_spinlock_t and use guard() at
all call sites. On PREEMPT_RT kernels spinlock_t is backed by rt_mutex and
sleeping from hard IRQ context is not permitted; raw_spinlock_t is safe in
both contexts.

Add WARN_ONCE to both register functions to surface double-registration
bugs at runtime.

Restructure both unregister functions to clear the global work pointer
under the lock before calling cancel_work_sync(), closing the window
where a CPER interrupt could schedule work on a pointer about to be
freed. Add kfifo_reset() after cancel_work_sync() so stale entries
are not replayed on next module load.

Both kfifos are single-consumer: only one work_struct is registered at
a time, enforced by the WARN_ONCE guard in the register functions.
kfifo_reset() is safe outside the lock because cancel_work_sync() has
already quiesced the consumer, and no new consumer can register until
the current module exit completes and a fresh module init runs.

Remove the redundant cancel_work_sync() call from cxl_ras_exit() and
cxl_pci_driver_exit(). The CPER unregister functions now quiesce
the work internally.

Reported-by: Sashiko <sashiko@linuxfoundation.org>
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Fixes: 5e4a264bf8b5 ("acpi/ghes: Process CXL Component Events")
Fixes: 36f257e3b0ba ("acpi/ghes, cxl/pci: Process CXL CPER Protocol Errors")
Cc: stable@vger.kernel.org
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260803221810.3685703-4-terry.bowman@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[ omitted protocol-error changes because the corresponding consumer infrastructure is absent in 6.12 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/ghes.c |   24 ++++++++++++++++--------
 drivers/cxl/pci.c        |    1 -
 2 files changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -710,7 +710,7 @@ static void ghes_defer_non_standard_even
 DEFINE_KFIFO(cxl_cper_fifo, struct cxl_cper_work_data, CXL_CPER_FIFO_DEPTH);
 
 /* Synchronize schedule_work() with cxl_cper_work changes */
-static DEFINE_SPINLOCK(cxl_cper_work_lock);
+static DEFINE_RAW_SPINLOCK(cxl_cper_work_lock);
 struct work_struct *cxl_cper_work;
 
 static void cxl_cper_post_event(enum cxl_event_type event_type,
@@ -730,7 +730,7 @@ static void cxl_cper_post_event(enum cxl
 		return;
 	}
 
-	guard(spinlock_irqsave)(&cxl_cper_work_lock);
+	guard(raw_spinlock_irqsave)(&cxl_cper_work_lock);
 
 	if (!cxl_cper_work)
 		return;
@@ -748,10 +748,11 @@ static void cxl_cper_post_event(enum cxl
 
 int cxl_cper_register_work(struct work_struct *work)
 {
-	if (cxl_cper_work)
+	guard(raw_spinlock_irqsave)(&cxl_cper_work_lock);
+	if (WARN_ONCE(cxl_cper_work,
+		      "CXL CPER kfifo consumer already registered\n"))
 		return -EINVAL;
 
-	guard(spinlock)(&cxl_cper_work_lock);
 	cxl_cper_work = work;
 	return 0;
 }
@@ -759,11 +760,18 @@ EXPORT_SYMBOL_NS_GPL(cxl_cper_register_w
 
 int cxl_cper_unregister_work(struct work_struct *work)
 {
-	if (cxl_cper_work != work)
-		return -EINVAL;
+	scoped_guard(raw_spinlock_irqsave, &cxl_cper_work_lock) {
+		if (WARN_ONCE(cxl_cper_work != work,
+			      "CXL CPER kfifo consumer mismatch on unregister\n"))
+			return -EINVAL;
+		cxl_cper_work = NULL;
+	}
+
+	cancel_work_sync(work);
+
+	/* Discard stale entries so they are not replayed on next module load */
+	kfifo_reset(&cxl_cper_fifo);
 
-	guard(spinlock)(&cxl_cper_work_lock);
-	cxl_cper_work = NULL;
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(cxl_cper_unregister_work, CXL);
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1084,7 +1084,6 @@ static int __init cxl_pci_driver_init(vo
 static void __exit cxl_pci_driver_exit(void)
 {
 	cxl_cper_unregister_work(&cxl_cper_work);
-	cancel_work_sync(&cxl_cper_work);
 	pci_unregister_driver(&cxl_pci_driver);
 }
 


