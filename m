Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1037EF0A;
	Mon,  8 Apr 2024 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582308; cv=none; b=ghLH57af7ZL1Mytmsuzgj9hh+sxN+xPhqKh/pkyaaRatplnIV4Gpruz+1H+3Ws4RjqDecJO7HGVwVD8yKNsvZOnvUHaafBZG081N9xbRCJRfphZ04auQaSIp6B+tOrwAcU+HH3HGLduBI4Q+Rb+h6dOWGcMGO0CweyQ+7CbW3xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582308; c=relaxed/simple;
	bh=ET12j8L2nyVrEUuKofJkLF5T4B8um7j3hp605UrSQcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ntaJYkvHq0BkWBbZMmkpNB49LsOd3gf1ANSQTl4laSCwzuoP9txpZv7ieXeHBpk5ihU9E6FYXdBMiKRbY9eWyWLxFzU1gIEtXjd4lnKpg/04tc1d/FEHZm7eVkr1pbzTx027lnciXE7XF6D5UjanHcwMGsrOmPrCTImBKYxiSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cyt+BlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cyt+BlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7F5C43390;
	Mon,  8 Apr 2024 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582308;
	bh=ET12j8L2nyVrEUuKofJkLF5T4B8um7j3hp605UrSQcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cyt+BlUgdZ6hPm7e0kDsrGbKBCxpYvvF2bdJAl8lo4KEqvz6POPCcREq28r4xFaq
	 CB1uoDjTs69uOdit9EI5nmDNhfSwMl2QkXo1abV70RH5gWBimcW8+AoFBStHJamltT
	 4VqEA7TteP4jKahFkYotMecoBV/WII4RIzlM1/RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.8 064/273] RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
Date: Mon,  8 Apr 2024 14:55:39 +0200
Message-ID: <20240408125311.288920669@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 arch/riscv/kvm/aia_aplic.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -137,11 +137,21 @@ static void aplic_write_pending(struct a
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


