Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A437BB01;
	Wed, 21 Feb 2024 14:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525725; cv=none; b=VP98P1xbamUZC1NtOn7eGmOLuAgillQB/8AfuuOrarE2/vbhL8Cy8ucTD6jmkgNjUIKZHQqYIqTnEi5RD1osqxked14MP+mg2n2PGb/DgMBeydZVAMNav1L8N+ZD1uZ+MCJpS920cdQRKAa8izuzUPYVMZA48FMcfiCCKyjGOk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525725; c=relaxed/simple;
	bh=t2fVBATn52jtXCiqM3ud7mrMGmYpYQo8vzLt0OiBiT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsluM0Avz87OfccK5Tlu977IUMsVIwLDM7heJur1XsdfMjhLY4RgkI10HLpqAKTtOb8DOr6BvzOpF1S4i6u4EXR+mg36Zx5S/DOBp9Zn/fga7/PCtNGq8JFukacAV1LGU69NYBu6ZRBUWVDvfLzBjtuCZX20V2LDeSvOztlrfFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbOgqm7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbOgqm7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F1FC433C7;
	Wed, 21 Feb 2024 14:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525725;
	bh=t2fVBATn52jtXCiqM3ud7mrMGmYpYQo8vzLt0OiBiT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbOgqm7F7k8Zq/AUbTl7Uij9SjUlNF4hmdk+OEml4PVseQdn7z+SCye6qQ8ss0A/r
	 kmmiPVSZlDedWF9N2YJKyGDflQxcSWqBwNxGo8QLoX0wPoYTB1AyopCXTCspPtIgEJ
	 xnSPTxdOQngKb8X34QxQXRjLjeARS/34cz6uDIYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 244/267] irqchip/irq-brcmstb-l2: Add write memory barrier before exit
Date: Wed, 21 Feb 2024 14:09:45 +0100
Message-ID: <20240221125947.908759332@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/irqchip/irq-brcmstb-l2.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -2,7 +2,7 @@
 /*
  * Generic Broadcom Set Top Box Level 2 Interrupt controller driver
  *
- * Copyright (C) 2014-2017 Broadcom
+ * Copyright (C) 2014-2024 Broadcom
  */
 
 #define pr_fmt(fmt)	KBUILD_MODNAME	": " fmt
@@ -113,6 +113,9 @@ static void brcmstb_l2_intc_irq_handle(s
 		generic_handle_irq(irq_linear_revmap(b->domain, irq));
 	} while (status);
 out:
+	/* Don't ack parent before all device writes are done */
+	wmb();
+
 	chained_irq_exit(chip, desc);
 }
 


