Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1049173161;
	Wed, 21 Feb 2024 13:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521755; cv=none; b=nHobrKVM+cvnGxFxpEsArHfVhVZo7MQG9V5hnGNn0Q5OOGUjJSkgl1Uwm1ZMgjXhxoedIFK3YQGrRr4vBPRkG11Zg51D6PxtQiCZQ790XA9e534NxTFBCbjuYu7TFeWRBqOvqhERNsrQv1r4anc52+2xIlmtNQd7FjoqaeocY0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521755; c=relaxed/simple;
	bh=25Gj7m4FkclrBImbi55YzYlLSglHauGN48rs89CA3K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaneI9p8+D3mYK517VRG/0XsPercyko0CDkPRHaOAORaJWhOCZRX1ZqAvhOX5AQDftewdawkZGH26OVDMbtWaWjsqMdbqCG1IiEXbzoKQrinvbzmlmnyoj6Y89fLsLvO1PHIksmxxkaEnZNAPzcv/1U3tnNntVCDrwJ3atgO0ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaiVt2S/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaiVt2S/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABB7C433F1;
	Wed, 21 Feb 2024 13:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521754;
	bh=25Gj7m4FkclrBImbi55YzYlLSglHauGN48rs89CA3K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaiVt2S/qqO4DCW+ApHLMcn3gKv/54PMWbz1OfGQjJ2Wv07aBqL1PiOlH2aTwKknX
	 R0cQulsHO4CSmtZ/F06V6un+1KyyPRzouLk5JvTMMP7ATFoqD2JHE5ApnqsscXUcxx
	 UYJDGFS7I94jeaXNiGg18zugICvmKpISXQ5tJFXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 195/202] irqchip/irq-brcmstb-l2: Add write memory barrier before exit
Date: Wed, 21 Feb 2024 14:08:16 +0100
Message-ID: <20240221125938.095317014@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit b0344d6854d25a8b3b901c778b1728885dd99007 upstream.

It was observed on Broadcom devices that use GIC v3 architecture L1
interrupt controllers as the parent of brcmstb-l2 interrupt controllers
that the deactivation of the parent interrupt could happen before the
brcmstb-l2 deasserted its output. This would lead the GIC to reactivate the
interrupt only to find that no L2 interrupt was pending. The result was a
spurious interrupt invoking handle_bad_irq() with its associated
messaging. While this did not create a functional problem it is a waste of
cycles.

The hazard exists because the memory mapped bus writes to the brcmstb-l2
registers are buffered and the GIC v3 architecture uses a very efficient
system register write to deactivate the interrupt.

Add a write memory barrier prior to invoking chained_irq_exit() to
introduce a dsb(st) on those systems to ensure the system register write
cannot be executed until the memory mapped writes are visible to the
system.

[ florian: Added Fixes tag ]

Fixes: 7f646e92766e ("irqchip: brcmstb-l2: Add Broadcom Set Top Box  Level-2 interrupt controller")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240210012449.3009125-1-florian.fainelli@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-brcmstb-l2.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -121,6 +121,9 @@ static void brcmstb_l2_intc_irq_handle(s
 		generic_handle_irq(irq_linear_revmap(b->domain, irq));
 	} while (status);
 out:
+	/* Don't ack parent before all device writes are done */
+	wmb();
+
 	chained_irq_exit(chip, desc);
 }
 


