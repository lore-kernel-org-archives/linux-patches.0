Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D394545D82;
	Wed,  9 Sep 2026 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961930; cv=none; b=G8T7nUGpt9e4PasPqwDA2NST8MC00VRx5PJkpjCg1PA9oqOUl42SzKJz2p6ss29zfOudHS33qyo5NpUIf/o8xmrixYMkre+v75pVqzn99VotTn1rGZSphlH335fNSoXKHC5aOaLFY0j9bhR9piBSxi9NaYzBERVI2gziWM5oQnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961930; c=relaxed/simple;
	bh=DZrrmjeuSAbU5PBbrZNLSIHkMnGhe/cZUzn11bWJR5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaXBBd/COHv06d2bLEATUXpUgZFIgDjzQZQ1Ewk5qba6lQUHOdzt4ywwqS8coK1tjiklYV5TQsieZ/hyPLULP7y/uuBSteB8DSjiD4KwqUhnLbHCgLLC3A4FDa35CqTauIfgbBGI+/IExWnAvBI1YJOh8lXXYmnGW68zXeTLwx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IY0Q7+8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IY0Q7+8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667D81F00A3A;
	Wed,  9 Sep 2026 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961928;
	bh=1/bGFrqv9i6fYC3FMWC9eZwRZil1w7QbO+Ch40u5wzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IY0Q7+8c15x7cj0OEtNR9k0oH7SjqL60JQ0oxA58Vs1Rswh+U2Ip8WHiYgOVEj9/X
	 W/R3C0/PUPGAvQCjA5NXS4hkJsviJSED5axc7zR+DRN2QH+erTc6InAYJU6zWXhck5
	 G3AvSI17Pq91tk0rD7eZBNJmeUZaDImlqbTVO4gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Koichiro Den <den@valinux.co.jp>,
	Frank Li <Frank.Li@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.2 113/556] dmaengine: dw-edma: Mark emulated IRQ as level-triggered
Date: Wed,  9 Sep 2026 15:36:33 +0200
Message-ID: <20260909134234.450335680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 0d995da5fb97e8c312834575604d4423eb6225b7 upstream.

The interrupt-emulation virtual IRQ uses handle_level_irq(), but the IRQ
descriptor has not been marked with IRQ_LEVEL.

The interrupt emulation is somewhat unusual: the eDMA interrupt handlers
dispatch the virtual IRQ for every edma_int[] interrupt because software
cannot reliably tell an interrupt-emulation event from one caused solely
by DONE/ABORT status. If an interrupt arrives before the doorbell
handler is registered for the virtual IRQ, the IRQ core marks it
pending. When the IRQ is later started, check_irq_resend() treats it as
non-level and replays the pending interrupt, causing the newly
registered handler to run for a stale event.

Mark the virtual IRQ with IRQ_LEVEL so the stale pending state is
cleared without being replayed. This was observed in pci_endpoint_test
as two doorbell handler calls when the DMA-variant test ran before
DOORBELL_TEST.

Fixes: d9d5e1bdd180 ("dmaengine: dw-edma: Add virtual IRQ for interrupt-emulation doorbells")
Cc: stable@vger.kernel.org
Reported-by: Niklas Cassel <cassel@kernel.org>
Closes: https://lore.kernel.org/r/ampndLtU32ODmncX@ryzen
Tested-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260730160701.3550710-1-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -763,6 +763,7 @@ static int dw_edma_emul_irq_alloc(struct
 		return virq;
 
 	irq_set_chip_and_handler(virq, &dw_edma_emul_irqchip, handle_level_irq);
+	irq_set_status_flags(virq, IRQ_LEVEL);
 	irq_set_chip_data(virq, dw);
 	irq_set_noprobe(virq);
 


