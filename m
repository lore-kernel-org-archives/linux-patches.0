Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AB1377EDC;
	Fri,  4 Sep 2026 05:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501004; cv=none; b=GI+YNm+wmkaaX60Fs93GaUkKrza7j0OirblR+gYTTB/KMpozWimKelXf8ib9/WNyzabzMFf/KHChGFXm2qbpeyr7GoZcyXjhb6D2Rxd0kyb8WI8vSdP+4NDshPs2P8/GhOBAgZiKhxNF65xwoc74hvPeWalaYA9+SLIRONWP9WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501004; c=relaxed/simple;
	bh=tl5FM6RPA0gDP7S/5xRt9UWMdbfv+ABvxC24ie0WFfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvmkTr6RVhkTrb9IhaFoeCCQP9GvgtrAQLnzvAzCbTs+Dr2WUptraBfmN8EoiKRpN3LxP3nEj9pFzLyFDu2oDRMVL4NdpbzmONzgHfnbMlww9PYqTaAhK6JWIPgpqF7QVmz4UxbhBAW2Eus/HbSh24koNqq1Yo0jl44GxMTUYJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYEZxEBo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYEZxEBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8D61F00A3D;
	Fri,  4 Sep 2026 05:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501002;
	bh=i5aSR0LwRAKiwTGLN1vPyvqmucXvWr8MvaW61Inrctw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kYEZxEBo8LjI4/T4LHUFH5fNjA2AnY+U2zgfjVekCKt7I586G0tlIXRXNoT+HTGNo
	 dGKbRHjdfr/Jv+r6RwfaIGON8I2PVKy/Fg2X+pB+CDwfLf0sVuQ8UZxWMifkBCU/7H
	 udsI1jWkIHFedu+udWh9awZkoWLUjl0zRZkgn8UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko@linuxfoundation.org>,
	Terry Bowman <terry.bowman@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6.18 213/552] acpi/apei/ghes: Use raw_spinlock_t for CXL CPER work locks
Date: Fri,  4 Sep 2026 06:56:10 +0200
Message-ID: <20260904045754.240789197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Bowman <terry.bowman@amd.com>

commit 6625ca499c3131ef63be3215f8f942d7a097ea3a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/ghes.c |   50 +++++++++++++++++++++++++++++++----------------
 drivers/cxl/core/ras.c   |    1 
 drivers/cxl/pci.c        |    1 
 3 files changed, 33 insertions(+), 19 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -736,7 +736,7 @@ static DEFINE_KFIFO(cxl_cper_prot_err_fi
 		    CXL_CPER_PROT_ERR_FIFO_DEPTH);
 
 /* Synchronize schedule_work() with cxl_cper_prot_err_work changes */
-static DEFINE_SPINLOCK(cxl_cper_prot_err_work_lock);
+static DEFINE_RAW_SPINLOCK(cxl_cper_prot_err_work_lock);
 struct work_struct *cxl_cper_prot_err_work;
 
 static void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
@@ -749,7 +749,7 @@ static void cxl_cper_post_prot_err(struc
 	if (cxl_cper_sec_prot_err_valid(prot_err))
 		return;
 
-	guard(spinlock_irqsave)(&cxl_cper_prot_err_work_lock);
+	guard(raw_spinlock_irqsave)(&cxl_cper_prot_err_work_lock);
 
 	if (!cxl_cper_prot_err_work)
 		return;
@@ -787,10 +787,11 @@ static void cxl_cper_post_prot_err(struc
 
 int cxl_cper_register_prot_err_work(struct work_struct *work)
 {
-	if (cxl_cper_prot_err_work)
-		return -EINVAL;
+	guard(raw_spinlock_irqsave)(&cxl_cper_prot_err_work_lock);
 
-	guard(spinlock)(&cxl_cper_prot_err_work_lock);
+	if (WARN_ONCE(cxl_cper_prot_err_work,
+		      "CPER-CXL kfifo consumer already registered\n"))
+		return -EINVAL;
 	cxl_cper_prot_err_work = work;
 	return 0;
 }
@@ -798,11 +799,18 @@ EXPORT_SYMBOL_NS_GPL(cxl_cper_register_p
 
 int cxl_cper_unregister_prot_err_work(struct work_struct *work)
 {
-	if (cxl_cper_prot_err_work != work)
-		return -EINVAL;
+	scoped_guard(raw_spinlock_irqsave, &cxl_cper_prot_err_work_lock) {
+		if (WARN_ONCE(cxl_cper_prot_err_work != work,
+			      "CPER-CXL kfifo consumer mismatch on unregister\n"))
+			return -EINVAL;
+		cxl_cper_prot_err_work = NULL;
+	}
+
+	cancel_work_sync(work);
+
+	/* Discard stale entries so they are not replayed on next module load */
+	kfifo_reset(&cxl_cper_prot_err_fifo);
 
-	guard(spinlock)(&cxl_cper_prot_err_work_lock);
-	cxl_cper_prot_err_work = NULL;
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(cxl_cper_unregister_prot_err_work, "CXL");
@@ -818,7 +826,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_cper_prot_err_k
 DEFINE_KFIFO(cxl_cper_fifo, struct cxl_cper_work_data, CXL_CPER_FIFO_DEPTH);
 
 /* Synchronize schedule_work() with cxl_cper_work changes */
-static DEFINE_SPINLOCK(cxl_cper_work_lock);
+static DEFINE_RAW_SPINLOCK(cxl_cper_work_lock);
 struct work_struct *cxl_cper_work;
 
 static void cxl_cper_post_event(enum cxl_event_type event_type,
@@ -838,7 +846,7 @@ static void cxl_cper_post_event(enum cxl
 		return;
 	}
 
-	guard(spinlock_irqsave)(&cxl_cper_work_lock);
+	guard(raw_spinlock_irqsave)(&cxl_cper_work_lock);
 
 	if (!cxl_cper_work)
 		return;
@@ -856,10 +864,11 @@ static void cxl_cper_post_event(enum cxl
 
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
@@ -867,11 +876,18 @@ EXPORT_SYMBOL_NS_GPL(cxl_cper_register_w
 
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
 EXPORT_SYMBOL_NS_GPL(cxl_cper_unregister_work, "CXL");
--- a/drivers/cxl/core/ras.c
+++ b/drivers/cxl/core/ras.c
@@ -136,7 +136,6 @@ int cxl_ras_init(void)
 void cxl_ras_exit(void)
 {
 	cxl_cper_unregister_prot_err_work(&cxl_cper_prot_err_work);
-	cancel_work_sync(&cxl_cper_prot_err_work);
 }
 
 static void cxl_dport_map_ras(struct cxl_dport *dport)
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1198,7 +1198,6 @@ static int __init cxl_pci_driver_init(vo
 static void __exit cxl_pci_driver_exit(void)
 {
 	cxl_cper_unregister_work(&cxl_cper_work);
-	cancel_work_sync(&cxl_cper_work);
 	pci_unregister_driver(&cxl_pci_driver);
 }
 


