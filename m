Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F73253F11;
	Wed, 25 Feb 2026 01:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982994; cv=none; b=d1tY73YimI+lN1Yleu7YQv1+52WM1ksqZE5dvBPPFBUHrcmKQo6tUUbb9e0MmLsTIf1E/Y3GHpjqXL9kMc2Q1EdpKtGGXg57AacnQ9PtGCYNtUk2YUYr9YJr8ptfwvwiS05Iza5fG3GF6tLEMzVHGL6YG213SmFOsfNNWcvGQu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982994; c=relaxed/simple;
	bh=VYQMtx2sRxw58EQmlfe3Mlaf9d82WHIZR3t4/Yic4ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7lXmjSxnoGfWWwHk4vNugzIJ4ZjkTA7E/eoieVBdmfRccO/qoz3AtSc5AdRCSTK/c19w0Ydfal2tpWOKOTKR7qlG7LMEp4uGXg86osO4fAjeyxF95lDz5TnYZ7119CMNcG3dMkQYwCCHEtIlKOkejZO74mp0Pbf1VNFP9iiA/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGn8IF8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGn8IF8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DDCC116D0;
	Wed, 25 Feb 2026 01:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982994;
	bh=VYQMtx2sRxw58EQmlfe3Mlaf9d82WHIZR3t4/Yic4ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGn8IF8gWUh+WkkT/O8uJUZr9YylpKUQsnwb6wEFg5G/SmQi7549Hq9PiQL/xTPjs
	 BDVViqHgwfoZ3r8yGLUvcPMZYM1BFV6LwBUCbufnWyitM81dDEJQqFXEt+mQo7TkMv
	 sQte37vhfsdnO+h8SlOVv8RS7FJe0QIvgxKk49fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 121/781] scsi: efct: Use IRQF_ONESHOT and default primary handler
Date: Tue, 24 Feb 2026 17:13:50 -0800
Message-ID: <20260225012402.636312903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 1bd42f7db1773..528399f725d42 100644
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



