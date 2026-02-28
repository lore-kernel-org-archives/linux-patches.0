Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4949F35AC00
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302677; cv=none; b=Id/BkUjxcWZVZa2QHSsGr/gxojzLo1J8aLYXjbbJ6h2etaZ+bhHfY6zEyfNpY1VNbj9ofQO8qSo1XNq4dkHh+dHJT31Kr+gM/bDM9JSym5iD4SwpDzn2sqaqYoguwBHZMNF5fPtzEQPPenA5qgUW5lnb25E5JDxjtCdMp+RiApI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302677; c=relaxed/simple;
	bh=GZ1pR6F0yW4r/iW/ZRsekU/+N//7Jg+eN2fXuXAWLBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cd/fqN0x4Ck6AtaAyn4y8SzgRUS7m+oDVA5R+MKgIEg1+2v9UZqAhlSnPhYcZ9UxGcitPGuzli3akB3TD8n2ezG0tEP9uxySDTzDk57VWUAEvnV2AuKmn53YDFdR0zDGe8VOHmorcxvKoeQw815iD77x6MbponLzttgX7K1TgRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TIGFZ5lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TIGFZ5lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23E5C116D0;
	Sat, 28 Feb 2026 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302677;
	bh=GZ1pR6F0yW4r/iW/ZRsekU/+N//7Jg+eN2fXuXAWLBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIGFZ5lt2g8YAuvyrbYzcsUKqvTTCV/kzi10Mrc8oIRltCbW06I+PQT3RZOzoMJKL
	 Z9LHms6BjEHqtVRi3yEIeTuJjlz1k9hK4UceK7jPeztHmHzo6qTAOhjXM/sa6yCdw+
	 6SLcMa4wKNW66k9VH/NLcc9L/ZAqZ2L8Wzi+SPGbT69vPhgoVxfxz09W3sreZ6p2PX
	 xxkg+6awKAZHGzYcTcuqV6AfBOrpbXQenrw67/G92x/CI6yJbiKU65i4MRtaOv9aRn
	 dX+EQurooQhwaVOtsZi5tQbAcDUfXXZXtEXiwJE+HHrgCuXXhqK2w8xM0VQWFS0JqT
	 0MRmZVF62IUnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/147] EDAC/altera: Remove IRQF_ONESHOT
Date: Sat, 28 Feb 2026 13:15:35 -0500
Message-ID: <20260228181736.1605592-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 681ffb9db8438..63fea769b99ac 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1521,8 +1521,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		goto err_release_group_1;
 	}
 	rc = devm_request_irq(&altdev->ddev, altdev->sb_irq,
-			      prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
+			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "PortB SBERR IRQ error\n");
@@ -1545,8 +1544,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		goto err_release_group_1;
 	}
 	rc = devm_request_irq(&altdev->ddev, altdev->db_irq,
-			      prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
+			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "PortB DBERR IRQ error\n");
@@ -1932,8 +1930,7 @@ static int altr_edac_a10_device_add(struct altr_arria10_edac *edac,
 		goto err_release_group1;
 	}
 	rc = devm_request_irq(edac->dev, altdev->sb_irq, prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
-			      ecc_name, altdev);
+			      IRQF_TRIGGER_HIGH, ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "No SBERR IRQ resource\n");
 		goto err_release_group1;
@@ -1955,7 +1952,7 @@ static int altr_edac_a10_device_add(struct altr_arria10_edac *edac,
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

