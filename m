Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C1339B959
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302527; cv=none; b=RTUkaSV/aUR2gk1c5kxvyKj2eyuQIMuXMgDBewfFGDme6dZndPKhE9VXwIE+KnH+1srAV474ActLTw4XirizGU9s1rLxk7skZMi6eTJkvHNxa8c6ShjOT+KKDYFkTc7HCLnwshRMGNo1GpOKoy4sIAcfJ2LzoHT0cyId0J+5kLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302527; c=relaxed/simple;
	bh=VljarYSoJR1Vu7vILIOkfVIo55WwxHbr/HMNk5IG7n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqNBKHEc6whWWDRLzDkgq8XWLc2NJjI8W/Za2O6UGBhFxeIaTk+QJB0SCYAX/0N6+b32McWtybIcvrQUbe+RfMHmXk087PDd0VhMr0gzFe0qEaFsetc/eD/oEg6Kr6ADMgRGXHY2Tp680p3287dX5PdDSG24iazcC95YjpqJToo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFu26gmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFu26gmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A94DC116D0;
	Sat, 28 Feb 2026 18:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302527;
	bh=VljarYSoJR1Vu7vILIOkfVIo55WwxHbr/HMNk5IG7n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFu26gmTjp6DSPKohyRZ51ObV6PVIS47ug5K1Rsiv8L88SCF8dVCbxSznQub+S8U2
	 ftfxkFcaM6QLO79oVTh9O4hZtmSa2OHp+U8QyVpLC8s0IfQ7sVofx//fbpx1quPb/I
	 W33tA1nAdKzGA3KpFTCKzENiMKYGrTyM958tGlraLCLTRq8+bv+gudS0jktj7GnVk8
	 hT5Zv3w8Fq677H+kmwRNYziznxy/gJpQkbS+WXGGvvXwvj8ggWNAEKCHEFZ+UWR6T9
	 2/JPmEt9gdHI4ncOa7f5XjdAw4oByHPrWjYZSDUo5iFm3LPwzY4xHbWxA/cz91OMI1
	 QWDd0FdMtkNEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/164] scsi: efct: Use IRQF_ONESHOT and default primary handler
Date: Sat, 28 Feb 2026 13:12:45 -0500
Message-ID: <20260228181505.1600663-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit bd81f07e9a27c341cd7e72be95eb0b7cf3910926 ]

There is no added value in efct_intr_msix() compared to
irq_default_primary_handler().

Using a threaded interrupt without a dedicated primary handler mandates
the IRQF_ONESHOT flag to mask the interrupt source while the threaded
handler is active. Otherwise the interrupt can fire again before the
threaded handler had a chance to run.

Use the default primary interrupt handler by specifying NULL and set
IRQF_ONESHOT so the interrupt source is masked until the secondary
handler is done.

Fixes: 4df84e8466242 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260128095540.863589-8-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/efct/efct_driver.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 37e1ab96ee5be..658f463744e66 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -415,12 +415,6 @@ efct_intr_thread(int irq, void *handle)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t
-efct_intr_msix(int irq, void *handle)
-{
-	return IRQ_WAKE_THREAD;
-}
-
 static int
 efct_setup_msix(struct efct *efct, u32 num_intrs)
 {
@@ -450,7 +444,7 @@ efct_setup_msix(struct efct *efct, u32 num_intrs)
 		intr_ctx->index = i;
 
 		rc = request_threaded_irq(pci_irq_vector(efct->pci, i),
-					  efct_intr_msix, efct_intr_thread, 0,
+					  NULL, efct_intr_thread, IRQF_ONESHOT,
 					  EFCT_DRIVER_NAME, intr_ctx);
 		if (rc) {
 			dev_err(&efct->pci->dev,
-- 
2.51.0

