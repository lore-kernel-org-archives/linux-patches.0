Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214E9DF5E
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D00BC433EF;
	Mon, 15 May 2023 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169322;
	bh=/G/kat3/EVFVq40tGfSYWvnXpO4BwYJ+wVxdSxVdJrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXL2GINuBchAh3BPSH3Cwn0i43iafOdr/bENzhXHH/8tA9GQwQ/WnNeQ427bKepC9
	 ZE8qIFb8ClP044V8OuyyhN95FMbDIHE4FUs1Czqykh9BwPdMgZviRebuL4jMZL8SNI
	 GlfNoPXwz1Hu/y2atVKqbTGQ7RrmN/UvGe2amJ10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 003/246] crypto: ccp - Clear PSP interrupt status register before calling handler
Date: Mon, 15 May 2023 18:23:35 +0200
Message-Id: <20230515161722.715758496@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>

[ Upstream commit 45121ad4a1750ca47ce3f32bd434bdb0cdbf0043 ]

The PSP IRQ is edge-triggered (MSI or MSI-X) in all cases supported by
the psp module so clear the interrupt status register early in the
handler to prevent missed interrupts. sev_irq_handler() calls wake_up()
on a wait queue, which can result in a new command being submitted from
a different CPU. This then races with the clearing of isr and can result
in missed interrupts. A missed interrupt results in a command waiting
until it times out, which results in the psp being declared dead.

This is unlikely on bare metal, but has been observed when running
virtualized. In the cases where this is observed, sev->cmdresp_reg has
PSP_CMDRESP_RESP set which indicates that the command was processed
correctly but no interrupt was asserted.

The full sequence of events looks like this:

CPU 1: submits SEV cmd #1
CPU 1: calls wait_event_timeout()
CPU 0: enters psp_irq_handler()
CPU 0: calls sev_handler()->wake_up()
CPU 1: wakes up; finishes processing cmd #1
CPU 1: submits SEV cmd #2
CPU 1: calls wait_event_timeout()
PSP:   finishes processing cmd #2; interrupt status is still set; no interrupt
CPU 0: clears intsts
CPU 0: exits psp_irq_handler()
CPU 1: wait_event_timeout() times out; psp_dead=true

Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
Cc: stable@vger.kernel.org
Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/psp-dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index c9c741ac84421..949a3fa0b94a9 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -42,6 +42,9 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 	/* Read the interrupt status: */
 	status = ioread32(psp->io_regs + psp->vdata->intsts_reg);
 
+	/* Clear the interrupt status by writing the same value we read. */
+	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
+
 	/* invoke subdevice interrupt handlers */
 	if (status) {
 		if (psp->sev_irq_handler)
@@ -51,9 +54,6 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 			psp->tee_irq_handler(irq, psp->tee_irq_data, status);
 	}
 
-	/* Clear the interrupt status by writing the same value we read. */
-	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
-
 	return IRQ_HANDLED;
 }
 
-- 
2.39.2



