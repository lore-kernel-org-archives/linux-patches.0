Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA6736C9E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302325; cv=none; b=jPn6Y6ZwZzVRyZlDFJITV0l7kU9bqSG2LNEh1Dv4lEuwB+xanO8Jiq02kR8XNe+ZAzPFup9iRHkyOWLDk3wcvo8QQeIzJD5MOXO8vXdObij+H3VZJT5ECUJWhyPxqiM7leFeG/BavK83pdc6S6LQlC7wa9QHV9Cn87+YNPgkLe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302325; c=relaxed/simple;
	bh=UyoWqlxixb3SoMs2BlyTc4bCKC4DVRh2QbtBUz/WhsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmD9ZyqmAoho5FKmr5KJTcG8ViQmOxuIUz6WkUz5xoWPXPwaR+VJIXHxNxFAttVxQT0zFZ4+/OmWPnBH9d/l9hurTDzF1wr9K52j8Di5fKTSAr1Oze+NOv3wG1Zmzdu2NrSje1fqVdQOIrhuRbCaIEUxL+pLgJXUrOl1TYwMFio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0rVjDgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0rVjDgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382FEC19423;
	Sat, 28 Feb 2026 18:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302325;
	bh=UyoWqlxixb3SoMs2BlyTc4bCKC4DVRh2QbtBUz/WhsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0rVjDgUjMaIQAUWqdggvBSt9pNhnVW3/JuQGRoqFmKwi3ScOmwAk5L9nvJpmNo50
	 vyRFX5fMOef3Wk1H1+l3CtP4qhxcNfJ/yv6wqRIS+oHRiHtk7S3/qKxDyfgIMznI0T
	 tQf+PqM+zy0uQ2bh+t1y1NRwzUugHggWjkSTBmg4bNUBVHFSVqFDAYv3ueZK4pIqlV
	 X9vU10cdMESaS1mMvGBt1194V3MQs7/TmuRiXvPAgkzrkJcWUXpSRtuzkscozr0d/G
	 Ka5ufWrVgnAzYLAmphYgfKfyzoRnQqirhnQY64XcNhayGuQU9KDtX9xsDPM1AT5d/9
	 fb+COfGbME52g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/232] scsi: efct: Use IRQF_ONESHOT and default primary handler
Date: Sat, 28 Feb 2026 13:08:18 -0500
Message-ID: <20260228181127.1592657-45-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

