Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AEB383C69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302073; cv=none; b=ropSjqIzjWnUbLnLf1j64KMGkKK8RlOZhlZfWbsQH36Rmh+GPiry87Gm/iIFFUfoGM0eZVgAmput8RGSZya6YiC4D9cw4/hoxkNgouejFvg70y2uzYdIk6CwzGE/vqqY1egf3fi8WytEVnqjcyZ6h4b1+08P2jM2CDD89m7tsqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302073; c=relaxed/simple;
	bh=UyoWqlxixb3SoMs2BlyTc4bCKC4DVRh2QbtBUz/WhsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arGunXCW6Oz6QeV1RWEKp+pVH/6LX6QvpJ4u547OWoiKX6GlG2+AU42FKz2rIS47e0gL6mK3JxwzbpnczBP1A09Y2mKCrA11QO4gKk7BRj/K1aSLeYK+R6TqfNsRpMQkYGOiwEu966VWPghvZmQF/yhJIn6xpU/b1cRazuq7CXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlTMFVYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlTMFVYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF51C19425;
	Sat, 28 Feb 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302073;
	bh=UyoWqlxixb3SoMs2BlyTc4bCKC4DVRh2QbtBUz/WhsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlTMFVYKeqIxLhTfZOXiezw7WiS6XSawKST34Ap/wVWcLgd+p139tXxktyGXxB4wn
	 fTyNpA6b0xwGd0czti16OenV8L+2pQ0zMF8fuFv5ndNJUEZ+W56+mWTkT0T4aXaZgE
	 bbUfZU7URMhoTpPxfrotnZHZhm1z9PI9hE/3kNgq32Z2rJ+xL2W+8QRgQ52DlY62Zh
	 59CsDnGccTpMXPuniwApArceuZK5PWA1hbJi86Dl8HpzwvSVZ2lq1igs0tjdOUFqWd
	 NoyQcyUIRrBV/rYMbZY95nrDk/EQ4XCkRXzO9J0MTCgGqa0oyb6z6JhMd0UTqiLuSK
	 jYeSuIt80GEWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/283] scsi: efct: Use IRQF_ONESHOT and default primary handler
Date: Sat, 28 Feb 2026 13:03:15 -0500
Message-ID: <20260228180709.1583486-53-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 49fd2cfed70c7..37aba56e07217 100644
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

