Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D93379EE2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301690; cv=none; b=R1PE9Av+5zks8oc+WGknPmZ2lmn5tnbai+gxRgZjBZLWF7HwwA3+2jxt8EP0a/5pZ5Lzc3EN2g6zzTOCmurizLjz9RhyczzHTSWZCedfni0rFeiNn8ztCWdPG30WMtRn9gE61N2uv3/CXA79Hi1YgopbyLgmOFihQLn8e6eaaZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301690; c=relaxed/simple;
	bh=4RuloAWiI+Zh6K89/fyO7etQsiilFFQylgdV63Q87U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8wzKGiQy8HiUZJ7KrXSAEYYgjSqMIilPyFIroSCtAABG7DX8R9oZPKvStYPiNmG22jtbiUrNyBj0JvK95ZkscwPMtNJ6Zn8MclHEUWV116XIzdfCnIOI0m/AhgShrxc/VzKsBHzGgqYFrig9ykkdhdHWjMytp93AatWJHp2bdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwOrti0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwOrti0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61700C19423;
	Sat, 28 Feb 2026 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301689;
	bh=4RuloAWiI+Zh6K89/fyO7etQsiilFFQylgdV63Q87U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwOrti0SiYxSh7kUzbkChc0SJKbDJA5d6ZQqVZg2BuBxHbeqbzwrWSavtfwRwVlIN
	 tMxgGKoiAqvlhZZdCumHeKov40++AgNTQAwG0A0DgSDDSCfSy37SbMLH3OtICgfobL
	 TACeOKQb/Inc4Li2/V6PrkXuU5SfdKSzOQi/7XsS7FKL+g/szjMMelMz44p47xg7GO
	 tjZ8uLbnpFkZfOjy8/lZigr9aJRIvvOGmHU1E3/dcgMF6zA9LfqhbCbB8abF6keEXq
	 lHy3Hq/0fTwiCy9zdVPWiqd/1+DxkD0uL3GxCxlUcpvgrYy+8qCMtvSpqiy7f/w7uE
	 /RKg1ZUXFoy4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/385] scsi: efct: Use IRQF_ONESHOT and default primary handler
Date: Sat, 28 Feb 2026 12:55:02 -0500
Message-ID: <20260228180011.1568201-80-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 55d2301bfd7de..d1a73cc2398ec 100644
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

