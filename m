Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1B64446F7;
	Thu, 30 Jul 2026 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425490; cv=none; b=XLMrzpuexSSaInD39LnK4U5mSLRRHKi9wn7tHIy1ARHPvgnk7iGLyHr34OecRuVfxs5a/RHg576uh1F/JZ7F4uVRwrGLKTjQKzDacqnRPSj3NKCQ2lKX+MmpW+y7NCFMnhX/evtwEJi9wi5lS2wwbs9Psl92FuExCGT8ZqHhIFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425490; c=relaxed/simple;
	bh=Ukvz5vvLG4lQydG04+SpS9eHQYu/K17EstYOvbwZwkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQGkhIt+SU28xHp82XFOIXSbAHgQ13m1l3u48np7a2EUuoS4e0261PMy0rMoUvnWrmECnKYnZrTED1DXAmTM/B7gxN6CdLluG6xUDhW2Va7RorSEnMhWUf5mivbfohy27ipmWdRlsc4A8wrbimGCgFR1wOikteuwCz5PrjAJ4cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HinY3xdP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HinY3xdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8831F1F000E9;
	Thu, 30 Jul 2026 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425489;
	bh=WM0iGQ6aLJEJQcJSjafm9n+8hHBFKQH8mTf5hNenZao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HinY3xdP9thsDsKwO9IvDILAA9vtfUe1s+M26uQRi/636o1Oq+iFEhJPY0hx943kn
	 e3kt9jNRaLe+9hF2wL806GvkrKLPycNpHwMLq45wc1RUk7RCdVA2Ut4ZvRBDHWph3Z
	 NY1nC1jkSoUh/dI8ykoFVC1A5wyMmKDPdgTVVwJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/602] ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered
Date: Thu, 30 Jul 2026 16:07:57 +0200
Message-ID: <20260730141437.781883029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 52f5168e4db542..16c1deef389d10 100644
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



