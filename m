Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC1A24677D;
	Wed, 25 Feb 2026 01:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983826; cv=none; b=jZmbUP3xlDw7Xm1KM43S6IQxuiXRq7CKQV9HVA1jGRgH1THM4U8IWm1zYUKTo95BqMWOYbCGvjFXaMQWn8O++x09fHRkJInBtGC+kviWv4pcg2tO52rEMwqQ0/Nr2yrs0+Gdyy4JLIrvlPVCJh+YnjYz107UGDPDALgFqaNfbJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983826; c=relaxed/simple;
	bh=x/SB3Xp7PLgqPMyExswdJ2jPTpIVjSoRLvMvIK08+Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSahRIZuyD/avejsBvzhY9bZ3iFR8cXJayvR9yMaqkZiFrhjE6p0OArpZZ58sb/LTpy85oAHfcSk2DWVRkA5TbBD4BDNb45nPun8MYsxzP6x9oTS4Qk5CZh0rCrm46X+uzYIBmGLP2TwpZSnTO7vb8qkCuEc9Fig/o9IMQMALrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ictnhAfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ictnhAfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30928C116D0;
	Wed, 25 Feb 2026 01:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983826;
	bh=x/SB3Xp7PLgqPMyExswdJ2jPTpIVjSoRLvMvIK08+Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ictnhAfU2kYD0xBEVRHw7biy2buxvXWQBiA4j3HD4tTiEDO2PrB/4NtQtofDQCFjf
	 GzLKCZF/gAjTKkrJVmz3xkBe4jXytl/13/Mer1hifAxrejql+FXqhvO4mC7JbVSQv2
	 deyKhOrGQgrqeEt4UVfXuLH7lwOgclQM82LDorgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/641] iommu/amd: Use cores primary handler and set IRQF_ONESHOT
Date: Tue, 24 Feb 2026 17:17:13 -0800
Message-ID: <20260225012351.711700470@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 9b4b589a54b57..bf77fdf5529f4 100644
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
index 034edce816d01..53afb1cb0a6fc 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2355,12 +2355,8 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
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
@@ -2534,8 +2530,8 @@ static int __iommu_setup_intcapxt(struct amd_iommu *iommu, const char *devname,
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
index 5914bef0c8c19..30dd482fe0953 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1146,11 +1146,6 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data)
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



