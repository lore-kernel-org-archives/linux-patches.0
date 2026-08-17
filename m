Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B013BB687;
	Mon, 17 Aug 2026 14:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975454; cv=none; b=YoAvMgZtKg4CbvqdviWl3ZTMQ0Dh8A+Fzup5fStZKxQo9DgcZAnzmfkfnLllSrYXtF8eUhLa0q4rDbTRDyDx4KiyKTuldyW4SJyt5bQF5tYHIfOGaKW0VFUAn5X71MBo32p0Pki42dcJ2NGeqhNw+0OM7QG7fnjNrO4Ki7MSy5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975454; c=relaxed/simple;
	bh=lVydpfuswHMxMV7lbWXK12X9sdLTPTkFAmwXCKH5x1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzuIERokuo5X+PXrhYqrzQJMUIwHs0lR/HHyYRHmQAomPI2F52Q08gGl+mpV48aoeFLHC4PvGrn2ZN0VJ2Y59Y5TPSMLr7rJq8idB1l2EjTPIdcA2hvBQwYHU87JaSqtcsqLlX8yTkXGXuIb+3qIwgBVwuOXWlNB4y1N9kC8M+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NuDvcfNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NuDvcfNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EC21F00A3A;
	Mon, 17 Aug 2026 14:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975453;
	bh=//yPDFaez1rZL13puMBRr6fK1WJhDeWHMwHhBOIhcYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NuDvcfNEZMmsZ1EBSl5lE9jNQOLthoNapc/QQiBOY14LW1uN2h/enBwt3mmVee018
	 6o2WIqT5xA2Su2dlGjqFouG81qtoK5YVpzXTHCYebT7Id/MLh8wgMhOuyTteL2HBH+
	 jOWAL4dbZ/li5kd43QW4d/Gwcx1I8LZmGD0x8iYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/389] ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered
Date: Mon, 17 Aug 2026 15:27:53 +0200
Message-ID: <20260817132540.301264906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 464260f6687082..e9383db1b13a98 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1246,9 +1246,6 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	/* Save dev for later use in dev_xxx() routines */
 	hsdev->dev = &ofdev->dev;
 
-	/* Enable SATA Interrupts */
-	sata_dwc_enable_interrupts(hsdev);
-
 	/* Get SATA interrupt number */
 	irq = irq_of_parse_and_map(np, 0);
 	if (irq == NO_IRQ) {
@@ -1281,6 +1278,8 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	if (err)
 		dev_err(&ofdev->dev, "failed to activate host");
 
+	/* Enable SATA Interrupts */
+	sata_dwc_enable_interrupts(hsdev);
 	return 0;
 
 error_out:
-- 
2.53.0



