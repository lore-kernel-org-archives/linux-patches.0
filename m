Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E2624677D;
	Wed, 25 Feb 2026 01:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983829; cv=none; b=ALzMmHmNL74A3Ohp3G+AqH3l+5YP5vvSYWBl7QkTPfLpnVkH6/WZeeUk0ZnGPXKCJlkRw0v6bVeteuUfuHK0OrivSJCZuRLhp0/44oRDfF5AVDP/9e/SX/GsG2KiMhgJUyFxooTMhAzI1fC3EwoXAalobBRoo3pRNWQbl/r4hkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983829; c=relaxed/simple;
	bh=sWX4Hxc743lh76Y1k/5EFjfE4SWhDqtwK+oyw3wIgUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5iKCUG1Zlk1WQv4J3XjagJV9RQWQ2GoIoym6Wt4PsCjPs6SXED/LQ9blanU9QxQrXIh+g6p6fUCy8VqfxdhZs9Hi7NBqUny4OOgt+w/fpRPMzwJIGBkHvg257vzd0i1YL1+ai4WrY+gmGe9ottg5mSu9qaqW0/g83xCk2uY0Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwOKD9aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwOKD9aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F89C116D0;
	Wed, 25 Feb 2026 01:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983829;
	bh=sWX4Hxc743lh76Y1k/5EFjfE4SWhDqtwK+oyw3wIgUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwOKD9aNIagrhGAxv4wqM0D6jXHMth5NmItUfZlIZP5d1BzPrLYiI69pT0a0rUnEQ
	 fb1jtl0ydeLAFRGYfQFc/ij8oQ82JEuzGU0S66q2Zln1nxjbjBHzXsPYVhY5XpLAwJ
	 h9wxItnfg7wOz3KfdcutWn6lxQbJkJWVGNn0Bon8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/641] EDAC/altera: Remove IRQF_ONESHOT
Date: Tue, 24 Feb 2026 17:17:16 -0800
Message-ID: <20260225012351.787751952@linuxfoundation.org>
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
index 0c5b94e64ea15..4edd2088c2db6 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1563,8 +1563,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		goto err_release_group_1;
 	}
 	rc = devm_request_irq(&altdev->ddev, altdev->sb_irq,
-			      prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
+			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "PortB SBERR IRQ error\n");
@@ -1587,8 +1586,7 @@ static int altr_portb_setup(struct altr_edac_device_dev *device)
 		goto err_release_group_1;
 	}
 	rc = devm_request_irq(&altdev->ddev, altdev->db_irq,
-			      prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
+			      prv->ecc_irq_handler, IRQF_TRIGGER_HIGH,
 			      ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "PortB DBERR IRQ error\n");
@@ -1970,8 +1968,7 @@ static int altr_edac_a10_device_add(struct altr_arria10_edac *edac,
 		goto err_release_group1;
 	}
 	rc = devm_request_irq(edac->dev, altdev->sb_irq, prv->ecc_irq_handler,
-			      IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
-			      ecc_name, altdev);
+			      IRQF_TRIGGER_HIGH, ecc_name, altdev);
 	if (rc) {
 		edac_printk(KERN_ERR, EDAC_DEVICE, "No SBERR IRQ resource\n");
 		goto err_release_group1;
@@ -1993,7 +1990,7 @@ static int altr_edac_a10_device_add(struct altr_arria10_edac *edac,
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



