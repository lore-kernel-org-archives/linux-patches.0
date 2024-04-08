Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C9B7442A;
	Mon,  8 Apr 2024 13:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582171; cv=none; b=XyD+4RdIG6+qkrlyIIy72drTC2fPJ0+ydMRaQrOzgOeus9l/zF7YexW7ffXvEiGantvLbizYKNDR94eylNydVhpF5rdVt5PnPrIyjq3OJn0A8uPHOlqEQd+pkfRpgnhwbvVF0GEcscLu4BRqfaxU/mZlmEm5vCD7w2e8zyenJQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582171; c=relaxed/simple;
	bh=Agax1ddfWYFn3szZzVoXOw7uRIX6Ibn/a9O3+UfBJCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fq5wyw0Xxw5q8Ch7icEIdZZSTwo1oRe+S8G5TFbZo8raBjq4DCKrievZGjmF6Lfw0JfAJNcI8l+VqmLR4/tvUg45SPtMErS8CK/QwYmNPeIZ7e69XFm28tczNgWAwi372MKTh+F3oBIWHdg3dDfl5TE/nUDdvREkvqh7W7CeNz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO6nJbOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO6nJbOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EDDC433C7;
	Mon,  8 Apr 2024 13:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582171;
	bh=Agax1ddfWYFn3szZzVoXOw7uRIX6Ibn/a9O3+UfBJCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tO6nJbOH3lAbLrFCWMaQd/4Q88rt0p2IF2mw98bUcY31RHUmbcUOjrxTBVXSxxbJa
	 5wyrF7hn9J28gWQIl+w8Gij2meaADHtbb9H0jekGxdwXiXbVakuZlPNw1ZUsnYVAnr
	 HK1OS26K+p7ncxojkFK7+H4xf7Qukrj6p4NaOOLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.6 069/252] RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
Date: Mon,  8 Apr 2024 14:56:08 +0200
Message-ID: <20240408125308.776659069@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

commit d8dd9f113e16bef3b29c9dcceb584a6f144f55e4 upstream.

The writes to setipnum_le/be register for APLIC in MSI-mode have special
consideration for level-triggered interrupts as-per the section "4.9.2
Special consideration for level-sensitive interrupt sources" of the RISC-V
AIA specification.

Particularly, the below text from the RISC-V AIA specification defines
the behaviour of writes to setipnum_le/be register for level-triggered
interrupts:

"A second option is for the interrupt service routine to write the
APLIC’s source identity number for the interrupt to the domain’s
setipnum register just before exiting. This will cause the interrupt’s
pending bit to be set to one again if the source is still asserting
an interrupt, but not if the source is not asserting an interrupt."

Fix setipnum_le/be write emulation for in-kernel APLIC by implementing
the above behaviour in aplic_write_pending() function.

Cc: stable@vger.kernel.org
Fixes: 74967aa208e2 ("RISC-V: KVM: Add in-kernel emulation of AIA APLIC")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20240321085041.1955293-2-apatel@ventanamicro.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/aia_aplic.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index 39e72aa016a4..5e842b92dc46 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -137,11 +137,21 @@ static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)
 	raw_spin_lock_irqsave(&irqd->lock, flags);
 
 	sm = irqd->sourcecfg & APLIC_SOURCECFG_SM_MASK;
-	if (!pending &&
-	    ((sm == APLIC_SOURCECFG_SM_LEVEL_HIGH) ||
-	     (sm == APLIC_SOURCECFG_SM_LEVEL_LOW)))
+	if (sm == APLIC_SOURCECFG_SM_INACTIVE)
 		goto skip_write_pending;
 
+	if (sm == APLIC_SOURCECFG_SM_LEVEL_HIGH ||
+	    sm == APLIC_SOURCECFG_SM_LEVEL_LOW) {
+		if (!pending)
+			goto skip_write_pending;
+		if ((irqd->state & APLIC_IRQ_STATE_INPUT) &&
+		    sm == APLIC_SOURCECFG_SM_LEVEL_LOW)
+			goto skip_write_pending;
+		if (!(irqd->state & APLIC_IRQ_STATE_INPUT) &&
+		    sm == APLIC_SOURCECFG_SM_LEVEL_HIGH)
+			goto skip_write_pending;
+	}
+
 	if (pending)
 		irqd->state |= APLIC_IRQ_STATE_PENDING;
 	else
-- 
2.44.0



