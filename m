Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DE837524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302528; cv=none; b=A3jB9blG8K7E/PSHGyfrKuhKpJUJ4hk1SMQUez3j6vU0kaL7Ec3L/OBEW8umlHDOvTWyNAgKG3twUWaFdQwlRM2ofGadB4pDG9p2v2itll8OgkhGXoEO6zOHmp+U0dhSO4KnI6KgW95cor5BYq6SPC3A9SkKK478whnFeXfYXwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302528; c=relaxed/simple;
	bh=59LITi7aOoN7r4wDqGtmrfOjDVR9dos2nmNH/nlGLZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBDhhSqR2amvzUNc+42n5lFLOXosmo5tmi4SHJQrd8Gl5v+2Lto0Tmyss6lcZyztAeX9SmjIbn7xtaFlF6OWrxHLoVMNhgk/y+AjJNDLeTg23jtWKi7nl8+mGgRexc5c21dyyPOV9toARVcGD2VccMW6ATUxUc4aNUuhgZZFgKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/44CTO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/44CTO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6667EC19424;
	Sat, 28 Feb 2026 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302527;
	bh=59LITi7aOoN7r4wDqGtmrfOjDVR9dos2nmNH/nlGLZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/44CTO1dA1YuJm7jX5UOqqbvLivDohu1jIp1cMdvhD+WAe/27iF5+K26DJWR+9/G
	 NaYNGRcF+DCCcMjVCbpPlvKqfAMAjCBeBMsFbotn1HEa3wXg3yUEkTjc0P7YGrFHG2
	 MQnSetQKqfTPzz8XJL0nIWSGxFrEzBVDnD+sbUgI9JOp13PmkcITrWfuSRpivqxvil
	 moqL8uwC20aq2ngSyurO1AVrrCEVhHFQ5oRJSDN0sIpjjM3hpfRUQrZ9mk5zqfVPnd
	 1Lut63hcz+2zbuLzmWP6cUBOFp+LaRWtQPhyIyC5hc3JtMxweSxprYDiapgD9IdBAG
	 lmEX00F3enoSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/164] EDAC/altera: Remove IRQF_ONESHOT
Date: Sat, 28 Feb 2026 13:12:46 -0500
Message-ID: <20260228181505.1600663-27-sashal@kernel.org>
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

[ Upstream commit 5c858d6c66304b4c7579582ec5235f02d43578ea ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until
the secondary (threaded) handler is done. If only a primary handler is
used then the flag makes no sense because the interrupt can not fire
(again) while its handler is running.

The flag also prevents force-threading of the primary handler and the
irq-core will warn about this.

Remove IRQF_ONESHOT from irqflags.

Fixes: a29d64a45eed1 ("EDAC, altera: Add IRQ Flags to disable IRQ while handling")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260128095540.863589-11-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/altera_edac.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index f1f8c34638339..ff65779b5d657 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1535,8 +1535,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		goto err_release_group_1;
 	}
 	rc = devm_request_irq(&altdev->ddev, altdev->sb_irq,
-			      prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
+			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "PortB SBERR IRQ error\n");
@@ -1559,8 +1558,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		goto err_release_group_1;
 	}
 	rc = devm_request_irq(&altdev->ddev, altdev->db_irq,
-			      prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
+			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "PortB DBERR IRQ error\n");
@@ -1943,8 +1941,7 @@ static int altr_edac_a10_device_add(struct altr_arria10_edac *edac,
 		goto err_release_group1;
 	}
 	rc = devm_request_irq(edac->dev, altdev->sb_irq, prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
-			      ecc_name, altdev);
+			      IRQF_TRIGGER_HIGH, ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "No SBERR IRQ resource\n");
 		goto err_release_group1;
@@ -1966,7 +1963,7 @@ static int altr_edac_a10_device_add(struct altr_arria10_edac *edac,
 		goto err_release_group1;
 	}
 	rc = devm_request_irq(edac->dev, altdev->db_irq, prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
+			      IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "No DBERR IRQ resource\n");
-- 
2.51.0

