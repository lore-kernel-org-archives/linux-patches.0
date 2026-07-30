Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E168212FAD;
	Thu, 30 Jul 2026 15:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423602; cv=none; b=Agaotqwmh0iBmwJjI5f0qE1FUl+1++JPlMmq/yqdcLdxf/5oV2kxhWMC81sJ4q18y2hD9wKq1QDMYgTw357Lz53BWvXj/vj8h4eknsSdAv3b+0aCAIlFpzYAyKNNFCar7RmYc6r1RFCVYcV54NbvfpHqYh5M5smVMTWf26rUlUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423602; c=relaxed/simple;
	bh=d8pZ6xYAluXf4Bkfd9Q0U39CKXptaRvf6gtWB6g2hqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+TaNR0Vy25fA5s8WXwTcO7ncKTf5nF1pKdmlPRhSF5ZpXFMn7Ykz7uLEYvspJlKZWnjmy5OUELzHzuRCoxdSruTkIKgXUtmbYYji0sw6lOSaS1A07FEVRpZvtYm3ets49BM0tQA8pGkt0byAAA5sroxc1Bx0dPg150aGCnMgnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jz+kDzAh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jz+kDzAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9651F000E9;
	Thu, 30 Jul 2026 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423601;
	bh=8ObwFG5LpAn3HmsCqmS+1WKSttlX7YH+XRFWeWT6W44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jz+kDzAhZwcZmQb0+/ubvAazGA5Vpt7Ziq3FpO4f+iqYOzVCX5Z+SyjlZkczJsUiy
	 T9GSeAAKKfK5rDNnnBRgiTBTDG0oXrhfvXoFxsuOkuy5v81gPitN5ipKt0ZsiQQIHE
	 Qe+sLc/Z3ykqEoFmyU9GfFAgK9rxG6E0emdhb0aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/675] ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered
Date: Thu, 30 Jul 2026 16:07:11 +0200
Message-ID: <20260730141447.282282696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 4bbc16a353a98023e5ddfca7c1fc0e49971cf4d0 ]

sata_dwc_enable_interrupts() is called before platform_get_irq() and
ata_host_activate(), leaving the SATA controller's interrupt mask
enabled without a registered handler.  If a later step fails (irq
request, phy init, etc.) or if the controller asserts an interrupt
during probe, the irq line may fire with no handler, causing a
spurious interrupt storm.

Move sata_dwc_enable_interrupts() after ata_host_activate() so that
interrupts are only unmasked once the handler is registered and the
core is fully initialized.

Fixes: 62936009f35a ("[libata] Add 460EX on-chip SATA driver, sata_dwc_460ex")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 7a4f59202156ec..4029e082577fe1 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1168,9 +1168,6 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	/* Save dev for later use in dev_xxx() routines */
 	hsdev->dev = dev;
 
-	/* Enable SATA Interrupts */
-	sata_dwc_enable_interrupts(hsdev);
-
 	/* Get SATA interrupt number */
 	irq = irq_of_parse_and_map(np, 0);
 	if (!irq) {
@@ -1203,6 +1200,8 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	if (err)
 		dev_err(dev, "failed to activate host");
 
+	/* Enable SATA Interrupts */
+	sata_dwc_enable_interrupts(hsdev);
 	return 0;
 
 error_out:
-- 
2.53.0



