Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E6F4B04A7;
	Mon, 17 Aug 2026 14:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976604; cv=none; b=i9tCjUCJ759AGs/IYQEVT4bDcw0e0pD4FVkDIuOK/rt2a0aNO28zyZMh6LekX3yLoCujMjV/OcShpVIjpuYUlXCLvuYfdIqlI3VVK/hcHBOidrkz8CEGGBjUcGVBz/41K4muT6cfevnCHU9UJ+YoY8/95NJc4H/YmoGsXKCVE94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976604; c=relaxed/simple;
	bh=r8CxjLMT94Z4eRqSF+khFp4ZefiSinAkrufCxwuWRqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upAU/P2/LWVkczapleIebWMI9Pg4NMYiKVIjTjc/efuuqTyNggfpZKuLRtW2x0cV/7e1GeAcdy+jhosP8Ogj1yhCuh/NuzwM79TT+xxGchjJcA3JCdRu1WWGvYEE8pM80OV5Ef3P3O+cX/JIsjl5EcgKoDh4cJseVQT6TG8csKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJMCwPY6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJMCwPY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BD21F000E9;
	Mon, 17 Aug 2026 14:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976602;
	bh=wkcQR+S5YYezdXTZXJNtANytEE9kEEQC7O/rUOqC4QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJMCwPY6H5rFHDG0D2OqHxdxuNWF1lO1b+QLlYAWJmaY/fRyg62+KO007MhKuR+1Y
	 4rZmbl9KRyGqGxGah95K2zZbuG616LKeGpVj1cQp9H08SBew5IjRIlHpWVhUMcviYw
	 57pVO8Sma2QWJ+/zDEqRB77IKOqxTXDLhcXrfdvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/456] ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered
Date: Mon, 17 Aug 2026 15:27:10 +0200
Message-ID: <20260817132541.606094446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 29e2b0dfba3096..dc9d91eacac82e 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1256,9 +1256,6 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	/* Save dev for later use in dev_xxx() routines */
 	hsdev->dev = &ofdev->dev;
 
-	/* Enable SATA Interrupts */
-	sata_dwc_enable_interrupts(hsdev);
-
 	/* Get SATA interrupt number */
 	irq = irq_of_parse_and_map(np, 0);
 	if (irq == NO_IRQ) {
@@ -1291,6 +1288,8 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	if (err)
 		dev_err(&ofdev->dev, "failed to activate host");
 
+	/* Enable SATA Interrupts */
+	sata_dwc_enable_interrupts(hsdev);
 	return 0;
 
 error_out:
-- 
2.53.0



