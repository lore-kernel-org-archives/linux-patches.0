Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18451383C69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302074; cv=none; b=mNuJVOp37JBF75KEihbZCcjV23oq3Is27EqffPQ855tYQJ5KflihIoaHcE4hYAcc7xEn3sbhlvPLDrJiHpUm0XQR/wgfPjLjmyPOo9N9aEna+aaeH8odkSBrIQ7jfG6yDfVXKISIqKaunVgKa4Q8/cvm+MzsZ5Oiw8qtpwoJO0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302074; c=relaxed/simple;
	bh=f1KmbxE3Tato8YOSJlhKs7BOwG9oRjD1++nMPx/Xti4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fz25rmQ5keUixQkxnnf8rz+AlmzwhfdGqRfiEcKn2GPFydICrGjHdVcLNs/Uqavcj3lDSen8lAj8u4VBqJlfZ85CdjUUfYUS3jsV8aCjhJAGAJEJ6N3peaDVCmLyCqsY23AJ5I+ckNWpklnQH0jBQwOCTOsW8+LkrFI6el35jDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PpTx837G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PpTx837G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDFBC19425;
	Sat, 28 Feb 2026 18:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302074;
	bh=f1KmbxE3Tato8YOSJlhKs7BOwG9oRjD1++nMPx/Xti4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpTx837GKdeV1Qj/SDWW1KaYT/UvEh6dcX0aj9H69bVJy6iod+hha+ZZj2hboGSJc
	 sjHBWRwzqBoC1DDwu6kbFu8XhbiXgnZirO7Hg8O2Cvp+K9qiUNeAkmG8QpI6Hgxc5Q
	 X60usjl22yd9KGv6jb6V1He5RYVk1OJw9OKUDNaPVJCoDvR+5iU6GOmX/w9Lz0fpLL
	 kXTtOwwtk8ROodjKHrTt20mEdsuJHPjNOx0Hkcw+pwKAQzDwO03Wcb4BYD4Cv8v8dO
	 IJp2A1y7PkdOuWFm24VcMd++Zfg1rP0RVno4tTiTwuzmo41zN+gPorAn+2tUtFUwon
	 16Pyk/tYE7CMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/283] EDAC/altera: Remove IRQF_ONESHOT
Date: Sat, 28 Feb 2026 13:03:16 -0500
Message-ID: <20260228180709.1583486-54-sashal@kernel.org>
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
index 4f8f87207b67b..dc1915ffc3cbe 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1573,8 +1573,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		goto err_release_group_1;
 	}
 	rc = devm_request_irq(&altdev->ddev, altdev->sb_irq,
-			      prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
+			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "PortB SBERR IRQ error\n");
@@ -1597,8 +1596,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		goto err_release_group_1;
 	}
 	rc = devm_request_irq(&altdev->ddev, altdev->db_irq,
-			      prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
+			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "PortB DBERR IRQ error\n");
@@ -1981,8 +1979,7 @@ static int altr_edac_a10_device_add(struct altr_arria10_edac *edac,
 		goto err_release_group1;
 	}
 	rc = devm_request_irq(edac->dev, altdev->sb_irq, prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
-			      ecc_name, altdev);
+			      IRQF_TRIGGER_HIGH, ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "No SBERR IRQ resource\n");
 		goto err_release_group1;
@@ -2004,7 +2001,7 @@ static int altr_edac_a10_device_add(struct altr_arria10_edac *edac,
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

