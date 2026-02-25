Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156351D5ABA;
	Wed, 25 Feb 2026 01:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982992; cv=none; b=mI7NSNZy1521WlK3sJrGyCHFTHssyzeqDv1C1czSI1jMrHfmhLMT/dwk3tSbAhaDCtZXMMgcVssb/bYK5nxbTl0yDvlnPmVkdxK9aZpNAJp3AyAZltyaTX2k41I8SLgmc+Z4rDrTLl115RjaB2UetRQgenBXH/0a+ucEjQ/i1J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982992; c=relaxed/simple;
	bh=dlE5c6Jef73r+HHchpMgDOyHbPsaDGVfmV1KWm9kWow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amAYXIOSmwbBMmTwhGl1TQCUwXTn3ePb5oOmtHtvAuiYHnXRxEnh0elAtVUJwTcKgmOu3nrgpNAXz+yiEMIBAGUE2pTQOdn0Is7FUZjAHyKxUz8uY09XKvyFl2oZOdhI+CQKT62iCGX79w85HdHmjfc+qgMyMF/KKunQ0JIaVJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqs4/L2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqs4/L2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D19C116D0;
	Wed, 25 Feb 2026 01:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982992;
	bh=dlE5c6Jef73r+HHchpMgDOyHbPsaDGVfmV1KWm9kWow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqs4/L2zwfm2CetdKFsbO0WdQmqwB0J8XSRwEO2w/M+oUR8U/s7ioJmp/JEgAuifH
	 fxijFphpOWiQJxysaCA78k37vdwOHfysXQLeiXuu8tDOOTi5ZFtUEzG5s5tJ3MAG0u
	 XxMzHciqp1KGgGQmEC6vUJZ7fwcfH2CP3lnYaffE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 119/781] iommu/amd: Use cores primary handler and set IRQF_ONESHOT
Date: Tue, 24 Feb 2026 17:13:48 -0800
Message-ID: <20260225012402.589740958@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 5bfcdccb4d18d3909b7f87942be67fd6bdc00c1d ]

request_threaded_irq() is invoked with a primary and a secondary handler
and no flags are passed. The primary handler is the same as
irq_default_primary_handler() so there is no need to have an identical
copy.

The lack of the IRQF_ONESHOT can be dangerous because the interrupt
source is not masked while the threaded handler is active. This means,
especially on LEVEL typed interrupt lines, the interrupt can fire again
before the threaded handler had a chance to run.

Use the default primary interrupt handler by specifying NULL and set
IRQF_ONESHOT so the interrupt source is masked until the secondary
handler is done.

Fixes: 72fe00f01f9a3 ("x86/amd-iommu: Use threaded interupt handler")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260128095540.863589-4-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h |  1 -
 drivers/iommu/amd/init.c      | 12 ++++--------
 drivers/iommu/amd/iommu.c     |  5 -----
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index b742ef1adb352..df1c238dc8885 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -15,7 +15,6 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data);
 irqreturn_t amd_iommu_int_thread_evtlog(int irq, void *data);
 irqreturn_t amd_iommu_int_thread_pprlog(int irq, void *data);
 irqreturn_t amd_iommu_int_thread_galog(int irq, void *data);
-irqreturn_t amd_iommu_int_handler(int irq, void *data);
 void amd_iommu_restart_log(struct amd_iommu *iommu, const char *evt_type,
 			   u8 cntrl_intr, u8 cntrl_log,
 			   u32 status_run_mask, u32 status_overflow_mask);
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 384c90b4f90a0..62a7a718acf8f 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2356,12 +2356,8 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 	if (r)
 		return r;
 
-	r = request_threaded_irq(iommu->dev->irq,
-				 amd_iommu_int_handler,
-				 amd_iommu_int_thread,
-				 0, "AMD-Vi",
-				 iommu);
-
+	r = request_threaded_irq(iommu->dev->irq, NULL, amd_iommu_int_thread,
+				 IRQF_ONESHOT, "AMD-Vi", iommu);
 	if (r) {
 		pci_disable_msi(iommu->dev);
 		return r;
@@ -2535,8 +2531,8 @@ static int __iommu_setup_intcapxt(struct amd_iommu *iommu, const char *devname,
 		return irq;
 	}
 
-	ret = request_threaded_irq(irq, amd_iommu_int_handler,
-				   thread_fn, 0, devname, iommu);
+	ret = request_threaded_irq(irq, NULL, thread_fn, IRQF_ONESHOT, devname,
+				   iommu);
 	if (ret) {
 		irq_domain_free_irqs(irq, 1);
 		irq_domain_remove(domain);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 7c12be1b247f4..0f9045ce93af1 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1151,11 +1151,6 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-irqreturn_t amd_iommu_int_handler(int irq, void *data)
-{
-	return IRQ_WAKE_THREAD;
-}
-
 /****************************************************************************
  *
  * IOMMU command queuing functions
-- 
2.51.0



